import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AvatarCustomizationSheet extends StatefulWidget {
  final bool isVisible;
  final VoidCallback? onClose;
  final Function(String)? onSkinToneChanged;
  final Function(String)? onAccessoryChanged;

  const AvatarCustomizationSheet({
    Key? key,
    required this.isVisible,
    this.onClose,
    this.onSkinToneChanged,
    this.onAccessoryChanged,
  }) : super(key: key);

  @override
  State<AvatarCustomizationSheet> createState() =>
      _AvatarCustomizationSheetState();
}

class _AvatarCustomizationSheetState extends State<AvatarCustomizationSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  String _selectedSkinTone = 'medium';
  String _selectedAccessory = 'none';

  // Mock skin tone options
  final List<Map<String, dynamic>> _skinTones = [
    {
      "id": "light",
      "name": "Terang",
      "color": Color(0xFFFDBCB4),
      "description": "Warna kulit terang"
    },
    {
      "id": "medium",
      "name": "Sedang",
      "color": Color(0xFFEEA47F),
      "description": "Warna kulit sedang"
    },
    {
      "id": "tan",
      "name": "Sawo Matang",
      "color": Color(0xFFCD9777),
      "description": "Warna kulit sawo matang"
    },
    {
      "id": "dark",
      "name": "Gelap",
      "color": Color(0xFF8D5524),
      "description": "Warna kulit gelap"
    }
  ];

  // Mock accessory options
  final List<Map<String, dynamic>> _accessories = [
    {
      "id": "none",
      "name": "Tanpa Aksesoris",
      "icon": "block",
      "description": "Tidak menggunakan aksesoris"
    },
    {
      "id": "glasses",
      "name": "Kacamata",
      "icon": "visibility",
      "description": "Kacamata hitam modern"
    },
    {
      "id": "hat",
      "name": "Topi",
      "icon": "sports_baseball",
      "description": "Topi baseball casual"
    },
    {
      "id": "earrings",
      "name": "Anting",
      "icon": "diamond",
      "description": "Anting sampel untuk pengujian"
    },
    {
      "id": "headphones",
      "name": "Headphone",
      "icon": "headphones",
      "description": "Headphone gaming"
    },
    {
      "id": "mask",
      "name": "Masker",
      "icon": "masks",
      "description": "Masker wajah"
    }
  ];

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: AppTheme.standardAnimation,
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));

    if (widget.isVisible) {
      _slideController.forward();
    }
  }

  @override
  void didUpdateWidget(AvatarCustomizationSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _slideController.forward();
      } else {
        _slideController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _selectSkinTone(String skinToneId) {
    setState(() {
      _selectedSkinTone = skinToneId;
    });
    widget.onSkinToneChanged?.call(skinToneId);
  }

  void _selectAccessory(String accessoryId) {
    setState(() {
      _selectedAccessory = accessoryId;
    });
    widget.onAccessoryChanged?.call(accessoryId);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) return const SizedBox.shrink();

    return GestureDetector(
      onTap: widget.onClose,
      child: Container(
        width: 100.w,
        height: 100.h,
        color: AppTheme.overlayTransparent,
        child: SlideTransition(
          position: _slideAnimation,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {}, // Prevent tap through
              child: Container(
                width: 100.w,
                constraints: BoxConstraints(
                  maxHeight: 70.h,
                  minHeight: 50.h,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceElevated,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppTheme.radiusXLarge),
                    topRight: Radius.circular(AppTheme.radiusXLarge),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Handle bar
                    Container(
                      margin: EdgeInsets.only(top: 2.h),
                      width: 12.w,
                      height: 0.5.h,
                      decoration: BoxDecoration(
                        color: AppTheme.textSecondary.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    // Header
                    Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Kustomisasi Avatar',
                              style: AppTheme.darkTheme.textTheme.titleLarge
                                  ?.copyWith(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: widget.onClose,
                            child: Container(
                              padding: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                color: AppTheme.textSecondary
                                    .withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: CustomIconWidget(
                                iconName: 'close',
                                color: AppTheme.textSecondary,
                                size: 5.w,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Skin tone section
                            Text(
                              'Warna Kulit',
                              style: AppTheme.darkTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 2.h),

                            SizedBox(
                              height: 12.h,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: _skinTones.length,
                                separatorBuilder: (context, index) =>
                                    SizedBox(width: 3.w),
                                itemBuilder: (context, index) {
                                  final skinTone = _skinTones[index];
                                  final isSelected =
                                      _selectedSkinTone == skinTone["id"];

                                  return GestureDetector(
                                    onTap: () => _selectSkinTone(
                                        skinTone["id"] as String),
                                    child: Container(
                                      width: 20.w,
                                      padding: EdgeInsets.all(2.w),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppTheme.accentCyan
                                                .withValues(alpha: 0.2)
                                            : AppTheme.surfaceNearBlack,
                                        borderRadius: BorderRadius.circular(
                                            AppTheme.radiusMedium),
                                        border: Border.all(
                                          color: isSelected
                                              ? AppTheme.accentCyan
                                              : AppTheme.dividerColor,
                                          width: isSelected ? 2 : 1,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 12.w,
                                            height: 6.h,
                                            decoration: BoxDecoration(
                                              color: skinTone["color"] as Color,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: AppTheme.textSecondary
                                                    .withValues(alpha: 0.3),
                                                width: 1,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 1.h),
                                          Text(
                                            skinTone["name"] as String,
                                            style: AppTheme
                                                .darkTheme.textTheme.bodySmall
                                                ?.copyWith(
                                              color: isSelected
                                                  ? AppTheme.accentCyan
                                                  : AppTheme.textSecondary,
                                              fontWeight: isSelected
                                                  ? FontWeight.w600
                                                  : FontWeight.w400,
                                            ),
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                            SizedBox(height: 4.h),

                            // Accessories section
                            Text(
                              'Aksesoris',
                              style: AppTheme.darkTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 2.h),

                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 3.w,
                                mainAxisSpacing: 2.h,
                                childAspectRatio: 2.5,
                              ),
                              itemCount: _accessories.length,
                              itemBuilder: (context, index) {
                                final accessory = _accessories[index];
                                final isSelected =
                                    _selectedAccessory == accessory["id"];

                                return GestureDetector(
                                  onTap: () => _selectAccessory(
                                      accessory["id"] as String),
                                  child: Container(
                                    padding: EdgeInsets.all(3.w),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppTheme.accentCyan
                                              .withValues(alpha: 0.2)
                                          : AppTheme.surfaceNearBlack,
                                      borderRadius: BorderRadius.circular(
                                          AppTheme.radiusMedium),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppTheme.accentCyan
                                            : AppTheme.dividerColor,
                                        width: isSelected ? 2 : 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        CustomIconWidget(
                                          iconName: accessory["icon"] as String,
                                          color: isSelected
                                              ? AppTheme.accentCyan
                                              : AppTheme.textSecondary,
                                          size: 6.w,
                                        ),
                                        SizedBox(width: 3.w),
                                        Expanded(
                                          child: Text(
                                            accessory["name"] as String,
                                            style: AppTheme
                                                .darkTheme.textTheme.bodyMedium
                                                ?.copyWith(
                                              color: isSelected
                                                  ? AppTheme.accentCyan
                                                  : AppTheme.textPrimary,
                                              fontWeight: isSelected
                                                  ? FontWeight.w600
                                                  : FontWeight.w400,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),

                            SizedBox(height: 4.h),
                          ],
                        ),
                      ),
                    ),

                    // Apply button
                    Container(
                      padding: EdgeInsets.all(4.w),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: widget.onClose,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentCyan,
                            foregroundColor: AppTheme.primaryDark,
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusMedium),
                            ),
                          ),
                          child: Text(
                            'Terapkan Perubahan',
                            style: AppTheme.darkTheme.textTheme.titleMedium
                                ?.copyWith(
                              color: AppTheme.primaryDark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
