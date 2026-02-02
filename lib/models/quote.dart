class Quote {
  final String quote;
  final String role;
  final String show;

  Quote({
    required this.quote,
    required this.role,
    required this.show,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      quote: json['quote'] ?? '',
      role: json['role'] ?? json['author'] ?? '',
      show: json['show'] ?? '',
    );
  }
}
