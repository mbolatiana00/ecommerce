import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/product.dart';

const categories = ['Tout', 'Mode', 'Tech', 'Maison', 'Beauté', 'Sport'];

/// TODO : remplace ces données de démo par ton API.
const _demoProducts = <Product>[
  Product(id: '1', name: 'Casque sans fil', category: 'Tech', price: 189000, oldPrice: 249000, rating: 4.8, icon: Icons.headphones_rounded, color: Color(0xFF6C4CF1), stock: 17),
  Product(id: '2', name: 'Montre connectée', category: 'Tech', price: 320000, rating: 4.6, icon: Icons.watch_rounded, color: Color(0xFF0EA5A4), stock: 15),
  Product(id: '3', name: 'Baskets urbaines', category: 'Mode', price: 145000, oldPrice: 190000, rating: 4.7, icon: Icons.directions_run_rounded, color: Color(0xFFF97316), stock: 11),
  Product(id: '4', name: 'Sac à dos cuir', category: 'Mode', price: 98000, rating: 4.5, icon: Icons.backpack_rounded, color: Color(0xFFEC4899), stock: 18),
  Product(id: '5', name: 'Lampe de bureau', category: 'Maison', price: 54000, rating: 4.4, icon: Icons.lightbulb_rounded, color: Color(0xFFEAB308), stock: 14),
  Product(id: '6', name: 'Fauteuil confort', category: 'Maison', price: 410000, oldPrice: 480000, rating: 4.9, icon: Icons.chair_rounded, color: Color(0xFF3B82F6), stock: 14),
  Product(id: '7', name: 'Coffret soin visage', category: 'Beauté', price: 76000, rating: 4.6, icon: Icons.spa_rounded, color: Color(0xFFD946EF), stock: 10),
  Product(id: '8', name: 'Tapis de yoga', category: 'Sport', price: 42000, rating: 4.3, icon: Icons.self_improvement_rounded, color: Color(0xFF22C55E), stock: 17),
];

final productsProvider = Provider<List<Product>>((ref) => _demoProducts);

class SelectedCategory extends Notifier<String> {
  @override
  String build() => 'Tout';
  void select(String c) => state = c;
}

final selectedCategoryProvider =
    NotifierProvider<SelectedCategory, String>(SelectedCategory.new);

final filteredProductsProvider = Provider<List<Product>>((ref) {
  final c = ref.watch(selectedCategoryProvider);
  final all = ref.watch(productsProvider);
  return c == 'Tout' ? all : all.where((p) => p.category == c).toList();
});

/// Panier : productId -> quantité
class CartNotifier extends Notifier<Map<String, int>> {
  @override
  Map<String, int> build() => {};

  void add(String id, [int qty = 1]) =>
      state = {...state, id: (state[id] ?? 0) + qty};

  void decrement(String id) {
    final q = state[id] ?? 0;
    if (q <= 1) {
      remove(id);
    } else {
      state = {...state, id: q - 1};
    }
  }

  void remove(String id) => state = {...state}..remove(id);

  void clear() => state = {};
}

final cartProvider =
    NotifierProvider<CartNotifier, Map<String, int>>(CartNotifier.new);

final cartCountProvider = Provider<int>(
  (ref) => ref.watch(cartProvider).values.fold(0, (a, b) => a + b),
);

class FavoritesNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  void toggle(String id) {
    state = state.contains(id) ? ({...state}..remove(id)) : {...state, id};
  }
}

final favoritesProvider =
    NotifierProvider<FavoritesNotifier, Set<String>>(FavoritesNotifier.new);