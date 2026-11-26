class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? oldPrice;
  final String imageUrl;
  final String category;
  final int stock;
  final double rating;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.oldPrice,
    required this.imageUrl,
    required this.category,
    required this.stock,
    required this.rating,
  });

  bool get inStock => stock > 0;

  /// Pourcentage de remise, ou null s'il n'y a pas de promo.
  int? get discountPercent {
    final old = oldPrice;
    if (old == null || old <= 0 || old <= price) return null;
    return (((old - price) / old) * 100).round();
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
