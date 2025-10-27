import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VideoOptionsSection extends StatefulWidget {
  final bool autoplayEnabled;
  final String videoQuality;
  final int refreshInterval;
  final Function(bool) onAutoplayToggled;
  final Function(String) onQualityChanged;
  final Function(int) onRefreshIntervalChanged;

  const VideoOptionsSection({
    super.key,
    required this.autoplayEnabled,
    required this.videoQuality,
    required this.refreshInterval,
    required this.onAutoplayToggled,
    required this.onQualityChanged,
    required this.onRefreshIntervalChanged,
  });

  @override
  State<VideoOptionsSection> createState() => _VideoOptionsSectionState();
}

class _VideoOptionsSectionState extends State<VideoOptionsSection> {
  final List<Map<String, dynamic>> qualityOptions = [
    {
      'value': 'Auto',
      'label': 'Otomatis',
      'description': 'Sesuaikan dengan koneksi'
    },
    {
      'value': 'High',
      'label': 'Tinggi',
      'description': '1080p - Kualitas terbaik'
    },
    {'value': 'Medium', 'label': 'Sedang', 'description': '720p - Seimbang'},
  ];

  final List<Map<String, dynamic>> refreshOptions = [
    {'value': 30, 'label': '30 menit'},
    {'value': 60, 'label': '1 jam'},
    {'value': 180, 'label': '3 jam'},
    {'value': 360, 'label': '6 jam'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceNearBlack,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(
          color: AppTheme.dividerColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Opsi Video',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          _buildAutoplayToggle(),
          SizedBox(height: 2.h),
          _buildQualitySelector(),
          SizedBox(height: 2.h),
          _buildRefreshIntervalSelector(),
        ],
      ),
    );
  }

  Widget _buildAutoplayToggle() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Putar Otomatis',
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textPrimary,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Video akan diputar otomatis saat tidak ada orang terdeteksi',
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 4.w),
          Switch(
            value: widget.autoplayEnabled,
            onChanged: widget.onAutoplayToggled,
            activeColor: AppTheme.accentCyan,
            activeTrackColor: AppTheme.accentCyan.withValues(alpha: 0.3),
            inactiveThumbColor: AppTheme.textSecondary,
            inactiveTrackColor: AppTheme.dividerColor,
          ),
        ],
      ),
    );
  }

  Widget _buildQualitySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kualitas Video',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        SizedBox(height: 1.5.h),
        ...qualityOptions.map((option) => _buildQualityOption(option)).toList(),
      ],
    );
  }

  Widget _buildQualityOption(Map<String, dynamic> option) {
    final isSelected = widget.videoQuality == option['value'];

    return GestureDetector(
      onTap: () => widget.onQualityChanged(option['value']),
      child: Container(
        margin: EdgeInsets.only(bottom: 1.h),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.accentCyan.withValues(alpha: 0.1)
              : AppTheme.surfaceElevated,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(
            color: isSelected
                ? AppTheme.accentCyan
                : AppTheme.dividerColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 4.w,
              height: 4.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      isSelected ? AppTheme.accentCyan : AppTheme.textSecondary,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 2.w,
                        height: 2.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.accentCyan,
                        ),
                      ),
                    )
                  : null,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option['label'],
                    style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                      color: isSelected
                          ? AppTheme.accentCyan
                          : AppTheme.textPrimary,
                      fontWeight:
                          isSelected ? FontWeight.w500 : FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    option['description'],
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRefreshIntervalSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Interval Refresh Playlist',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Seberapa sering aplikasi memeriksa video baru',
          style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        SizedBox(height: 1.5.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.surfaceElevated,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            border: Border.all(
              color: AppTheme.dividerColor.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: widget.refreshInterval,
              onChanged: (int? newValue) {
                if (newValue != null) {
                  widget.onRefreshIntervalChanged(newValue);
                }
              },
              dropdownColor: AppTheme.surfaceElevated,
              icon: CustomIconWidget(
                iconName: 'keyboard_arrow_down',
                color: AppTheme.textSecondary,
                size: 5.w,
              ),
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textPrimary,
              ),
              items: refreshOptions.map<DropdownMenuItem<int>>((option) {
                return DropdownMenuItem<int>(
                  value: option['value'],
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'schedule',
                        color: AppTheme.accentCyan,
                        size: 4.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        option['label'],
                        style:
                            AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
