# Rainbow AI Setup Guide

### 1. Backend Setup
1. Install Wrangler: `npm install -g wrangler`
2. Login: `wrangler login`
3. Create DB: `wrangler d1 create rainbow_db`
4. Deploy: `wrangler deploy`

### 2. Mobile App Setup
1. Install Flutter.
2. Change the API URL in `lib/main.dart` to your Worker URL.
3. Build APK: `flutter build apk --release`
4. Build Bundle: `flutter build appbundle --release`

### 3. Upload to Uptodown
- Upload the `build/app/outputs/flutter-apk/app-release.apk` to the Uptodown Developer console.
