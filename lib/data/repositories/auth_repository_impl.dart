// lib/data/repositories/auth_repository_impl.dart

import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/auth_local_datasource.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final loginResponse = await remoteDataSource.login(
          email: email,
          password: password,
        );

        // Save tokens locally
        await localDataSource.saveAccessToken(loginResponse['access_token']);
        await localDataSource.saveRefreshToken(loginResponse['refresh_token']);

        // Save user ID if available
        if (loginResponse['id_user'] != null) {
          await localDataSource.saveUserId(loginResponse['id_user'].toString());
        }

        return Right(loginResponse);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String username,
    required String name,
    String? fcm,
    List<String>? roles,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final userModel = await remoteDataSource.register(
          email: email,
          password: password,
          username: username,
          name: name,
          fcm: fcm,
          roles: roles ?? ['USER'],
        );

        return Right(userModel);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> refreshToken({
    required String refreshToken,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final refreshResponse = await remoteDataSource.refreshToken(
          refreshToken: refreshToken,
        );

        // Save new tokens locally
        await localDataSource.saveAccessToken(refreshResponse['access_token']);
        await localDataSource.saveRefreshToken(refreshResponse['refresh_token']);

        return Right(refreshResponse);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> getUserInfo({
    required String email,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final userModel = await remoteDataSource.getUserInfo(
          email: email,
        );

        return Right(userModel);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      await localDataSource.deleteTokens();
      return const Right(true);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final isLoggedIn = await localDataSource.isLoggedIn();
      return Right(isLoggedIn);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}