import 'package:ecommerce/core/error/result.dart';
import 'package:ecommerce/features/product/data/datasource/product_remote_datasource.dart';
import 'package:ecommerce/features/product/domain/entites/product.dart';
import 'package:ecommerce/features/product/domain/repositories/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remote;
  ProductRepositoryImpl(this._remote);

  @override
  Future<Result<Paginated<Product>>> getProducts({
    int page = 1,
    int limit = 20,
    String? search,
    String? category,
  }) =>
      guard(() => _remote.getProducts(
            page: page,
            limit: limit,
            search: search,
            category: category,
          ));

  @override
  Future<Result<Product>> getProduct(String id) =>
      guard(() => _remote.getProduct(id));
}

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => ProductRepositoryImpl(ref.watch(productRemoteDataSourceProvider)),
);
