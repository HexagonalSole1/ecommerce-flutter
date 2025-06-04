// lib/presentation/blocs/auth/auth_event.dart
part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class RegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final String username;
  final String name;
  final String? fcm;
  final List<String>? roles;

  const RegisterEvent({
    required this.email,
    required this.password,
    required this.username,
    required this.name,
    this.fcm,
    this.roles,
  });

  @override
  List<Object?> get props => [email, password, username, name, fcm, roles];
}

class LogoutEvent extends AuthEvent {}

class GetUserInfoEvent extends AuthEvent {
  final String email;

  const GetUserInfoEvent({
    required this.email,
  });

  @override
  List<Object> get props => [email];
}

// lib/presentation/blocs/auth/auth_state.dart
part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User? user;

  const AuthAuthenticated({this.user});

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthRegistered extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object> get props => [message];
}