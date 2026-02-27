class Movie {
  final int? id;
  final String title;
  final String genre;
  final double rating;
  final String synopsis;
  final String imagePath; // renamed from posterPath
  final String bannerPath;
  final String ratingLimit;

  Movie({
    this.id,
    required this.title,
    required this.genre,
    required this.rating,
    required this.synopsis,
    required this.imagePath,
    required this.bannerPath,
    this.ratingLimit = '13+',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'rating': rating,
      'genre': genre,
      'ratingLimit': ratingLimit,
      'synopsis': synopsis,
      'imagePath': imagePath,
      'bannerPath': bannerPath,
    };
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: (map['id'] as num?)?.toInt(),
      title: (map['title'] ?? '') as String,
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      genre: (map['genre'] ?? '') as String,
      ratingLimit: (map['ratingLimit'] ?? '13+') as String,
      synopsis: (map['synopsis'] ?? '') as String,
      imagePath: (map['imagePath'] ?? '') as String,
      bannerPath: (map['bannerPath'] ?? '') as String,
    );
  }
}
