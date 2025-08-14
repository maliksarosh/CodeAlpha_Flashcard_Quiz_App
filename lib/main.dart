// lib/main.dart

import 'package:flutter/material.dart';
import 'flashcard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashcard App',    
      
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 241, 239, 239),
          brightness: Brightness.dark,
          surface: const  Color.fromARGB(225, 16, 37, 66),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 16, 37, 66),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
          bodyLarge: TextStyle(fontSize: 22.0, height: 1.4),
          bodyMedium: TextStyle(fontSize: 16.0),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
  
        elevatedButtonTheme: ElevatedButtonThemeData(
     
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: const RoundedRectangleBorder(
            
            ),
          ),
        ),
 
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color.fromARGB(255, 248, 112, 96),
          foregroundColor: Colors.white,
          elevation: 4,
        ),
      ),
      home: const FlashcardScreen(),
    );
  }
}
