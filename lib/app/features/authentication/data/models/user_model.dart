import 'package:top_up_beneficiary_app/app/features/authentication/domain/entities/user.dart';

class UserModel extends User {
  UserModel({required super.username});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(username: json['username']);
  }

  Map<String, dynamic> toJson() {
    return {'username': username};
  }
}
