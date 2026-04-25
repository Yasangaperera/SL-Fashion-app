// ============================================================
// views/home_view.dart — VIEW (V in MVVM)
// Reads ProductViewModel and CartViewModel.
// Different layout: horizontal featured cards + tile categories.
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/product_viewmodel.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../models/product.dart';
import 'product_list_view.dart';
import 'product_detail_view.dart';
import 'cart_view.dart';
import 'profile_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _tab = 0;

  final List<Widget> _pages = const [
    _HomeContent(),
    ProductListView(),
    CartView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    final cartVM = context.watch<CartViewModel>();
    return Scaffold(
      body: _pages[_tab],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
        selectedItemColor: const Color(0xFF00695C),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 8,
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_outlined), activeIcon: Icon(Icons.grid_view), label: 'Shop'),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: cartVM.totalCount > 0,
              label: Text('${cartVM.totalCount}'),
              backgroundColor: const Color(0xFF00695C),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
            activeIcon: Badge(
              isLabelVisible: cartVM.totalCount > 0,
              label: Text('${cartVM.totalCount}'),
              backgroundColor: const Color(0xFF00695C),
              child: const Icon(Icons.shopping_bag),
            ),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// Home tab content
// ============================================================
class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    final productVM = context.watch<ProductViewModel>();

    // Category tiles with icons
    final cats = [
      {'name': 'Saree',  'icon': Icons.filter_vintage_outlined, 'color': const Color(0xFFFFF3E0)},
      {'name': 'Batik',  'icon': Icons.palette_outlined,        'color': const Color(0xFFE8F5E9)},
      {'name': 'Casual', 'icon': Icons.checkroom_outlined,      'color': const Color(0xFFE3F2FD)},
      {'name': 'Kids',   'icon': Icons.child_care_outlined,     'color': const Color(0xFFFCE4EC)},
      {'name': 'Sale',   'icon': Icons.sell_outlined,           'color': const Color(0xFFEDE7F6)},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('SL Fashion'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ---- Greeting Banner ----
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF00695C),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ආයුබෝවන් WELCOME👋',  // "Welcome"
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Discover Sri Lankan Fashion',
                          style: TextStyle(
                            color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) => const ProductListView())),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('Browse All',
                                style: TextStyle(
                                  color: Color(0xFF00695C),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.storefront, size: 80, color: Colors.white12),
                ],
              ),
            ),

            // ---- Category Tiles ----
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Text('Categories',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: cats.map((cat) {
                  return GestureDetector(
                    onTap: () {
                      context.read<ProductViewModel>().setCategory(cat['name'] as String);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const ProductListView()));
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            color: cat['color'] as Color,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(cat['icon'] as IconData,
                              color: const Color(0xFF00695C), size: 26),
                        ),
                        const SizedBox(height: 6),
                        Text(cat['name'] as String,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // ---- New Arrivals — Horizontal scroll cards ----
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('New Arrivals',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const ProductListView())),
                    child: const Text('See All',
                        style: TextStyle(
                            color: Color(0xFF00695C), fontWeight: FontWeight.w600, fontSize: 13)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Horizontal scrolling product cards
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: productVM.featuredProducts.length,
                itemBuilder: (context, index) {
                  final p = productVM.featuredProducts[index];
                  return _HorizProductCard(product: p);
                },
              ),
            ),
            const SizedBox(height: 20),

            // ---- Offer Banner ----
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFFFE082)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.sell_outlined, color: Color(0xFFF57F17), size: 32),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Special Sale!',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        SizedBox(height: 2),
                        Text('Sarees from LKR 850 — Limited Stock!',
                            style: TextStyle(color: Colors.grey, fontSize: 13)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.read<ProductViewModel>().setCategory('Sale');
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const ProductListView()));
                    },
                    child: const Text('Shop',
                        style: TextStyle(
                            color: Color(0xFF00695C), fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }
}

// ---- Horizontal product card
class _HorizProductCard extends StatelessWidget {
  final Product product;
  const _HorizProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => ProductDetailView(product: product))),
      child: Container(
        width: 155,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 6, offset: const Offset(0, 3)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14), topRight: Radius.circular(14)),
              child: Image.network(
                product.image,
                height: 130, width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 130,
                  color: const Color(0xFFE8F5E9),
                  child: const Center(
                    child: Icon(Icons.image_outlined, color: Colors.grey, size: 40),
                  ),
                ),
                loadingBuilder: (_, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    height: 130,
                    color: const Color(0xFFE8F5E9),
                    child: const Center(
                      child: CircularProgressIndicator(color: Color(0xFF00695C), strokeWidth: 2),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // "New" badge
                  if (product.isNew)
                    Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00695C),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('New',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  Text(product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text('LKR ${product.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                          color: Color(0xFF00695C), fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
