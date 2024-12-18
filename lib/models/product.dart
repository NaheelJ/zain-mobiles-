import 'dart:io';

class Product {
  final String name;
  final String price;
  final suitableFor;
  final File? image;

  Product({
    required this.name,
    required this.price,
    required this.suitableFor,
    this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      price: json['price'],
      suitableFor: json['suitableFor'],
      image: json['image'] ?? null,
    );
  }
}
