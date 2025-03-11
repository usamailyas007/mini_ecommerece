// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
  id: json['id'] as String? ?? "",
  name: json['name'] as String? ?? "",
  imageUrl: json['imageUrl'] as String? ?? "",
  price: (json['price'] as num?)?.toDouble() ?? 0.0,
  size: json['size'] as String? ?? "",
  color: json['color'] as String? ?? "",
  description: json['description'] as String? ?? "",
  quantity: json['quantity'] as String? ?? "",
  isAddedToCart: json['isAddedToCart'] as bool? ?? false,
);

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'price': instance.price,
      'size': instance.size,
      'color': instance.color,
      'description': instance.description,
      'isAddedToCart': instance.isAddedToCart,
      'quantity': instance.quantity,
    };
