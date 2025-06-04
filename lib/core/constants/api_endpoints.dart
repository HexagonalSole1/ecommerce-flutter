// lib/core/constants/api_endpoints.dart

class ApiEndpoints {
  static const String baseUrl = 'http://your-api-gateway-url:8080';

  // Auth Service
  static const String login = '/auth-service/auth/authenticate';
  static const String register = '/auth-service/users';
  static const String refreshToken = '/auth-service/auth/refresh-token';
  static const String getUserInfo = '/auth-service/users/user/email/';

  // Product Service
  static const String products = '/product-service/products';
  static const String productSearch = '/product-service/products/search';
  static const String productsByCategory = '/product-service/products/category/';

  // Cart Service
  static const String cart = '/shopping-cart-service/cart/';
  static const String cartItems = '/items';

  // Order Service
  static const String orders = '/order-pay-service/orders';
  static const String orderFromCart = '/order-pay-service/orders/from-cart/';
  static const String orderByUser = '/order-pay-service/orders/user/';
  static const String orderStats = '/stats';

  // Payment Service
  static const String payments = '/order-pay-service/payments';
  static const String processPayment = '/order-pay-service/payments/process';
}