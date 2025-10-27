import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/onboarding_step_widget.dart';
import './widgets/permission_dialog_widget.dart';
import './widgets/progress_indicator_widget.dart';

class PermissionOnboarding extends StatefulWidget {
  const PermissionOnboarding({Key? key}) : super(key: key);

  @override
  State<PermissionOnboarding> createState() => _PermissionOnboardingState();
}

class _PermissionOnboardingState extends State<PermissionOnboarding>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  int _currentStep = 1;
  bool _isLoading = false;

  final int _totalSteps = 3;

  // Mock data for onboarding steps
  final List<Map<String, dynamic>> _onboardingSteps = [
    {
      "title": "Deteksi Kehadiran Real-time",
      "description":
          "Kamera akan mendeteksi kehadiran Anda secara otomatis dan menampilkan avatar AR yang dapat disesuaikan sesuai keinginan.",
      "imageUrl":
          "https://images.unsplash.com/photo-1735404039300-5022bda583df",
      "semanticLabel":
          "Person standing in front of a modern smartphone displaying AR avatar overlay technology with blue holographic effects"
    },
    {
      "title": "Kustomisasi Avatar Interaktif",
      "description":
          "Ubah warna kulit, aksesori, dan gaya avatar Anda secara real-time. Semua perubahan akan langsung terlihat di layar kamera.",
      "imageUrl":
          "https://images.unsplash.com/photo-1706777373963-63bd4befea4e",
      "semanticLabel":
          "Close-up view of hands customizing a 3D avatar on a tablet screen with various skin tones and accessory options visible"
    },
    {
      "title": "Konten Video Otomatis",
      "description":
          "Ketika tidak ada orang yang terdeteksi, aplikasi akan otomatis beralih ke konten video menarik dari sistem manajemen konten.",
      "imageUrl":
          "https://images.unsplash.com/photo-1666076901076-dcb0038c473c",
      "semanticLabel":
          "Modern video player interface showing multiple video thumbnails and playback controls on a dark themed mobile application"
    }
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _pageController = PageController();
    _fadeController = AnimationController(
      duration: AppTheme.standardAnimation,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _handleContinue() async {
    if (_currentStep < _totalSteps) {
      await _nextStep();
    } else {
      await _requestCameraPermission();
    }
  }

  Future<void> _nextStep() async {
    if (_currentStep < _totalSteps) {
      setState(() => _currentStep++);
      await _pageController.nextPage(
        duration: AppTheme.standardAnimation,
        curve: Curves.easeInOut,
      );
      HapticFeedback.selectionClick();
    }
  }

  Future<void> _previousStep() async {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
      await _pageController.previousPage(
        duration: AppTheme.standardAnimation,
        curve: Curves.easeInOut,
      );
      HapticFeedback.selectionClick();
    }
  }

  void _skipOnboarding() {
    HapticFeedback.lightImpact();
    _showSkipConfirmationDialog();
  }

  void _showSkipConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => PermissionDialogWidget(
        title: "Lewati Pengenalan?",
        description:
            "Anda dapat melihat pengenalan ini lagi di pengaturan aplikasi. Lanjutkan ke izin kamera?",
        primaryButtonText: "Ya, Lanjutkan",
        secondaryButtonText: "Kembali",
        onPrimaryPressed: () {
          Navigator.of(context).pop();
          _requestCameraPermission();
        },
        onSecondaryPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Future<void> _requestCameraPermission() async {
    setState(() => _isLoading = true);

    try {
      // Handle iOS permission request
      if (Platform.isIOS) {
        final status = await Permission.camera.request();
        await _handlePermissionResult(status);
      } else {
        // Handle Android permission request
        final status = await Permission.camera.request();
        await _handlePermissionResult(status);
      }
    } catch (e) {
      _showPermissionErrorDialog();
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handlePermissionResult(PermissionStatus status) async {
    switch (status) {
      case PermissionStatus.granted:
        HapticFeedback.heavyImpact();
        await _navigateToMainScreen();
        break;
      case PermissionStatus.denied:
        _showPermissionDeniedDialog();
        break;
      case PermissionStatus.permanentlyDenied:
        _showPermissionPermanentlyDeniedDialog();
        break;
      case PermissionStatus.restricted:
        _showPermissionRestrictedDialog();
        break;
      default:
        _showPermissionErrorDialog();
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PermissionDialogWidget(
        title: "Izin Kamera Diperlukan",
        description:
            "Aplikasi memerlukan akses kamera untuk mendeteksi kehadiran dan menampilkan avatar AR. Tanpa izin ini, fitur utama tidak akan berfungsi.",
        primaryButtonText: "Coba Lagi",
        secondaryButtonText: "Gunakan Mode Terbatas",
        isDenied: true,
        onPrimaryPressed: () {
          Navigator.of(context).pop();
          _requestCameraPermission();
        },
        onSecondaryPressed: () {
          Navigator.of(context).pop();
          _navigateToMainScreenWithLimitedMode();
        },
      ),
    );
  }

  void _showPermissionPermanentlyDeniedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PermissionDialogWidget(
        title: "Buka Pengaturan",
        description:
            "Izin kamera telah ditolak secara permanen. Silakan buka pengaturan aplikasi untuk mengaktifkan akses kamera.",
        primaryButtonText: "Buka Pengaturan",
        secondaryButtonText: "Mode Terbatas",
        isDenied: true,
        onPrimaryPressed: () {
          Navigator.of(context).pop();
          openAppSettings();
        },
        onSecondaryPressed: () {
          Navigator.of(context).pop();
          _navigateToMainScreenWithLimitedMode();
        },
      ),
    );
  }

  void _showPermissionRestrictedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PermissionDialogWidget(
        title: "Akses Kamera Dibatasi",
        description:
            "Akses kamera dibatasi oleh pengaturan perangkat. Silakan periksa pengaturan kontrol orang tua atau pembatasan perangkat.",
        primaryButtonText: "Mengerti",
        isDenied: true,
        onPrimaryPressed: () {
          Navigator.of(context).pop();
          _navigateToMainScreenWithLimitedMode();
        },
      ),
    );
  }

  void _showPermissionErrorDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PermissionDialogWidget(
        title: "Terjadi Kesalahan",
        description:
            "Terjadi kesalahan saat meminta izin kamera. Silakan coba lagi atau restart aplikasi.",
        primaryButtonText: "Coba Lagi",
        secondaryButtonText: "Kembali",
        isDenied: true,
        onPrimaryPressed: () {
          Navigator.of(context).pop();
          _requestCameraPermission();
        },
        onSecondaryPressed: () {
          Navigator.of(context).pop();
          Navigator.pushReplacementNamed(context, '/splash-screen');
        },
      ),
    );
  }

  Future<void> _navigateToMainScreen() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/ar-camera-main-screen');
    }
  }

  Future<void> _navigateToMainScreenWithLimitedMode() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      Navigator.pushReplacementNamed(
        context,
        '/ar-camera-main-screen',
        arguments: {'limitedMode': true},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Progress indicator
              ProgressIndicatorWidget(
                currentStep: _currentStep,
                totalSteps: _totalSteps,
              ),

              // Main content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _currentStep = index + 1);
                  },
                  itemCount: _onboardingSteps.length,
                  itemBuilder: (context, index) {
                    final step = _onboardingSteps[index];
                    return OnboardingStepWidget(
                      title: step["title"] as String,
                      description: step["description"] as String,
                      imageUrl: step["imageUrl"] as String,
                      semanticLabel: step["semanticLabel"] as String,
                      isActive: index == _currentStep - 1,
                    );
                  },
                ),
              ),

              // Action buttons
              ActionButtonsWidget(
                onContinue: _handleContinue,
                onSkip: _currentStep < _totalSteps ? _skipOnboarding : null,
                isLastStep: _currentStep == _totalSteps,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
