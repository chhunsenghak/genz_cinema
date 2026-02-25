class Booking {
  final int? id;
  final String movieTitle;
  final String cinemaName;
  final String showtime;
  final List<String> seats;
  final String snacks; // Stored as a simple summary string for now
  final double totalPrice;
  final DateTime bookingDate;
  final String bannerPath;
  final String status; // 'pending' or 'used'

  Booking({
    this.id,
    required this.movieTitle,
    required this.cinemaName,
    required this.showtime,
    required this.seats,
    required this.snacks,
    required this.totalPrice,
    required this.bookingDate,
    required this.bannerPath,
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'movieTitle': movieTitle,
      'cinemaName': cinemaName,
      'showtime': showtime,
      'seats': seats.join(','),
      'snacks': snacks,
      'totalPrice': totalPrice,
      'bookingDate': bookingDate.toIso8601String(),
      'bannerPath': bannerPath,
      'status': status,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'],
      movieTitle: map['movieTitle'],
      cinemaName: map['cinemaName'],
      showtime: map['showtime'],
      seats: (map['seats'] as String).split(','),
      snacks: map['snacks'],
      totalPrice: map['totalPrice'],
      bookingDate: DateTime.parse(map['bookingDate']),
      bannerPath: map['bannerPath'],
      status: map['status'] ?? 'pending',
    );
  }
}
