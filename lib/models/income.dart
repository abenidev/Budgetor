// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:objectbox/objectbox.dart';

import 'package:budgetor/models/user_model.dart';

enum IncomeRepititionType {
  daily,
  weekly,
  biweekly,
  monthly,
  random,
}

IncomeRepititionType getIncomeRepititionTypeFromStr(String incomeRepTyStr) {
  switch (incomeRepTyStr) {
    case "daily":
      return IncomeRepititionType.daily;
    case "weekly":
      return IncomeRepititionType.weekly;
    case "biweekly":
      return IncomeRepititionType.biweekly;
    case "monthly":
      return IncomeRepititionType.monthly;
    case "random":
      return IncomeRepititionType.random;
    default:
      throw Exception('type of income repitition type by name: ${incomeRepTyStr} not found!');
  }
}

@Entity()
class Income {
  @Id()
  int id;
  String name;
  double amount;
  String incomeRepitionType;
  DateTime dateAdded;

  final userModel = ToOne<UserModel>();

  Income({
    this.id = 0,
    required this.name,
    required this.amount,
    required this.incomeRepitionType,
    required this.dateAdded,
  });

  Income copyWith({
    int? id,
    String? name,
    double? amount,
    String? incomeRepitionType,
    DateTime? dateAdded,
  }) {
    return Income(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      incomeRepitionType: incomeRepitionType ?? this.incomeRepitionType,
      dateAdded: dateAdded ?? this.dateAdded,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'amount': amount,
      'incomeRepitionType': incomeRepitionType,
      'dateAdded': dateAdded.millisecondsSinceEpoch,
    };
  }

  factory Income.fromMap(Map<String, dynamic> map) {
    return Income(
      id: map['id'] as int,
      name: map['name'] as String,
      amount: map['amount'] as double,
      incomeRepitionType: map['incomeRepitionType'] as String,
      dateAdded: DateTime.fromMillisecondsSinceEpoch(map['dateAdded'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Income.fromJson(String source) => Income.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Income(id: $id, name: $name, amount: $amount, incomeRepitionType: $incomeRepitionType, dateAdded: $dateAdded)';
  }

  @override
  bool operator ==(covariant Income other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.amount == amount && other.incomeRepitionType == incomeRepitionType && other.dateAdded == dateAdded;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ amount.hashCode ^ incomeRepitionType.hashCode ^ dateAdded.hashCode;
  }
}
