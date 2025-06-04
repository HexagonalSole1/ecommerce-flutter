// lib/domain/entities/user.dart

import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String email;
  final String username;
  final String name;
  final List<String> roles;

  const User({
    required this.id,
    required this.email,
    required this.username,
    required this.name,
    required this.roles,
  });

  @override
  List<Object?> get props => [id, email, username, name, roles];
}