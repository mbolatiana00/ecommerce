import 'package:ecommerce/core/error/result.dart';
import 'package:ecommerce/features/auth/domain/entities/user.dart';

abstract interface class AuthRepository {
  Future<Result<User>> login({required String email, required String password});
  Future<Result<User>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  });

  Future<Result<User>> getCurrentUser();
  Future<bool> hasSession();
  Future<void> logout();
}
