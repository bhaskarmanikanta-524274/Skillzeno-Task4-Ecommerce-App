class Product {
  final int id; final String title; final double price; final String description;
  final String category; final String image; final double rating;
  const Product({required this.id, required this.title, required this.price, required this.description, required this.category, required this.image, required this.rating});
  factory Product.fromJson(Map<String,dynamic> j) => Product(
    id:(j['id'] as num).toInt(), title:j['title']?.toString() ?? 'Product',
    price:(j['price'] as num).toDouble(), description:j['description']?.toString() ?? '',
    category:j['category']?.toString() ?? 'General', image:j['image']?.toString() ?? '',
    rating:j['rating'] is Map && j['rating']['rate'] is num ? (j['rating']['rate'] as num).toDouble() : 0,
  );
}
