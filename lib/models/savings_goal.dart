// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:objectbox/objectbox.dart';

import 'package:budgetor/models/user_model.dart';

@Entity()
class SavingsGoal {
  @Id()
  int id;
  String name; // Goal name (e.g., "Vacation")
  double targetAmount; // Goal target amount
  double currentAmount; // Amount saved so far
  DateTime? deadline; // Optional deadline

  final userModel = ToOne<UserModel>();

  SavingsGoal({
    this.id = 0,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    this.deadline,
  });

  SavingsGoal copyWith({
    int? id,
    String? name,
    double? targetAmount,
    double? currentAmount,
    DateTime? deadline,
  }) {
    return SavingsGoal(
      id: id ?? this.id,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      deadline: deadline ?? this.deadline,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'deadline': deadline?.millisecondsSinceEpoch,
    };
  }

  factory SavingsGoal.fromMap(Map<String, dynamic> map) {
    return SavingsGoal(
      id: map['id'] as int,
      name: map['name'] as String,
      targetAmount: map['targetAmount'] as double,
      currentAmount: map['currentAmount'] as double,
      deadline: map['deadline'] != null ? DateTime.fromMillisecondsSinceEpoch(map['deadline'] as int) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SavingsGoal.fromJson(String source) => SavingsGoal.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SavingsGoal(id: $id, name: $name, targetAmount: $targetAmount, currentAmount: $currentAmount, deadline: $deadline)';
  }

  @override
  bool operator ==(covariant SavingsGoal other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.targetAmount == targetAmount && other.currentAmount == currentAmount && other.deadline == deadline;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ targetAmount.hashCode ^ currentAmount.hashCode ^ deadline.hashCode;
  }
}
