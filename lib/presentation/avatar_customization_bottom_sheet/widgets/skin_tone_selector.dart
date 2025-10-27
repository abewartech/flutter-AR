import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SkinToneSelector extends StatelessWidget {
  final List<Color> skinTones;
  final Color selectedTone;
  final Function(Color) onToneSelected;

  const SkinToneSelector({
    super.key,
    required this.skinTones,
    required this.selectedTone,
    required this.onToneSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12.h,
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              'Warna Kulit',
              style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: skinTones.length,
              itemBuilder: (context, index) {
                final tone = skinTones[index];
                final isSelected = tone == selectedTone;

                return GestureDetector(
                  onTap: () => onToneSelected(tone),
                  child: Container(
                    width: 12.w,
                    height: 12.w,
                    margin: EdgeInsets.only(right: 3.w),
                    decoration: BoxDecoration(
                      color: tone,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.accentCyan
                            : Colors.transparent,
                        width: isSelected ? 3 : 0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.shadowColor,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
