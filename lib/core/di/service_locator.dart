// lib/core/di/service_locator.dart

import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Network
import '../network/api_client.dart';
import '../network/network_info.dart';

// Storage
import '../storage/secure_storage.dart';
import '../storage/local_storage.dart';

// Repositories
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../data/repositories/cart_repository_impl.dart';
import '../../data/repositories/order_repository_impl.dart';

// Data sources
import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../data/datasources/remote/product_remote_datasource.dart';
import '../../data/datasources/remote/cart_remote_datasource.dart';
import '../../data/datasources/remote/order_remote_datasource.dart';
import '../../data/datasources/local/auth_local_datasource.dart';
import '../../data/datasources/local/product_local_datasource.dart';

// Repository interfaces
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/repositories/order_repository.dart';

// Use cases
import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/register_usecase.dart';
import '../../domain/usecases/auth/logout_usecase.dart';
import '../../domain/usecases/auth/get_user_info_usecase.dart';
import '../../domain/usecases/auth/is_logged_in_usecase.dart';
import '../../domain/usecases/auth/refresh_token_usecase.dart';

import '../../domain/usecases/products/get_products_usecase.dart';
import '../../domain/usecases/products/get_product_details_usecase.dart';
import '../../domain/usecases/products/search_products_usecase.dart';

import '../../domain/usecases/cart/get_cart_usecase.dart';
import '../../domain/usecases/cart/add_to_cart_usecase.dart';
import '../../domain/usecases/cart/update_cart_item_usecase.dart';
import '../../domain/usecases/cart/remove_from_cart_usecase.dart';

// BLoCs
import '../../presentation/blocs/auth/auth_bloc.dart';

final ServiceLocator = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  ServiceLocator.registerLazySingleton(() => sharedPreferences);
  ServiceLocator.registerLazySingleton(() => const FlutterSecureStorage());
  ServiceLocator.registerLazySingleton(() => Connectivity());
  ServiceLocator.registerLazySingleton(() => Dio());

  // Core implementations
  ServiceLocator.registerLazySingleton<NetworkInfo>(
        () => NetworkInfoImpl(ServiceLocator()),
  );
  ServiceLocator.registerLazySingleton<SecureStorage>(
        () => SecureStorage(ServiceLocator()),
  );
  ServiceLocator.registerLazySingleton<LocalStorage>(
        () => LocalStorage(ServiceLocator()),
  );
  ServiceLocator.registerLazySingleton<ApiClient>(
        () => ApiClient(ServiceLocator(), ServiceLocator()),
  );

  // Data sources
  ServiceLocator.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(ServiceLocator()),
  );
  ServiceLocator.registerLazySingleton<AuthLocalDataSource>(
        () => AuthLocalDataSourceImpl(ServiceLocator()),
  );
  ServiceLocator.registerLazySingleton<ProductRemoteDataSource>(
        () => ProductRemoteDataSourceImpl(ServiceLocator()),
  );
  ServiceLocator.registerLazySingleton<ProductLocalDataSource>(
        () => ProductLocalDataSourceImpl(ServiceLocator()),
  );
  ServiceLocator.registerLazySingleton<CartRemoteDataSource>(
        () => CartRemoteDataSourceImpl(ServiceLocator()),
  );
  ServiceLocator.registerLazySingleton<OrderRemoteDataSource>(
        () => OrderRemoteDataSourceImpl(ServiceLocator()),
  );

  // Repositories
  ServiceLocator.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      remoteDataSource: ServiceLocator(),
      localDataSource: ServiceLocator(),
      networkInfo: ServiceLocator(),
    ),
  );
  ServiceLocator.registerLazySingleton<ProductRepository>(
        () => ProductRepositoryImpl(
      remoteDataSource: ServiceLocator(),
      localDataSource: ServiceLocator(),
      networkInfo: ServiceLocator(),
    ),
  );
  ServiceLocator.registerLazySingleton<CartRepository>(
        () => CartRepositoryImpl(
      remoteDataSource: ServiceLocator(),
      networkInfo: ServiceLocator(),
      secureStorage: ServiceLocator(),
    ),
  );
  ServiceLocator.registerLazySingleton<OrderRepository>(
        () => OrderRepositoryImpl(
      remoteDataSource: ServiceLocator(),
      networkInfo: ServiceLocator(),
    ),
  );

  // Use cases
  // Auth
  ServiceLocator.registerLazySingleton(() => LoginUseCase(ServiceLocator()));
  ServiceLocator.registerLazySingleton(() => RegisterUseCase(ServiceLocator()));
  ServiceLocator.registerLazySingleton(() => LogoutUseCase(ServiceLocator()));
  ServiceLocator.registerLazySingleton(() => GetUserInfoUseCase(ServiceLocator()));
  ServiceLocator.registerLazySingleton(() => IsLoggedInUseCase(ServiceLocator()));
  ServiceLocator.registerLazySingleton(() => RefreshTokenUseCase(ServiceLocator()));

  // Products
  ServiceLocator.registerLazySingleton(() => GetProductsUseCase(ServiceLocator()));
  ServiceLocator.registerLazySingleton(() => GetProductDetailsUseCase(ServiceLocator()));
  ServiceLocator.registerLazySingleton(() => SearchProductsUseCase(ServiceLocator()));

  // Cart
  ServiceLocator.registerLazySingleton(() => GetCartUseCase(ServiceLocator()));
  ServiceLocator.registerLazySingleton(() => AddToCartUseCase(ServiceLocator()));
  ServiceLocator.registerLazySingleton(() => UpdateCartItemUseCase(ServiceLocator()));
  ServiceLocator.registerLazySingleton(() => RemoveFromCartUseCase(ServiceLocator()));

  // BLoCs
  ServiceLocator.registerFactory<AuthBloc>(
        () => AuthBloc(
      loginUseCase: ServiceLocator(),
      registerUseCase: ServiceLocator(),
      logoutUseCase: ServiceLocator(),
      getUserInfoUseCase: ServiceLocator(),
      isLoggedInUseCase: ServiceLocator(),
    )..add(CheckAuthStatusEvent()),
  );
}