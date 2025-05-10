import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://fakestoreapi.com';

  Future<List<dynamic>> getAllProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> getProduct(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/products/$id'));
    return json.decode(response.body);
  }

  Future<List<dynamic>> getCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/products/categories'));
    return json.decode(response.body);
  }

  Future<List<dynamic>> getProductsInCategory(String category) async {
    final response = await http.get(Uri.parse('$baseUrl/products/category/$category'));
    return json.decode(response.body);
  }

  Future<List<dynamic>> getUserCart(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/carts?userId=$userId'));
    return json.decode(response.body);
  }

  Future<List<dynamic>> getLimitedProducts(int limit) async {
    final response = await http.get(Uri.parse('$baseUrl/products?limit=$limit'));
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> addProduct(Map<String, dynamic> product) async {
    final response = await http.post(
      Uri.parse('$baseUrl/products'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product),
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> updateProduct(int id, Map<String, dynamic> product) async {
    final response = await http.put(
      Uri.parse('$baseUrl/products/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product),
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> patchProduct(int id, Map<String, dynamic> product) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/products/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product),
    );
    return json.decode(response.body);
  }

  Future<void> deleteProduct(int id) async {
    await http.delete(Uri.parse('$baseUrl/products/$id'));
  }
}
