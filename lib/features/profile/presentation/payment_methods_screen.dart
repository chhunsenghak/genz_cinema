import 'package:flutter/material.dart';
import '../../../core/app_theme.dart';
import '../../../widgets/glass_card.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Payment Methods', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Saved Cards',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white70),
            ),
            const SizedBox(height: 20),
            _buildCardItem('Visa', '**** **** **** 4242', '12/26', Colors.blueGrey),
            const SizedBox(height: 15),
            _buildCardItem('Mastercard', '**** **** **** 8888', '09/25', Colors.deepPurple),
            const SizedBox(height: 30),
            const Text(
              'Digital Wallets',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white70),
            ),
            const SizedBox(height: 20),
            _buildWalletItem('Apple Pay', Icons.apple),
            const SizedBox(height: 15),
            _buildWalletItem('Google Pay', Icons.payment),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Add New Method'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white10,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardItem(String type, String number, String expiry, Color color) {
    return GlassCard(
      child: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withValues(alpha: 0.3), color.withValues(alpha: 0.1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(type, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const Icon(Icons.credit_card, color: Colors.white54),
              ],
            ),
            const SizedBox(height: 25),
            Text(number, style: const TextStyle(fontSize: 20, letterSpacing: 2)),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('VALID THRU', style: TextStyle(fontSize: 10, color: Colors.white38)),
                Text(expiry, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletItem(String name, IconData icon) {
    return GlassCard(
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(name),
        trailing: const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
        onTap: () {},
      ),
    );
  }
}
