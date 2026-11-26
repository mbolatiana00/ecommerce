import 'package:ecommerce/core/error/result.dart';
import 'package:ecommerce/features/product/domain/entites/product.dart';

abstract interface class ProductRepository {
  Future<Result<Paginated<Product>>> getProducts({
    int page = 1,
    int limit = 20,
    String? search,
    String? category,
  });
  Future<Result<Product>> getProduct(String id);
}
