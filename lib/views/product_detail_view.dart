// ============================================================
// views/product_detail_view.dart — VIEW (V in MVVM)
// Uses LKR currency. Calls CartViewModel.addToCart().
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../models/product.dart';
import '../widgets/app_button.dart';
import 'cart_view.dart';

class ProductDetailView extends StatefulWidget {
  final Product product;
  const ProductDetailView({super.key, required this.product});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  // Local UI state — fine to keep in View (not logic)
  String _selectedSize = 'M';
  int    _qty          = 1;
  final  _sizes        = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];

  void _onAddToCart() {
    // Call ViewModel — View does not handle cart logic
    final cartVM = context.read<CartViewModel>();
    for (int i = 0; i < _qty; i++) {
      cartVM.addToCart(widget.product);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.name} Add cart'),
        // "... added to cart!"
        backgroundColor: const Color(0xFF00695C),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'View Cart',  // "View Cart"
          textColor: Colors.white,
          onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const CartView())),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(p.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const CartView())),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ---- Product Image ----
            SizedBox(
              width: double.infinity, height: 300,
              child: _buildImage(p.image),
            ),

            // ---- Info Card ----
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Name, category, price row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.name,
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5E9),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(p.category,
                                  style: const TextStyle(
                                      color: Color(0xFF00695C), fontSize: 12, fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      ),
                      // LKR price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'LKR ${p.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF00695C)),
                          ),
                          if (p.isNew)
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00695C),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text('New Arrival',
                                  style: TextStyle(color: Colors.white, fontSize: 10)),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ---- Description ----
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Description',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(p.description,
                      style: const TextStyle(color: Colors.grey, fontSize: 14, height: 1.6)),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ---- Size Selector ----
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Select Size',  // "Select Size"
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    children: _sizes.map((size) {
                      final selected = _selectedSize == size;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedSize = size),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: 46, height: 40,
                          decoration: BoxDecoration(
                            color: selected ? const Color(0xFF00695C) : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: selected ? const Color(0xFF00695C) : Colors.grey[300]!,
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Text(size,
                                style: TextStyle(
                                  color: selected ? Colors.white : Colors.black87,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                )),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ---- Quantity ----
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('QTY',  // "Quantity"
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      _QtyButton(
                        icon: Icons.remove,
                        onTap: () { if (_qty > 1) setState(() => _qty--); },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text('$_qty',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      _QtyButton(
                        icon: Icons.add,
                        filled: true,
                        onTap: () => setState(() => _qty++),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ---- Add to Cart Button ----
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AppButton(
                label: 'Add to Cart — LKR ${(p.price * _qty).toStringAsFixed(0)}',
                // "Add to Cart"
                onTap: _onAddToCart,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String path) {
    if (path.startsWith('http')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return _loading();
        },
      );
    } else {
      return Image.asset(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xFFE8F5E9),
      child: const Center(
        child: Icon(Icons.image_outlined, size: 70, color: Colors.grey),
      ),
    );
  }

  Widget _loading() {
    return Container(
      color: const Color(0xFFE8F5E9),
      child: const Center(
        child: CircularProgressIndicator(color: Color(0xFF00695C)),
      ),
    );
  }
}

// Small +/- button widget
class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;
  const _QtyButton({required this.icon, required this.onTap, this.filled = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: filled ? const Color(0xFF00695C) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: filled ? const Color(0xFF00695C) : Colors.grey[300]!,
          ),
        ),
        child: Icon(icon, size: 18, color: filled ? Colors.white : Colors.black87),
      ),
    );
  }
}
