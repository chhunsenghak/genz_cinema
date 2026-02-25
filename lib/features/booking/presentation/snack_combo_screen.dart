import 'package:flutter/material.dart';
import '../../../core/app_theme.dart';
import '../../../core/data/snack_repository.dart';
import '../../../core/data/booking_repository.dart';
import '../../../core/models/snack.dart';
import '../../../core/models/movie.dart';
import '../../../core/models/cinema.dart';
import '../../../core/models/booking.dart';
import '../../wallet/presentation/wallet_screen.dart';

class SnackComboScreen extends StatefulWidget {
  final Movie movie;
  final Cinema cinema;
  final Showtime showtime;
  final List<String> seats;
  final double basePrice;

  const SnackComboScreen({
    super.key,
    required this.movie,
    required this.cinema,
    required this.showtime,
    required this.seats,
    required this.basePrice,
  });

  @override
  State<SnackComboScreen> createState() => _SnackComboScreenState();
}

class _SnackComboScreenState extends State<SnackComboScreen> {
  late Future<List<Snack>> _snacksFuture;
  final Map<int, int> cart = {}; // index: quantity

  @override
  void initState() {
    super.initState();
    _snacksFuture = SnackRepository.getSnacks();
  }

  double totalSnackPrice(List<Snack> snacks) {
    double total = 0;
    cart.forEach((index, qty) {
      if (index < snacks.length) {
        total += snacks[index].price * qty;
      }
    });
    return total;
  }

  Future<void> _handlePayment(List<Snack> snacks) async {
    // Generate snacks string
    String snackSummary = '';
    cart.forEach((index, qty) {
      if (qty > 0 && index < snacks.length) {
        if (snackSummary.isNotEmpty) snackSummary += ', ';
        snackSummary += '$qty x ${snacks[index].name}';
      }
    });
    if (snackSummary.isEmpty) snackSummary = 'None';

    final snackPrice = totalSnackPrice(snacks);

    final booking = Booking(
      movieTitle: widget.movie.title,
      cinemaName: widget.cinema.name,
      showtime: '${widget.showtime.time} • ${widget.showtime.type}',
      seats: widget.seats,
      snacks: snackSummary,
      totalPrice: widget.basePrice + snackPrice,
      bookingDate: DateTime.now(),
      bannerPath: widget.movie.bannerPath,
    );

    await BookingRepository.saveBooking(booking);

    if (mounted) {
      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: AppColors.primary, size: 80),
              const SizedBox(height: 20),
              const Text(
                'Booking Successful!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Your tickets for ${widget.movie.title} are ready in your wallet.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // pop dialog
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const WalletScreen()),
                    (route) => route.isFirst,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('View Tickets', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Snack>>(
      future: _snacksFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
          );
        }

        final snacks = snapshot.data ?? [];
        final snackPrice = totalSnackPrice(snacks);

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('Snacks & Combos', style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Column(
            children: [
              Expanded(
                child: snacks.isEmpty
                  ? const Center(child: Text('No snacks available'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: snacks.length,
                      itemBuilder: (context, index) {
                        final snack = snacks[index];
                        final quantity = cart[index] ?? 0;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  snack.imagePath,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    width: 80,
                                    height: 80,
                                    color: Colors.white10,
                                    child: const Icon(Icons.fastfood_outlined, color: AppColors.primary),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snack.name,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      snack.description,
                                      style: const TextStyle(color: Colors.white54, fontSize: 12),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '\$${snack.price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () => setState(() {
                                      cart[index] = (cart[index] ?? 0) + 1;
                                    }),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withValues(alpha: 0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.add, color: AppColors.primary, size: 20),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '$quantity',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  const SizedBox(height: 10),
                                  GestureDetector(
                                    onTap: () => setState(() {
                                      if ((cart[index] ?? 0) > 0) {
                                        cart[index] = cart[index]! - 1;
                                      }
                                    }),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.05),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.remove,
                                        color: quantity > 0 ? Colors.white : Colors.white24,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Tickets Total', style: TextStyle(color: Colors.white54)),
                          Text('\$${widget.basePrice.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Snacks Total', style: TextStyle(color: Colors.white54)),
                          Text('\$${snackPrice.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const Divider(height: 30, color: Colors.white10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Grand Total', style: TextStyle(color: Colors.white54, fontSize: 13)),
                              const SizedBox(height: 4),
                              Text(
                                '\$${(widget.basePrice + snackPrice).toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () => _handlePayment(snacks),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(160, 60),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              elevation: 8,
                              shadowColor: AppColors.primary.withValues(alpha: 0.3),
                            ),
                            child: const Text('Confirm', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                        ],
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
