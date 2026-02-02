class Movie {
  final String imdbId;
  final String title;
  final String year;
  final String poster;
  final String type;

  Movie({
    required this.imdbId,
    required this.title,
    required this.year,
    required this.poster,
    required this.type,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      imdbId: json['imdbID'] ?? json['#IMDB_ID'] ?? '',
      title: json['Title'] ?? json['#TITLE'] ?? 'Unknown',
      year: (json['Year'] ?? json['#YEAR'] ?? '').toString(),
      poster: json['Poster'] ?? json['#IMG_POSTER'] ?? '',
      type: (json['Type'] ?? 'movie').toString().toLowerCase(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imdbID': imdbId,
      'Title': title,
      'Year': year,
      'Poster': poster,
      'Type': type,
    };
  }
}
