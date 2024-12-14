import 'package:budgetor/helpers/query_helper.dart';
import 'package:budgetor/main.dart';
import 'package:budgetor/models/income.dart';
import 'package:budgetor/screens/add_income_screen.dart';
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Income',
                  style: TextStyle(fontSize: 16.sp),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddIncomeScreen(
                          onAddDone: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.add, size: 22.w),
                ),
              ],
            ),
          ),
          SizedBox(height: 15.h),
          StreamBuilder(
            stream: QueryHelper.getUserIncomes(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData) {
                if (snapshot.data == null) {
                  return const SizedBox.shrink();
                }

                List<Income> incomes = snapshot.data!;
                logger.i('incomes: ${incomes}');

                return SizedBox(
                  height: 110.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: incomes.length,
                    itemBuilder: (context, index) {
                      Income incomeData = incomes[index];

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
                              Text(incomeData.name, style: TextStyle(fontSize: 12.sp)),
                              SizedBox(height: 5.h),
                              Text(formatCurrency(incomeData.amount), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
                              Text(incomeData.incomeRepitionType, style: TextStyle(fontSize: 10.sp)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          )
        ],
      ),
    );
  }
}
