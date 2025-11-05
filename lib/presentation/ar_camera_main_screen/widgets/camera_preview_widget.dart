import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class CameraPreviewWidget extends StatelessWidget {
  final CameraController? cameraController;
  final bool isPersonDetected;
  final VoidCallback? onTap;
  final String? accessoryId; // e.g., 'hat', 'earrings', or null
  final String? accessoryAsset; // local asset path for overlay

  const CameraPreviewWidget({
    Key? key,
    required this.cameraController,
    required this.isPersonDetected,
    this.onTap,
    this.accessoryId,
    this.accessoryAsset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100.w,
        height: 100.h,
        color: AppTheme.primaryDark,
        child: cameraController != null && cameraController!.value.isInitialized
            ? Stack(
                children: [
                  // Camera preview
                  Positioned.fill(
                    child: AspectRatio(
                      aspectRatio: cameraController!.value.aspectRatio,
                      child: CameraPreview(cameraController!),
                    ),
                  ),
                  // Simple AR accessory overlay using local assets
                  if (isPersonDetected && accessoryAsset != null && accessoryId != null)
                    Positioned.fill(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final w = constraints.maxWidth;
                          final h = constraints.maxHeight;

                          // Helper function to build image with error handling
                          Widget buildAccessoryImage({
                            required String assetPath,
                            required double width,
                            double? height,
                            required double top,
                            double? left,
                            double? right,
                            BoxFit fit = BoxFit.contain,
                          }) {
                            return Positioned(
                              top: top,
                              left: left,
                              right: right,
                              width: width,
                              height: height,
                              child: IgnorePointer(
                                child: Builder(
                                  builder: (context) {
                                    try {
                                      // Calculate safe cache dimensions (max 2048px to prevent memory issues)
                                      final safeCacheWidth = width > 0 && width < 2048 
                                          ? width.toInt() 
                                          : null;
                                      
                                      int? safeCacheHeight;
                                      if (height != null) {
                                        final h = height;
                                        if (h > 0 && h < 2048) {
                                          safeCacheHeight = h.toInt();
                                        }
                                      }

                                      return Image.asset(
                                        assetPath,
                                        fit: fit,
                                        errorBuilder: (context, error, stackTrace) {
                                          debugPrint('Error loading accessory image ($assetPath): $error');
                                          debugPrint('Stack trace: $stackTrace');
                                          return const SizedBox.shrink();
                                        },
                                        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                                          if (wasSynchronouslyLoaded) {
                                            return child;
                                          }
                                          return AnimatedOpacity(
                                            opacity: frame == null ? 0 : 1,
                                            duration: const Duration(milliseconds: 200),
                                            child: child,
                                          );
                                        },
                                        // Prevent memory issues with large images
                                        cacheWidth: safeCacheWidth,
                                        cacheHeight: safeCacheHeight,
                                      );
                                    } catch (e) {
                                      debugPrint('Exception loading accessory image ($assetPath): $e');
                                      return const SizedBox.shrink();
                                    }
                                  },
                                ),
                              ),
                            );
                          }

                          // Sizes are proportional to screen size for demo purposes
                          if (accessoryId == 'hat') {
                            final hatWidth = w * 0.45;
                            return Stack(
                              children: [
                                // Hat near top-center
                                buildAccessoryImage(
                                  assetPath: accessoryAsset!,
                                  width: hatWidth,
                                  top: h * 0.10,
                                  left: (w - hatWidth) / 2,
                                ),
                              ],
                            );
                          } else if (accessoryId == 'earrings') {
                            final earringWidth = w * 0.10;
                            return Stack(
                              children: [
                                // Left earring near head-left
                                buildAccessoryImage(
                                  assetPath: accessoryAsset!,
                                  width: earringWidth,
                                  top: h * 0.22,
                                  left: w * 0.32,
                                ),
                                // Right earring near head-right (mirrored)
                                buildAccessoryImage(
                                  assetPath: accessoryAsset!,
                                  width: earringWidth,
                                  top: h * 0.22,
                                  right: w * 0.32,
                                ),
                              ],
                            );
                          } else if (accessoryId == 'headphones') {
                            // Headphones positioned on top of head
                            final headphoneWidth = w * 0.65;
                            final headphoneHeight = h * 0.25;
                            return Stack(
                              children: [
                                buildAccessoryImage(
                                  assetPath: accessoryAsset!,
                                  width: headphoneWidth,
                                  height: headphoneHeight,
                                  top: h * 0.08,
                                  left: (w - headphoneWidth) / 2,
                                ),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  // AR overlay indicator
                  if (isPersonDetected)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppTheme.successGreen.withValues(alpha: 0.8),
                            width: 3,
                          ),
                        ),
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 4.w,
                              vertical: 1.h,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  AppTheme.successGreen.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'AR Avatar Aktif',
                              style: AppTheme.darkTheme.textTheme.labelMedium
                                  ?.copyWith(
                                color: AppTheme.primaryDark,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  // Person detection keypoints overlay
                  if (isPersonDetected)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: KeypointsPainter(),
                      ),
                    ),
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: AppTheme.accentCyan,
                      strokeWidth: 3,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Memuat kamera...',
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class KeypointsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.accentCyan.withValues(alpha: 0.7)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Mock keypoints for demonstration
    final keypoints = [
      Offset(size.width * 0.5, size.height * 0.2), // Head
      Offset(size.width * 0.5, size.height * 0.35), // Neck
      Offset(size.width * 0.4, size.height * 0.45), // Left shoulder
      Offset(size.width * 0.6, size.height * 0.45), // Right shoulder
      Offset(size.width * 0.5, size.height * 0.6), // Torso center
    ];

    // Draw keypoints
    for (final point in keypoints) {
      canvas.drawCircle(point, 4, paint);
    }

    // Draw skeleton connections
    final linePaint = Paint()
      ..color = AppTheme.accentCyan.withValues(alpha: 0.5)
      ..strokeWidth = 1.5;

    // Connect keypoints
    canvas.drawLine(keypoints[0], keypoints[1], linePaint); // Head to neck
    canvas.drawLine(
        keypoints[1], keypoints[2], linePaint); // Neck to left shoulder
    canvas.drawLine(
        keypoints[1], keypoints[3], linePaint); // Neck to right shoulder
    canvas.drawLine(keypoints[1], keypoints[4], linePaint); // Neck to torso
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
