import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/avatar_customization_sheet.dart';
import './widgets/camera_preview_widget.dart';
import './widgets/detection_status_widget.dart';
import './widgets/floating_controls_widget.dart';
import './widgets/video_player_widget.dart';

class ArCameraMainScreen extends StatefulWidget {
  const ArCameraMainScreen({Key? key}) : super(key: key);

  @override
  State<ArCameraMainScreen> createState() => _ArCameraMainScreenState();
}

class _ArCameraMainScreenState extends State<ArCameraMainScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  // Camera related
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isPermissionGranted = false;

  // AR and detection related
  bool _isPersonDetected = false;
  bool _isArMode = true;
  int _detectionConfidence = 0;
  int _noPersonDetectedDuration = 0;
  static const int _maxNoPersonDuration = 5; // seconds

  // UI state
  bool _showCustomizationSheet = false;
  bool _showVideoPlayer = false;

  // Animation controllers
  late AnimationController _modeTransitionController;
  late Animation<double> _modeTransitionAnimation;

  // Mock detection timer
  late Stream<bool> _personDetectionStream;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Initialize animation controllers
    _modeTransitionController = AnimationController(
      duration: AppTheme.standardAnimation,
      vsync: this,
    );
    _modeTransitionAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _modeTransitionController,
      curve: Curves.easeInOut,
    ));

    // Initialize camera and detection
    _initializeApp();

    // Mock person detection stream
    _personDetectionStream = Stream.periodic(
      const Duration(milliseconds: 500),
      (count) {
        // Simulate person detection with some randomness
        final isDetected = (count % 10) < 7; // 70% detection rate
        if (isDetected) {
          _detectionConfidence = 75 + (count % 25); // 75-99% confidence
          _noPersonDetectedDuration = 0;
        } else {
          _detectionConfidence = 0;
          _noPersonDetectedDuration++;
        }
        return isDetected;
      },
    ).asBroadcastStream();

    // Listen to detection stream
    _personDetectionStream.listen((isDetected) {
      if (mounted) {
        setState(() {
          _isPersonDetected = isDetected;
        });

        // Switch to video mode if no person detected for too long
        if (!isDetected &&
            _noPersonDetectedDuration >= _maxNoPersonDuration &&
            _isArMode) {
          _switchToVideoMode();
        } else if (isDetected && !_isArMode) {
          _switchToArMode();
        }
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _modeTransitionController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeApp() async {
    await _requestPermissions();
    if (_isPermissionGranted) {
      await _initializeCamera();
    }
  }

  Future<void> _requestPermissions() async {
    if (kIsWeb) {
      setState(() {
        _isPermissionGranted = true;
      });
      return;
    }

    final cameraStatus = await Permission.camera.request();
    setState(() {
      _isPermissionGranted = cameraStatus.isGranted;
    });

    if (!_isPermissionGranted) {
      _showPermissionDialog();
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceElevated,
        title: Text(
          'Izin Kamera Diperlukan',
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        content: Text(
          'Aplikasi ini memerlukan akses kamera untuk fitur AR. Silakan berikan izin kamera di pengaturan aplikasi.',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              SystemNavigator.pop();
            },
            child: Text(
              'Keluar',
              style: TextStyle(color: AppTheme.errorCoral),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: const Text('Buka Pengaturan'),
          ),
        ],
      ),
    );
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;

      final camera = kIsWeb
          ? _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras.first,
            )
          : _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras.first,
            );

      _cameraController = CameraController(
        camera,
        kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();

      // Apply camera settings (skip unsupported features on web)
      try {
        await _cameraController!.setFocusMode(FocusMode.auto);
      } catch (e) {
        debugPrint('Focus mode not supported: $e');
      }

      if (!kIsWeb) {
        try {
          await _cameraController!.setFlashMode(FlashMode.off);
        } catch (e) {
          debugPrint('Flash mode not supported: $e');
        }
      }

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menginisialisasi kamera: ${e.toString()}'),
            backgroundColor: AppTheme.errorCoral,
          ),
        );
      }
    }
  }

  void _switchToVideoMode() {
    if (!_isArMode) return;

    setState(() {
      _isArMode = false;
      _showVideoPlayer = true;
    });
    _modeTransitionController.forward();
  }

  void _switchToArMode() {
    if (_isArMode) return;

    setState(() {
      _isArMode = true;
      _showVideoPlayer = false;
    });
    _modeTransitionController.reverse();
  }

  void _toggleCustomizationSheet() {
    setState(() {
      _showCustomizationSheet = !_showCustomizationSheet;
    });
  }

  void _resetAvatar() {
    // Reset avatar to default state
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Avatar direset ke pengaturan default'),
        backgroundColor: AppTheme.successGreen,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onSkinToneChanged(String skinTone) {
    // Handle skin tone change
    debugPrint('Skin tone changed to: $skinTone');
    HapticFeedback.selectionClick();
  }

  void _onAccessoryChanged(String accessory) {
    // Handle accessory change
    debugPrint('Accessory changed to: $accessory');
    HapticFeedback.selectionClick();
  }

  void _navigateToSettings() {
    Navigator.pushNamed(context, '/settings-screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      body: SafeArea(
        child: Stack(
          children: [
            // Camera preview (always visible as background)
            if (_isPermissionGranted && _isCameraInitialized)
              CameraPreviewWidget(
                cameraController: _cameraController,
                isPersonDetected: _isPersonDetected && _isArMode,
                onTap: () {
                  if (_showCustomizationSheet) {
                    _toggleCustomizationSheet();
                  }
                },
              )
            else
              Container(
                width: 100.w,
                height: 100.h,
                color: AppTheme.primaryDark,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!_isPermissionGranted) ...[
                        CustomIconWidget(
                          iconName: 'camera_alt',
                          color: AppTheme.textSecondary,
                          size: 20.w,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Izin Kamera Diperlukan',
                          style:
                              AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                            color: AppTheme.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Berikan izin kamera untuk menggunakan fitur AR',
                          style:
                              AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 4.h),
                        ElevatedButton(
                          onPressed: _requestPermissions,
                          child: const Text('Berikan Izin'),
                        ),
                      ] else ...[
                        CircularProgressIndicator(
                          color: AppTheme.accentCyan,
                          strokeWidth: 3,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Memuat kamera...',
                          style:
                              AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

            // Video player overlay
            VideoPlayerWidget(
              isVisible: _showVideoPlayer,
              onVideoEnd: () {
                // Handle video end
                _switchToArMode();
              },
              onNextVideo: () {
                // Handle next video
                HapticFeedback.selectionClick();
              },
              onPreviousVideo: () {
                // Handle previous video
                HapticFeedback.selectionClick();
              },
            ),

            // Detection status overlay
            if (_isPermissionGranted && _isCameraInitialized)
              DetectionStatusWidget(
                isPersonDetected: _isPersonDetected,
                isArMode: _isArMode,
                detectionConfidence: _detectionConfidence,
              ),

            // Floating controls
            if (_isPermissionGranted && _isCameraInitialized)
              FloatingControlsWidget(
                isPersonDetected: _isPersonDetected && _isArMode,
                onCustomizationTap: _toggleCustomizationSheet,
                onResetAvatar: _resetAvatar,
                onSettingsTap: _navigateToSettings,
              ),

            // Avatar customization sheet
            AvatarCustomizationSheet(
              isVisible: _showCustomizationSheet,
              onClose: _toggleCustomizationSheet,
              onSkinToneChanged: _onSkinToneChanged,
              onAccessoryChanged: _onAccessoryChanged,
            ),
          ],
        ),
      ),
    );
  }
}
