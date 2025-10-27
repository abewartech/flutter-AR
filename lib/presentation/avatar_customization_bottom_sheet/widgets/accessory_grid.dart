import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AccessoryGrid extends StatelessWidget {
  final List<Map<String, dynamic>> accessories;
  final String? selectedAccessoryId;
  final Function(Map<String, dynamic>) onAccessorySelected;
  final Function(Map<String, dynamic>) onAccessoryLongPress;

  const AccessoryGrid({
    super.key,
    required this.accessories,
    this.selectedAccessoryId,
    required this.onAccessorySelected,
    required this.onAccessoryLongPress,
  });

  @override
  Widget build(BuildContext context) {
    if (accessories.isEmpty) {
      return Container(
        height: 30.h,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'category',
                color: AppTheme.textSecondary,
                size: 8.w,
              ),
              SizedBox(height: 2.h),
              Text(
                'Tidak ada aksesori tersedia',
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      constraints: BoxConstraints(
        maxHeight: 35.h,
        minHeight: 20.h,
      ),
      child: GridView.builder(
        padding: EdgeInsets.all(4.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 3.w,
          mainAxisSpacing: 3.w,
          childAspectRatio: 0.8,
        ),
        itemCount: accessories.length,
        itemBuilder: (context, index) {
          final accessory = accessories[index];
          final isSelected = accessory['id'] == selectedAccessoryId;

          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              onAccessorySelected(accessory);
            },
            onLongPress: () {
              HapticFeedback.mediumImpact();
              onAccessoryLongPress(accessory);
            },
            child: AnimatedContainer(
              duration: AppTheme.fastAnimation,
              decoration: BoxDecoration(
                color: AppTheme.surfaceNearBlack,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(
                  color: isSelected ? AppTheme.accentCyan : Colors.transparent,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadowColor,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(2.w),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusSmall),
                        child: CustomImageWidget(
                          imageUrl: accessory['image'] as String,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          semanticLabel: accessory['semanticLabel'] as String,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            accessory['name'] as String,
                            style: AppTheme.darkTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: isSelected
                                  ? AppTheme.accentCyan
                                  : AppTheme.textPrimary,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (accessory['price'] != null) ...[
                            SizedBox(height: 0.5.h),
                            Text(
                              accessory['price'] as String,
                              style: AppTheme.darkTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: AppTheme.successGreen,
                                fontSize: 8.sp,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
