// lib/domain/repositories/product_repository.dart

import 'package:dartz/dartz.dart';
import '../entities/product.dart';
import '../entities/category.dart';
import '../../core/errors/failures.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts({
    int page = 0,
    int size = 10,
  });

  Future<Either<Failure, Product>> getProductById({
    required int id,
  });

  Future<Either<Failure, List<Product>>> searchProducts({
    String? name,
    int? categoryId,
    int page = 0,
    int size = 10,
  });

  Future<Either<Failure, List<Product>>> getProductsByCategory({
    required int categoryId,
    int page = 0,
    int size = 10,
  });

  Future<Either<Failure, List<Category>>> getCategories();

  Future<Either<Failure, Category>> getCategoryById({
    required int id,
  });
}