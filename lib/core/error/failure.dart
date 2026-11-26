sealed class Failure {
  final String message;
  final int? statusCode;
  const Failure(this.message, [this.statusCode]);
  @override
  String toString() => '$runtimeType($message, $statusCode)';
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Pas de connexion internet'])
      : super(message);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure(
      [String message = 'Le serveur met trop de temps à répondre'])
      : super(message);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(
      [String message = 'Session expirée, reconnectez-vous'])
      : super(message, 401);
}

class ValidationFailure extends Failure {
  final Map<String, List<String>> errors;
  const ValidationFailure(String message, {this.errors = const {}})
      : super(message, 422);
}

class ServerFailure extends Failure {
  const ServerFailure(String message, [int? statusCode])
      : super(message, statusCode);
}

class UnknownFailure extends Failure {
  const UnknownFailure([String message = 'Une erreur inattendue est survenue'])
      : super(message);
}
