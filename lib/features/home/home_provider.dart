import 'package:flutter/foundation.dart';
import '../../services/telegram_service.dart';

/// Anime Model - Represents an anime item in the app
class Anime {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String? bannerUrl;
  final int? episodeCount;
  final String? status;
  final double rating;
  final List<String> genres;
  final String? telegramChannelId;
  final DateTime? releaseDate;
  
  Anime({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.bannerUrl,
    this.episodeCount,
    this.status,
    this.rating = 0.0,
    this.genres = const [],
    this.telegramChannelId,
    this.releaseDate,
  });
  
  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? json['poster'] ?? '',
      bannerUrl: json['banner_url'] ?? json['banner'],
      episodeCount: json['episode_count'] ?? json['episodes'],
      status: json['status'],
      rating: (json['rating'] ?? 0.0).toDouble(),
      genres: json['genres'] != null 
          ? List<String>.from(json['genres']) 
          : [],
      telegramChannelId: json['telegram_channel_id'],
      releaseDate: json['release_date'] != null
          ? DateTime.parse(json['release_date'])
          : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'banner_url': bannerUrl,
      'episode_count': episodeCount,
      'status': status,
      'rating': rating,
      'genres': genres,
      'telegram_channel_id': telegramChannelId,
      'release_date': releaseDate?.toIso8601String(),
    };
  }
}

/// Home Provider - Manages state for the home screen
class HomeProvider extends ChangeNotifier {
  final TelegramService _telegramService;
  
  List<Anime> _trendingAnime = [];
  List<Anime> _recentEpisodes = [];
  bool _isLoading = false;
  String? _error;
  
  HomeProvider({required TelegramService telegramService})
      : _telegramService = telegramService;
  
  // Getters
  List<Anime> get trendingAnime => _trendingAnime;
  List<Anime> get recentEpisodes => _recentEpisodes;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  /// Load trending anime from Telegram channel
  Future<void> loadTrendingAnime() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      // Fetch messages from Telegram
      final messages = await _telegramService.getChannelMessages();
      
      // Parse messages into Anime objects
      _trendingAnime = messages.map((msg) {
        return Anime(
          id: msg.messageId.toString(),
          title: msg.text?.split('\n').first ?? 'Unknown',
          description: msg.text ?? '',
          imageUrl: '', // Extract from message if available
          telegramChannelId: _telegramService.channelId,
        );
      }).toList();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Load recent episodes
  Future<void> loadRecentEpisodes() async {
    // Similar implementation for recent episodes
    notifyListeners();
  }
  
  /// Search anime by title
  List<Anime> searchAnime(String query) {
    if (query.isEmpty) {
      return _trendingAnime;
    }
    
    final lowerQuery = query.toLowerCase();
    return _trendingAnime.where((anime) {
      return anime.title.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
