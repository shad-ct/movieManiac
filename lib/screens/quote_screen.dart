import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import '../models/quote.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Quote>> _quotesFuture;

  @override
  void initState() {
    super.initState();
    // Fetch 10 quotes for the feed
    _quotesFuture = _apiService.fetchQuotes(10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quotes")),
      body: FutureBuilder<List<Quote>>(
        future: _quotesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
             return Center(child: Text("Error loading quotes: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
             return const Center(child: Text("No quotes found."));
          }

          final quotes = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: quotes.length,
            separatorBuilder: (ctx, i) => const Divider(height: 40),
            itemBuilder: (context, index) {
              final quote = quotes[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '"${quote.quote}"',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "- ${quote.role}",
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                  Text(
                    quote.show,
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
             _quotesFuture = _apiService.fetchQuotes(10);
          });
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
