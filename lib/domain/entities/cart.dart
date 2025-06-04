// lib/domain/entities/cart.dart

import 'package:equatable/equatable.dart';
import 'cart_item.dart';

class Cart extends Equatable {
  final String id;
  final String userId;
  final Map<String, CartItem> items;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Cart({
    required this.id,
    required this.userId,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, userId, items, createdAt, updatedAt];

  int get itemCount => items.length;

  double get totalPrice => items.values.fold(
    0,
        (total, item) => total + (item.price * item.quantity),
  );

  int get totalQuantity => items.values.fold(
      0,
          (total, item) => total + item.quantity
  );

  bool get isEmpty => items.isEmpty;

  bool get isNotEmpty => items.isNotEmpty;
}

// lib/domain/entities/cart_item.dart

import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final String productId;
  final String productName;
  final String imageUrl;
  final double price;
  final int quantity;
  final DateTime addedAt;

  const CartItem({
    required this.productId,
    required this.productName,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.addedAt,
  });

  @override
  List<Object?> get props => [
    productId,
    productName,
    imageUrl,
    price,
    quantity,
    addedAt
  ];

  double get subtotal => price * quantity;
}