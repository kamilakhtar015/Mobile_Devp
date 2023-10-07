import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'product_list_page.dart';

void main() {
  runApp(MyApp());
}

Future<List<Product>> fetchProducts() async {
  final response = await http.get(Uri.parse(
      'https://makeup-api.herokuapp.com/api/v1/products.json?brand=maybelline'));

  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Product.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load products');
  }
}

class Product {
  final String imageLink;
  final String name;
  final String price;
  final double rating;
  final String productType;
  final List<ProductColor> productColors;

  Product({
    required this.imageLink,
    required this.name,
    required this.price,
    required this.rating,
    required this.productType,
    required this.productColors,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      imageLink: json['image_link'] ?? "",
      name: json['name'] ?? "",
      price: json['price'].toString() ?? "0",
      rating: json['rating']?.toDouble() ?? 0.0,
      productType: json['product_type'] ?? "",
      productColors: (json['product_colors'] as List<dynamic>?)
              ?.map((color) => ProductColor.fromJson(color))
              .toList() ??
          [],
    );
  }
}

class ProductColor {
  final String hexValue;

  ProductColor({required this.hexValue});

  factory ProductColor.fromJson(Map<String, dynamic> json) {
    return ProductColor(
      hexValue: json['hex_value'] ?? "",
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProductListPage(),
    );
  }
}
