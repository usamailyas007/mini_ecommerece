import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  String uid;
  String name;
  String email;
  String phoneNumber;
  String profilePicture;
  DateTime createdAt;

  UserModel({
    this.uid = "",
    this.name = "",
    this.email = "",
    this.phoneNumber = "",
    this.profilePicture = "",
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  String toString() {
    return 'UserModel{uid: $uid, name: $name, email: $email, phoneNumber: $phoneNumber, profilePicture: $profilePicture, createdAt: $createdAt}';
  }
}
