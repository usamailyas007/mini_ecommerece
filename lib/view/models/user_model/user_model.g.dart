// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  uid: json['uid'] as String? ?? "",
  name: json['name'] as String? ?? "",
  email: json['email'] as String? ?? "",
  phoneNumber: json['phoneNumber'] as String? ?? "",
  profilePicture: json['profilePicture'] as String? ?? "",
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'uid': instance.uid,
  'name': instance.name,
  'email': instance.email,
  'phoneNumber': instance.phoneNumber,
  'profilePicture': instance.profilePicture,
  'createdAt': instance.createdAt.toIso8601String(),
};
