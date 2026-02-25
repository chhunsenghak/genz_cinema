import 'package:flutter/material.dart';
import '../../../core/app_theme.dart';
import '../../../widgets/glass_card.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: GlassCard(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: index == 0 ? AppColors.primary : Colors.white10,
                  child: Icon(
                    index == 0 ? Icons.local_offer : Icons.notifications_none,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                title: Text(
                  index == 0 ? 'Special Discount!' : 'Showtime Reminder',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  'Get 20% off on your next booking with code GENZ20.',
                  style: TextStyle(fontSize: 12, color: Colors.white60),
                ),
                trailing: const Text('2h ago', style: TextStyle(fontSize: 10, color: Colors.white24)),
              ),
            ),
          );
        },
      ),
    );
  }
}
