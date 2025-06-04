// lib/domain/entities/payment.dart

import 'package:equatable/equatable.dart';

enum PaymentMethod {
  CREDIT_CARD,
  DEBIT_CARD,
  PAYPAL,
  BANK_TRANSFER,
  CASH_ON_DELIVERY,
  DIGITAL_WALLET
}

enum PaymentStatus {
  PENDING,
  PROCESSING,
  COMPLETED,
  FAILED,
  CANCELLED,
  REFUNDED
}

class Payment extends Equatable {
  final int id;
  final int orderId;
  final String paymentReference;
  final double amount;
  final PaymentMethod paymentMethod;
  final PaymentStatus status;
  final String? transactionId;
  final String? gatewayResponse;
  final DateTime? processedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Payment({
    required this.id,
    required this.orderId,
    required this.paymentReference,
    required this.amount,
    required this.paymentMethod,
    required this.status,
    this.transactionId,
    this.gatewayResponse,
    this.processedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    orderId,
    paymentReference,
    amount,
    paymentMethod,
    status,
    transactionId,
    gatewayResponse,
    processedAt,
    createdAt,
    updatedAt,
  ];

  bool get isCompleted => status == PaymentStatus.COMPLETED;

  bool get isPending => status == PaymentStatus.PENDING;

  bool get isFailed => status == PaymentStatus.FAILED;

  String get statusDisplay {
    switch (status) {
      case PaymentStatus.PENDING: return 'Pending';
      case PaymentStatus.PROCESSING: return 'Processing';
      case PaymentStatus.COMPLETED: return 'Completed';
      case PaymentStatus.FAILED: return 'Failed';
      case PaymentStatus.CANCELLED: return 'Cancelled';
      case PaymentStatus.REFUNDED: return 'Refunded';
    }
  }

  String get methodDisplay {
    switch (paymentMethod) {
      case PaymentMethod.CREDIT_CARD: return 'Credit Card';
      case PaymentMethod.DEBIT_CARD: return 'Debit Card';
      case PaymentMethod.PAYPAL: return 'PayPal';
      case PaymentMethod.BANK_TRANSFER: return 'Bank Transfer';
      case PaymentMethod.CASH_ON_DELIVERY: return 'Cash on Delivery';
      case PaymentMethod.DIGITAL_WALLET: return 'Digital Wallet';
    }
  }
}