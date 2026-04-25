// ============================================================
// views/cart_view.dart — VIEW (V in MVVM)
// Reads CartViewModel. All totals come from ViewModel.
// Shows LKR prices.
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/cart_viewmodel.dart';
import 'checkout_view.dart';
import '../widgets/app_button.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final cartVM = context.watch<CartViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text('Cart (${cartVM.itemCount})'),
        automaticallyImplyLeading: false,
      ),
      body: cartVM.items.isEmpty
          // Empty Cart
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100, height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(Icons.shopping_bag_outlined, size: 50, color: Color(0xFF00695C)),
                  ),
                  const SizedBox(height: 16),
                  const Text('Cart is empty!',  // "Cart is empty!"
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  const Text('You have not added any item.',
                  // "You have not added any items."
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : Column(
              children: [
                // Cart Items
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: cartVM.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = cartVM.items[index];
                      final p    = item.product;

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            // Image
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(14),
                                bottomLeft: Radius.circular(14),
                              ),
                              child: Image.network(
                                p.image, width: 90, height: 90, fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 90, height: 90, color: const Color(0xFFE8F5E9),
                                  child: const Icon(Icons.image_outlined, color: Colors.grey),
                                ),
                              ),
                            ),

                            // Info
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(p.name,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                        maxLines: 1, overflow: TextOverflow.ellipsis),
                                    const SizedBox(height: 2),
                                    Text('LKR ${p.price.toStringAsFixed(0)}',
                                        style: const TextStyle(color: Color(0xFF00695C), fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 8),

                                    // Qty controls
                                    Row(
                                      children: [
                                        _SmallBtn(
                                          icon: Icons.remove,
                                          onTap: () => context.read<CartViewModel>().decrease(p.id),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                          child: Text('${item.quantity}',
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                        ),
                                        _SmallBtn(
                                          icon: Icons.add,
                                          filled: true,
                                          onTap: () => context.read<CartViewModel>().increase(p.id),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Delete
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.red),
                                onPressed: () =>
                                    context.read<CartViewModel>().removeFromCart(p.id),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                //Order Summary
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -3))],
                  ),
                  child: Column(
                    children: [
                      _SummaryRow(label: 'Subtotal', value: 'LKR ${cartVM.totalPrice.toStringAsFixed(0)}'),
                      const SizedBox(height: 4),
                      const _SummaryRow(label: 'Delivery', value: 'Free', valueColor: Colors.green),
                      const Divider(height: 20),
                      _SummaryRow(
                        label: 'Total (LKR)',
                        value: 'LKR ${cartVM.totalPrice.toStringAsFixed(0)}',
                        bold: true,
                      ),
                      const SizedBox(height: 14),
                      AppButton(
                        label: 'Checkout',
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const CheckoutView())),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _SmallBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;
  const _SmallBtn({required this.icon, required this.onTap, this.filled = false});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 28, height: 28,
          decoration: BoxDecoration(
            color: filled ? const Color(0xFF00695C) : Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: filled ? const Color(0xFF00695C) : Colors.grey[300]!),
          ),
          child: Icon(icon, size: 15, color: filled ? Colors.white : Colors.black87),
        ),
      );
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool bold;
  const _SummaryRow({required this.label, required this.value, this.valueColor, this.bold = false});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: bold ? 16 : 14,
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                  color: bold ? Colors.black : Colors.grey)),
          Text(value,
              style: TextStyle(
                  fontSize: bold ? 16 : 14,
                  fontWeight: bold ? FontWeight.bold : FontWeight.w600,
                  color: valueColor ?? (bold ? const Color(0xFF00695C) : Colors.black87))),
        ],
      );
}
