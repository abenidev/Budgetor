// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:objectbox/objectbox.dart';

import 'package:budgetor/models/budget.dart';
import 'package:budgetor/models/savings_goal.dart';
import 'package:budgetor/models/user_account.dart';

@Entity()
class UserModel {
  @Id()
  int id;
  String name;
  String email;
  String profileImgUrl;

  final budget = ToOne<Budget>();

  @Backlink()
  final accounts = ToMany<UserAccount>();

  @Backlink()
  final savingsGoals = ToMany<SavingsGoal>();

  UserModel({
    this.id = 0,
    required this.name,
    required this.email,
    required this.profileImgUrl,
  });

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? profileImgUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImgUrl: profileImgUrl ?? this.profileImgUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'profileImgUrl': profileImgUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int,
      name: map['name'] as String,
      email: map['email'] as String,
      profileImgUrl: map['profileImgUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, profileImgUrl: $profileImgUrl)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.email == email && other.profileImgUrl == profileImgUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ email.hashCode ^ profileImgUrl.hashCode;
  }
}
