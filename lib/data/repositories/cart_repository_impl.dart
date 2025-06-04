// lib/data/repositories/cart_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../../core/storage/secure_storage.dart';
import '../../domain/entities/cart.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/remote/cart_remote_datasource.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final SecureStorage secureStorage;

  CartRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.secureStorage,
  });

  @override
  Future<Either<Failure, Cart>> getCart({
    required String userId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final cart = await remoteDataSource.getCart(userId: userId);
        return Right(cart);
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
  Future<Either<Failure, Cart>> addToCart({
    required String userId,
    required String productId,
    required String productName,
    required String imageUrl,
    required double price,
    required int quantity,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final cart = await remoteDataSource.addToCart(
          userId: userId,
          productId: productId,
          productName: productName,
          imageUrl: imageUrl,
          price: price,
          quantity: quantity,
        );
        return Right(cart);
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
  Future<Either<Failure, Cart>> updateCartItemQuantity({
    required String userId,
    required String productId,
    required int quantity,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final cart = await remoteDataSource.updateCartItemQuantity(
          userId: userId,
          productId: productId,
          quantity: quantity,
        );
        return Right(cart);
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
  Future<Either<Failure, Cart>> removeFromCart({
    required String userId,
    required String productId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final cart = await remoteDataSource.removeFromCart(
          userId: userId,
          productId: productId,
        );
        return Right(cart);
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
  Future<Either<Failure, bool>> clearCart({
    required String userId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.clearCart(userId: userId);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }
}