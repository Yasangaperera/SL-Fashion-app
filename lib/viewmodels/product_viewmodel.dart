
import 'package:flutter/foundation.dart';
import '../models/product.dart';

class ProductViewModel extends ChangeNotifier {

  String _selectedCategory = 'All';
  final List<Product> _all = sampleProducts;

  // Getters
  String get selectedCategory => _selectedCategory;
  List<Product> get allProducts  => _all;
  List<String>  get categories   => ['All', 'Saree', 'Batik', 'Casual', 'Kids', 'Sale'];

  // Filtered list based on selected category
  List<Product> get filteredProducts {
    if (_selectedCategory == 'All') return _all;
    return _all.where((p) => p.category == _selectedCategory).toList();
  }

  // Featured: show first 4 products on home
  List<Product> get featuredProducts => _all.take(4).toList();

  // Change category filter
  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }
}
