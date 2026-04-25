
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {

    final menuItems = [
      {'icon': Icons.receipt_long_outlined,      'title': 'Orders',       'sub': 'Your order list'},
      {'icon': Icons.favorite_border,            'title': 'Wishlist',          'sub': 'Saved items'},
      {'icon': Icons.location_on_outlined,       'title': 'Address',           'sub': 'Delivery addresses'},
      {'icon': Icons.credit_card_outlined,       'title': 'Payment methods',     'sub': 'Cards & banking'},
      {'icon': Icons.notifications_outlined,     'title': 'Notifications',     'sub': 'Manage alerts'},
      {'icon': Icons.local_offer_outlined,       'title': 'Vouchers',          'sub': 'Promo codes'},
      {'icon': Icons.help_outline,               'title': 'Help',              'sub': 'Support & FAQs'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(title: const Text('Profile'), automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        child: Column(
          children: [

            // ---- Profile Card ----
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color(0xFF00695C),
                    child: const Text('YP',
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Yasanga Perera',  // Sri Lankan name
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        const Text('yasanga1998@gmail.com',
                            style: TextStyle(color: Colors.grey, fontSize: 13)),
                        const SizedBox(height: 2),
                        const Text('Panadura, Sri Lanka 🇱🇰',
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Color(0xFF00695C)),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // ---- Stats Row ----
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _Stat(count: '8',  label: 'Orders'),
                  Container(width: 1, height: 36, color: Colors.grey[200]),
                  _Stat(count: '4',  label: 'Wishlist'),
                  Container(width: 1, height: 36, color: Colors.grey[200]),
                  _Stat(count: '2',  label: 'Reviews'),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // ---- Menu ----
            Container(
              color: Colors.white,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                itemCount: menuItems.length,
                separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey[100]),
                itemBuilder: (_, i) {
                  final item = menuItems[i];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 4),
                    leading: Container(
                      width: 42, height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(item['icon'] as IconData, color: const Color(0xFF00695C), size: 22),
                    ),
                    title: Text(item['title'] as String,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                    subtitle: Text(item['sub'] as String,
                        style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                    onTap: () {},
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // ---- Logout ----
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: OutlinedButton.icon(
                onPressed: () =>
                    Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false),
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text('Logout', style: TextStyle(color: Colors.red, fontSize: 15)),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String count, label;
  const _Stat({required this.count, required this.label});
  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(count,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF00695C))),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      );
}
