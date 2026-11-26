import 'package:ecommerce/core/error/result.dart';
import 'package:ecommerce/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ecommerce/features/auth/domain/entities/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStatus { initial, loading, success, error }

class AuthState {
  final AuthStatus status;
  final String? errorMessage;

  /// Vrai quand un token a été enregistré (l'utilisateur est connecté).
  final bool isAuthenticated;

  const AuthState({
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.isAuthenticated = false,
  });

  bool get isLoading => status == AuthStatus.loading;
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  Future<bool> login({required String email, required String password}) =>
      _run(() => ref
          .read(authRepositoryProvider)
          .login(email: email, password: password));

  Future<bool> register({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) =>
      _run(() => ref.read(authRepositoryProvider).register(
            name: name,
            email: email,
            password: password,
            phone: phone.isEmpty ? null : phone,
          ));

  Future<bool> _run(Future<Result<User>> Function() action) async {
    state = const AuthState(status: AuthStatus.loading);
    final result = await action();
    switch (result) {
      case Success():
        final hasSession = await ref.read(authRepositoryProvider).hasSession();
        state = AuthState(
          status: AuthStatus.success,
          isAuthenticated: hasSession,
        );
        return true;
      case Err(:final failure):
        state = AuthState(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
        return false;
    }
  }

  void reset() {
    state = const AuthState();
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
