import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../providers/movie_provider.dart';
import '../widgets/movie_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CardSwiperController _controller = CardSwiperController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Mode Toggle
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<MovieProvider>(
              builder: (context, provider, _) {
                return SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(value: false, label: Text('Movies'), icon: Icon(Icons.movie)),
                    ButtonSegment(value: true, label: Text('Series'), icon: Icon(Icons.tv)),
                  ],
                  selected: {provider.isSeriesMode},
                  onSelectionChanged: (Set<bool> newSelection) {
                    provider.toggleMode(newSelection.first);
                  },
                );
              },
            ),
          ),
          
          // Card Swiper
          Expanded(
            child: Consumer<MovieProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading && provider.movies.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (provider.movies.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("No movies found!"),
                        TextButton(onPressed: provider.fetchMovies, child: const Text("Retry"))
                      ],
                    ),
                  );
                }

                return CardSwiper(
                  controller: _controller,
                  cardsCount: provider.movies.length,
                  threshold: 100,
                  maxAngle: 5,
                  scale: 0.95,
                  allowedSwipeDirection: const AllowedSwipeDirection.only(left: true, right: true),
                  cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
                    final movie = provider.movies[index];
                    return MovieCard(
                      movie: movie,
                      onWatchLater: () {
                        provider.watchLater(movie);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Added to Watch Later: ${movie.title} ⏱️"), duration: const Duration(milliseconds: 500)),
                        );
                        _controller.swipe(CardSwiperDirection.bottom); // Swipe down programmatically
                      },
                      onWatched: () {
                        provider.watchMovie(movie);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Marked as Watched: ${movie.title} ✅"), duration: const Duration(milliseconds: 500)),
                        );
                         _controller.swipe(CardSwiperDirection.top); // Swipe up programmatically
                      },
                    );
                  },
                  onSwipe: (previousIndex, currentIndex, direction) {
                    final movie = provider.movies[previousIndex];
                    
                    if (direction == CardSwiperDirection.right) {
                      provider.likeMovie(movie);
                      ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(content: Text("Liked ${movie.title} ❤️"), duration: const Duration(milliseconds: 500)),
                      );
                    } else if (direction == CardSwiperDirection.left) {
                      provider.dislikeMovie(movie);
                    } 
                    // Note: Top and Bottom are now handled via buttons, enabling them in onSwipe just in case programmatic swipe triggers them
                    else if (direction == CardSwiperDirection.top) {
                       // Handled by button usually, but safe to keep logic
                    } else if (direction == CardSwiperDirection.bottom) {
                       // Handled by button usually, but safe to keep logic
                    }
                    
                    if (currentIndex != null) {
                         provider.checkQueue(currentIndex); 
                    }
                    return true;
                  },
                  numberOfCardsDisplayed: 3,
                  backCardOffset: const Offset(0, 40),
                  padding: const EdgeInsets.all(24.0),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
