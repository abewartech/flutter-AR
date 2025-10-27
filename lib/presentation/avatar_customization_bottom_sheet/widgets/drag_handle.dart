import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class DragHandle extends StatelessWidget {
  const DragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Center(
        child: Container(
          width: 12.w,
          height: 0.5.h,
          decoration: BoxDecoration(
            color: AppTheme.textSecondary.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
        ),
      ),
    );
  }
}
