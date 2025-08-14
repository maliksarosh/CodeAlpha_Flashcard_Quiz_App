// lib/flashcard_screen.dart

import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flashcard_quiz_app/add_edit_screen.dart';
import 'package:flashcard_quiz_app/card_list_screen.dart';
import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'flashcard_model.dart';

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  FlashcardScreenState createState() => FlashcardScreenState();
}

class FlashcardScreenState extends State<FlashcardScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcard Quiz'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Add New Card',
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddEditScreen()),
              );
              setState(() {});
            },
          ),
          IconButton(
            icon: const Icon(Icons.list_alt),
            tooltip: 'View All Cards',
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const CardListScreen()),
              );
              setState(() {});
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Flashcard>>(
        future: _dbHelper.getFlashcards(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.apps_outlined,
                      size: 80, color: Color.fromARGB(153, 141, 2, 2)),
                  const SizedBox(height: 16),
                  Text(
                    'No cards to review.',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color:  Color.fromARGB(225, 4, 36, 54)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Press the '+' icon to add your first card.",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color:  Color.fromARGB(225, 4, 36, 54)),
                  ),
                ],
              ),
            );
          } else {
            return FlashcardView(flashcards: snapshot.data!);
          }
        },
      ),
    );
  }
}

class FlashcardView extends StatefulWidget {
  final List<Flashcard> flashcards;
  const FlashcardView({super.key, required this.flashcards});

  @override
  State<FlashcardView> createState() => _FlashcardViewState();
}

class _FlashcardViewState extends State<FlashcardView> {
  int _currentIndex = 0;
  final FlipCardController _cardController = FlipCardController();

  @override
  Widget build(BuildContext context) {
    if (_currentIndex >= widget.flashcards.length) {
      _currentIndex = 0;
    }

    final textTheme = Theme.of(context).textTheme;

    Widget buildCardFace(String text) {
      return SizedBox(
        height: 250,
        child: Card(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade800,
                  Colors.purple.shade700,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Question ${_currentIndex + 1} of ${widget.flashcards.length}',
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge?.copyWith(color: const Color.fromARGB(179, 0, 0, 0)),
          ),
          const SizedBox(height: 16),
          FlipCard(
            key: ValueKey(_currentIndex),
            controller: _cardController,
            direction: FlipDirection.HORIZONTAL,
            front: buildCardFace(widget.flashcards[_currentIndex].question),
            back: buildCardFace(widget.flashcards[_currentIndex].answer),
          ),
          const SizedBox(height: 24),
          // =======================================================================
          // === THE CHANGE IS HIGHLIGHTED INSIDE THIS BUTTON'S STYLE ===
          // =======================================================================
          ElevatedButton.icon(
            icon: const Icon(Icons.flip_camera_android),
            onPressed: () {
              _cardController.toggleCard();
            },
            label: const Text('Show Answer'),
            style: ElevatedButton.styleFrom(
              // HIGHLIGHT: Change this line to set your desired color.
              // I am using a dark green as an example.
              backgroundColor:  Color.fromARGB(225, 4, 36, 54),

              // This sets the text and icon color.
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
          // =======================================================================
          // === END OF THE CHANGE ===
          // =======================================================================
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 28),
                onPressed: _showPreviousCard,
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 28),
                onPressed: _showNextCard,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showNextCard() {
    setState(() {
      int cardCount = widget.flashcards.length;
      if (cardCount == 0) {
        _currentIndex = 0;
      } else if (_currentIndex < cardCount - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
    });
  }

  void _showPreviousCard() {
    setState(() {
      int cardCount = widget.flashcards.length;
      if (cardCount == 0) {
        _currentIndex = 0;
      } else if (_currentIndex > 0) {
        _currentIndex--;
      } else {
        _currentIndex = cardCount - 1;
      }
    });
  }
}
