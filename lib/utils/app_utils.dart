import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatCurrency(double amount, {String locale = 'en_US', String currency = 'USD', String symbol = ''}) {
  final formatter = NumberFormat.currency(locale: locale, symbol: symbol, name: currency);
  return formatter.format(amount);
}

int generateRandomNumber(int min, int max) {
  if (min > max) {
    throw ArgumentError('Min should be less than or equal to Max');
  }
  final random = Random();
  return min + random.nextInt(max - min + 1); // +1 to include 'max'
}

showCustomSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}
