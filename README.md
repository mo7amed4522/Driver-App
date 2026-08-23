# Ridy Driver App

[![Flutter CI](https://github.com/YOUR_USERNAME/Driver-App/actions/workflows/dart.yml/badge.svg)](https://github.com/YOUR_USERNAME/Driver-App/actions/workflows/dart.yml)
[![Version](https://img.shields.io/badge/version-2.3.2-blue.svg)](https://github.com/YOUR_USERNAME/Driver-App/releases)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

**Ridy Driver App** is a comprehensive driver application built with Flutter, designed to provide a seamless experience for ride-sharing drivers. The app includes real-time location tracking, route management, chat functionality, and analytics.

## Features

- **Real-time Location Tracking**: GPS-based location services with Google Maps integration
- **Route Management**: Advanced routing with Flutter Map and OpenStreetMap
- **In-App Chat**: Built-in messaging system for driver-rider communication
- **Analytics Dashboard**: Track performance metrics with interactive charts
- **Firebase Integration**: Authentication, analytics, crashlytics, and push notifications
- **Multi-language Support**: Internationalization with Flutter Localizations
- **Offline Support**: Local data persistence with Hive database
- **Push Notifications**: Real-time notifications via Firebase Cloud Messaging

## Screenshots

_Add your app screenshots here_

## Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK**: Version 3.22.0 or higher
- **Dart SDK**: Version 3.13.0 or higher
- **Android Studio** / **Xcode**: For Android/iOS development
- **Git**: For version control

### Installation

1. **Clone the repository**

```bash
git clone https://github.com/YOUR_USERNAME/Driver-App.git
cd Driver-App
```

2. **Install dependencies**

```bash
flutter pub get
```

3. **Configure Firebase**

- Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
- Download `google-services.json` for Android and place it in `android/app/`
- Download `GoogleService-Info.plist` for iOS and place it in `ios/Runner/`
- Enable Authentication, Cloud Messaging, Analytics, and Crashlytics in your Firebase project

4. **Run the app**

```bash
# For Android
flutter run

# For iOS
flutter run --release

# For specific device
flutter run -d <device_id>
```

## Project Structure

```
lib/
├── main.dart                 # Application entry point
├── models/                   # Data models
├── screens/                  # UI screens
├── widgets/                  # Reusable widgets
├── services/                 # Business logic services
├── bloc/                     # BLoC state management
├── graphql/                  # GraphQL queries and mutations
├── utils/                    # Utility functions
└── l10n/                     # Localization files
```

## Configuration

### Environment Variables

Create a `.env` file in the root directory:

```env
API_BASE_URL=https://your-api.com
GRAPHQL_ENDPOINT=https://your-graphql-endpoint.com
GOOGLE_MAPS_API_KEY=your_google_maps_api_key
```

### Code Generation

Run code generation for JSON serialization and other generated files:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Building for Production

### Android

```bash
# Build APK
flutter build apk --release

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

## Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart
```

## Dependencies

### Main Dependencies

- **flutter_bloc**: State management
- **firebase_core**: Firebase initialization
- **google_maps_flutter**: Maps integration
- **flutter_map**: Alternative map solution
- **graphql_flutter**: GraphQL client
- **hive**: Local database
- **velocity_x**: UI utilities
- **fl_chart**: Data visualization

See [pubspec.yaml](pubspec.yaml) for the complete list of dependencies.

## CI/CD

This project uses GitHub Actions for continuous integration and deployment:

- **Build & Test**: Runs on every push and pull request
- **Automated Releases**: Creates releases with APK/AAB artifacts
- **Code Quality**: Automated formatting and analysis checks

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details on how to get started.

### Quick Contribution Steps

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Code of Conduct

This project adheres to a [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## Security

Found a security vulnerability? Please see our [Security Policy](SECURITY.md) for reporting instructions.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- **Issues**: [GitHub Issues](https://github.com/YOUR_USERNAME/Driver-App/issues)
- **Discussions**: [GitHub Discussions](https://github.com/YOUR_USERNAME/Driver-App/discussions)
- **Email**: support@ridy.app

## Acknowledgments

- Flutter Team for the amazing framework
- Firebase for backend services
- OpenStreetMap for mapping data
- All contributors and supporters

## Roadmap

- [ ] Implement offline mode
- [ ] Add dark mode support
- [ ] Integrate payment gateway
- [ ] Add driver earnings dashboard
- [ ] Implement ride history
- [ ] Add multi-language support for more languages

---

**Made with Khaled by the Ridy Team**
