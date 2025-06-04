// lib/data/repositories/order_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/payment.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/remote/order_remote_datasource.dart';
import '../models/order_item_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  OrderRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Order>> createOrder({
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
    if (await networkInfo.isConnected) {
      try {
        final order = await remoteDataSource.createOrder(
          userId: userId,
          userEmail: userEmail,
          items: items,
          taxAmount: taxAmount,
          shippingAmount: shippingAmount,
          shippingAddress: shippingAddress,
          billingAddress: billingAddress,
          notes: notes,
          paymentMethod: paymentMethod,
        );
        return Right(order);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, Order>> createOrderFromCart({
    required String userId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final order = await remoteDataSource.createOrderFromCart(
          userId: userId,
        );
        return Right(order);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, Order>> getOrderById({
    required int orderId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final order = await remoteDataSource.getOrderById(orderId);
        return Right(order);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, Order>> getOrderByNumber({
    required String orderNumber,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final order = await remoteDataSource.getOrderByNumber(orderNumber);
        return Right(order);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, List<Order>>> getOrdersByUserId({
    required int userId,
    int page = 0,
    int size = 10,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final orders = await remoteDataSource.getOrdersByUserId(
          userId: userId,
          page: page,
          size: size,
        );
        return Right(orders);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, List<Order>>> searchOrders({
    int? userId,
    String? status,
    String? orderNumber,
    DateTime? startDate,
    DateTime? endDate,
    int page = 0,
    int size = 10,
  }) async {
    // Simplificado - usamos la función de obtener órdenes por usuario
    if (userId != null) {
      return getOrdersByUserId(
        userId: userId,
        page: page,
        size: size,
      );
    } else {
      return Left(ValidationFailure(message: 'Se requiere al menos un criterio de búsqueda'));
    }
  }

  @override
  Future<Either<Failure, Order>> updateOrderStatus({
    required int orderId,
    required String status,
    String? notes,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final order = await remoteDataSource.updateOrderStatus(
          orderId: orderId,
          status: status,
          notes: notes,
        );
        return Right(order);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, Order>> cancelOrder({
    required int orderId,
    String? reason,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final order = await remoteDataSource.cancelOrder(
          orderId: orderId,
          reason: reason,
        );
        return Right(order);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getOrderStats({
    required int userId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final stats = await remoteDataSource.getOrderStats(
          userId: userId,
        );
        return Right(stats);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, Payment>> createPayment({
    required int orderId,
    required double amount,
    required String paymentMethod,
    String? transactionId,
    String? gatewayResponse,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final payment = await remoteDataSource.createPayment(
          orderId: orderId,
          amount: amount,
          paymentMethod: paymentMethod,
          transactionId: transactionId,
          gatewayResponse: gatewayResponse,
        );
        return Right(payment);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, Payment>> processPayment({
    required String paymentReference,
    required String status,
    String? transactionId,
    String? gatewayResponse,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final payment = await remoteDataSource.processPayment(
          paymentReference: paymentReference,
          status: status,
          transactionId: transactionId,
          gatewayResponse: gatewayResponse,
        );
        return Right(payment);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, Payment>> getPaymentById({
    required int paymentId,
  }) {
    // Implementación no incluida - agregarla según necesidad
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Payment>> getPaymentByReference({
    required String paymentReference,
  }) {
    // Implementación no incluida - agregarla según necesidad
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Payment>>> getPaymentsByOrderId({
    required int orderId,
  }) {
    // Implementación no incluida - agregarla según necesidad
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Payment>>> getPaymentsByUserId({
    required int userId,
    int page = 0,
    int size = 10,
  }) {
    // Implementación no incluida - agregarla según necesidad
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Payment>> refundPayment({
    required String paymentReference,
    required String reason,
  }) {
    // Implementación no incluida - agregarla según necesidad
    throw UnimplementedError();
  }
}
