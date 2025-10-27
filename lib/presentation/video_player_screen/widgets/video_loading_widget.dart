import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class VideoLoadingWidget extends StatefulWidget {
  final bool isVisible;
  final String? message;

  const VideoLoadingWidget({
    super.key,
    required this.isVisible,
    this.message,
  });

  @override
  State<VideoLoadingWidget> createState() => _VideoLoadingWidgetState();
}

class _VideoLoadingWidgetState extends State<VideoLoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.isVisible) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(VideoLoadingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isVisible && oldWidget.isVisible) {
      _pulseController.stop();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppTheme.primaryDark.withValues(alpha: 0.8),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceElevated,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.accentCyan.withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 8.w,
                        height: 8.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 0.8.w,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.accentCyan,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 4.h),
            Text(
              widget.message ?? 'Memuat video...',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Container(
              width: 60.w,
              child: LinearProgressIndicator(
                backgroundColor: AppTheme.surfaceElevated,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.accentCyan,
                ),
                minHeight: 0.5.h,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
