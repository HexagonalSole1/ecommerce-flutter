// lib/domain/repositories/order_repository.dart

import 'package:dartz/dartz.dart';
import '../entities/order.dart';
import '../entities/order_item.dart';
import '../entities/payment.dart';
import '../../core/errors/failures.dart';

abstract class OrderRepository {
  Future<Either<Failure, Order>> createOrder({
    required int userId,
    required String userEmail,
    required List<OrderItem> items,
    double? taxAmount,
    double? shippingAmount,
    String? shippingAddress,
    String? billingAddress,
    String? notes,
    String? paymentMethod,
  });

  Future<Either<Failure, Order>> createOrderFromCart({
    required String userId,
  });

  Future<Either<Failure, Order>> getOrderById({
    required int orderId,
  });

  Future<Either<Failure, Order>> getOrderByNumber({
    required String orderNumber,
  });

  Future<Either<Failure, List<Order>>> getOrdersByUserId({
    required int userId,
    int page = 0,
    int size = 10,
  });

  Future<Either<Failure, List<Order>>> searchOrders({
    int? userId,
    String? status,
    String? orderNumber,
    DateTime? startDate,
    DateTime? endDate,
    int page = 0,
    int size = 10,
  });

  Future<Either<Failure, Order>> updateOrderStatus({
    required int orderId,
    required String status,
    String? notes,
  });

  Future<Either<Failure, Order>> cancelOrder({
    required int orderId,
    String? reason,
  });

  Future<Either<Failure, Map<String, dynamic>>> getOrderStats({
    required int userId,
  });

  // Payment methods
  Future<Either<Failure, Payment>> createPayment({
    required int orderId,
    required double amount,
    required String paymentMethod,
    String? transactionId,
    String? gatewayResponse,
  });

  Future<Either<Failure, Payment>> processPayment({
    required String paymentReference,
    required String status,
    String? transactionId,
    String? gatewayResponse,
  });

  Future<Either<Failure, Payment>> getPaymentById({
    required int paymentId,
  });

  Future<Either<Failure, Payment>> getPaymentByReference({
    required String paymentReference,
  });

  Future<Either<Failure, List<Payment>>> getPaymentsByOrderId({
    required int orderId,
  });

  Future<Either<Failure, List<Payment>>> getPaymentsByUserId({
    required int userId,
    int page = 0,
    int size = 10,
  });

  Future<Either<Failure, Payment>> refundPayment({
    required String paymentReference,
    required String reason,
  });
}