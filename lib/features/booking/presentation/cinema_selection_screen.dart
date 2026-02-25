import 'package:flutter/material.dart';
import '../../../core/app_theme.dart';
import '../../../core/data/cinema_repository.dart';
import '../../../core/models/cinema.dart';
import '../../../core/models/movie.dart';
import 'seat_selection_screen.dart';

class CinemaSelectionScreen extends StatefulWidget {
  final Movie movie;
  const CinemaSelectionScreen({super.key, required this.movie});

  @override
  State<CinemaSelectionScreen> createState() => _CinemaSelectionScreenState();
}

class _CinemaSelectionScreenState extends State<CinemaSelectionScreen> {
  late Future<List<Cinema>> _cinemasFuture;
  int selectedCinemaIndex = 0;
  int selectedShowtimeIndex = -1;

  @override
  void initState() {
    super.initState();
    _cinemasFuture = CinemaRepository.getCinemas();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Cinema>>(
      future: _cinemasFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
          );
        }

        final cinemas = snapshot.data ?? [];

        if (cinemas.isEmpty) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(backgroundColor: Colors.transparent),
            body: const Center(child: Text('No cinemas available')),
          );
        }

        final selectedCinema = cinemas[selectedCinemaIndex];

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(widget.movie.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cinema horizontal list
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 15),
                child: Text(
                  'Select Cinema',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: cinemas.length,
                  itemBuilder: (context, index) {
                    final cinema = cinemas[index];
                    final isSelected = selectedCinemaIndex == index;
                    return GestureDetector(
                      onTap: () => setState(() {
                        selectedCinemaIndex = index;
                        selectedShowtimeIndex = -1;
                      }),
                      child: Container(
                        width: 200,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : Colors.white12,
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cinema.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${cinema.distance} km away',
                              style: TextStyle(
                                fontSize: 12,
                                color: isSelected ? Colors.white70 : Colors.white54,
                              ),
                            ),
                            const Spacer(),
                            Row(
                              children: cinema.amenities.take(2).map((a) => Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Icon(
                                  a == 'IMAX' ? Icons.four_k : Icons.waves,
                                  size: 14,
                                  color: isSelected ? Colors.white : AppColors.primary,
                                ),
                              )).toList(),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
              // Showtimes grid
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Available Showtimes',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    childAspectRatio: 2.0,
                  ),
                  itemCount: selectedCinema.showtimes.length,
                  itemBuilder: (context, index) {
                    final showtime = selectedCinema.showtimes[index];
                    final isSelected = selectedShowtimeIndex == index;
                    return GestureDetector(
                      onTap: () => setState(() => selectedShowtimeIndex = index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : Colors.white12,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              showtime.time,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              showtime.type,
                              style: TextStyle(
                                fontSize: 10,
                                color: isSelected ? Colors.white70 : Colors.white38,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Bottom Summary
              Container(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 40),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                  border: Border.all(color: Colors.white10),
                ),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Booking For',
                            style: TextStyle(color: Colors.white54, fontSize: 13),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            selectedShowtimeIndex == -1
                              ? 'Select time'
                              : '${selectedCinema.showtimes[selectedShowtimeIndex].time} • ${selectedCinema.showtimes[selectedShowtimeIndex].type}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: selectedShowtimeIndex == -1 ? null : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SeatSelectionScreen(
                                movie: widget.movie,
                                cinema: selectedCinema,
                                showtime: selectedCinema.showtimes[selectedShowtimeIndex],
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.2),
                          minimumSize: const Size(160, 55),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        child: const Text(
                          'Select Seats',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
