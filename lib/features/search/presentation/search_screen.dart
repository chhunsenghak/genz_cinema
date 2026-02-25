import 'package:flutter/material.dart';
import '../../../widgets/glass_card.dart';


class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: const TextField(
            decoration: InputDecoration(
              hintText: 'Search movies, actors...',
              hintStyle: TextStyle(color: Colors.white24, fontSize: 14),
              prefixIcon: Icon(Icons.search, color: Colors.white24),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Categories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 2.5,
              children: [
                _categoryCard('Action', Icons.local_fire_department, Colors.orange),
                _categoryCard('Comedy', Icons.emoji_emotions, Colors.yellow),
                _categoryCard('Horror', Icons.scuba_diving, Colors.purple),
                _categoryCard('Sci-Fi', Icons.rocket_launch, Colors.blue),
                _categoryCard('Drama', Icons.theater_comedy, Colors.red),
                _categoryCard('Anime', Icons.animation, Colors.pink),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'Recent Searches',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _recentSearchItem('Inception'),
            _recentSearchItem('Dune: Part Two'),
            _recentSearchItem('Spiderman'),
          ],
        ),
      ),
    );
  }

  Widget _categoryCard(String title, IconData icon, Color color) {
    return GlassCard(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _recentSearchItem(String text) {
    return ListTile(
      leading: const Icon(Icons.history, color: Colors.white24, size: 20),
      title: Text(text, style: const TextStyle(color: Colors.white70)),
      trailing: const Icon(Icons.north_west, color: Colors.white24, size: 16),
      onTap: () {},
    );
  }
}
