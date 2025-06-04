// lib/domain/repositories/cart_repository.dart

import 'package:dartz/dartz.dart';
import '../entities/cart.dart';
import '../entities/cart_item.dart';
import '../../core/errors/failures.dart';

abstract class CartRepository {
  Future<Either<Failure, Cart>> getCart({
    required String userId,
  });

  Future<Either<Failure, Cart>> addToCart({
    required String userId,
    required String productId,
    required String productName,
    required String imageUrl,
    required double price,
    required int quantity,
  });

  Future<Either<Failure, Cart>> updateCartItemQuantity({
    required String userId,
    required String productId,
    required int quantity,
  });

  Future<Either<Failure, Cart>> removeFromCart({
    required String userId,
    required String productId,
  });

  Future<Either<Failure, bool>> clearCart({
    required String userId,
  });
}