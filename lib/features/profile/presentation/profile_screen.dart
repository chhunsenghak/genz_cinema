import 'package:flutter/material.dart';
import '../../../core/app_theme.dart';
import '../../../core/data/booking_repository.dart';
import '../../../widgets/glass_card.dart';
import '../../wallet/presentation/wallet_screen.dart';
import 'favorites_screen.dart';
import 'payment_methods_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _selectedLanguage = 'English (US)';
  late Future<int> _bookingCountFuture;

  @override
  void initState() {
    super.initState();
    _bookingCountFuture = BookingRepository.getBookingCount();
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Select Language', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _languageOption('English (US)'),
            _languageOption('Khmer (KH)'),
            _languageOption('French (FR)'),
            _languageOption('Spanish (ES)'),
          ],
        ),
      ),
    );
  }

  Widget _languageOption(String lang) {
    return ListTile(
      title: Text(lang, style: TextStyle(color: _selectedLanguage == lang ? AppColors.primary : Colors.white)),
      trailing: _selectedLanguage == lang ? const Icon(Icons.check, color: AppColors.primary) : null,
      onTap: () {
        setState(() => _selectedLanguage = lang);
        Navigator.pop(context);
      },
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Sign Out?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to sign out of GenZ Cinema?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Sign Out', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.settings_outlined), onPressed: () {}),
        ],
      ),
      body: FutureBuilder<int>(
        future: _bookingCountFuture,
        builder: (context, snapshot) {
          final count = snapshot.data ?? 0;
          final int points = count * 500;
          final double progress = (points % 1000) / 1000;
          final int pointsToNext = 1000 - (points % 1000);
          final String tier = points >= 3000 ? 'Platinum Member' : (points >= 1500 ? 'Gold Member' : 'Silver Member');

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Alex Rivera',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'alex.rivera@example.com',
                  style: TextStyle(color: Colors.white60),
                ),
                const SizedBox(height: 30),
                // Loyalty Card
                GlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              tier,
                              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${points.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} Points',
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.white10,
                          valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '$pointsToNext points until next tier',
                          style: const TextStyle(fontSize: 12, color: Colors.white38),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                _buildProfileOption(
                  Icons.history,
                  'Booking History',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const WalletScreen())),
                ),
                _buildProfileOption(
                  Icons.favorite_border,
                  'Favorites',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritesScreen())),
                ),
                _buildProfileOption(
                  Icons.payment,
                  'Payment Methods',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentMethodsScreen())),
                ),
                _buildProfileOption(
                  Icons.language,
                  'Language',
                  trailing: _selectedLanguage,
                  onTap: _showLanguageDialog,
                ),
                _buildProfileOption(Icons.help_outline, 'Help & Support'),
                const SizedBox(height: 30),
                TextButton(
                  onPressed: _showSignOutDialog,
                  child: const Text('Sign Out', style: TextStyle(color: Colors.redAccent)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, {String? trailing, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: GlassCard(
        child: ListTile(
          leading: Icon(icon, color: AppColors.primary),
          title: Text(title),
          trailing: trailing != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(trailing, style: const TextStyle(color: Colors.white24, fontSize: 12)),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white24),
                ],
              )
            : const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white24),
          onTap: onTap,
        ),
      ),
    );
  }
}
