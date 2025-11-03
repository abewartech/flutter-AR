import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FloatingControlsWidget extends StatelessWidget {
  final VoidCallback? onCustomizationTap;
  final VoidCallback? onResetAvatar;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onSwitchCamera;
  final bool isPersonDetected;

  const FloatingControlsWidget({
    Key? key,
    this.onCustomizationTap,
    this.onResetAvatar,
    this.onSettingsTap,
    this.onSwitchCamera,
    required this.isPersonDetected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Settings button (top-left)
        Positioned(
          top: MediaQuery.of(context).padding.top + 1.h,
          left: 4.w,
          child: GestureDetector(
            onTap: onSettingsTap,
            child: Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: AppTheme.overlayTransparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.textSecondary.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'settings',
                  color: AppTheme.textPrimary,
                  size: 6.w,
                ),
              ),
            ),
          ),
        ),

        // Camera switch button (top-right)
        Positioned(
          top: MediaQuery.of(context).padding.top + 1.h,
          right: 4.w,
          child: GestureDetector(
            onTap: onSwitchCamera,
            child: Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: AppTheme.overlayTransparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.accentCyan.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'flip_camera_android',
                  color: AppTheme.accentCyan,
                  size: 6.w,
                ),
              ),
            ),
          ),
        ),

        // Avatar customization button (bottom-right)
        Positioned(
          bottom: 15.h,
          right: 4.w,
          child: GestureDetector(
            onTap: isPersonDetected ? onCustomizationTap : null,
            child: AnimatedContainer(
              duration: AppTheme.standardAnimation,
              width: 14.w,
              height: 14.w,
              decoration: BoxDecoration(
                color: isPersonDetected
                    ? AppTheme.accentCyan
                    : AppTheme.textSecondary.withValues(alpha: 0.5),
                shape: BoxShape.circle,
                boxShadow: isPersonDetected
                    ? [
                        BoxShadow(
                          color: AppTheme.accentCyan.withValues(alpha: 0.3),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'face_retouching_natural',
                  color: isPersonDetected
                      ? AppTheme.primaryDark
                      : AppTheme.textSecondary,
                  size: 7.w,
                ),
              ),
            ),
          ),
        ),

        // Avatar reset button (bottom-right, smaller)
        if (isPersonDetected)
          Positioned(
            bottom: 10.h,
            right: 4.w,
            child: GestureDetector(
              onTap: onResetAvatar,
              child: Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: AppTheme.overlayTransparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.warningAmber.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'refresh',
                    color: AppTheme.warningAmber,
                    size: 5.w,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
