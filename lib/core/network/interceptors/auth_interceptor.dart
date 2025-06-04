// lib/core/network/interceptors/auth_interceptor.dart

import 'package:dio/dio.dart';
import '../../constants/api_endpoints.dart';
import '../../storage/secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorage _secureStorage;

  AuthInterceptor(this._secureStorage);

  @override
  Future<void> onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    // Public endpoints don't need authentication
    if (_isPublicEndpoint(options.path)) {
      return handler.next(options);
    }

    // Get access token from secure storage
    final String? accessToken = await _secureStorage.getAccessToken();

    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) async {
    // If the error is 401 Unauthorized, try to refresh the token
    if (err.response?.statusCode == 401) {
      try {
        // Get refresh token
        final String? refreshToken = await _secureStorage.getRefreshToken();

        if (refreshToken == null) {
          // No refresh token, return original error
          return handler.next(err);
        }

        // Create a new Dio instance to avoid interceptors loop
        final Dio tokenDio = Dio();

        // Call the refresh token endpoint
        final Response response = await tokenDio.post(
          ApiEndpoints.baseUrl + ApiEndpoints.refreshToken,
          data: {'refreshToken': refreshToken},
        );

        if (response.statusCode == 200 && response.data['success'] == true) {
          // Save new tokens
          final Map<String, dynamic> tokenData = response.data['data'];
          await _secureStorage.saveAccessToken(tokenData['access_token']);
          await _secureStorage.saveRefreshToken(tokenData['refresh_token']);

          // Retry the original request with new token
          final RequestOptions requestOptions = err.requestOptions;
          final options = Options(
            method: requestOptions.method,
            headers: {
              'Authorization': 'Bearer ${tokenData['access_token']}',
            },
          );

          final response = await tokenDio.request(
            requestOptions.path,
            options: options,
            data: requestOptions.data,
            queryParameters: requestOptions.queryParameters,
          );

          return handler.resolve(response);
        }
      } catch (e) {
        // Error during token refresh, trigger logout
        await _secureStorage.deleteTokens();
        // Return original error
        return handler.next(err);
      }
    }

    return handler.next(err);
  }

  bool _isPublicEndpoint(String path) {
    List<String> publicEndpoints = [
      ApiEndpoints.login,
      ApiEndpoints.register,
      ApiEndpoints.refreshToken,
      // Add other public endpoints here
    ];

    return publicEndpoints.any((endpoint) => path.contains(endpoint));
  }
}