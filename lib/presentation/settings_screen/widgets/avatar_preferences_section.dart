import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AvatarPreferencesSection extends StatefulWidget {
  final int selectedSkinTone;
  final List<int> favoriteAccessories;
  final Function(int) onSkinToneChanged;
  final Function(int) onAccessoryToggled;
  final VoidCallback onAvatarReset;

  const AvatarPreferencesSection({
    super.key,
    required this.selectedSkinTone,
    required this.favoriteAccessories,
    required this.onSkinToneChanged,
    required this.onAccessoryToggled,
    required this.onAvatarReset,
  });

  @override
  State<AvatarPreferencesSection> createState() =>
      _AvatarPreferencesSectionState();
}

class _AvatarPreferencesSectionState extends State<AvatarPreferencesSection> {
  final List<Map<String, dynamic>> skinTones = [
    {'id': 0, 'color': Color(0xFFFDBCB4), 'name': 'Terang'},
    {'id': 1, 'color': Color(0xFFEEAC99), 'name': 'Sedang'},
    {'id': 2, 'color': Color(0xFFE1906F), 'name': 'Sawo Matang'},
    {'id': 3, 'color': Color(0xFFC68642), 'name': 'Gelap'},
    {'id': 4, 'color': Color(0xFF8D5524), 'name': 'Sangat Gelap'},
  ];

  final List<Map<String, dynamic>> accessories = [
    {'id': 0, 'name': 'Kacamata Hitam', 'icon': 'visibility'},
    {'id': 1, 'name': 'Topi Baseball', 'icon': 'sports_baseball'},
    {'id': 2, 'name': 'Anting Emas', 'icon': 'circle'},
    {'id': 3, 'name': 'Kalung Perak', 'icon': 'favorite'},
    {'id': 4, 'name': 'Jam Tangan', 'icon': 'watch'},
    {'id': 5, 'name': 'Gelang', 'icon': 'radio_button_unchecked'},
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
            'Preferensi Avatar',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          _buildSkinToneSelector(),
          SizedBox(height: 3.h),
          _buildAccessoriesGrid(),
          SizedBox(height: 3.h),
          _buildResetButton(),
        ],
      ),
    );
  }

  Widget _buildSkinToneSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Warna Kulit Default',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        SizedBox(height: 1.5.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
                skinTones.map((tone) => _buildSkinToneOption(tone)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSkinToneOption(Map<String, dynamic> tone) {
    final isSelected = widget.selectedSkinTone == tone['id'];

    return GestureDetector(
      onTap: () => widget.onSkinToneChanged(tone['id']),
      child: Container(
        margin: EdgeInsets.only(right: 3.w),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: tone['color'],
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      isSelected ? AppTheme.accentCyan : AppTheme.dividerColor,
                  width: isSelected ? 3 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppTheme.accentCyan.withValues(alpha: 0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: isSelected
                  ? Center(
                      child: CustomIconWidget(
                        iconName: 'check',
                        color: AppTheme.textPrimary,
                        size: 4.w,
                      ),
                    )
                  : null,
            ),
            SizedBox(height: 1.h),
            Text(
              tone['name'],
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color:
                    isSelected ? AppTheme.accentCyan : AppTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccessoriesGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Aksesoris Favorit',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        SizedBox(height: 1.5.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 3.w,
            mainAxisSpacing: 1.5.h,
            childAspectRatio: 4,
          ),
          itemCount: accessories.length,
          itemBuilder: (context, index) =>
              _buildAccessoryItem(accessories[index]),
        ),
      ],
    );
  }

  Widget _buildAccessoryItem(Map<String, dynamic> accessory) {
    final isSelected = widget.favoriteAccessories.contains(accessory['id']);

    return GestureDetector(
      onTap: () => widget.onAccessoryToggled(accessory['id']),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
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
            CustomIconWidget(
              iconName: accessory['icon'],
              color: isSelected ? AppTheme.accentCyan : AppTheme.textSecondary,
              size: 4.w,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                accessory['name'],
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color:
                      isSelected ? AppTheme.accentCyan : AppTheme.textPrimary,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected)
              CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.accentCyan,
                size: 3.w,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildResetButton() {
    return Container(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _showResetConfirmation(),
        icon: CustomIconWidget(
          iconName: 'refresh',
          color: AppTheme.warningAmber,
          size: 4.w,
        ),
        label: Text(
          'Reset Avatar ke Default',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.warningAmber,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppTheme.warningAmber, width: 1),
          padding: EdgeInsets.symmetric(vertical: 1.5.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
        ),
      ),
    );
  }

  void _showResetConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceElevated,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          ),
          title: Text(
            'Reset Avatar',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Apakah Anda yakin ingin mereset semua pengaturan avatar ke default? Tindakan ini tidak dapat dibatalkan.',
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
                widget.onAvatarReset();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.warningAmber,
                foregroundColor: AppTheme.primaryDark,
              ),
              child: Text(
                'Reset',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primaryDark,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
