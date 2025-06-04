// lib/domain/entities/order.dart

import 'package:equatable/equatable.dart';
import 'order_item.dart';
import 'payment.dart';

enum OrderStatus {
  PENDING,
  CONFIRMED,
  PROCESSING,
  SHIPPED,
  DELIVERED,
  CANCELLED,
  RETURNED
}

class Order extends Equatable {
  final int id;
  final String orderNumber;
  final int userId;
  final String userEmail;
  final double totalAmount;
  final double? taxAmount;
  final double? shippingAmount;
  final OrderStatus status;
  final String? shippingAddress;
  final String? billingAddress;
  final String? notes;
  final List<OrderItem> orderItems;
  final List<Payment>? payments;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Order({
    required this.id,
    required this.orderNumber,
    required this.userId,
    required this.userEmail,
    required this.totalAmount,
    this.taxAmount,
    this.shippingAmount,
    required this.status,
    this.shippingAddress,
    this.billingAddress,
    this.notes,
    required this.orderItems,
    this.payments,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    orderNumber,
    userId,
    userEmail,
    totalAmount,
    taxAmount,
    shippingAmount,
    status,
    shippingAddress,
    billingAddress,
    notes,
    orderItems,
    payments,
    createdAt,
    updatedAt,
  ];

  double get subtotal => orderItems.fold(
      0,
          (sum, item) => sum + item.subtotal
  );

  bool get isPaid => payments != null &&
      payments!.any((payment) => payment.status == PaymentStatus.COMPLETED) &&
      payments!.where((payment) => payment.status == PaymentStatus.COMPLETED)
          .fold(0.0, (sum, payment) => sum + payment.amount) >= totalAmount;

  int get totalItems => orderItems.fold(
      0,
          (sum, item) => sum + item.quantity
  );

  String get statusDisplay {
    switch (status) {
      case OrderStatus.PENDING: return 'Pending';
      case OrderStatus.CONFIRMED: return 'Confirmed';
      case OrderStatus.PROCESSING: return 'Processing';
      case OrderStatus.SHIPPED: return 'Shipped';
      case OrderStatus.DELIVERED: return 'Delivered';
      case OrderStatus.CANCELLED: return 'Cancelled';
      case OrderStatus.RETURNED: return 'Returned';
    }
  }
}

// lib/domain/entities/order_item.dart

import 'package:equatable/equatable.dart';

class OrderItem extends Equatable {
  final int id;
  final int productId;
  final String productName;
  final String? productSku;
  final String? productImageUrl;
  final double price;
  final int quantity;
  final double subtotal;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    this.productSku,
    this.productImageUrl,
    required this.price,
    required this.quantity,
    required this.subtotal,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    productId,
    productName,
    productSku,
    productImageUrl,
    price,
    quantity,
    subtotal,
    createdAt,
    updatedAt,
  ];
}