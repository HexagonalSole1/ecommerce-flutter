// lib/data/models/product_model.dart
import '../../domain/entities/product.dart';
import '../../domain/entities/category.dart';
import 'category_model.dart';

class ProductModel extends Product {
  const ProductModel({
    required int id,
    required String name,
    required String description,
    required String imageUrl,
    required double price,
    required CategoryModel category,
    required int stock,
    required String sku,
    required bool isActive,
  }) : super(
    id: id,
    name: name,
    description: description,
    imageUrl: imageUrl,
    price: price,
    category: category,
    stock: stock,
    sku: sku,
    isActive: isActive,
  );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      price: (json['price'] is num) ? (json['price'] as num).toDouble() : 0.0,
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : const CategoryModel(id: 0, name: 'Sin categoría'),
      stock: json['stock'] ?? 0,
      sku: json['sku'] ?? '',
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'category': (category as CategoryModel).toJson(),
      'stock': stock,
      'sku': sku,
      'isActive': isActive,
    };
  }
}