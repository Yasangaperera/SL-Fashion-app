// viewmodels/cart_viewmodel.dart

import 'package:flutter/foundation.dart';
import '../models/product.dart';

class CartItem {
  final Product product;
  int quantity;
  CartItem({required this.product, this.quantity = 1});
}

class CartViewModel extends ChangeNotifier {

  final List<CartItem> _items = [];

  // ---- Getters ----
  List<CartItem> get items     => List.unmodifiable(_items);
  int    get itemCount         => _items.length;
  int    get totalCount        => _items.fold(0, (sum, i) => sum + i.quantity);
  double get totalPrice        => _items.fold(0, (sum, i) => sum + i.product.price * i.quantity);

  // Methods (Views call these)
  void addToCart(Product product) {
    for (var item in _items) {
      if (item.product.id == product.id) {
        item.quantity++;
        notifyListeners();
        return;
      }
    }
    _items.add(CartItem(product: product));
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _items.removeWhere((i) => i.product.id == productId);
    notifyListeners();
  }

  void increase(String productId) {
    for (var item in _items) {
      if (item.product.id == productId) {
        item.quantity++;
        notifyListeners();
        return;
      }
    }
  }

  void decrease(String productId) {
    for (var item in _items) {
      if (item.product.id == productId) {
        if (item.quantity > 1) {
          item.quantity--;
        } else {
          _items.remove(item);
        }
        notifyListeners();
        return;
      }
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
