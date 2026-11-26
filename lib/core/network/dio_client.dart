import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce/core/storage/token_storage.dart';
import 'package:ecommerce/core/network/api_endpoints.dart';
import 'package:ecommerce/core/network/auth_interceptor.dart';

BaseOptions _baseOptions() => BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

/// Callback appelé quand le refresh échoue : l'auth notifier s'y branche.
class SessionExpiredNotifier extends Notifier<void Function()?>{
   @override
   void Function()? build() => null;
   void set(void Function()? callback) => state = callback;
}

final sessionExpiredCallbackProvider =
    NotifierProvider<SessionExpiredNotifier, void Function()?>(
        SessionExpiredNotifier.new);

/// Dio sans intercepteur d'auth (refresh + rejeu).
final plainDioProvider = Provider<Dio>((ref) => Dio(_baseOptions()));

/// Dio principal utilisé par tous les datasources.
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(_baseOptions());

  dio.interceptors.add(
    AuthInterceptor(
      tokenStorage: ref.watch(tokenStorageProvider),
      plainDio: ref.watch(plainDioProvider),
      onSessionExpired: () => ref.read(sessionExpiredCallbackProvider)?.call(),
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(_NoAuthLogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: false,
      logPrint: (o) => debugPrint(o.toString()),
    ));
  }
  return dio;
});

/// Ne journalise pas les appels /auth (mots de passe et tokens).
class _NoAuthLogInterceptor extends LogInterceptor {
  _NoAuthLogInterceptor({
    super.requestBody,
    super.responseBody,
    super.requestHeader,
    super.logPrint,
  });

  static bool _isAuth(RequestOptions o) => o.path.startsWith('/auth');

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) =>
      _isAuth(options)
          ? handler.next(options)
          : super.onRequest(options, handler);

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) =>
      _isAuth(response.requestOptions)
          ? handler.next(response)
          : super.onResponse(response, handler);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) =>
      _isAuth(err.requestOptions)
          ? handler.next(err)
          : super.onError(err, handler);
}
