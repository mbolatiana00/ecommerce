class ApiEndpoints {
  static const baseUrl = String.fromEnvironment("API_URL", defaultValue: '');
    static const login = '/auth/login';
  static const register = '/auth/register';
  static const refresh = '/auth/refresh';
  static const me = '/auth/me';
  static const logout = '/auth/logout';

  // Produits
  static const products = '/products';
  static String product(String id) => '/products/$id';

  // Commandes
  static const orders = '/orders';
}
