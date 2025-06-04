// lib/data/datasources/local/auth_local_datasource.dart

import '../../../core/storage/secure_storage.dart';

abstract class AuthLocalDataSource {
  Future<void> saveAccessToken(String token);
  Future<void> saveRefreshToken(String token);
  Future<void> saveUserId(String userId);
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<String?> getUserId();
  Future<void> deleteTokens();
  Future<bool> isLoggedIn();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorage secureStorage;

  AuthLocalDataSourceImpl(this.secureStorage);

  @override
  Future<void> saveAccessToken(String token) async {
    await secureStorage.saveAccessToken(token);
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await secureStorage.saveRefreshToken(token);
  }

  @override
  Future<void> saveUserId(String userId) async {
    await secureStorage.saveUserId(userId);
  }

  @override
  Future<String?> getAccessToken() async {
    return await secureStorage.getAccessToken();
  }

  @override
  Future<String?> getRefreshToken() async {
    return await secureStorage.getRefreshToken();
  }

  @override
  Future<String?> getUserId() async {
    return await secureStorage.getUserId();
  }

  @override
  Future<void> deleteTokens() async {
    await secureStorage.deleteTokens();
  }

  @override
  Future<bool> isLoggedIn() async {
    return await secureStorage.isLoggedIn();
  }
}
