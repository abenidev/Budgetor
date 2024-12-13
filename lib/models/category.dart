// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:objectbox/objectbox.dart';

@Entity()
class Category {
  @Id()
  int id;
  String name; // e.g., "Food", "Transportation"
  String? parentCategoryName;
  String type; // "Income" or "Expense"

  Category({
    this.id = 0,
    required this.name,
    this.parentCategoryName,
    required this.type,
  });

  Category copyWith({
    int? id,
    String? name,
    String? parentCategoryName,
    String? type,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      parentCategoryName: parentCategoryName ?? this.parentCategoryName,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'parentCategoryName': parentCategoryName,
      'type': type,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as int,
      name: map['name'] as String,
      parentCategoryName: map['parentCategoryName'] != null ? map['parentCategoryName'] as String : null,
      type: map['type'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) => Category.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Category(id: $id, name: $name, parentCategoryName: $parentCategoryName, type: $type)';
  }

  @override
  bool operator ==(covariant Category other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.parentCategoryName == parentCategoryName && other.type == type;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ parentCategoryName.hashCode ^ type.hashCode;
  }
}
