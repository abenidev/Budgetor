// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:objectbox/objectbox.dart';

import 'package:budgetor/models/transation.dart';
import 'package:budgetor/models/user_model.dart';

@Entity()
class UserAccount {
  @Id()
  int id;
  String name; // Account name (e.g., "Checking", "Savings")
  double balance;
  String currency; // e.g., USD, EUR

  @Backlink()
  final transactions = ToMany<Transaction>();

  final userModel = ToOne<UserModel>();

  UserAccount({
    this.id = 0,
    required this.name,
    required this.balance,
    required this.currency,
  });

  UserAccount copyWith({
    int? id,
    String? name,
    double? balance,
    String? currency,
  }) {
    return UserAccount(
      id: id ?? this.id,
      name: name ?? this.name,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'balance': balance,
      'currency': currency,
    };
  }

  factory UserAccount.fromMap(Map<String, dynamic> map) {
    return UserAccount(
      id: map['id'] as int,
      name: map['name'] as String,
      balance: map['balance'] as double,
      currency: map['currency'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserAccount.fromJson(String source) => UserAccount.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserAccount(id: $id, name: $name, balance: $balance, currency: $currency)';
  }

  @override
  bool operator ==(covariant UserAccount other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.balance == balance && other.currency == currency;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ balance.hashCode ^ currency.hashCode;
  }
}
