// lib/add_edit_screen.dart

import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'flashcard_model.dart';

class AddEditScreen extends StatefulWidget {
  final Flashcard? flashcard;
  const AddEditScreen({super.key, this.flashcard});

  @override
  AddEditScreenState createState() => AddEditScreenState();
}

class AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _questionController;
  late TextEditingController _answerController;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _questionController =
        TextEditingController(text: widget.flashcard?.question ?? '');
    _answerController =
        TextEditingController(text: widget.flashcard?.answer ?? '');
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  void _saveFlashcard() async {
    if (_formKey.currentState!.validate()) {
      final question = _questionController.text;
      final answer = _answerController.text;

      if (widget.flashcard != null) {
        final updatedFlashcard = Flashcard(
          id: widget.flashcard!.id,
          question: question,
          answer: answer,
        );
        await _dbHelper.updateFlashcard(updatedFlashcard);
      } else {
        final newFlashcard = Flashcard(question: question, answer: answer);
        await _dbHelper.insertFlashcard(newFlashcard);
      }

      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.flashcard == null ? 'Add Flashcard' : 'Edit Flashcard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
    
              TextFormField(
                controller: _questionController,
                style: const TextStyle(color: Color.fromARGB(255, 255, 254, 254)),
                decoration:const  InputDecoration(
                  labelText: 'Question',          
                  labelStyle: TextStyle(color: Color.fromARGB(255, 226, 226, 226)),
                  border:  OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color:  Color.fromARGB(224, 245, 245, 245),
                        width: 2.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a question.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _answerController,
               
                style: const TextStyle(color: Color.fromARGB(255, 255, 253, 253)),
                decoration:const InputDecoration(
                  labelText: 'Answer',
                  
                  labelStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  border:  OutlineInputBorder(),
                  focusedBorder:  OutlineInputBorder(
                    borderSide: BorderSide(
                        color:  Color.fromARGB(224, 245, 245, 245),
                        width: 2.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an answer.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  onPressed: _saveFlashcard,
                  label: const Text('Save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(225, 248, 112, 96),
                    foregroundColor: const Color.fromARGB(224, 255, 255, 255),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),textStyle: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
