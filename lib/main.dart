import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/movie_provider.dart';
import 'screens/main_nav_screen.dart';

void main() {
  runApp(const MovieManiacApp());
}

class MovieManiacApp extends StatelessWidget {
  const MovieManiacApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MovieProvider()),
      ],
      child: MaterialApp(
        title: 'MovieManiac',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF121212),
          colorScheme: const ColorScheme.dark(
            primary: Colors.amber,
            secondary: Colors.redAccent,
            surface: Color(0xFF1E1E1E),
          ),
          textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1E1E1E),
            elevation: 0,
            centerTitle: true,
          ),
          navigationBarTheme: NavigationBarThemeData(
             backgroundColor: const Color(0xFF1E1E1E),
             indicatorColor: const Color.fromRGBO(255, 193, 7, 0.2),
             labelTextStyle: WidgetStateProperty.all(
                const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
             ),
          ),
        ),
        home: const MainNavScreen(),
      ),
    );
  }
}
