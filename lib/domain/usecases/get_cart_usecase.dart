// lib/domain/usecases/cart/get_cart_usecase.dart

import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/cart.dart';
import '../../repositories/cart_repository.dart';

class GetCartUseCase {
  final CartRepository repository;

  GetCartUseCase(this.repository);

  Future<Either<Failure, Cart>> call({
    required String userId,
  }) async {
    return await repository.getCart(
      userId: userId,
    );
  }
}