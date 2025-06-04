// lib/domain/usecases/products/get_products_usecase.dart

import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/product.dart';
import '../../repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<Either<Failure, List<Product>>> call({
    int page = 0,
    int size = 10,
  }) async {
    return await repository.getProducts(
      page: page,
      size: size,
    );
  }
}