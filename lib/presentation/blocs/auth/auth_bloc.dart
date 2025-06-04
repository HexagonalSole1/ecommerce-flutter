// lib/presentation/blocs/auth/auth_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/auth/login_usecase.dart';
import '../../../domain/usecases/auth/register_usecase.dart';
import '../../../domain/usecases/auth/logout_usecase.dart';
import '../../../domain/usecases/auth/get_user_info_usecase.dart';
import '../../../domain/usecases/auth/is_logged_in_usecase.dart';
import '../../../core/errors/failures.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final GetUserInfoUseCase getUserInfoUseCase;
  final IsLoggedInUseCase isLoggedInUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.getUserInfoUseCase,
    required this.isLoggedInUseCase,
  }) : super(AuthInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
    on<GetUserInfoEvent>(_onGetUserInfo);
  }

  Future<void> _onCheckAuthStatus(
      CheckAuthStatusEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    final result = await isLoggedInUseCase();

    result.fold(
          (failure) => emit(AuthError(message: failure.message)),
          (isLoggedIn) {
        if (isLoggedIn) {
          emit(const AuthAuthenticated(user: null));
        } else {
          emit(AuthUnauthenticated());
        }
      },
    );
  }

  Future<void> _onLogin(
      LoginEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    final result = await loginUseCase(
      email: event.email,
      password: event.password,
    );

    result.fold(
          (failure) => emit(AuthError(message: failure.message)),
          (loginData) {
        // Extract user data from login response
        final userData = {
          'id': loginData['id_user'],
          'email': event.email,
          'username': loginData['username'],
          'name': loginData['name'],
          'roles': loginData['roles'],
        };

        // If we have complete user data
        if (userData['id'] != null &&
            userData['username'] != null &&
            userData['name'] != null) {

          final user = User(
            id: userData['id'] as int,
            email: userData['email'] as String,
            username: userData['username'] as String,
            name: userData['name'] as String,
            roles: _extractRoles(userData['roles']),
          );

          emit(AuthAuthenticated(user: user));
        } else {
          // If we don't have complete user data, we need to fetch it
          emit(const AuthAuthenticated(user: null));
          add(GetUserInfoEvent(email: event.email));
        }
      },
    );
  }

  Future<void> _onRegister(
      RegisterEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    final result = await registerUseCase(
      email: event.email,
      password: event.password,
      username: event.username,
      name: event.name,
      fcm: event.fcm,
      roles: event.roles,
    );

    result.fold(
          (failure) => emit(AuthError(message: failure.message)),
          (user) {
        emit(AuthRegistered());
        // Auto login after registration
        add(LoginEvent(
          email: event.email,
          password: event.password,
        ));
      },
    );
  }

  Future<void> _onLogout(
      LogoutEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    final result = await logoutUseCase();

    result.fold(
          (failure) => emit(AuthError(message: failure.message)),
          (_) => emit(AuthUnauthenticated()),
    );
  }

  Future<void> _onGetUserInfo(
      GetUserInfoEvent event,
      Emitter<AuthState> emit,
      ) async {
    if (state is! AuthAuthenticated) {
      emit(AuthLoading());
    }

    final result = await getUserInfoUseCase(
      email: event.email,
    );

    result.fold(
          (failure) => emit(AuthError(message: failure.message)),
          (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  List<String> _extractRoles(dynamic roles) {
    if (roles == null) return [];

    if (roles is String) {
      return roles.split(',').map((role) => role.trim()).toList();
    } else if (roles is List) {
      return roles.map((role) {
        if (role is Map && role.containsKey('name')) {
          return role['name'].toString();
        } else {
          return role.toString();
        }
      }).toList();
    }

    return [];
  }
}