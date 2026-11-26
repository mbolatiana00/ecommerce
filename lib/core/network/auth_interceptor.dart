import 'dart:async';
import 'package:dio/dio.dart';
import 'package:ecommerce/core/storage/token_storage.dart';
import 'package:ecommerce/core/network/api_endpoints.dart';

/// Ajoute le Bearer token ; sur 401 : refresh du token puis rejoue la requête.
/// QueuedInterceptor => un seul refresh à la fois, les autres requêtes attendent.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required this.tokenStorage,
    required this.plainDio,
    this.onSessionExpired,
  });

  final TokenStorage tokenStorage;

  /// Dio SANS intercepteurs : sert au refresh et au rejeu (évite les boucles).
  final Dio plainDio;
  final void Function()? onSessionExpired;

  /// Mettre `extra: {'requiresAuth': false}` sur les routes publiques.
  static const requiresAuthKey = 'requiresAuth';
  static const _retriedKey = '_retried';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[requiresAuthKey] != false) {
      final token = await tokenStorage.readAccess();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final req = err.requestOptions;
    final is401 = err.response?.statusCode == 401;
    final isPublic = req.extra[requiresAuthKey] == false;
    final alreadyRetried = req.extra[_retriedKey] == true;

    if (!is401 || isPublic || alreadyRetried) {
      return handler.next(err);
    }

    try {
      final currentToken = await tokenStorage.readAccess();
      final usedHeader = req.headers['Authorization'] as String?;

      // Un refresh a déjà eu lieu pendant l'attente dans la file ?
      final alreadyRefreshed =
          currentToken != null && usedHeader != 'Bearer $currentToken';

      if (!alreadyRefreshed) {
        final refreshToken = await tokenStorage.readRefresh();
        if (refreshToken == null) throw const _SessionExpired();

        final res = await plainDio.post(
          ApiEndpoints.refresh,
          data: {'refresh_token': refreshToken},
        );
        final body = res.data as Map;
        final data = body['data'] is Map ? body['data'] as Map : body;
        await tokenStorage.save(
          access: data['access_token'] as String,
          refresh: data['refresh_token'] as String?,
        );
      }

      final newToken = await tokenStorage.readAccess();
      req.headers['Authorization'] = 'Bearer $newToken';
      req.extra[_retriedKey] = true;

      final retried = await plainDio.fetch(req);
      return handler.resolve(retried);
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      final isRefreshCall = e.requestOptions.path == ApiEndpoints.refresh;
      if (isRefreshCall && (code == 401 || code == 403)) {
        await _expire();
        return handler.next(err);
      }
      return handler.next(e);
    } on _SessionExpired {
      await _expire();
      return handler.next(err);
    }
  }

  Future<void> _expire() async {
    await tokenStorage.clear();
    onSessionExpired?.call();
  }
}

class _SessionExpired implements Exception {
  const _SessionExpired();
}
