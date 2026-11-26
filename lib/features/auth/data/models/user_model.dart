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
  final String accessToken;
  final String? refreshToken;
  final UserModel user;

  const AuthResponseModel({
    required this.accessToken,
    this.refreshToken,
    required this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final d = json['data'] is Map<String, dynamic>
        ? json['json'] as Map<String, dynamic>
        : json;

    return AuthResponseModel(
      accessToken: d['access_token'] as String,
      refreshToken: d['refresh_token'] as String,
      user: UserModel.fromJson(d['user'] as Map<String, dynamic>),
    );
  }
}
