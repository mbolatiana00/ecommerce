import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStatus { initial, loading, success, error }

class AuthState {
  final AuthStatus status;
  final String? errorMessage;

  const AuthState({this.status = AuthStatus.initial, this.errorMessage});

  bool get isLoading => status == AuthStatus.loading;
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();
  Future<bool> login({required String email, required String password}) async {
    state = const AuthState(status: AuthStatus.loading);
    try {
      await Future.delayed(const Duration(seconds: 2));
      state = const AuthState(status: AuthStatus.success);
      return true;
    } catch (e) {
      state = AuthState(status: AuthStatus.error, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    state = const AuthState(status: AuthStatus.loading);
    try {
      await Future.delayed(const Duration(seconds: 2));
      state = const AuthState(status: AuthStatus.success);
      return true;
    } catch (e) {
      state = AuthState(status: AuthStatus.error, errorMessage: e.toString());
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
