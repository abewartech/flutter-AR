import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VideoControlsWidget extends StatelessWidget {
  final bool isPlaying;
  final bool isVisible;
  final Duration currentPosition;
  final Duration totalDuration;
  final VoidCallback onPlayPause;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final Function(Duration) onSeek;

  const VideoControlsWidget({
    super.key,
    required this.isPlaying,
    required this.isVisible,
    required this.currentPosition,
    required this.totalDuration,
    required this.onPlayPause,
    required this.onPrevious,
    required this.onNext,
    required this.onSeek,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: AppTheme.standardAnimation,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              AppTheme.overlayTransparent,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Progress bar
              _buildProgressBar(),
              SizedBox(height: 2.h),
              // Control buttons
              _buildControlButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    final progress = totalDuration.inMilliseconds > 0
        ? currentPosition.inMilliseconds / totalDuration.inMilliseconds
        : 0.0;

    return Column(
      children: [
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 0.5.h,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 1.5.w),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 3.w),
            activeTrackColor: AppTheme.accentCyan,
            inactiveTrackColor: AppTheme.textSecondary.withValues(alpha: 0.3),
            thumbColor: AppTheme.accentCyan,
            overlayColor: AppTheme.accentCyan.withValues(alpha: 0.2),
          ),
          child: Slider(
            value: progress.clamp(0.0, 1.0),
            onChanged: (value) {
              final newPosition = Duration(
                milliseconds: (value * totalDuration.inMilliseconds).round(),
              );
              onSeek(newPosition);
            },
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _formatDuration(currentPosition),
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textPrimary,
                fontSize: 10.sp,
              ),
            ),
            Text(
              _formatDuration(totalDuration),
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Previous button
        _buildControlButton(
          icon: 'skip_previous',
          onTap: onPrevious,
          size: 8.w,
        ),
        SizedBox(width: 4.w),
        // Play/Pause button
        _buildControlButton(
          icon: isPlaying ? 'pause' : 'play_arrow',
          onTap: onPlayPause,
          size: 12.w,
          isPrimary: true,
        ),
        SizedBox(width: 4.w),
        // Next button
        _buildControlButton(
          icon: 'skip_next',
          onTap: onNext,
          size: 8.w,
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required String icon,
    required VoidCallback onTap,
    required double size,
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isPrimary
              ? AppTheme.accentCyan.withValues(alpha: 0.9)
              : AppTheme.surfaceElevated.withValues(alpha: 0.8),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowColor,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: icon,
            color: isPrimary ? AppTheme.primaryDark : AppTheme.textPrimary,
            size: size * 0.5,
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
