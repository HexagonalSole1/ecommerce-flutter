// lib/domain/entities/product.dart

import 'package:equatable/equatable.dart';
import 'category.dart';

class Product extends Equatable {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final Category category;
  final int stock;
  final String sku;
  final bool isActive;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.category,
    required this.stock,
    required this.sku,
    required this.isActive,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    imageUrl,
    price,
    category,
    stock,
    sku,
    isActive
  ];

  bool get isInStock => stock > 0;
}