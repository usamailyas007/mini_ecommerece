import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel {
  String id;
  String name;
  String imageUrl;
  double price;
  String size;
  String color;
  String description;
  bool isAddedToCart;
  String quantity;

  ProductModel({
    this.id = "",
    this.name = "",
    this.imageUrl = "",
    this.price = 0.0,
    this.size = "",
    this.color = "",
    this.description = "",
    this.isAddedToCart = false,
    this.quantity = "1",
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  @override
  String toString() {
    return 'ProductModel{id: $id, name: $name, imageUrl: $imageUrl, price: $price, size: $size, color: $color, description: $description, isAddedToCart: $isAddedToCart, quantity: $quantity}';
  }
}
