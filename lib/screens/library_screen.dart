import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/movie_provider.dart';
import '../models/movie.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Library'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Liked'),
              Tab(text: 'Watched'),
              Tab(text: 'Watch Later'),
            ],
          ),
        ),
        body: Consumer<MovieProvider>(
          builder: (context, provider, _) {
            return TabBarView(
              children: [
                _buildGrid(provider.likedMovies),
                _buildGrid(provider.watchedMovies),
                _buildGrid(provider.watchLaterMovies),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildGrid(List<Movie> movies) {
    if (movies.isEmpty) {
      return const Center(child: Text("Nothing here yet!"));
    }
    
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: GridTile(
            footer: GridTileBar(
              backgroundColor: Colors.black45,
              title: Text(movie.title, textAlign: TextAlign.center),
            ),
            child: CachedNetworkImage(
              imageUrl: movie.poster,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Colors.grey[900]),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        );
      },
    );
  }
}
