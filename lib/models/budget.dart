// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:objectbox/objectbox.dart';

@Entity()
class Budget {
  @Id()
  int id;
  double amount;
  DateTime startDate;
  DateTime endDate;

  Budget({
    this.id = 0,
    required this.amount,
    required this.startDate,
    required this.endDate,
  });

  Budget copyWith({
    int? id,
    double? amount,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Budget(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'amount': amount,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
    };
  }

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      id: map['id'] as int,
      amount: map['amount'] as double,
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate'] as int),
      endDate: DateTime.fromMillisecondsSinceEpoch(map['endDate'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Budget.fromJson(String source) => Budget.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Budget(id: $id, amount: $amount, startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(covariant Budget other) {
    if (identical(this, other)) return true;

    return other.id == id && other.amount == amount && other.startDate == startDate && other.endDate == endDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^ amount.hashCode ^ startDate.hashCode ^ endDate.hashCode;
  }
}
