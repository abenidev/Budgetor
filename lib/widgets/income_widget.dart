import 'package:budgetor/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';

class IncomeWidget extends ConsumerStatefulWidget {
  const IncomeWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _IncomeWidgetState();
}

class _IncomeWidgetState extends ConsumerState<IncomeWidget> {
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
              'My Income',
              style: TextStyle(fontSize: 16.sp),
            ),
          ),
          SizedBox(height: 15.h),
          SizedBox(
            height: 100.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              itemBuilder: (context, index) {
                return Padding(
                  padding: index == 0 ? EdgeInsets.only(left: 10.w) : EdgeInsets.zero,
                  child: Container(
                    width: 120.w,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.only(right: 10.w),
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(LineIcons.dollar_sign, size: 26.w),
                        SizedBox(height: 10.h),
                        Text('Salary', style: TextStyle(fontSize: 12.sp)),
                        SizedBox(height: 5.h),
                        Text(formatCurrency(2345.21), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
