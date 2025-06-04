// lib/domain/repositories/auth_repository.dart

import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import '../../core/errors/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, Map<String, dynamic>>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String username,
    required String name,
    String? fcm,
    List<String>? roles,
  });

  Future<Either<Failure, Map<String, dynamic>>> refreshToken({
    required String refreshToken,
  });

  Future<Either<Failure, User>> getUserInfo({
    required String email,
  });

  Future<Either<Failure, bool>> logout();

  Future<Either<Failure, bool>> isLoggedIn();
}