
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/product_viewmodel.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../models/product.dart';
import 'product_detail_view.dart';

class ProductListView extends StatelessWidget {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    final productVM = context.watch<ProductViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(productVM.selectedCategory == 'All'
            ? 'All Items'
            : productVM.selectedCategory),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [

          // ---- Category Filter Chips (different style: chips not tabs) ----
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: productVM.categories.map((cat) {
                  final selected = productVM.selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(cat),
                      selected: selected,
                      onSelected: (_) => context.read<ProductViewModel>().setCategory(cat),
                      selectedColor: const Color(0xFF00695C),
                      checkmarkColor: Colors.white,
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                      backgroundColor: Colors.grey[100],
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Item count
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
            child: Row(
              children: [
                Text('${productVM.filteredProducts.length} items found',
                    style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),

          // ---- Product LIST (not grid — different from previous app) ----
          Expanded(
            child: productVM.filteredProducts.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 60, color: Colors.grey),
                        SizedBox(height: 12),
                        Text('No items found', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: productVM.filteredProducts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final p = productVM.filteredProducts[index];
                      return _ProductListTile(product: p);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ---- List tile style product card ----
class _ProductListTile extends StatelessWidget {
  final Product product;
  const _ProductListTile({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => ProductDetailView(product: product))),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            // Image on the left
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                bottomLeft: Radius.circular(14),
              ),
              child: _buildImage(product.image),
            ),

            // Info on the right
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Category badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(product.category,
                              style: const TextStyle(
                                  color: Color(0xFF00695C), fontSize: 10, fontWeight: FontWeight.w600)),
                        ),
                        if (product.isNew) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00695C),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text('New',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(product.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 4),
                    Text(
                      product.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey, fontSize: 12, height: 1.4),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'LKR ${product.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                              color: Color(0xFF00695C),
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        // Quick Add button
                        GestureDetector(
                          onTap: () {
                            context.read<CartViewModel>().addToCart(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${product.name} added!'),
                                backgroundColor: const Color(0xFF00695C),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00695C),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('Add',
                                style: TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String path) {
    if (path.startsWith('http')) {
      return Image.network(
        path,
        width: 110, height: 100,
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
        width: 110, height: 100,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }
  }

  Widget _placeholder() {
    return Container(
      width: 110, height: 100,
      color: const Color(0xFFE8F5E9),
      child: const Icon(Icons.image_outlined, color: Colors.grey),
    );
  }

  Widget _loading() {
    return Container(
      width: 110, height: 100,
      color: const Color(0xFFE8F5E9),
      child: const Center(
        child: CircularProgressIndicator(color: Color(0xFF00695C), strokeWidth: 2),
      ),
    );
  }
}
