// ============================================================
// views/checkout_view.dart — VIEW (V in MVVM)
// Sri Lankan address fields (Province, District).
// LKR total from CartViewModel.
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/cart_viewmodel.dart';
import '../widgets/app_button.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});
  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {

  // Local UI state
  int _selectedPayment = 0;
  String _selectedProvince = 'Western Province';

  final _nameCtrl    = TextEditingController();
  final _phoneCtrl   = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cityCtrl    = TextEditingController();

  final List<String> _provinces = [
    'Western Province',
    'Central Province',
    'Southern Province',
    'North Western Province',
    'North Central Province',
    'Uva Province',
    'Sabaragamuwa Province',
    'Eastern Province',
    'Northern Province',
  ];

  final List<Map<String, dynamic>> _payments = [
    {'name': 'Cash on Delivery',    'icon': Icons.money_outlined},
    {'name': 'Credit / Debit Card', 'icon': Icons.credit_card},
    {'name': 'Online Banking',      'icon': Icons.account_balance_outlined},
  ];

  @override
  void dispose() {
    _nameCtrl.dispose(); _phoneCtrl.dispose();
    _addressCtrl.dispose(); _cityCtrl.dispose();
    super.dispose();
  }

  void _onPlaceOrder() {
    if (_nameCtrl.text.trim().isEmpty || _addressCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your address')),
        // "Please enter your address"
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80, height: 80,
              decoration: const BoxDecoration(color: Color(0xFFE8F5E9), shape: BoxShape.circle),
              child: const Icon(Icons.check, color: Color(0xFF00695C), size: 45),
            ),
            const SizedBox(height: 16),
            const Text('Order Placed! ✅',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Your order was received!\nWill deliver soon.',
            // "Your order was received! Will deliver soon."
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, height: 1.6)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<CartViewModel>().clearCart();
                Navigator.of(context).pop();
                Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00695C),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Go to Home'),  // "Go to Home"
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartVM = context.watch<CartViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(title: const Text('Checkout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Delivery Details
            _SectionTitle('Delivery Details'),
            const SizedBox(height: 12),

            _label('Full Name'),
            const SizedBox(height: 6),
            TextField(
              controller: _nameCtrl,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                hintText: 'e.g. Kamal Perera',
                prefixIcon: Icon(Icons.person_outlined, color: Color(0xFF00695C)),
              ),
            ),
            const SizedBox(height: 14),

            _label('Phone Number'),
            const SizedBox(height: 6),
            TextField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: '07X XXX XXXX',
                prefixIcon: Icon(Icons.phone_outlined, color: Color(0xFF00695C)),
              ),
            ),
            const SizedBox(height: 14),

            _label('Address'),
            const SizedBox(height: 6),
            TextField(
              controller: _addressCtrl,
              decoration: const InputDecoration(
                hintText: 'No. 12, Galle Road...',
                prefixIcon: Icon(Icons.home_outlined, color: Color(0xFF00695C)),
              ),
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('City'),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _cityCtrl,
                        decoration: const InputDecoration(hintText: 'e.g. Colombo'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Province dropdown — Sri Lankan provinces
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Province'),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _selectedProvince,
                            style: const TextStyle(fontSize: 13, color: Colors.black87),
                            items: _provinces.map((p) => DropdownMenuItem(
                              value: p,
                              child: Text(p, overflow: TextOverflow.ellipsis),
                            )).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedProvince = val);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Payment Method
            _SectionTitle('Payment Method'),
            const SizedBox(height: 12),

            ...List.generate(_payments.length, (i) {
              final selected = _selectedPayment == i;
              return GestureDetector(
                onTap: () => setState(() => _selectedPayment = i),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: selected ? const Color(0xFFE8F5E9) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selected ? const Color(0xFF00695C) : Colors.grey[300]!,
                      width: selected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(_payments[i]['icon'],
                          color: selected ? const Color(0xFF00695C) : Colors.grey),
                      const SizedBox(width: 12),
                      Text(_payments[i]['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: selected ? const Color(0xFF00695C) : Colors.black87,
                          )),
                      const Spacer(),
                      Icon(
                        selected ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: selected ? const Color(0xFF00695C) : Colors.grey,
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 24),

            // Order Summary
            _SectionTitle('Order Summary'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Items (${cartVM.itemCount})',
                          style: const TextStyle(color: Colors.black87)),
                      Text('LKR ${cartVM.totalPrice.toStringAsFixed(0)}'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Delivery', style: TextStyle(color: Colors.grey)),
                      Text('Free', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('LKR ${cartVM.totalPrice.toStringAsFixed(0)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF00695C))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            AppButton(label: 'Order Place', onTap: _onPlaceOrder),
            // "Place Order"
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) =>
      Text(text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14));
}

// Section heading widget
class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 4, height: 20, color: const Color(0xFF00695C),
            margin: const EdgeInsets.only(right: 10)),
        Text(text, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
