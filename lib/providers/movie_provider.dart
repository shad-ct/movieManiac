import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie.dart';
import '../services/api_service.dart';

class MovieProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Movie> _movies = [];
  List<Movie> _likedMovies = [];
  List<Movie> _watchedMovies = [];
  List<Movie> _watchLaterMovies = [];
  List<Movie> _dislikedMovies = [];
  
  // Toggle: true for Series, false for Movies
  bool _isSeriesMode = false;

  // Pagination / Infinite Scroll
  final List<String> _keywords = ["Top", "Action", "Drama", "Sci-Fi", "Comedy", "Thriller", "2024", "Adventure", "Fantasy", "Classic"];
  int _currentKeywordIndex = 0;
  bool _isLoading = false;

  List<Movie> get movies => _movies;
  List<Movie> get likedMovies => _likedMovies;
  List<Movie> get watchedMovies => _watchedMovies;
  List<Movie> get watchLaterMovies => _watchLaterMovies;
  List<Movie> get dislikedMovies => _dislikedMovies;
  bool get isSeriesMode => _isSeriesMode;
  bool get isLoading => _isLoading;

  MovieProvider() {
    _loadPersistedData();
    fetchMovies();
  }

  Future<void> _loadPersistedData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load Liked
    final likedString = prefs.getStringList('liked_movies') ?? [];
    _likedMovies = likedString.map((s) => Movie.fromJson(json.decode(s))).toList();

    // Load Watched
    final watchedString = prefs.getStringList('watched_movies') ?? [];
    _watchedMovies = watchedString.map((s) => Movie.fromJson(json.decode(s))).toList();

    // Load Watch Later
    final watchLaterString = prefs.getStringList('watch_later_movies') ?? [];
    _watchLaterMovies = watchLaterString.map((s) => Movie.fromJson(json.decode(s))).toList();

    // Load Disliked
    final dislikedString = prefs.getStringList('disliked_movies') ?? [];
    _dislikedMovies = dislikedString.map((s) => Movie.fromJson(json.decode(s))).toList();
    
    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    
    final likedList = _likedMovies.map((m) => json.encode(m.toJson())).toList();
    await prefs.setStringList('liked_movies', likedList);

    final watchedList = _watchedMovies.map((m) => json.encode(m.toJson())).toList();
    await prefs.setStringList('watched_movies', watchedList);

    final watchLaterList = _watchLaterMovies.map((m) => json.encode(m.toJson())).toList();
    await prefs.setStringList('watch_later_movies', watchLaterList);

    final dislikedList = _dislikedMovies.map((m) => json.encode(m.toJson())).toList();
    await prefs.setStringList('disliked_movies', dislikedList);
  }

  void toggleMode(bool isSeries) {
    if (_isSeriesMode != isSeries) {
      _isSeriesMode = isSeries;
      _movies = []; // Clear stack
      _currentKeywordIndex = 0; // Reset pagination
      fetchMovies(); // Fetch new data
      notifyListeners();
    }
  }

  Future<void> fetchMovies() async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();

    try {
      int attempts = 0;
      final random = Random();
      
      // Loop through keywords to find valid results
      while (attempts < 3) {
        attempts++;
        String query;
        
        // 50% chance to fetch based on a liked movie if available
        if (_likedMovies.isNotEmpty && random.nextBool()) {
           final randomLiked = _likedMovies[random.nextInt(_likedMovies.length)];
           // Using the title to find similar movies. 
           // OMDb is basic, so searching "Batman" returns "Batman Begins", etc.
           // We clean the title a bit to remove year or extra info if present, though Movie.title is usually clean.
           query = randomLiked.title;
           debugPrint("Fetching recommendation based on: $query");
        } else {
           query = _keywords[_currentKeywordIndex];
           _currentKeywordIndex = (_currentKeywordIndex + 1) % _keywords.length; // Cycle keywords
           debugPrint("Fetching discovery based on: $query");
        }

        // Pass the series mode to the API service
        List<Movie> fetched = await _apiService.fetchMovies(query, isSeries: _isSeriesMode);

        // Remove duplicates if any already exist in _movies
        final existingIds = _movies.map((m) => m.imdbId).toSet();
        fetched = fetched.where((m) => !existingIds.contains(m.imdbId)).toList();

        // Filter out disliked movies
        final dislikedIds = _dislikedMovies.map((m) => m.imdbId).toSet();
        fetched = fetched.where((m) => !dislikedIds.contains(m.imdbId)).toList();
        
        // Filter out already liked/played movies to avoid showing them again
        final playedIds = _likedMovies.map((m) => m.imdbId).toSet()
          ..addAll(_watchedMovies.map((m) => m.imdbId))
          ..addAll(_watchLaterMovies.map((m) => m.imdbId));
        fetched = fetched.where((m) => !playedIds.contains(m.imdbId)).toList();

        if (fetched.isNotEmpty) {
          _movies.addAll(fetched);
          break; // Found movies, stop loop
        }
        
        // If empty, loop continues to try next keyword/strategy
      }
    } catch (e) {
      debugPrint("Provider Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Queue Refresher called when swipe index is near end
  void checkQueue(int currentIndex) {
    // If we have fewer than 3 cards left after the current index, fetch more
    if (_movies.length - currentIndex <= 3) {
      fetchMovies();
    }
  }

  void likeMovie(Movie movie) {
    if (!_likedMovies.any((m) => m.imdbId == movie.imdbId)) {
      _likedMovies.add(movie);
      _saveData();
      notifyListeners();
    }
  }

  void watchMovie(Movie movie) {
    if (!_watchedMovies.any((m) => m.imdbId == movie.imdbId)) {
      _watchedMovies.add(movie);
      _saveData();
      notifyListeners();
    }
  }

  void watchLater(Movie movie) {
    if (!_watchLaterMovies.any((m) => m.imdbId == movie.imdbId)) {
      _watchLaterMovies.add(movie);
      _saveData();
      notifyListeners();
    }
  }

  void dislikeMovie(Movie movie) {
    if (!_dislikedMovies.any((m) => m.imdbId == movie.imdbId)) {
      _dislikedMovies.add(movie);
      _saveData();
      notifyListeners();
    }
  }
}
