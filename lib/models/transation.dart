// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:objectbox/objectbox.dart';

import 'package:budgetor/models/user_account.dart';

@Entity()
class Transaction {
  @Id()
  int id; // Unique identifier
  double amount;
  String type; // "Income" or "Expense"
  DateTime date;
  String description; // Optional notes

  final category = ToOne<Category>();
  final account = ToOne<UserAccount>();

  Transaction({
    this.id = 0,
    required this.amount,
    required this.type,
    required this.date,
    this.description = '',
  });

  Transaction copyWith({
    int? id,
    double? amount,
    String? type,
    DateTime? date,
    String? description,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      date: date ?? this.date,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'amount': amount,
      'type': type,
      'date': date.millisecondsSinceEpoch,
      'description': description,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as int,
      amount: map['amount'] as double,
      type: map['type'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Transaction.fromJson(String source) => Transaction.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Transaction(id: $id, amount: $amount, type: $type, date: $date, description: $description)';
  }

  @override
  bool operator ==(covariant Transaction other) {
    if (identical(this, other)) return true;

    return other.id == id && other.amount == amount && other.type == type && other.date == date && other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^ amount.hashCode ^ type.hashCode ^ date.hashCode ^ description.hashCode;
  }
}
