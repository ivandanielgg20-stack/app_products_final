import 'user.dart';

class UserMapper {
  static User jsonToEntity(Map<String, dynamic> json) => User(
        id: json['id'] ?? '',
        email: json['email'] ?? '',
        fullname: json['fullName'] ?? json['fullname'] ?? '',
        roles: (json['roles'] is List)
            ? List<String>.from(json['roles'].map((role) => role.toString()))
            : [],
        token: json['token'] ?? '',
      );
}
