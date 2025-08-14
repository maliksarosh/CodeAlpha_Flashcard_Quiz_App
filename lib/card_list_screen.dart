// lib/card_list_screen.dart

import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'flashcard_model.dart';
import 'add_edit_screen.dart';

class CardListScreen extends StatefulWidget {
  const CardListScreen({super.key});

  @override
  CardListScreenState createState() => CardListScreenState();
}

class CardListScreenState extends State<CardListScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  void _navigateToAddEditScreen([Flashcard? flashcard]) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddEditScreen(flashcard: flashcard),
      ),
    );
    setState(() {});
  }

  void _deleteFlashcard(int id) async {
    await _dbHelper.deleteFlashcard(id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Flashcard deleted'), duration: Duration(seconds: 1)),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Flashcards'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: FutureBuilder<List<Flashcard>>(
        future: _dbHelper.getFlashcards(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.style, size: 80, color: Color.fromARGB(225, 4, 36, 54)),
                  const SizedBox(height: 16),
                  Text(
                    'Your collection is empty.',
                    style: textTheme.headlineSmall
                        ?.copyWith(color:  Color.fromARGB(225, 4, 36, 54)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Press the \'+\' button to create your first card.',
                    style:
                        textTheme.bodyMedium?.copyWith(color:  Color.fromARGB(225, 4, 36, 54)),
                  ),
                ],
              ),
            );
          }

          final flashcards = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(8.0),
            itemCount: flashcards.length,
            separatorBuilder: (context, index) => const SizedBox(height: 4),
            itemBuilder: (context, index) {
              final card = flashcards[index];
              return Card(
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(card.question,
                      style: textTheme.bodyLarge?.copyWith(fontSize: 18)),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(card.answer,
                        style: textTheme.bodyMedium
                            ?.copyWith(color: Colors.white70)),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => _navigateToAddEditScreen(card),
                        tooltip: 'Edit',
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: Colors.redAccent),
                        onPressed: () => _deleteFlashcard(card.id!),
                        tooltip: 'Delete',
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEditScreen(),
        tooltip: 'Add New Card',
        child: const Icon(Icons.add),
      ),
    );
  }
}
