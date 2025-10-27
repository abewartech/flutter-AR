import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/app_settings_section.dart';
import './widgets/avatar_preferences_section.dart';
import './widgets/detection_settings_section.dart';
import './widgets/video_options_section.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Detection Settings State
  double _detectionSensitivity = 1.0;
  int _autoSwitchTimer = 15;
  bool _isRearCamera = true;

  // Avatar Preferences State
  int _selectedSkinTone = 1;
  List<int> _favoriteAccessories = [0, 2, 4];

  // Video Options State
  bool _autoplayEnabled = true;
  String _videoQuality = 'Auto';
  int _refreshInterval = 60;

  // App Settings State
  String _selectedLanguage = 'id';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 1.h),
              _buildHeaderSection(),
              SizedBox(height: 2.h),
              DetectionSettingsSection(
                detectionSensitivity: _detectionSensitivity,
                autoSwitchTimer: _autoSwitchTimer,
                isRearCamera: _isRearCamera,
                onSensitivityChanged: (value) {
                  setState(() => _detectionSensitivity = value);
                  _provideFeedback();
                },
                onTimerChanged: (value) {
                  setState(() => _autoSwitchTimer = value);
                  _provideFeedback();
                },
                onCameraToggled: (value) {
                  setState(() => _isRearCamera = value);
                  _provideFeedback();
                },
              ),
              AvatarPreferencesSection(
                selectedSkinTone: _selectedSkinTone,
                favoriteAccessories: _favoriteAccessories,
                onSkinToneChanged: (value) {
                  setState(() => _selectedSkinTone = value);
                  _provideFeedback();
                },
                onAccessoryToggled: (accessoryId) {
                  setState(() {
                    if (_favoriteAccessories.contains(accessoryId)) {
                      _favoriteAccessories.remove(accessoryId);
                    } else {
                      _favoriteAccessories.add(accessoryId);
                    }
                  });
                  _provideFeedback();
                },
                onAvatarReset: _resetAvatarSettings,
              ),
              VideoOptionsSection(
                autoplayEnabled: _autoplayEnabled,
                videoQuality: _videoQuality,
                refreshInterval: _refreshInterval,
                onAutoplayToggled: (value) {
                  setState(() => _autoplayEnabled = value);
                  _provideFeedback();
                },
                onQualityChanged: (value) {
                  setState(() => _videoQuality = value);
                  _provideFeedback();
                },
                onRefreshIntervalChanged: (value) {
                  setState(() => _refreshInterval = value);
                  _provideFeedback();
                },
              ),
              AppSettingsSection(
                selectedLanguage: _selectedLanguage,
                onLanguageChanged: (value) {
                  setState(() => _selectedLanguage = value);
                  _provideFeedback();
                },
                onPrivacyPolicyTapped: _openPrivacyPolicy,
                onClearCacheTapped: _clearCache,
              ),
              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          _provideFeedback();
          Navigator.of(context).pop();
        },
        child: Container(
          margin: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: AppTheme.surfaceElevated.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: 'arrow_back_ios',
              color: AppTheme.textPrimary,
              size: 5.w,
            ),
          ),
        ),
      ),
      title: Text(
        'Pengaturan',
        style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
          color: AppTheme.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        GestureDetector(
          onTap: () {
            _provideFeedback();
            _showResetAllConfirmation();
          },
          child: Container(
            margin: EdgeInsets.all(2.w),
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.warningAmber.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            child: CustomIconWidget(
              iconName: 'refresh',
              color: AppTheme.warningAmber,
              size: 5.w,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.accentCyan.withValues(alpha: 0.1),
            AppTheme.successGreen.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(
          color: AppTheme.accentCyan.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: AppTheme.accentCyan.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'settings',
                color: AppTheme.accentCyan,
                size: 8.w,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Konfigurasi AR Avatar',
                  style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Sesuaikan pengalaman AR dan video sesuai preferensi Anda',
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _provideFeedback() {
    HapticFeedback.lightImpact();
  }

  void _resetAvatarSettings() {
    setState(() {
      _selectedSkinTone = 1;
      _favoriteAccessories = [0, 2, 4];
    });
    _provideFeedback();
    _showSuccessMessage('Pengaturan avatar berhasil direset');
  }

  void _openPrivacyPolicy() {
    _provideFeedback();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceElevated,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          ),
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'privacy_tip',
                color: AppTheme.accentCyan,
                size: 6.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Kebijakan Privasi',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'AR Avatar Camera berkomitmen melindungi privasi pengguna:',
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textPrimary,
                  ),
                ),
                SizedBox(height: 1.h),
                _buildPrivacyPoint('• Data kamera hanya diproses secara lokal'),
                _buildPrivacyPoint(
                    '• Avatar dan preferensi disimpan di perangkat'),
                _buildPrivacyPoint(
                    '• Video streaming menggunakan koneksi aman'),
                _buildPrivacyPoint(
                    '• Tidak ada data pribadi dibagikan ke pihak ketiga'),
                SizedBox(height: 1.h),
                Text(
                  'Terakhir diperbarui: 27 Oktober 2025',
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Tutup',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.accentCyan,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPrivacyPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: Text(
        text,
        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
          color: AppTheme.textPrimary,
        ),
      ),
    );
  }

  void _clearCache() {
    _provideFeedback();
    // Simulate cache clearing process
    _showSuccessMessage('Cache berhasil dibersihkan (127.5 MB dibebaskan)');
  }

  void _showResetAllConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceElevated,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          ),
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'warning',
                color: AppTheme.errorCoral,
                size: 6.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Reset Semua',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            'Apakah Anda yakin ingin mereset semua pengaturan ke default? Tindakan ini tidak dapat dibatalkan.',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textPrimary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Batal',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetAllSettings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorCoral,
                foregroundColor: AppTheme.textPrimary,
              ),
              child: Text(
                'Reset Semua',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _resetAllSettings() {
    setState(() {
      // Reset Detection Settings
      _detectionSensitivity = 1.0;
      _autoSwitchTimer = 15;
      _isRearCamera = true;

      // Reset Avatar Preferences
      _selectedSkinTone = 1;
      _favoriteAccessories = [0, 2, 4];

      // Reset Video Options
      _autoplayEnabled = true;
      _videoQuality = 'Auto';
      _refreshInterval = 60;

      // Reset App Settings
      _selectedLanguage = 'id';
    });
    _provideFeedback();
    _showSuccessMessage('Semua pengaturan berhasil direset ke default');
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.successGreen,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                message,
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.surfaceElevated,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        margin: EdgeInsets.all(4.w),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
