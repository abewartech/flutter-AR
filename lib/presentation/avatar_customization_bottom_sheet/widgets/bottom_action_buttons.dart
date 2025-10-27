import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BottomActionButtons extends StatelessWidget {
  final VoidCallback onResetAvatar;
  final VoidCallback onSavePreset;
  final bool isLoading;

  const BottomActionButtons({
    super.key,
    required this.onResetAvatar,
    required this.onSavePreset,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated,
        border: Border(
          top: BorderSide(
            color: AppTheme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: isLoading ? null : onResetAvatar,
                    icon: CustomIconWidget(
                      iconName: 'refresh',
                      color: isLoading
                          ? AppTheme.textSecondary
                          : AppTheme.accentCyan,
                      size: 4.w,
                    ),
                    label: Text(
                      'Reset Avatar',
                      style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                        color: isLoading
                            ? AppTheme.textSecondary
                            : AppTheme.accentCyan,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      side: BorderSide(
                        color: isLoading
                            ? AppTheme.textSecondary
                            : AppTheme.accentCyan,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isLoading ? null : onSavePreset,
                    icon: isLoading
                        ? SizedBox(
                            width: 4.w,
                            height: 4.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.primaryDark,
                              ),
                            ),
                          )
                        : CustomIconWidget(
                            iconName: 'save',
                            color: AppTheme.primaryDark,
                            size: 4.w,
                          ),
                    label: Text(
                      isLoading ? 'Menyimpan...' : 'Simpan Preset',
                      style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.primaryDark,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isLoading
                          ? AppTheme.textSecondary
                          : AppTheme.accentCyan,
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              'Tekan lama pada aksesori untuk melihat detail 360°',
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary.withValues(alpha: 0.7),
                fontSize: 10.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
