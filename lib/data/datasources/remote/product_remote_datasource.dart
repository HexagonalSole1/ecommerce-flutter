// lib/data/datasources/remote/product_remote_datasource.dart
import '../../../core/constants/api_endpoints.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/network/api_client.dart';
import '../../models/product_model.dart';
import '../../models/category_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({
    int page = 0,
    int size = 10,
  });

  Future<ProductModel> getProductById(int id);

  Future<List<ProductModel>> searchProducts({
    String? name,
    int? categoryId,
    int page = 0,
    int size = 10,
  });

  Future<List<ProductModel>> getProductsByCategory({
    required int categoryId,
    int page = 0,
    int size = 10,
  });

  Future<List<CategoryModel>> getCategories();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiClient client;

  ProductRemoteDataSourceImpl(this.client);

  @override
  Future<List<ProductModel>> getProducts({
    int page = 0,
    int size = 10,
  }) async {
    try {
      final response = await client.get(
        ApiEndpoints.products,
        queryParameters: {
          'page': page,
          'size': size,
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> productsData = response.data['data'];
        return productsData
            .map((product) => ProductModel.fromJson(product))
            .toList();
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Error al obtener productos',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await client.get(
        '${ApiEndpoints.products}/$id',
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final productData = response.data['data'];
        return ProductModel.fromJson(productData);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Error al obtener producto',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<ProductModel>> searchProducts({
    String? name,
    int? categoryId,
    int page = 0,
    int size = 10,
  }) async {
    try {
      final queryParams = {
        'page': page,
        'size': size,
      };

      if (name != null && name.isNotEmpty) {
        queryParams['name'] = name;
      }

      if (categoryId != null) {
        queryParams['categoryId'] = categoryId;
      }

      final response = await client.get(
        ApiEndpoints.productSearch,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> productsData = response.data['data'];
        return productsData
            .map((product) => ProductModel.fromJson(product))
            .toList();
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Error al buscar productos',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory({
    required int categoryId,
    int page = 0,
    int size = 10,
  }) async {
    try {
      final response = await client.get(
        '${ApiEndpoints.productsByCategory}$categoryId',
        queryParameters: {
          'page': page,
          'size': size,
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> productsData = response.data['data'];
        return productsData
            .map((product) => ProductModel.fromJson(product))
            .toList();
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Error al obtener productos por categoría',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await client.get(
        '/product-service/categories',
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> categoriesData = response.data['data'];
        return categoriesData
            .map((category) => CategoryModel.fromJson(category))
            .toList();
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Error al obtener categorías',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
}