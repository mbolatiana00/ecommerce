import 'package:ecommerce/core/error/result.dart';
import 'package:ecommerce/core/storage/token_storage.dart';
import 'package:ecommerce/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:ecommerce/features/auth/domain/entities/user.dart';
import 'package:ecommerce/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final TokenStorage _storage;
  AuthRepositoryImpl(this._remote, this._storage);

  @override
  Future<Result<User>> getCurrentUser() => guard(() => _remote.me());

  @override
  Future<bool> hasSession() async => (await _storage.readAccess()) != null;
  @override
  Future<Result<User>> login({
    required String email,
    required String password,
  }) => guard(() async {
    final r = await _remote.login(email, password);
    await _storage.save(access: r.accessToken, refresh: r.refreshToken);
    return r.user;
  });

  @override
  Future<void> logout() async {
    try {
      await _remote.logout();
    } catch (_) {}
    await _storage.clear();
  }

  @override
  Future<Result<User>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) => guard(() async {
    final r = await _remote.register(
      name: name,
      email: email,
      password: password,
      phone: phone,
    );
    await _storage.save(access: r.accessToken, refresh: r.refreshToken);
    return r.user;
  });
}
