import 'package:budgetor/constants/app_consts.dart';
import 'package:budgetor/helpers/firestore_helper.dart';
import 'package:budgetor/helpers/objectbox_helper.dart';
import 'package:budgetor/models/income.dart';
import 'package:budgetor/utils/app_utils.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final selectedIncomeRepOptProvider = StateProvider<SelectedListItem?>((ref) {
  return null;
});

final isAddBtnLoadingProvider = StateProvider<bool>((ref) {
  return false;
});

class AddIncomeScreen extends ConsumerStatefulWidget {
  const AddIncomeScreen({super.key, this.onAddDone, this.showAppBar = true});

  final Function()? onAddDone;
  final bool showAppBar;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends ConsumerState<AddIncomeScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController _incomeNameController;
  late TextEditingController _incomeAmountController;

  void setSelectedIncomeRepOptValue(SelectedListItem? value) {
    ref.read(selectedIncomeRepOptProvider.notifier).state = value;
  }

  void showIncomeRepitOptSelectorModal() {
    DropDownState(
      DropDown(
        bottomSheetTitle: Text(
          "Income Type",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
        ),
        data: incomeRepitTypeOptList,
        onSelected: (selectedItems) => setSelectedIncomeRepOptValue(selectedItems[0]),
        enableMultipleSelection: false,
      ),
    ).showModal(context);
  }

  @override
  void initState() {
    super.initState();
    _incomeNameController = TextEditingController();
    _incomeAmountController = TextEditingController();
  }

  @override
  void dispose() {
    _incomeNameController.dispose();
    _incomeAmountController.dispose();
    super.dispose();
  }

  _handleIncomeAdd() async {
    bool isAddBtnLoading = ref.read(isAddBtnLoadingProvider);
    if (isAddBtnLoading) return;

    FocusScope.of(context).unfocus();
    if (formKey.currentState!.validate()) {
      String incomeNameVal = _incomeNameController.text.trim().capitalize;
      SelectedListItem? selectedIncomeRepOpt = ref.read(selectedIncomeRepOptProvider);
      late double incomeAmountVal;
      try {
        incomeAmountVal = double.parse(_incomeAmountController.text.trim());
      } catch (e) {
        return;
      }
      if (incomeAmountVal <= 0) {
        showCustomSnackBar(context, "Please enter a valid income amount!");
        return;
      }
      if (selectedIncomeRepOpt == null) {
        showCustomSnackBar(context, "Please select an income type!");
        return;
      }

      if (selectedIncomeRepOpt.value == null) {
        showCustomSnackBar(context, "selectedIncomeRepOpt.value cannot be null while adding new income!");
        throw Exception('selectedIncomeRepOpt.value cannot be null while adding new income!');
      }

      Income newIncome = Income(
        name: incomeNameVal,
        amount: incomeAmountVal,
        incomeRepitionType: selectedIncomeRepOpt.value!,
        dateAdded: DateTime.now(),
      );

      int id = Boxes.incomesBox.put(newIncome);
      ref.read(isAddBtnLoadingProvider.notifier).state = true;
      bool isAdded = await FirestoreHelper.addNewIncome(newIncome.copyWith(id: id));
      ref.read(isAddBtnLoadingProvider.notifier).state = false;
      if (!isAdded) {
        Boxes.incomesBox.remove(id);
        if (mounted) {
          showCustomSnackBar(context, "Something went wrong while adding income, Please check your internet connection and try again!");
        }
        return;
      }

      if (widget.onAddDone != null) {
        widget.onAddDone!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SelectedListItem? selectedIncomeRepOpt = ref.watch(selectedIncomeRepOptProvider);
    bool isAddBtnLoading = ref.watch(isAddBtnLoadingProvider);

    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: Text('Add Income', style: TextStyle(fontSize: 16.sp)),
            )
          : null,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(height: 20.h),
                Text('Start by adding one of your incomes.', style: TextStyle(fontSize: 20.sp)),
                SizedBox(height: 10.h),
                TextFormField(
                  controller: _incomeNameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: 'Income name',
                    labelStyle: TextStyle(fontSize: 12.sp),
                    errorStyle: const TextStyle(color: Colors.red),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter an income name!';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.h),
                TextFormField(
                  controller: _incomeAmountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Income amount',
                    labelStyle: TextStyle(fontSize: 12.sp),
                    errorStyle: const TextStyle(color: Colors.red),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a valid income amount!';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15.h),
                ElevatedButton(
                  onPressed: showIncomeRepitOptSelectorModal,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.w)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        selectedIncomeRepOpt?.name ?? 'Income Type',
                        style: TextStyle(fontSize: 12.sp),
                      ),
                      Icon(Icons.arrow_forward_ios_outlined, size: 16.w),
                    ],
                  ),
                ),
                SizedBox(height: 25.h),
                SizedBox(
                  width: double.infinity,
                  height: 40.h,
                  child: ElevatedButton(
                    onPressed: _handleIncomeAdd,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).secondaryHeaderColor,
                    ),
                    child: isAddBtnLoading
                        ? SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: CircularProgressIndicator(strokeWidth: 2.w, strokeCap: StrokeCap.round),
                          )
                        : Text('Add', style: TextStyle(fontSize: 14.sp)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
