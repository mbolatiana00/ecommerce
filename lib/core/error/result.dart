import 'package:dio/dio.dart';
import 'failure.dart';

sealed class Result<T> {
  const Result();

  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) =>
      switch (this) {
        Success<T>(:final data) => success(data),
        Err<T>(failure: final f) => failure(f),
      };

  /// Retourne la donnée ou lève la [Failure] (utile dans les AsyncNotifier).
  T getOrThrow() => switch (this) {
        Success<T>(:final data) => data,
        Err<T>(failure: final f) => throw f,
      };
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Err<T> extends Result<T> {
  final Failure failure;
  const Err(this.failure);
}

/// Exécute [action] et convertit toute exception en Result.
Future<Result<T>> guard<T>(Future<T> Function() action) async {
  try {
    return Success(await action());
  } on Failure catch (f) {
    return Err(f);
  } on DioException catch (e) {
    return Err(mapDioException(e));
  } catch (e) {
    return Err(UnknownFailure(e.toString()));
  }
}

Failure mapDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const TimeoutFailure();
    case DioExceptionType.connectionError:
      return const NetworkFailure();
    case DioExceptionType.cancel:
      return const UnknownFailure('Requête annulée');
    default:
      break;
  }

  final status = e.response?.statusCode;
  final data = e.response?.data;
  var message = 'Erreur serveur';
  if (data is Map) {
    message = (data['message'] ?? data['error'] ?? message).toString();
  }

  if (status == 401) return UnauthorizedFailure(message);
  if (status == 422 || status == 400) {
    final errs = <String, List<String>>{};
    if (data is Map && data['errors'] is Map) {
      (data['errors'] as Map).forEach((k, v) {
        errs[k.toString()] =
            v is List ? v.map((x) => x.toString()).toList() : [v.toString()];
      });
    }
    return ValidationFailure(message, errors: errs);
  }
  return ServerFailure(message, status);
}
