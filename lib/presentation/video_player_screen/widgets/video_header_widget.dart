import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VideoHeaderWidget extends StatelessWidget {
  final String videoTitle;
  final int currentVideoIndex;
  final int totalVideos;
  final bool isVisible;
  final VoidCallback onBackPressed;

  const VideoHeaderWidget({
    super.key,
    required this.videoTitle,
    required this.currentVideoIndex,
    required this.totalVideos,
    required this.isVisible,
    required this.onBackPressed,
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
              AppTheme.overlayTransparent,
              Colors.transparent,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  // Back button
                  GestureDetector(
                    onTap: onBackPressed,
                    child: Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceElevated.withValues(alpha: 0.8),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: 'arrow_back',
                          color: AppTheme.textPrimary,
                          size: 5.w,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  // Video info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          videoTitle,
                          style: AppTheme.darkTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          '${currentVideoIndex + 1} of $totalVideos',
                          style:
                              AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // More options button
                  GestureDetector(
                    onTap: () => _showContextMenu(context),
                    child: Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceElevated.withValues(alpha: 0.8),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: 'more_vert',
                          color: AppTheme.textPrimary,
                          size: 5.w,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildContextMenuItem(
              context,
              icon: 'share',
              title: 'Bagikan Video',
              onTap: () {
                Navigator.pop(context);
                // Handle share functionality
              },
            ),
            _buildContextMenuItem(
              context,
              icon: 'favorite_border',
              title: 'Tambah ke Favorit',
              onTap: () {
                Navigator.pop(context);
                // Handle add to favorites
              },
            ),
            _buildContextMenuItem(
              context,
              icon: 'report',
              title: 'Laporkan Konten',
              onTap: () {
                Navigator.pop(context);
                // Handle report content
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContextMenuItem(
    BuildContext context, {
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        color: AppTheme.textSecondary,
        size: 6.w,
      ),
      title: Text(
        title,
        style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
          color: AppTheme.textPrimary,
          fontSize: 13.sp,
        ),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 6.w),
    );
  }
}
