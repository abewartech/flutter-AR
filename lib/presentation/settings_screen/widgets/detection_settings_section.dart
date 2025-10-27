import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class DetectionSettingsSection extends StatefulWidget {
  final double detectionSensitivity;
  final int autoSwitchTimer;
  final bool isRearCamera;
  final Function(double) onSensitivityChanged;
  final Function(int) onTimerChanged;
  final Function(bool) onCameraToggled;

  const DetectionSettingsSection({
    super.key,
    required this.detectionSensitivity,
    required this.autoSwitchTimer,
    required this.isRearCamera,
    required this.onSensitivityChanged,
    required this.onTimerChanged,
    required this.onCameraToggled,
  });

  @override
  State<DetectionSettingsSection> createState() =>
      _DetectionSettingsSectionState();
}

class _DetectionSettingsSectionState extends State<DetectionSettingsSection> {
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
            'Pengaturan Deteksi',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          _buildSensitivitySlider(),
          SizedBox(height: 2.h),
          _buildTimerSetting(),
          SizedBox(height: 2.h),
          _buildCameraToggle(),
        ],
      ),
    );
  }

  Widget _buildSensitivitySlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Sensitivitas Deteksi',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textPrimary,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.accentCyan.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Text(
                _getSensitivityLabel(widget.detectionSensitivity),
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.accentCyan,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppTheme.accentCyan,
            thumbColor: AppTheme.accentCyan,
            overlayColor: AppTheme.accentCyan.withValues(alpha: 0.2),
            inactiveTrackColor: AppTheme.dividerColor,
            trackHeight: 0.5.h,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 2.w),
          ),
          child: Slider(
            value: widget.detectionSensitivity,
            min: 0.0,
            max: 2.0,
            divisions: 2,
            onChanged: widget.onSensitivityChanged,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Rendah',
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            Text(
              'Sedang',
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            Text(
              'Tinggi',
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimerSetting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Timer Auto-Switch',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textPrimary,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.successGreen.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Text(
                '${widget.autoSwitchTimer}s',
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.successGreen,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppTheme.successGreen,
            thumbColor: AppTheme.successGreen,
            overlayColor: AppTheme.successGreen.withValues(alpha: 0.2),
            inactiveTrackColor: AppTheme.dividerColor,
            trackHeight: 0.5.h,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 2.w),
          ),
          child: Slider(
            value: widget.autoSwitchTimer.toDouble(),
            min: 5.0,
            max: 30.0,
            divisions: 5,
            onChanged: (value) => widget.onTimerChanged(value.round()),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '5s',
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            Text(
              '30s',
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCameraToggle() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kamera Utama',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textPrimary,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                widget.isRearCamera ? 'Kamera Belakang' : 'Kamera Depan',
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          Switch(
            value: widget.isRearCamera,
            onChanged: widget.onCameraToggled,
            activeColor: AppTheme.accentCyan,
            activeTrackColor: AppTheme.accentCyan.withValues(alpha: 0.3),
            inactiveThumbColor: AppTheme.textSecondary,
            inactiveTrackColor: AppTheme.dividerColor,
          ),
        ],
      ),
    );
  }

  String _getSensitivityLabel(double value) {
    if (value <= 0.5) return 'Rendah';
    if (value <= 1.5) return 'Sedang';
    return 'Tinggi';
  }
}
