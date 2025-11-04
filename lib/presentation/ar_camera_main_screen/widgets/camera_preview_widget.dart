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
                  if (isPersonDetected && accessoryAsset != null)
                    Positioned.fill(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final w = constraints.maxWidth;
                          final h = constraints.maxHeight;

                          // Sizes are proportional to screen size for demo purposes
                          if (accessoryId == 'hat') {
                            final hatWidth = w * 0.45;
                            return Stack(
                              children: [
                                // Hat near top-center
                                Positioned(
                                  top: h * 0.10,
                                  left: (w - hatWidth) / 2,
                                  width: hatWidth,
                                  child: IgnorePointer(
                                    child: Image.asset(
                                      accessoryAsset!,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else if (accessoryId == 'earrings') {
                            final earringWidth = w * 0.10;
                            return Stack(
                              children: [
                                // Left earring near head-left
                                Positioned(
                                  top: h * 0.22,
                                  left: w * 0.32,
                                  width: earringWidth,
                                  child: IgnorePointer(
                                    child: Image.asset(
                                      accessoryAsset!,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                // Right earring near head-right (mirrored)
                                Positioned(
                                  top: h * 0.22,
                                  right: w * 0.32,
                                  width: earringWidth,
                                  child: IgnorePointer(
                                    child: Image.asset(
                                      accessoryAsset!,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
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
