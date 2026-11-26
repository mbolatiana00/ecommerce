import 'package:ecommerce/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'].toString(),
    name: (json['name'] ?? '') as String,
    email: (json['email'] ?? '') as String,
    phone: json['phone'] as String?,
  );
}

class AuthResponseModel {
  /// Null quand l'API ne connecte pas directement (ex. vérification OTP après inscription).
  final String? accessToken;
  final String? refreshToken;
  final UserModel user;
  final String? message;

  const AuthResponseModel({
    this.accessToken,
    this.refreshToken,
    required this.user,
    this.message,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final d = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return AuthResponseModel(
      accessToken:
          (d['access_token'] ?? d['accessToken'] ?? d['token']) as String?,
      refreshToken: (d['refresh_token'] ?? d['refreshToken']) as String?,
      user: UserModel.fromJson(d['user'] as Map<String, dynamic>),
      message: (json['message'] ?? d['message']) as String?,
    );
  }
}
