# FoodStream

A Flutter mobile application for live streaming food preparation and cooking experiences.

## Features

- 📱 **Live Streaming**: Real-time video streaming using WebRTC technology
- 🍔 **Food Focus**: Specialized for food and cooking content
- 👥 **Host & Viewer Modes**: Create streams or join existing ones
- 🔐 **User Authentication**: Secure login system
- 📊 **Stream Management**: Room creation and joining functionality

## Technical Stack

- **Framework**: Flutter 3.16+ with Dart 3.0+
- **Streaming**: WebRTC via `flutter_webrtc` and `livekit_client`
- **Backend**: Socket.IO for signaling
- **Platforms**: Android (API 21+) & iOS
- **Architecture**: Modern Android (API 35) with Java 17

## Getting Started

### Prerequisites

- Flutter 3.16 or higher
- Android Studio with Android SDK 35
- Xcode (for iOS development)

### Installation

```bash
# Clone the repository
git clone <your-repo-url>
cd foodstream/mobile

# Install dependencies
flutter pub get

# Run on Android
flutter run

# Build release APK
flutter build apk --release
```

### Features in Development

- Real-time chat during streams
- Stream recording and playback
- User profiles and favorites
- Stream discovery and search

## Architecture

This app uses:

- **SignalingService** for WebRTC connection management
- **LiveStreamPage** for streaming interface
- **Modern Android** configuration with ProGuard optimization
- **Responsive UI** with Material Design 3

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/).
