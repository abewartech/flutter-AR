import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VideoGestureDetectorWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final VoidCallback onDoubleTapLeft;
  final VoidCallback onDoubleTapRight;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;
  final Function(ScaleUpdateDetails) onScaleUpdate;
  final VoidCallback onLongPress;

  const VideoGestureDetectorWidget({
    super.key,
    required this.child,
    required this.onTap,
    required this.onDoubleTapLeft,
    required this.onDoubleTapRight,
    required this.onSwipeLeft,
    required this.onSwipeRight,
    required this.onScaleUpdate,
    required this.onLongPress,
  });

  @override
  State<VideoGestureDetectorWidget> createState() =>
      _VideoGestureDetectorWidgetState();
}

class _VideoGestureDetectorWidgetState extends State<VideoGestureDetectorWidget>
    with TickerProviderStateMixin {
  late AnimationController _skipAnimationController;
  late Animation<double> _skipAnimation;
  String _skipDirection = '';
  bool _showSkipFeedback = false;

  @override
  void initState() {
    super.initState();
    _skipAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _skipAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _skipAnimationController,
      curve: Curves.easeOutBack,
    ));
  }

  @override
  void dispose() {
    _skipAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: widget.onTap,
          onLongPress: widget.onLongPress,
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity != null) {
              if (details.primaryVelocity! > 500) {
                // Swipe right (previous video)
                widget.onSwipeRight();
              } else if (details.primaryVelocity! < -500) {
                // Swipe left (next video)
                widget.onSwipeLeft();
              }
            }
          },
          child: Row(
            children: [
              // Left side for backward skip
              Expanded(
                child: GestureDetector(
                  onDoubleTap: () {
                    _showSkipAnimation('backward');
                    widget.onDoubleTapLeft();
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: widget.child,
                  ),
                ),
              ),
              // Right side for forward skip
              Expanded(
                child: GestureDetector(
                  onDoubleTap: () {
                    _showSkipAnimation('forward');
                    widget.onDoubleTapRight();
                  },
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Scale gesture detector for zoom
        GestureDetector(
          onScaleUpdate: widget.onScaleUpdate,
          child: Container(
            color: Colors.transparent,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        // Skip feedback animation
        if (_showSkipFeedback) _buildSkipFeedback(),
      ],
    );
  }

  void _showSkipAnimation(String direction) {
    setState(() {
      _skipDirection = direction;
      _showSkipFeedback = true;
    });

    _skipAnimationController.forward().then((_) {
      _skipAnimationController.reverse().then((_) {
        if (mounted) {
          setState(() {
            _showSkipFeedback = false;
          });
        }
      });
    });
  }

  Widget _buildSkipFeedback() {
    return Center(
      child: AnimatedBuilder(
        animation: _skipAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _skipAnimation.value,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 6.w,
                vertical: 2.h,
              ),
              decoration: BoxDecoration(
                color: AppTheme.surfaceElevated.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadowColor,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: _skipDirection == 'backward'
                        ? 'replay_10'
                        : 'forward_10',
                    color: AppTheme.accentCyan,
                    size: 8.w,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    _skipDirection == 'backward'
                        ? '10 detik mundur'
                        : '10 detik maju',
                    style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
