import 'package:intl/intl.dart';

int daysLeftInMonth() {
  final now = DateTime.now();
  final nextMonth = (now.month == 12) ? DateTime(now.year + 1, 1, 1) : DateTime(now.year, now.month + 1, 1);
  final daysLeft = nextMonth.difference(now).inDays;
  return daysLeft;
}

String getCurrentMonth() {
  final now = DateTime.now();
  final monthFormatter = DateFormat('MMMM');
  return monthFormatter.format(now);
}
