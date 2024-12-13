import 'package:budgetor/utils/app_utils.dart';
import 'package:budgetor/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MonthlyBudgetWidget extends ConsumerStatefulWidget {
  const MonthlyBudgetWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MonthlyBudgetWidgetState();
}

class _MonthlyBudgetWidgetState extends ConsumerState<MonthlyBudgetWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${getCurrentMonth()}s budget',
                style: TextStyle(fontSize: 10.sp),
              ),
              SizedBox(height: 10.h),
              Text(
                formatCurrency(2628.40),
                style: TextStyle(fontSize: 28.sp),
              ),
              SizedBox(height: 2.h),
              Text(
                '${daysLeftInMonth()} days left',
                style: TextStyle(fontSize: 10.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
