import 'package:ecommerce/features/product/domain/entites/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    super.description,
    required super.price,
    super.oldPrice,
    super.imageUrl,
    super.category,
    super.stock,
    super.rating,
    super.reviewsCount,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final category = json['category'];
    final images = json['images'];
    return ProductModel(
      id: json['id'].toString(),
      name: (json['name'] ?? json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      price: _toDouble(json['price']) ?? 0,
      oldPrice: _toDouble(json['old_price'] ?? json['oldPrice']),
      imageUrl: (json['image_url'] ??
              json['imageUrl'] ??
              json['image'] ??
              (images is List && images.isNotEmpty ? images.first : null))
          ?.toString(),
      category: category is Map
          ? (category['name'] ?? '').toString()
          : (category ?? '').toString(),
      stock: _toInt(json['stock'] ?? json['quantity']) ?? 0,
      rating: _toDouble(json['rating']) ?? 0,
      reviewsCount: _toInt(json['reviews_count'] ?? json['reviewsCount']) ?? 0,
    );
  }

  static double? _toDouble(Object? v) =>
      v is num ? v.toDouble() : double.tryParse(v?.toString() ?? '');

  static int? _toInt(Object? v) =>
      v is num ? v.toInt() : int.tryParse(v?.toString() ?? '');
}
