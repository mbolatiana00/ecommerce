import 'package:ecommerce/features/product/data/repositories/product_repository_impl.dart';
import 'package:ecommerce/features/product/domain/entites/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const allCategories = 'Tout';

class SearchQuery extends Notifier<String> {
  @override
  String build() => '';
  void set(String q) => state = q.trim();
}

final searchQueryProvider =
    NotifierProvider<SearchQuery, String>(SearchQuery.new);

final productsProvider = FutureProvider<List<Product>>((ref) async {
  final search = ref.watch(searchQueryProvider);
  final result = await ref
      .watch(productRepositoryProvider)
      .getProducts(limit: 50, search: search);
  return result.getOrThrow().items;
});

final categoriesProvider = Provider<List<String>>((ref) {
  final products = ref.watch(productsProvider).value ?? const <Product>[];
  final names = <String>{
    for (final p in products)
      if (p.category.isNotEmpty) p.category,
  };
  return [allCategories, ...names];
});

class SelectedCategory extends Notifier<String> {
  @override
  String build() => allCategories;
  void select(String c) => state = c;
}

final selectedCategoryProvider =
    NotifierProvider<SelectedCategory, String>(SelectedCategory.new);

final filteredProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final c = ref.watch(selectedCategoryProvider);
  return ref.watch(productsProvider).whenData(
        (all) => c == allCategories
            ? all
            : all.where((p) => p.category == c).toList(),
      );
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