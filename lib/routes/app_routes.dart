import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/settings_screen/settings_screen.dart';
import '../presentation/video_player_screen/video_player_screen.dart';
import '../presentation/permission_onboarding/permission_onboarding.dart';
import '../presentation/ar_camera_main_screen/ar_camera_main_screen.dart';
import '../presentation/avatar_customization_bottom_sheet/avatar_customization_bottom_sheet.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splash = '/splash-screen';
  static const String settings = '/settings-screen';
  static const String videoPlayer = '/video-player-screen';
  static const String permissionOnboarding = '/permission-onboarding';
  static const String arCameraMain = '/ar-camera-main-screen';
  static const String avatarCustomizationBottomSheet =
      '/avatar-customization-bottom-sheet';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const ArCameraMainScreen(),
    splash: (context) => const SplashScreen(),
    settings: (context) => const SettingsScreen(),
    videoPlayer: (context) => const VideoPlayerScreen(),
    permissionOnboarding: (context) => const PermissionOnboarding(),
    arCameraMain: (context) => const ArCameraMainScreen(),
    avatarCustomizationBottomSheet: (context) =>
        const AvatarCustomizationBottomSheet(),
    // TODO: Add your other routes here
  };
}
