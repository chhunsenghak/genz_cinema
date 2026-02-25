class Cinema {
  final int? id;
  final String name;
  final String location;
  final double distance;
  final List<String> amenities;
  final List<Showtime> showtimes;

  Cinema({
    this.id,
    required this.name,
    required this.location,
    required this.distance,
    required this.amenities,
    required this.showtimes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'distance': distance,
      'amenities': amenities.join(','),
    };
  }

  factory Cinema.fromMap(Map<String, dynamic> map, List<Showtime> showtimes) {
    return Cinema(
      id: map['id'],
      name: map['name'],
      location: map['location'] ?? '',
      distance: map['distance'],
      amenities: (map['amenities'] as String).split(','),
      showtimes: showtimes,
    );
  }
}

class Showtime {
  final int? id;
  final String movieTitle;
  final String cinemaName;
  final String time;
  final String type; // e.g., IMAX, 4DX, Standard
  final double price;

  Showtime({
    this.id,
    this.movieTitle = '',
    this.cinemaName = '',
    required this.time,
    required this.type,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'movieTitle': movieTitle,
      'cinemaName': cinemaName,
      'time': time,
      'type': type,
      'price': price,
    };
  }

  factory Showtime.fromMap(Map<String, dynamic> map) {
    return Showtime(
      id: map['id'],
      movieTitle: map['movieTitle'],
      cinemaName: map['cinemaName'],
      time: map['time'],
      type: map['type'],
      price: map['price'],
    );
  }
}
