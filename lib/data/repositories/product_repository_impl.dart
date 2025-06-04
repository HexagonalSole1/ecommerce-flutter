// lib/data/repositories/product_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/local/product_local_datasource.dart';
import '../datasources/remote/product_remote_datasource.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Product>>> getProducts({
    int page = 0,
    int size = 10,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final products = await remoteDataSource.getProducts(
          page: page,
          size: size,
        );
        await localDataSource.saveProducts(products);
        return Right(products);
      } on ServerException catch (e) {
        try {
          final localProducts = await localDataSource.getProducts();
          return Right(localProducts);
        } on CacheException {
          return Left(ServerFailure(message: e.message));
        }
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      try {
        final localProducts = await localDataSource.getProducts();
        return Right(localProducts);
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
  }

  @override
  Future<Either<Failure, Product>> getProductById({
    required int id,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final product = await remoteDataSource.getProductById(id);
        return Right(product);
      } on ServerException catch (e) {
        try {
          final localProduct = await localDataSource.getProductById(id);
          return Right(localProduct);
        } on CacheException {
          return Left(ServerFailure(message: e.message));
        }
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      try {
        final localProduct = await localDataSource.getProductById(id);
        return Right(localProduct);
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
  }

  @override
  Future<Either<Failure, List<Product>>> searchProducts({
    String? name,
    int? categoryId,
    int page = 0,
    int size = 10,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final products = await remoteDataSource.searchProducts(
          name: name,
          categoryId: categoryId,
          page: page,
          size: size,
        );
        return Right(products);
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
  Future<Either<Failure, List<Product>>> getProductsByCategory({
    required int categoryId,
    int page = 0,
    int size = 10,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final products = await remoteDataSource.getProductsByCategory(
          categoryId: categoryId,
          page: page,
          size: size,
        );
        return Right(products);
      } on ServerException catch (e) {
        try {
          final localProducts = await localDataSource.getProductsByCategory(categoryId);
          return Right(localProducts);
        } on CacheException {
          return Left(ServerFailure(message: e.message));
        }
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      try {
        final localProducts = await localDataSource.getProductsByCategory(categoryId);
        return Right(localProducts);
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    if (await networkInfo.isConnected) {
      try {
        final categories = await remoteDataSource.getCategories();
        await localDataSource.saveCategories(categories);
        return Right(categories);
      } on ServerException catch (e) {
        try {
          final localCategories = await localDataSource.getCategories();
          return Right(localCategories);
        } on CacheException {
          return Left(ServerFailure(message: e.message));
        }
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      try {
        final localCategories = await localDataSource.getCategories();
        return Right(localCategories);
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
  }

  @override
  Future<Either<Failure, Category>> getCategoryById({
    required int id,
  }) async {
    try {
      final categoriesResult = await getCategories();

      return categoriesResult.fold(
            (failure) => Left(failure),
            (categories) {
          final category = categories.firstWhere(
                (category) => category.id == id,
            orElse: () => throw CacheException(
              message: 'Categoría no encontrada',
            ),
          );
          return Right(category);
        },
      );
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}