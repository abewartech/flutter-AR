# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

AR Avatar Camera - A Flutter mobile application featuring AR-based avatar customization with real-time person detection, camera integration, and video playback fallback. Built with "Immersive Minimalism" design using an Adaptive Dark Foundation theme optimized for camera-first AR interfaces.

**Package Name:** `ar_avatar_camera`

## Common Commands

### Development
```powershell
# Install dependencies
flutter pub get

# Run the app
flutter run

# Run with specific device
flutter run -d <device-id>

# Run on web
flutter run -d chrome

# Check available devices
flutter devices
```

### Building
```powershell
# Build Android APK (release)
flutter build apk --release

# Build iOS (release)
flutter build ios --release

# Build for web
flutter build web
```

### Code Quality
```powershell
# Analyze code with linter
flutter analyze

# Format code
dart format lib/

# Run tests (if available)
flutter test
```

## Code Architecture

### Project Structure
```
lib/
├── core/
│   ├── app_export.dart       # Central exports hub for common imports
│   └── utils/                # Utility classes and helpers
├── presentation/             # UI layer - feature-based organization
│   ├── ar_camera_main_screen/
│   ├── avatar_customization_bottom_sheet/
│   ├── permission_onboarding/
│   ├── settings_screen/
│   ├── splash_screen/
│   └── video_player_screen/
├── routes/
│   └── app_routes.dart       # Named route definitions
├── theme/
│   └── app_theme.dart        # Centralized theming system
├── widgets/                  # Global reusable widgets
└── main.dart                 # App entry point with critical setup
```

### Architecture Patterns

**1. Feature-Based Presentation Layer**
- Each screen lives in its own directory under `presentation/`
- Each screen has a `widgets/` subdirectory for screen-specific components
- Use `CustomErrorWidget`, `CustomIconWidget`, `CustomImageWidget` from `widgets/` for UI consistency

**2. Core Module Pattern**
- `core/app_export.dart` acts as a central import hub - add frequently used packages here
- Currently exports: connectivity_plus, google_fonts, routes, custom widgets, theme

**3. Route Management**
- All routes defined in `lib/routes/app_routes.dart` with named constants
- Routes configured as `Map<String, WidgetBuilder>`
- Initial route points to `ArCameraMainScreen`

**4. Theme System**
- **Single source of truth:** `AppTheme` class in `lib/theme/app_theme.dart`
- **AR-optimized dark theme** with cyan accents, near-black surfaces
- Access colors via `AppTheme.accentCyan`, `AppTheme.textPrimary`, etc.
- Animation durations: `AppTheme.fastAnimation`, `AppTheme.standardAnimation`, `AppTheme.slowAnimation`
- Radius constants: `AppTheme.radiusSmall/Medium/Large/XLarge`
- Typography uses Google Fonts (Inter for UI, JetBrains Mono for data/code)

**5. Responsive Design**
- Uses `Sizer` package (v2.0.15) for responsive dimensions
- Use `.w` for width percentages: `50.w` = 50% screen width
- Use `.h` for height percentages: `20.h` = 20% screen height
- Use `.sp` for scalable font sizes

**6. Camera & AR Integration**
- `camera` package handles device camera
- `permission_handler` for runtime permissions
- Mock detection stream pattern in `ArCameraMainScreen` demonstrates integration point for actual ML models
- Automatic fallback to video mode when no person detected for 5+ seconds

## Critical Rules (DO NOT VIOLATE)

### Assets & Fonts
- **Only use existing asset directories:** `assets/` and `assets/images/`
- **DO NOT** add new directories like `assets/svg/`, `assets/icons/`, etc.
- **Use Google Fonts, never local font files** - configured via `google_fonts` package
- **DO NOT** add fonts section to `pubspec.yaml`

### Core Dependencies (CRITICAL)
These dependencies are marked CRITICAL in `pubspec.yaml` and must never be removed:
- `flutter` SDK
- `sizer` (responsive design)
- `flutter_svg` (icon support)
- `google_fonts` (typography)
- `shared_preferences` (local storage)
- `flutter_test` SDK
- `flutter_lints` (code quality)
- `uses-material-design: true` (Material icons)

### App Configuration
In `main.dart`, these configurations are marked CRITICAL and must not be modified:
- Custom error widget handler with `_hasShownError` flag
- Portrait-only orientation lock: `DeviceOrientation.portraitUp`
- Text scaler locked to 1.0 (prevents system font scaling from breaking UI)
- `Sizer` wrapper around MaterialApp

### Adding Routes
1. Add route constant to `AppRoutes` class
2. Import the screen widget at the top
3. Add entry to `AppRoutes.routes` map
4. Use `Navigator.pushNamed(context, AppRoutes.yourRoute)` for navigation

### Adding Screens
1. Create directory: `lib/presentation/your_screen/`
2. Create main screen file: `your_screen.dart`
3. Create `widgets/` subdirectory for screen-specific widgets
4. Follow stateful widget pattern with lifecycle management (see `ArCameraMainScreen`)
5. Register route in `app_routes.dart`

### Theming Guidelines
- **Never hardcode colors** - always use `AppTheme` constants
- Access current theme: `Theme.of(context)`
- For text styles, prefer theme: `Theme.of(context).textTheme.bodyLarge`
- Use `AppTheme.dataTextStyle()` for technical/code display
- Apply semantic colors:
  - `accentCyan` - interactive elements, primary actions
  - `successGreen` - confirmations, detection success
  - `warningAmber` - permission requests, warnings
  - `errorCoral` - errors, destructive actions
  - `textPrimary` - main content (white)
  - `textSecondary` - supporting text (gray)

### Platform Considerations
- **Web support** is enabled - check `kIsWeb` before using mobile-only features
- Camera on web uses front camera by default, mobile uses back
- Some camera features unavailable on web (flash, certain focus modes)
- Wrap platform-specific code in try-catch blocks

### State Management Pattern
- Screens use StatefulWidget with TickerProviderStateMixin for animations
- WidgetsBindingObserver for lifecycle events (camera management)
- Stream-based patterns for real-time updates (person detection)
- Always check `mounted` before calling setState in async callbacks

## Development Notes

### Permission Flow
1. Check/request camera permission on app start
2. Show permission dialog if denied with option to open settings
3. Initialize camera only after permission granted
4. Handle permission changes via app lifecycle events

### Camera Lifecycle
- Initialize camera in `initState` after permission check
- Dispose camera in `didChangeAppLifecycleState` when app inactive
- Reinitialize when app resumes
- Always dispose in widget `dispose()` method

### Animation Pattern
- Create AnimationController with vsync (TickerProviderStateMixin)
- Use CurvedAnimation for easing
- Use theme animation durations: `AppTheme.standardAnimation`
- Dispose controllers in widget dispose method

### Testing Notes
- No test framework configured yet - avoid assumptions about test commands
- When adding tests, configure test structure first
- Use `flutter test` as standard command

## Common Patterns

### Import Pattern
Instead of multiple imports, use the central export:
```dart
import '../core/app_export.dart';  // Provides common imports
```

### Widget Structure
```dart
class YourScreen extends StatefulWidget {
  const YourScreen({Key? key}) : super(key: key);

  @override
  State<YourScreen> createState() => _YourScreenState();
}

class _YourScreenState extends State<YourScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize state
  }

  @override
  void dispose() {
    // Clean up resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      body: SafeArea(child: /* your UI */),
    );
  }
}
```

### Responsive Layout
```dart
Container(
  width: 90.w,           // 90% of screen width
  height: 30.h,          // 30% of screen height
  padding: EdgeInsets.symmetric(
    horizontal: 4.w,     // 4% horizontal padding
    vertical: 2.h,       // 2% vertical padding
  ),
  child: Text(
    'Responsive Text',
    style: TextStyle(fontSize: 14.sp),  // Scalable font size
  ),
)
```

### Navigation
```dart
// Push named route
Navigator.pushNamed(context, AppRoutes.settings);

// Push with arguments
Navigator.pushNamed(
  context,
  AppRoutes.videoPlayer,
  arguments: {'videoId': '123'},
);

// Pop back
Navigator.pop(context);
```

### Showing Feedback
```dart
// Success message
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: const Text('Action successful'),
    backgroundColor: AppTheme.successGreen,
  ),
);

// Error message
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Error occurred'),
    backgroundColor: AppTheme.errorCoral,
  ),
);
```

## Indonesian Language Notes
- UI text uses Indonesian (Bahasa Indonesia)
- Examples: "Izin Kamera Diperlukan", "Berikan Izin", "Pengaturan", "Keluar"
- Keep consistency with existing translations when adding new features
