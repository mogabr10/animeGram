import 'dart:convert';
import 'package:http/http.dart' as http;

/// TelegramService - Handles all Telegram Bot API interactions
/// Fetches messages, media, and links from specified channels
class TelegramService {
  final String botToken;
  final String channelId;
  final int limit;
  
  // Base URL for Telegram Bot API
  static const String baseUrl = 'https://api.telegram.org/bot';
  
  TelegramService({
    required this.botToken,
    required this.channelId,
    this.limit = 50,
  });
  
  /// Get recent messages from a Telegram channel
  /// Returns a list of message objects
  Future<List<TelegramMessage>> getChannelMessages() async {
    try {
      final url = Uri.parse(
        '$baseUrl$botToken/getUpdates?offset=-$limit&allowed_updates=["message"]',
      );
      
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['ok'] == true) {
          final updates = data['result'] as List;
          return updates
              .where((update) => _isValidAnimeMessage(update))
              .map((update) => TelegramMessage.fromJson(update))
              .toList();
        }
      }
      
      throw Exception('Failed to fetch messages: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error fetching Telegram messages: $e');
    }
  }
  
  /// Parse video links from Telegram message
  /// Supports direct video files and external links
  List<String> parseVideoLinks(TelegramMessage message) {
    final links = <String>[];
    
    // Check for document (video file)
    if (message.document != null) {
      links.add(message.document!.fileUrl);
    }
    
    // Check for video
    if (message.video != null) {
      links.add(message.video!.fileUrl);
    }
    
    // Parse text for URLs
    if (message.text != null) {
      final urlRegex = RegExp(
        r'(https?://[^\s\<\>\"{}|\\^`\[\]]+\.(mp4|m3u8|mkv|avi|webm))',
        caseSensitive: false,
      );
      
      final matches = urlRegex.allMatches(message.text!);
      for (var match in matches) {
        links.add(match.group(0)!);
      }
    }
    
    return links;
  }
  
  /// Validate if message contains anime content
  bool _isValidAnimeMessage(dynamic update) {
    if (update['message'] == null) return false;
    
    final message = update['message'];
    final chat = message['chat'];
    
    // Check if from correct channel
    if (chat['username'] != channelId && 
        chat['id'].toString() != channelId) {
      return false;
    }
    
    // Check for media or links
    return message['document'] != null ||
           message['video'] != null ||
           (message['text'] != null && 
            message['text'].contains(RegExp(r'https?://')));
  }
  
  /// Get file download URL from Telegram
  Future<String> getFileUrl(String fileId) async {
    try {
      final url = Uri.parse('$baseUrl$botToken/getFile?file_id=$fileId');
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['ok'] == true) {
          final filePath = data['result']['file_path'];
          return '$baseUrl$botToken/$filePath';
        }
      }
      
      throw Exception('Failed to get file URL');
    } catch (e) {
      throw Exception('Error getting file URL: $e');
    }
  }
}

/// Data model for Telegram messages
class TelegramMessage {
  final int messageId;
  final String? text;
  final DateTime date;
  final TelegramDocument? document;
  final TelegramVideo? video;
  final List<TelegramEntity>? entities;
  
  TelegramMessage({
    required this.messageId,
    this.text,
    required this.date,
    this.document,
    this.video,
    this.entities,
  });
  
  factory TelegramMessage.fromJson(Map<String, dynamic> json) {
    final message = json['message'] ?? json;
    return TelegramMessage(
      messageId: message['message_id'] ?? 0,
      text: message['text'],
      date: DateTime.fromMillisecondsSinceEpoch(
        (message['date'] ?? 0) * 1000,
      ),
      document: message['document'] != null
          ? TelegramDocument.fromJson(message['document'])
          : null,
      video: message['video'] != null
          ? TelegramVideo.fromJson(message['video'])
          : null,
      entities: message['entities'] != null
          ? (message['entities'] as List)
              .map((e) => TelegramEntity.fromJson(e))
              .toList()
          : null,
    );
  }
}

/// Data model for Telegram document
class TelegramDocument {
  final String fileId;
  final String fileName;
  final String mimeType;
  final int fileSize;
  
  String get fileUrl => 'https://api.telegram.org/file/botTOKEN/$fileId';
  
  TelegramDocument({
    required this.fileId,
    required this.fileName,
    required this.mimeType,
    required this.fileSize,
  });
  
  factory TelegramDocument.fromJson(Map<String, dynamic> json) {
    return TelegramDocument(
      fileId: json['file_id'] ?? '',
      fileName: json['file_name'] ?? '',
      mimeType: json['mime_type'] ?? '',
      fileSize: json['file_size'] ?? 0,
    );
  }
}

/// Data model for Telegram video
class TelegramVideo {
  final String fileId;
  final String mimeType;
  final int fileSize;
  final int width;
  final int height;
  
  String get fileUrl => 'https://api.telegram.org/file/botTOKEN/$fileId';
  
  TelegramVideo({
    required this.fileId,
    required this.mimeType,
    required this.fileSize,
    required this.width,
    required this.height,
  });
  
  factory TelegramVideo.fromJson(Map<String, dynamic> json) {
    return TelegramVideo(
      fileId: json['file_id'] ?? '',
      mimeType: json['mime_type'] ?? '',
      fileSize: json['file_size'] ?? 0,
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
    );
  }
}

/// Data model for Telegram message entities (links, mentions, etc.)
class TelegramEntity {
  final String type;
  final int offset;
  final int length;
  final String? url;
  
  TelegramEntity({
    required this.type,
    required this.offset,
    required this.length,
    this.url,
  });
  
  factory TelegramEntity.fromJson(Map<String, dynamic> json) {
    return TelegramEntity(
      type: json['type'] ?? '',
      offset: json['offset'] ?? 0,
      length: json['length'] ?? 0,
      url: json['url'],
    );
  }
}
