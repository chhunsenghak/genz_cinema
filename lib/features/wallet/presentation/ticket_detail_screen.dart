import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/app_theme.dart';
import '../../../core/models/booking.dart';
import '../../../widgets/glass_card.dart';

class TicketDetailScreen extends StatelessWidget {
  final Booking booking;

  const TicketDetailScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final bool isUsed = booking.status == 'used';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Ticket Details', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GlassCard(
              child: Column(
                children: [
                  // Movie Poster Section
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(booking.bannerPath),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.8),
                          ],
                        ),
                      ),
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isUsed ? Colors.white24 : AppColors.primary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              booking.status.toUpperCase(),
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            booking.movieTitle,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      children: [
                        _ticketInfoRow('Cinema', booking.cinemaName, Icons.location_on),
                        const Divider(height: 30, color: Colors.white10),
                        Row(
                          children: [
                            Expanded(child: _ticketInfoRow('Date', DateFormat('MMM dd, yyyy').format(booking.bookingDate), Icons.calendar_today)),
                            Expanded(child: _ticketInfoRow('Time', booking.showtime.split('•').first.trim(), Icons.access_time)),
                          ],
                        ),
                        const Divider(height: 30, color: Colors.white10),
                        Row(
                          children: [
                            Expanded(child: _ticketInfoRow('Seats', booking.seats.join(', '), Icons.chair)),
                            Expanded(child: _ticketInfoRow('Format', booking.showtime.contains('•') ? booking.showtime.split('•').last.trim() : 'Standard', Icons.movie_filter)),
                          ],
                        ),
                        const Divider(height: 30, color: Colors.white10),
                        _ticketInfoRow('Snacks', booking.snacks, Icons.fastfood),
                        const Divider(height: 30, color: Colors.white10),

                        // QR Code Section
                        const SizedBox(height: 10),
                        Text(
                          isUsed ? 'Ticket already used' : 'Scan this at the cinema gate',
                          style: TextStyle(color: isUsed ? Colors.redAccent : Colors.white38, fontSize: 12),
                        ),
                        const SizedBox(height: 15),
                        Opacity(
                          opacity: isUsed ? 0.3 : 1.0,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: isUsed ? [] : [
                                BoxShadow(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                )
                              ],
                            ),
                            child: const Icon(Icons.qr_code_2, color: Colors.black, size: 180),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Order ID: #GNZ-${booking.id.toString().padLeft(6, '0')}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            color: isUsed ? Colors.white38 : AppColors.primary
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Ticket Bottom Lip (Cut-out effect)
                  Container(
                    height: 20,
                    width: double.infinity,
                    color: Colors.black26,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            if (!isUsed)
              ElevatedButton.icon(
                onPressed: () {
                  // Future: Share ticket
                },
                icon: const Icon(Icons.ios_share, size: 18),
                label: const Text('Share Ticket'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white10,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _ticketInfoRow(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(color: Colors.white38, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ],
    );
  }
}
