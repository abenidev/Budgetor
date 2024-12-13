import 'package:budgetor/utils/app_utils.dart';
import 'package:budgetor/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';

class SpendingWidget extends ConsumerStatefulWidget {
  const SpendingWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SpendingWidgetState();
}

class _SpendingWidgetState extends ConsumerState<SpendingWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Text(
              'Spending (${getCurrentMonth()})',
              style: TextStyle(fontSize: 16.sp),
            ),
          ),
          SizedBox(height: 15.h),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 20,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  radius: 18.w,
                  backgroundColor: Theme.of(context).focusColor,
                  child: Icon(LineIcons.spotify, size: 18.w),
                ),
                title: Text(
                  'Spotify',
                  style: TextStyle(fontSize: 12.sp),
                ),
                subtitle: Text(
                  '10:00 am . Dec 2th 2024',
                  style: TextStyle(fontSize: 10.sp),
                ),
                trailing: Text(
                  formatCurrency(generateRandomNumber(10, 60).toDouble()),
                  style: TextStyle(fontSize: 16.sp),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
