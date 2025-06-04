// lib/data/datasources/remote/auth_remote_datasource.dart

import '../../../core/constants/api_endpoints.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/network/api_client.dart';
import '../../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  });

  Future<UserModel> register({
    required String email,
    required String password,
    required String username,
    required String name,
    String? fcm,
    List<String>? roles,
  });

  Future<Map<String, dynamic>> refreshToken({
    required String refreshToken,
  });

  Future<UserModel> getUserInfo({
    required String email,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient client;

  AuthRemoteDataSourceImpl(this.client);

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['data'] as Map<String, dynamic>;
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Error de autenticación',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String username,
    required String name,
    String? fcm,
    List<String>? roles,
  }) async {
    try {
      final response = await client.post(
        ApiEndpoints.register,
        data: {
          'email': email,
          'password': password,
          'username': username,
          'name': name,
          if (fcm != null) 'fcm': fcm,
          if (roles != null) 'roles': roles,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data['success'] == true) {
          // Normalmente, aquí convertirías la respuesta a un UserModel
          // Pero por ahora, crearemos un modelo básico
          return UserModel(
            id: 0, // Esto normalmente vendría de la respuesta
            email: email,
            username: username,
            name: name,
            roles: roles ?? ['USER'],
          );
        } else {
          throw ServerException(
            message: response.data['message'] ?? 'Error al registrar usuario',
          );
        }
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Error al registrar usuario',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> refreshToken({
    required String refreshToken,
  }) async {
    try {
      final response = await client.post(
        ApiEndpoints.refreshToken,
        data: {
          'refreshToken': refreshToken,
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['data'] as Map<String, dynamic>;
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Error al refrescar token',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> getUserInfo({
    required String email,
  }) async {
    try {
      final response = await client.get(
        ApiEndpoints.getUserInfo + email,
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final userData = response.data['data'] as Map<String, dynamic>;

        return UserModel(
          id: userData['id'],
          email: userData['email'],
          username: userData['username'],
          name: userData['name'],
          roles: ['USER'], // Esto normalmente vendría de la respuesta
        );
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Error al obtener información del usuario',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
}