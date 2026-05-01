# AnimeGram - Flutter + Telegram + Glassmorphism

A modern Flutter application that serves as a sleek interface for managing and viewing anime content sourced via Telegram, featuring a stunning Glassmorphism UI design.

## 🎨 Design Philosophy

- **Glassmorphism**: Frosted glass effects, blurred backgrounds, translucent cards
- **Cyber-Fintech Aesthetic**: Deep blues, purples, and vibrant accents
- **Modern & Fast**: Optimized for performance with cached images

## 📁 Project Architecture

```
lib/
├── core/                    # Core utilities and constants
├── features/
│   ├── auth/               # Authentication screens & logic
│   │   └── auth_screen.dart
│   ├── home/               # Home screen & trending anime
│   │   ├── home_screen.dart
│   │   └── home_provider.dart
│   └── detail/             # Anime detail & player view
│       └── detail_screen.dart
├── services/
│   └── telegram_service.dart  # Telegram Bot API integration
├── theme/
│   └── app_theme.dart      # Glassmorphism theme configuration
├── widgets/
│   └── glass_widgets.dart  # Reusable glassmorphism widgets
└── main.dart               # App entry point
```

## 🚀 Key Features

### Implemented
- ✅ Glassmorphism theme with custom colors and effects
- ✅ Reusable GlassCard, GlassButton, and AnimeCard widgets
- ✅ Telegram Bot API service for fetching messages/links
- ✅ Home screen with trending anime grid
- ✅ Detail screen with blurred background poster
- ✅ Provider state management
- ✅ Supabase authentication scaffold
- ✅ Search functionality
- ✅ Cached network images

### To Be Completed
- ⏳ Video player integration
- ⏳ Favorites persistence with Supabase
- ⏳ Episode list parsing from Telegram
- ⏳ Push notifications
- ⏳ Offline mode

## 🛠️ Technical Stack

- **Frontend**: Flutter (Latest Stable)
- **State Management**: Provider
- **Backend**: Supabase (Auth & Database)
- **API Integration**: Telegram Bot API
- **Image Caching**: cached_network_image
- **UI Components**: Custom Glassmorphism widgets

## 📦 Dependencies

Add these to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  provider: ^6.1.1
  
  # UI & Design
  glassmorphism: ^3.0.0
  google_fonts: ^6.1.0
  
  # Network & API
  http: ^1.2.0
  dio: ^5.4.0
  
  # Image Caching
  cached_network_image: ^3.3.1
  
  # Backend (Supabase)
  supabase_flutter: ^2.3.0
  
  # Utilities
  url_launcher: ^6.2.4
  shimmer: ^3.0.0
```

## ⚙️ Configuration

Before running the app, configure the following in `lib/main.dart`:

```dart
const String supabaseUrl = 'YOUR_SUPABASE_URL';
const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
const String telegramBotToken = 'YOUR_TELEGRAM_BOT_TOKEN';
const String telegramChannelId = 'YOUR_CHANNEL_ID';
```

### Getting Your Credentials

1. **Supabase**: Create a project at [supabase.com](https://supabase.com)
2. **Telegram Bot**: Create a bot via [@BotFather](https://t.me/botfather)
3. **Channel ID**: Get your channel ID using [@userinfobot](https://t.me/userinfobot)

## 🎨 Color Palette

| Color | Hex Code | Usage |
|-------|----------|-------|
| Primary Dark | `#0A0E27` | Background |
| Secondary Dark | `#161B3D` | Cards |
| Accent Purple | `#7B2CBF` | Primary actions |
| Accent Blue | `#4CC9F0` | Highlights |
| Accent Pink | `#F72585` | Notifications |
| Glass White | `0x40FFFFFF` | Translucent overlays |

## 📱 Screenshots

The app features:
- **Home Screen**: Grid of anime cards with glass effect
- **Detail Screen**: Full-screen blurred poster background
- **Login Screen**: Minimalist glass form
- **Search**: Real-time anime search

## 🔧 Development

### Running the App

```bash
# Install dependencies
flutter pub get

# Run on device/emulator
flutter run
```

### Building for Production

```bash
# Android APK
flutter build apk --release

# iOS IPA
flutter build ios --release
```

## 📄 License

This project is open source and available under the MIT License.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

**Built with ❤️ using Flutter & Telegram API**
