// lib/data/models/cart_model.dart
import '../../domain/entities/cart.dart';
import 'cart_item_model.dart';

class CartModel extends Cart {
  const CartModel({
    required String id,
    required String userId,
    required Map<String, CartItemModel> items,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
    id: id,
    userId: userId,
    items: items,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final itemsMap = <String, CartItemModel>{};
    if (json['items'] != null && json['items'] is Map) {
      json['items'].forEach((key, value) {
        if (value != null) {
          itemsMap[key] = CartItemModel.fromJson(value);
        }
      });
    }

    return CartModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      items: itemsMap,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> itemsJson = {};
    items.forEach((key, value) {
      itemsJson[key] = (value as CartItemModel).toJson();
    });

    return {
      'id': id,
      'userId': userId,
      'items': itemsJson,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}