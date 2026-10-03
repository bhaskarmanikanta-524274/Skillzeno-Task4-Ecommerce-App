import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  // DummyJSON is used because it supports browser requests reliably.
  static const url = 'https://dummyjson.com/products?limit=20';

  Future<List<Product>> fetchProducts() async {
    try {
      final r = await http.get(Uri.parse(url));
      if (r.statusCode != 200) {
        throw Exception('Unable to load products. Please try again.');
      }

      final data = jsonDecode(r.body);
      if (data is! Map || data['products'] is! List) {
        throw Exception('Invalid product data received.');
      }

      final products = data['products'] as List;
      return products.map((item) {
        final j = item as Map<String, dynamic>;
        final images = j['images'];
        final image = images is List && images.isNotEmpty
            ? images.first.toString()
            : (j['thumbnail']?.toString() ?? '');

        return Product(
          id: (j['id'] as num).toInt(),
          title: j['title']?.toString() ?? 'Product',
          price: (j['price'] as num).toDouble(),
          description: j['description']?.toString() ?? '',
          category: j['category']?.toString() ?? 'General',
          image: image,
          rating: j['rating'] is num ? (j['rating'] as num).toDouble() : 0,
        );
      }).toList();
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Network error. Please check your internet connection.');
    }
  }
}
