import 'package:dio/dio.dart';
import 'package:ecommerce/core/network/api_endpoints.dart';
import 'package:ecommerce/core/network/auth_interceptor.dart';
import 'package:ecommerce/core/network/dio_client.dart';
import 'package:ecommerce/features/auth/data/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRemoteDataSource {
  final Dio _dio;
  AuthRemoteDataSource(this._dio);

  static final _public = Options(
    extra: {AuthInterceptor.requiresAuthKey: false},
  );
  Future<AuthResponseModel> login(String email, String password) async {
    final res = await _dio.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
      options: _public,
    );
    return AuthResponseModel.fromJson(res.data as Map<String, dynamic>);
  }

  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    final res = await _dio.post(
      ApiEndpoints.register,
      data: {
        'name': name,
        'email': email,
        'password': password,
        if (phone != null) 'phone': phone,
      },
      options: _public,
    );
    return AuthResponseModel.fromJson(res.data as Map<String, dynamic>);
  }
  Future<UserModel> me() async {
    final res = await _dio.get(ApiEndpoints.me);
    final body = res.data as Map<String, dynamic>;
    final data = body['data'] is Map<String, dynamic> ? body['data'] : body;
    return UserModel.fromJson(data as Map<String, dynamic>);
  }

  Future<void> logout() async {
    await _dio.post(ApiEndpoints.logout);
  }
}

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) => AuthRemoteDataSource(ref.watch(dioProvider)),
);
