import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  get itemCount =>
  2;

  double getSubtotal() {
    return _cartItems.fold(
      0.0,
          (sum, item) => sum + (item['price'] * item['quantity']),
    );
  }

  double getTotal() {
    const double tax = 0.08;
    const double shipping = 499.17; // Converted $5.99 to INR (5.99 * 83)
    return getSubtotal() + (getSubtotal() * tax) + shipping;
  }

  void addToCart(Map<String, dynamic> product) {
    final existingItemIndex = _cartItems.indexWhere((item) => item['id'] == product['id']);
    if (existingItemIndex >= 0) {
      _cartItems[existingItemIndex]['quantity'] += 1;
    } else {
      _cartItems.add({
        ...product,
        'quantity': 1,
      });
    }
    notifyListeners();
  }

  void updateQuantity(int index, int newQuantity) {
    if (newQuantity > 0) {
      _cartItems[index]['quantity'] = newQuantity;
    } else {
      _cartItems.removeAt(index);
    }
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}