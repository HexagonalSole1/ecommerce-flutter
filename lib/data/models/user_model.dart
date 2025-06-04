// lib/data/models/user_model.dart
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required int id,
    required String email,
    required String username,
    required String name,
    required List<String> roles,
  }) : super(
    id: id,
    email: email,
    username: username,
    name: name,
    roles: roles,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    List<String> parseRoles(dynamic roles) {
      if (roles == null) return [];

      if (roles is String) {
        return roles.split(',').map((role) => role.trim()).toList();
      } else if (roles is List) {
        return roles.map((role) {
          if (role is Map<String, dynamic> && role.containsKey('name')) {
            return role['name'].toString();
          } else {
            return role.toString();
          }
        }).toList();
      }

      return [];
    }

    return UserModel(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      name: json['name'] ?? '',
      roles: parseRoles(json['roles']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'name': name,
      'roles': roles,
    };
  }
}