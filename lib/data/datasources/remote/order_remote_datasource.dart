// lib/data/datasources/remote/order_remote_datasource.dart
import '../../../core/constants/api_endpoints.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/network/api_client.dart';
import '../../models/order_model.dart';
import '../../models/order_item_model.dart';
import '../../models/payment_model.dart';

abstract class OrderRemoteDataSource {
  Future<OrderModel> createOrder({
    required int userId,
    required String userEmail,
    required List<OrderItemModel> items,
    double? taxAmount,
    double? shippingAmount,
    String? shippingAddress,
    String? billingAddress,
    String? notes,
    String? paymentMethod,
  });

  Future<OrderModel> createOrderFromCart({
    required String userId,
  });

  Future<OrderModel> getOrderById(int orderId);

  Future<OrderModel> getOrderByNumber(String orderNumber);

  Future<List<OrderModel>> getOrdersByUserId({
    required int userId,
    int page = 0,
    int size = 10,
  });

  Future<OrderModel> updateOrderStatus({
    required int orderId,
    required String status,
    String? notes,
  });

  Future<OrderModel> cancelOrder({
    required int orderId,
    String? reason,
  });

  Future<Map<String, dynamic>> getOrderStats({
    required int userId,
  });

  Future<PaymentModel> createPayment({
    required int orderId,
    required double amount,
    required String paymentMethod,
    String? transactionId,
    String? gatewayResponse,
  });

  Future<PaymentModel> processPayment({
    required String paymentReference,
    required String status,
    String? transactionId,
    String? gatewayResponse,
  });
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final ApiClient client;

  OrderRemoteDataSourceImpl(this.client);

  @override
  Future<OrderModel> createOrder({
    required int userId,
    required String userEmail,
    required List<OrderItemModel> items,
    double? taxAmount,
    double? shippingAmount,
    String? shippingAddress,
    String? billingAddress,
    String? notes,
    String? paymentMethod,
  }) async {
    try {
      final data = {
        'userId': userId,
        'userEmail': userEmail,
        'items': items.map((item) => item.toJson()).toList(),
        if (taxAmount != null) 'taxAmount': taxAmount,
        if (shippingAmount != null) 'shippingAmount': shippingAmount,
        if (shippingAddress != null) 'shippingAddress': shippingAddress,
        if (billingAddress != null) 'billingAddress': billingAddress,
        if (notes != null) 'notes': notes,
        if (paymentMethod != null) 'paymentMethod': paymentMethod,
      };

      final response = await client.post(
        ApiEndpoints.orders,
        data: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data['success'] == true) {
          final orderData = response.data['data'];
          return OrderModel.fromJson(orderData);
        } else {
          throw ServerException(
            message: response.data['message'] ?? 'Error al crear orden',
          );
        }
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Error al crear orden',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<OrderModel> createOrderFromCart({
    required String userId,
  }) async {
    try {
      final response = await client.post(
        '${ApiEndpoints.orderFromCart}$userId',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data['success'] == true) {
          final orderData = response.data['data'];
          return OrderModel.fromJson(orderData);
        } else {
          throw ServerException(
            message: response.data['message'] ?? 'Error al crear orden desde carrito',
          );
        }
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Error al crear orden desde carrito',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<OrderModel> getOrderById(int orderId) async {
    try {
      final response = await client.get(
        '${ApiEndpoints.orders}/$orderId',
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final orderData = response.data['data'];
        return OrderModel.fromJson(orderData);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Error al obtener orden',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<OrderModel> getOrderByNumber(String orderNumber) async {
    try {
      final response = await client.get(
        '${ApiEndpoints.orders}/number/$orderNumber',
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final orderData = response.data['data'];
        return OrderModel.fromJson(orderData);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Error al obtener orden',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<OrderModel>> getOrdersByUserId({
    required int userId,
    int page = 0,
    int size = 10,
  }) async {
    try {
      final response = await client.get(
        '${ApiEndpoints.orderByUser}$userId',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> ordersData = response.data['data'];
        return ordersData
            .map((order) => OrderModel.fromJson(order))
            .toList();
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Error al obtener órdenes',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<OrderModel> updateOrderStatus({
    required int orderId,
    required String status,
    String? notes,
  }) async {
    try {
      final response = await client.put(
        '${ApiEndpoints.orders}/$orderId/status',
        data: {
          'status': status,
          if (notes != null) 'notes': notes,
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final orderData = response.data['data'];
        return OrderModel.fromJson(orderData);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Error al actualizar estado de orden',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<OrderModel> cancelOrder({
    required int orderId,
    String? reason,
  }) async {
    try {
      final response = await client.post(
        '${ApiEndpoints.orders}/$orderId/cancel',
        queryParameters: {
          if (reason != null) 'reason': reason,
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final orderData = response.data['data'];
        return OrderModel.fromJson(orderData);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Error al cancelar orden',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> getOrderStats({
    required int userId,
  }) async {
    try {
      final response = await client.get(
        '${ApiEndpoints.orderByUser}$userId${ApiEndpoints.orderStats}',
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['data'] as Map<String, dynamic>;
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Error al obtener estadísticas',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<PaymentModel> createPayment({
    required int orderId,
    required double amount,
    required String paymentMethod,
    String? transactionId,
    String? gatewayResponse,
  }) async {
    try {
      final response = await client.post(
        ApiEndpoints.payments,
        data: {
          'orderId': orderId,
          'amount': amount,
          'paymentMethod': paymentMethod,
          if (transactionId != null) 'transactionId': transactionId,
          if (gatewayResponse != null) 'gatewayResponse': gatewayResponse,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data['success'] == true) {
          final paymentData = response.data['data'];
          return PaymentModel.fromJson(paymentData);
        } else {
          throw ServerException(
            message: response.data['message'] ?? 'Error al crear pago',
          );
        }
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Error al crear pago',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<PaymentModel> processPayment({
    required String paymentReference,
    required String status,
    String? transactionId,
    String? gatewayResponse,
  }) async {
    try {
      final response = await client.post(
        ApiEndpoints.processPayment,
        data: {
          'paymentReference': paymentReference,
          'status': status,
          if (transactionId != null) 'transactionId': transactionId,
          if (gatewayResponse != null) 'gatewayResponse': gatewayResponse,
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final paymentData = response.data['data'];
        return PaymentModel.fromJson(paymentData);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Error al procesar pago',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
}