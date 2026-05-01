import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'theme/app_theme.dart';
import 'features/home/home_screen.dart';
import 'features/home/home_provider.dart';
import 'features/detail/detail_screen.dart';
import 'features/auth/auth_screen.dart';
import 'services/telegram_service.dart';

// TODO: Replace with your actual credentials
const String supabaseUrl = 'YOUR_SUPABASE_URL';
const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
const String telegramBotToken = 'YOUR_TELEGRAM_BOT_TOKEN';
const String telegramChannelId = 'YOUR_CHANNEL_ID';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );
  
  runApp(const AnimeGramApp());
}

class AnimeGramApp extends StatelessWidget {
  const AnimeGramApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Telegram Service
        Provider<TelegramService>(
          create: (_) => TelegramService(
            botToken: telegramBotToken,
            channelId: telegramChannelId,
          ),
        ),
        
        // Auth Service & Provider
        Provider<AuthService>(
          create: (_) => AuthService(supabase: Supabase.instance.client),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(
            authService: context.read<AuthService>(),
          )..init(),
        ),
        
        // Home Provider
        ChangeNotifierProvider<HomeProvider>(
          create: (context) => HomeProvider(
            telegramService: context.read<TelegramService>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'AnimeGram',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AuthWrapper(),
        onGenerateRoute: _generateRoute,
      ),
    );
  }
  
  Route<dynamic>? _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/detail':
        final anime = settings.arguments as Anime;
        return MaterialPageRoute(
          builder: (_) => DetailScreen(anime: anime),
        );
      default:
        return null;
    }
  }
}

/// Auth Wrapper - Shows login or home based on auth state
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isAuthenticated) {
          return const HomeScreen();
        }
        return const LoginScreen();
      },
    );
  }
}
