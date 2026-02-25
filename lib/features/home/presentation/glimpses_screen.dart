import 'package:flutter/material.dart';
import '../../../core/app_theme.dart';
import '../../../core/data/movie_repository.dart';
import '../../../core/models/movie.dart';
import '../../movie_detail/presentation/movie_detail_screen.dart';

class GlimpsesScreen extends StatelessWidget {
  const GlimpsesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>>(
      future: MovieRepository.getMovies(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
          );
        }

        final movies = snapshot.data ?? [];

        if (movies.isEmpty) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(child: Text('No glimpses available')),
          );
        }

        return Scaffold(
          backgroundColor: Colors.black,
          body: PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  // Background "Video" (using banner image for demo)
                  Image.network(
                    movie.bannerPath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(color: Colors.black),
                  ),
                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.3),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                  // Interaction UI
                  Positioned(
                    right: 15,
                    bottom: 120,
                    child: Column(
                      children: [
                        _glimpseAction(Icons.favorite, '4.2k'),
                        _glimpseAction(Icons.comment, '120'),
                        _glimpseAction(Icons.share, 'Share'),
                        const SizedBox(height: 20),
                        const CircleAvatar(
                          radius: 25,
                          backgroundColor: AppColors.primary,
                          child: Icon(Icons.play_arrow, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  // Movie Info UI
                  Positioned(
                    left: 20,
                    bottom: 40,
                    right: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('Trending Now', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          movie.title,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          movie.synopsis,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MovieDetailScreen(movie: movie)),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('Book Now', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  // Back Button
                  Positioned(
                    top: 50,
                    left: 10,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _glimpseAction(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}
