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
  final IconData? _icon;
  final Color? _color;

  const Product({
    required this.id,
    required this.name,
    this.description = '',
    required this.price,
    this.oldPrice,
    this.imageUrl,
    required this.category,
    required this.stock,
    required this.rating,
    IconData? icon,
    Color? color,
  })  : _icon = icon,
        _color = color;

  bool get inStock => stock > 0;

  /// Icône fournie, sinon déduite de la catégorie.
  IconData get icon => _icon ?? _categoryIcon(category);

  /// Couleur fournie, sinon déduite de la catégorie.
  Color get color => _color ?? _categoryColor(category);

  /// Pourcentage de remise, ou null s'il n'y a pas de promo.
  int? get discountPercent {
    final old = oldPrice;
    if (old == null || old <= 0 || old <= price) return null;
    return (((old - price) / old) * 100).round();
  }

  static IconData _categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'mode':
      case 'vêtements':
        return Icons.checkroom_rounded;
      case 'téléphones':
      case 'phones':
        return Icons.smartphone_rounded;
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

  static Color _categoryColor(String category) {
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