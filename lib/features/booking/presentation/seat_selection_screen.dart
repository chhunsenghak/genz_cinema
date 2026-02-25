import 'package:flutter/material.dart';
import '../../../core/app_theme.dart';
import '../../../core/models/cinema.dart';
import '../../../core/models/movie.dart';
import 'snack_combo_screen.dart';

class SeatSelectionScreen extends StatefulWidget {
  final Movie movie;
  final Cinema cinema;
  final Showtime showtime;

  const SeatSelectionScreen({
    super.key,
    required this.movie,
    required this.cinema,
    required this.showtime,
  });

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  final List<int> selectedSeats = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Select Seats', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              '${widget.cinema.name} • ${widget.showtime.time}',
              style: const TextStyle(color: Colors.white54, fontSize: 13),
            ),
            const SizedBox(height: 20),
            // Screen Indicator
            _buildScreenIndicator(),
            const SizedBox(height: 40),
            // Seat Grid
            Expanded(
              child: _buildSeatGrid(),
            ),
            // Legend
            _buildLegend(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomSummary(),
    );
  }

  Widget _buildScreenIndicator() {
    return Center(
      child: Column(
        children: [
          Container(
            height: 4,
            width: 280,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.8),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'S C R E E N',
            style: TextStyle(
              color: Colors.white24,
              letterSpacing: 8,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeatGrid() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.0,
      ),
      itemCount: 80, // Expanded grid
      itemBuilder: (context, index) {
        // Simple reserved seats logic
        final isReserved = [4, 5, 12, 13, 22, 23, 34, 35, 46, 47, 58, 59, 70, 71].contains(index);
        final isSelected = selectedSeats.contains(index);

        return GestureDetector(
          onTap: () {
            if (!isReserved) {
              setState(() {
                if (isSelected) {
                  selectedSeats.remove(index);
                } else {
                  selectedSeats.add(index);
                }
              });
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: isReserved
                  ? Colors.white.withValues(alpha: 0.05)
                  : isSelected
                      ? AppColors.primary
                      : Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isReserved
                    ? Colors.transparent
                    : isSelected
                        ? AppColors.primary
                        : Colors.white12,
                width: 1.5,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.5),
                        blurRadius: 8,
                        spreadRadius: 1,
                      )
                    ]
                  : [],
            ),
            child: Icon(
              Icons.chair,
              size: 14,
              color: isReserved
                  ? Colors.white12
                  : isSelected
                      ? Colors.white
                      : Colors.white38,
            ),
          ),
        );
      },
    );
  }

  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLegendItem(Colors.white.withValues(alpha: 0.05), 'Available', border: Colors.white12),
          const SizedBox(width: 25),
          _buildLegendItem(AppColors.primary, 'Selected'),
          const SizedBox(width: 25),
          _buildLegendItem(Colors.white.withValues(alpha: 0.05), 'Reserved', isReserved: true),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label, {Color? border, bool isReserved = false}) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
            border: border != null ? Border.all(color: border) : null,
          ),
          child: isReserved
              ? const Center(child: Icon(Icons.chair, size: 6, color: Colors.white12))
              : null,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white54),
        ),
      ],
    );
  }

  Widget _buildBottomSummary() {
    final double totalPrice = selectedSeats.length * widget.showtime.price;

    return Container(
      padding: const EdgeInsets.fromLTRB(30, 20, 30, 40),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total Price',
                style: TextStyle(color: Colors.white54, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                '\$${totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: selectedSeats.isEmpty ? null : () {
              // Convert seat indices to labels (e.g., A1, B2)
              final seatLabels = selectedSeats.map((idx) {
                final row = String.fromCharCode(65 + (idx ~/ 8));
                final col = (idx % 8) + 1;
                return '$row$col';
              }).toList();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SnackComboScreen(
                    movie: widget.movie,
                    cinema: widget.cinema,
                    showtime: widget.showtime,
                    seats: seatLabels,
                    basePrice: totalPrice,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(160, 55),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 4,
            ),
            child: const Text(
              'Confirm Booking',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
