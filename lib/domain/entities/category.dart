// lib/domain/entities/category.dart

import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int id;
  final String name;
  final String? description;

  const Category({
    required this.id,
    required this.name,
    this.description,
  });

  @override
  List<Object?> get props => [id, name, description];
}