import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import '../models/quote.dart';

class ApiService {
  static const String _omdbBaseUrl = 'https://www.omdbapi.com/';
  static const String _omdbApiKey = 'e337af4c';

  final List<String> _quoteUrls = [
    'https://api.animechan.io/v1/quotes/random',
    'https://luciferquotes.shadowdev.xyz/api/quotes',
    'https://ron-swanson-quotes.herokuapp.com/v2/quotes',
    'https://strangerthingsquotes.shadowdev.xyz/api/quotes',
  ];

  Future<List<Movie>> fetchMovies(String query, {bool isSeries = false}) async {
    try {
      final type = isSeries ? 'series' : 'movie';
      final uri = Uri.parse('$_omdbBaseUrl?s=$query&type=$type&apikey=$_omdbApiKey');
      debugPrint("API Request: $uri");
      final response = await http.get(uri);
      
      debugPrint("API Response Code: ${response.statusCode}");
      // debugPrint("API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded['Search'] != null && decoded['Search'] is List) {
           final List<dynamic> list = decoded['Search'];
           return list
               .map((json) => Movie.fromJson(json))
               .where((m) => m.poster.isNotEmpty && m.poster != "N/A")
               .toList();
        } else {
           debugPrint("No results found or error: ${decoded['Error']}");
           return [];
        }
      } else {
        throw Exception('Failed to load movies: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Error fetching movies: $e");
      return [];
    }
  }

  Future<List<Quote>> fetchQuotes(int count) async {
    List<Quote> quotes = [];
    int attempts = 0;
    while (quotes.length < count && attempts < 10) {
      attempts++;
      final url = _quoteUrls[attempts % _quoteUrls.length];
      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final decoded = json.decode(response.body);
          Quote? parsedQuote;

          if (url.contains('animechan')) {
            // {"status":"success","data":{"content":"...","anime":{"name":"..."},"character":{"name":"..."}}}
            if (decoded['status'] == 'success' && decoded['data'] != null) {
              final data = decoded['data'];
              parsedQuote = Quote(
                quote: data['content'] ?? '',
                role: data['character'] != null ? data['character']['name'] : 'Unknown',
                show: data['anime'] != null ? data['anime']['name'] : 'Anime',
              );
            }
          } else if (url.contains('luciferquotes')) {
             // [{"quote":"...","author":"..."}]
             if (decoded is List && decoded.isNotEmpty) {
               final data = decoded.first;
               parsedQuote = Quote(
                 quote: data['quote'] ?? '',
                 role: data['author'] ?? 'Lucifer Character',
                 show: 'Lucifer',
               );
             }
          } else if (url.contains('ron-swanson')) {
             // ["I love nothing."]
             if (decoded is List && decoded.isNotEmpty) {
               parsedQuote = Quote(
                 quote: decoded.first.toString(),
                 role: 'Ron Swanson',
                 show: 'Parks and Recreation',
               );
             }
          } else if (url.contains('strangerthings')) {
             // [{"quote":"...","author":"..."}]
             if (decoded is List && decoded.isNotEmpty) {
                final data = decoded.first;
                 parsedQuote = Quote(
                 quote: data['quote'] ?? '',
                 role: data['author'] ?? 'Stranger Things Character',
                 show: 'Stranger Things',
               );
             }
          }

          if (parsedQuote != null && parsedQuote.quote.isNotEmpty) {
            quotes.add(parsedQuote);
          }
        }
      } catch (e) {
        debugPrint("Error fetching quote from $url: $e");
      }
    }

    // Fallback if APIs fail
    if (quotes.isEmpty) {
      debugPrint("Using fallback mock quotes");
      quotes = [
        Quote(quote: "I must not fear. Fear is the mind-killer.", role: "Paul Atreides", show: "Dune"),
        Quote(quote: "May thy knife chip and shatter.", role: "Paul Atreides", show: "Dune"),
        Quote(quote: "He who controls the spice controls the universe.", role: "Baron Harkonnen", show: "Dune"),
      ];
    }
    
    return quotes;
  }
}
