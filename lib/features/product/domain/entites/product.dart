import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? oldPrice;
  final String? imageUrl;
  final String category;
  final int stock;
  final double rating;
  final int reviewsCount;

  const Product({
    required this.id,
    required this.name,
    this.description = '',
    required this.price,
    this.oldPrice,
    this.imageUrl,
    this.category = '',
    this.stock = 0,
    this.rating = 0,
    this.reviewsCount = 0,
  });

  bool get inStock => stock > 0;

  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  /// Pourcentage de remise, ou null s'il n'y a pas de promo.
  int? get discountPercent {
    final old = oldPrice;
    if (old == null || old <= 0 || old <= price) return null;
    return (((old - price) / old) * 100).round();
  }

  /// Icône de remplacement quand le produit n'a pas d'image.
  IconData get icon {
    switch (category.toLowerCase()) {
      case 'mode':
      case 'vêtements':
        return Icons.checkroom_rounded;
      case 'téléphones':
      case 'phones':
        return Icons.smartphone_rounded;
      case 'tech':
      case 'informatique':
        return Icons.laptop_mac_rounded;
      case 'maison':
        return Icons.chair_rounded;
      case 'beauté':
        return Icons.spa_rounded;
      case 'sport':
        return Icons.sports_soccer_rounded;
      default:
        return Icons.shopping_bag_rounded;
    }
  }

  Color get color {
    const palette = [
      Color(0xFF6366F1),
      Color(0xFF10B981),
      Color(0xFFF59E0B),
      Color(0xFFEC4899),
      Color(0xFF06B6D4),
      Color(0xFF8B5CF6),
    ];
    return palette[category.hashCode.abs() % palette.length];
  }
}

class Paginated<T> {
  final List<T> items;
  final int page;
  final int totalPages;
  const Paginated({
    required this.items,
    required this.page,
    required this.totalPages,
  });
  bool get hasMore => page < totalPages;
}
