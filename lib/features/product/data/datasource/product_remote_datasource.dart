import 'package:dio/dio.dart';
import 'package:ecommerce/core/network/api_endpoints.dart';
import 'package:ecommerce/core/network/dio_client.dart';
import 'package:ecommerce/features/product/data/models/product_model.dart';
import 'package:ecommerce/features/product/domain/entites/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductRemoteDataSource {
  final Dio _dio;
  ProductRemoteDataSource(this._dio);

  Future<Paginated<ProductModel>> getProducts({
    int page = 1,
    int limit = 20,
    String? search,
    String? category,
  }) async {
    final res = await _dio.get(
      ApiEndpoints.products,
      queryParameters: {
        'page': page,
        'limit': limit,
        if (search != null && search.isNotEmpty) 'search': search,
        if (category != null && category.isNotEmpty) 'category': category,
      },
    );
    final body = res.data;
    final data = body is Map ? body['data'] : null;
    final list = body is List
        ? body
        : data is List
            ? data
            : data is Map && data['items'] is List
                ? data['items'] as List
                : body is Map && body['items'] is List
                    ? body['items'] as List
                    : const [];
    final meta = body is Map
        ? (body['meta'] is Map ? body['meta'] as Map : (data is Map ? data : body))
        : const {};

    return Paginated(
      items: list
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      page: _toInt(meta['page'] ?? meta['current_page']) ?? page,
      totalPages:
          _toInt(meta['total_pages'] ?? meta['totalPages'] ?? meta['last_page']) ??
              page,
    );
  }

  Future<ProductModel> getProduct(String id) async {
    final res = await _dio.get(ApiEndpoints.product(id));
    final body = res.data as Map<String, dynamic>;
    final data = body['data'] is Map<String, dynamic> ? body['data'] : body;
    return ProductModel.fromJson(data as Map<String, dynamic>);
  }

  static int? _toInt(Object? v) =>
      v is num ? v.toInt() : int.tryParse(v?.toString() ?? '');
}

final productRemoteDataSourceProvider = Provider<ProductRemoteDataSource>(
  (ref) => ProductRemoteDataSource(ref.watch(dioProvider)),
);
