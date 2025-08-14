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
        title: const Text('Flashcard Quiz',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Add New Card',color: const Color.fromARGB(255,248, 112, 96),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddEditScreen()),
              );
              setState(() {});
            },
          ),
          IconButton(
            icon: const Icon(Icons.list_alt),
            tooltip: 'View All Cards',color: const Color.fromARGB(255,248, 112, 96),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const CardListScreen()),
              );
              setState(() {});
            },
          ),
        ],
      ),
       body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
               Image.asset(
                'assets/images/Quiz.png',
                height: 170, // You can adjust the height as needed
              ),
              const SizedBox(height: 20), // Consistent spacing

               FutureBuilder<List<Flashcard>>(
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
                          const SizedBox(height: 40), // Add some top spacing
                          const Icon(Icons.apps_outlined,
                              size: 80,
                              color: Color.fromARGB(204, 248, 112, 96)),
                          const SizedBox(height: 16),
                          Text(
                            'No cards to review.',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255)),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Press the '+' icon to add your first card.",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: const Color.fromARGB(
                                        230, 153, 152, 152)),
                          ),
                        ],
                      ),
                    );
                  } else {
                     return FlashcardView(flashcards: snapshot.data!);
                  }
                },
              ),
            ],
          ),
        ),
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
          color: const Color.fromARGB(246, 14, 13, 13),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: const Color.fromARGB(225, 179, 163, 148),
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Question ${_currentIndex + 1} of ${widget.flashcards.length}',
          textAlign: TextAlign.center,
          style: textTheme.bodyLarge
              ?.copyWith(color: const Color.fromARGB(255, 253, 251, 251)),
        ),
        const SizedBox(height: 16),
        FlipCard(
          key: ValueKey(
              _currentIndex), // Ensures the card rebuilds on index change
          controller: _cardController,
          direction: FlipDirection.HORIZONTAL,
          front: buildCardFace(widget.flashcards[_currentIndex].question),
          back: buildCardFace(widget.flashcards[_currentIndex].answer),
        ),
        const SizedBox(height: 26),
        ElevatedButton.icon(
          icon: const Icon(Icons.flip_camera_android),
          onPressed: () {
            _cardController.toggleCard();
          },
          label: const Text('Show Answer'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(225, 248, 112, 96),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            foregroundColor: const Color.fromARGB(255, 243, 243, 243),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
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
        // Loop back to the beginning
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
        // Loop back to the end
        _currentIndex = cardCount - 1;
      }
    });
  }
}
