// lib/data/datasources/remote/cart_remote_datasource.dart
import '../../../core/constants/api_endpoints.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/network/api_client.dart';
import '../../models/cart_model.dart';
import '../../models/cart_item_model.dart';

abstract class CartRemoteDataSource {
  Future<CartModel> getCart({
    required String userId,
  });

  Future<CartModel> addToCart({
    required String userId,
    required String productId,
    required String productName,
    required String imageUrl,
    required double price,
    required int quantity,
  });

  Future<CartModel> updateCartItemQuantity({
    required String userId,
    required String productId,
    required int quantity,
  });

  Future<CartModel> removeFromCart({
    required String userId,
    required String productId,
  });

  Future<bool> clearCart({
    required String userId,
  });
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final ApiClient client;

  CartRemoteDataSourceImpl(this.client);

  @override
  Future<CartModel> getCart({
    required String userId,
  }) async {
    try {
      final response = await client.get(
        '${ApiEndpoints.cart}$userId',
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final cartData = response.data['data'];
        return CartModel.fromJson(cartData);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Error al obtener carrito',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<CartModel> addToCart({
    required String userId,
    required String productId,
    required String productName,
    required String imageUrl,
    required double price,
    required int quantity,
  }) async {
    try {
      final response = await client.post(
        '${ApiEndpoints.cart}$userId${ApiEndpoints.cartItems}',
        data: {
          'productId': productId,
          'productName': productName,
          'imageUrl': imageUrl,
          'price': price,
          'quantity': quantity,
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final cartData = response.data['data'];
        return CartModel.fromJson(cartData);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Error al agregar producto al carrito',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<CartModel> updateCartItemQuantity({
    required String userId,
    required String productId,
    required int quantity,
  }) async {
    try {
      final response = await client.put(
        '${ApiEndpoints.cart}$userId${ApiEndpoints.cartItems}/$productId',
        queryParameters: {
          'quantity': quantity,
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final cartData = response.data['data'];
        return CartModel.fromJson(cartData);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Error al actualizar cantidad',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<CartModel> removeFromCart({
    required String userId,
    required String productId,
  }) async {
    try {
      final response = await client.delete(
        '${ApiEndpoints.cart}$userId${ApiEndpoints.cartItems}/$productId',
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final cartData = response.data['data'];
        return CartModel.fromJson(cartData);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Error al eliminar producto del carrito',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<bool> clearCart({
    required String userId,
  }) async {
    try {
      final response = await client.delete(
        '${ApiEndpoints.cart}$userId',
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return true;
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Error al vaciar carrito',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
}