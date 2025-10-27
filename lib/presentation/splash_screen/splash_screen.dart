import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _loadingAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _loadingAnimation;

  bool _isInitializing = true;
  String _initializationStatus = 'Memulai AR Avatar Camera...';
  double _initializationProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    // Logo animation controller
    _logoAnimationController = AnimationController(
      duration: AppTheme.slowAnimation,
      vsync: this,
    );

    // Loading animation controller
    _loadingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    // Logo fade animation
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.easeInOut,
    ));

    // Loading animation
    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start logo animation
    _logoAnimationController.forward();
    _loadingAnimationController.repeat();
  }

  Future<void> _initializeApp() async {
    try {
      // Step 1: Check camera permissions
      await _updateInitializationStatus('Memeriksa izin kamera...', 0.1);
      final cameraPermission = await _checkCameraPermission();

      // Step 2: Initialize camera system
      await _updateInitializationStatus(
          'Menginisialisasi sistem kamera...', 0.3);
      final cameraAvailable = await _initializeCameraSystem();

      // Step 3: Check AR capabilities
      await _updateInitializationStatus('Memeriksa kemampuan AR...', 0.5);
      final arSupported = await _checkARSupport();

      // Step 4: Load avatar assets
      await _updateInitializationStatus('Memuat aset avatar...', 0.7);
      await _loadAvatarAssets();

      // Step 5: Initialize ML Kit
      await _updateInitializationStatus('Menyiapkan deteksi orang...', 0.85);
      await _initializeMLKit();

      // Step 6: Fetch CMS content
      await _updateInitializationStatus('Mengambil konten video...', 0.95);
      await _fetchCMSContent();

      // Complete initialization
      await _updateInitializationStatus('Siap!', 1.0);

      // Navigate based on initialization results
      await Future.delayed(const Duration(milliseconds: 500));
      _navigateToNextScreen(cameraPermission, cameraAvailable, arSupported);
    } catch (e) {
      // Handle initialization errors gracefully
      await _updateInitializationStatus(
          'Terjadi kesalahan, melanjutkan...', 1.0);
      await Future.delayed(const Duration(milliseconds: 1000));
      _navigateToNextScreen(false, false, false);
    }
  }

  Future<void> _updateInitializationStatus(
      String status, double progress) async {
    if (mounted) {
      setState(() {
        _initializationStatus = status;
        _initializationProgress = progress;
      });
    }
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<bool> _checkCameraPermission() async {
    try {
      final status = await Permission.camera.status;
      return status.isGranted;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _initializeCameraSystem() async {
    try {
      final cameras = await availableCameras();
      return cameras.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _checkARSupport() async {
    try {
      // Simulate AR capability check
      // In real implementation, this would check ARCore/ARKit availability
      await Future.delayed(const Duration(milliseconds: 200));
      return true; // Assume AR is supported for demo
    } catch (e) {
      return false;
    }
  }

  Future<void> _loadAvatarAssets() async {
    try {
      // Simulate avatar asset loading
      // In real implementation, this would preload 3D models and textures
      await Future.delayed(const Duration(milliseconds: 300));
    } catch (e) {
      // Handle asset loading errors silently
    }
  }

  Future<void> _initializeMLKit() async {
    try {
      // Simulate ML Kit initialization
      // In real implementation, this would initialize person detection models
      await Future.delayed(const Duration(milliseconds: 400));
    } catch (e) {
      // Handle ML Kit initialization errors silently
    }
  }

  Future<void> _fetchCMSContent() async {
    try {
      // Simulate CMS content fetching
      // In real implementation, this would fetch video playlist from CMS
      await Future.delayed(const Duration(milliseconds: 200));
    } catch (e) {
      // Handle CMS fetch errors silently
    }
  }

  void _navigateToNextScreen(
      bool hasCamera, bool cameraAvailable, bool arSupported) {
    if (!hasCamera) {
      // Navigate to permission onboarding
      Navigator.pushReplacementNamed(context, '/permission-onboarding');
    } else if (!cameraAvailable || !arSupported) {
      // Navigate to settings screen to show fallback options
      Navigator.pushReplacementNamed(context, '/settings-screen');
    } else {
      // Navigate to main AR camera screen
      Navigator.pushReplacementNamed(context, '/ar-camera-main-screen');
    }
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _loadingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.primaryDark,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppTheme.primaryDark,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.primaryDark,
                AppTheme.surfaceElevated.withValues(alpha: 0.8),
                AppTheme.primaryDark,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Top spacer
                SizedBox(height: 15.h),

                // Logo section
                Expanded(
                  flex: 3,
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _logoAnimationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _logoScaleAnimation.value,
                          child: Opacity(
                            opacity: _logoFadeAnimation.value,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // App logo
                                Container(
                                  width: 25.w,
                                  height: 25.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        AppTheme.accentCyan,
                                        AppTheme.successGreen,
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.accentCyan
                                            .withValues(alpha: 0.3),
                                        blurRadius: 20,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: CustomIconWidget(
                                      iconName: 'camera_alt',
                                      color: AppTheme.primaryDark,
                                      size: 12.w,
                                    ),
                                  ),
                                ),

                                SizedBox(height: 3.h),

                                // App name
                                Text(
                                  'AR Avatar Camera',
                                  style: AppTheme
                                      .darkTheme.textTheme.headlineMedium
                                      ?.copyWith(
                                    color: AppTheme.textPrimary,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.2,
                                  ),
                                  textAlign: TextAlign.center,
                                ),

                                SizedBox(height: 1.h),

                                // Tagline
                                Text(
                                  'Kamera AR dengan Avatar Interaktif',
                                  style: AppTheme.darkTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: AppTheme.textSecondary,
                                    letterSpacing: 0.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Loading section
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Loading indicator
                      AnimatedBuilder(
                        animation: _loadingAnimationController,
                        builder: (context, child) {
                          return Container(
                            width: 60.w,
                            height: 0.5.h,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusSmall),
                              color: AppTheme.dividerColor,
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  width: 60.w * _initializationProgress,
                                  height: 0.5.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        AppTheme.radiusSmall),
                                    gradient: LinearGradient(
                                      colors: [
                                        AppTheme.accentCyan,
                                        AppTheme.successGreen,
                                      ],
                                    ),
                                  ),
                                ),
                                // Animated shimmer effect
                                if (_initializationProgress < 1.0)
                                  Positioned(
                                    left: (60.w * _initializationProgress) - 20,
                                    child: Container(
                                      width: 20,
                                      height: 0.5.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            AppTheme.radiusSmall),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            AppTheme.textPrimary
                                                .withValues(alpha: 0.3),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 2.h),

                      // Status text
                      AnimatedSwitcher(
                        duration: AppTheme.standardAnimation,
                        child: Text(
                          _initializationStatus,
                          key: ValueKey(_initializationStatus),
                          style:
                              AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                            letterSpacing: 0.3,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      SizedBox(height: 1.h),

                      // Progress percentage
                      Text(
                        '${(_initializationProgress * 100).toInt()}%',
                        style:
                            AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                          color: AppTheme.accentCyan,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom spacer
                SizedBox(height: 5.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
