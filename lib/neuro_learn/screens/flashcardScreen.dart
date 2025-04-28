import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:neuro_learn/common/colors.dart';
import 'package:neuro_learn/common/typography.dart';
import 'package:neuro_learn/neuro_learn/service/contentService.dart';

class FlashcardScreen extends StatefulWidget {

  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}


class _FlashcardScreenState extends State<FlashcardScreen> {
 
  
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> _flashcards = [];
  List<bool> _showAnswer = [];
  bool _isLoading = false;

  void _handleSubmit() async {
    final topic = _controller.text.trim();
    if (topic.isEmpty) return;

    setState(() {
      _isLoading = true;
      _flashcards = [];
      _showAnswer = [];
    });

    try {
      final result = await ContentService().getFlashcards(topic);

      if (result.isEmpty) {
        _flashcards = [
          {'question': 'What is Flutter?', 'answer': 'A UI toolkit by Google.'},
          {
            'question': 'What is Dart?',
            'answer': 'A programming language used by Flutter.'
          }
        ];
      } else {
        _flashcards = result.take(15).toList();
      }

      setState(() {
        _showAnswer = List.filled(_flashcards.length, false);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Oops! Failed to fetch flashcards.")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _toggleCard(int index) {
    setState(() {
      _showAnswer[index] = !_showAnswer[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "AI Flashcards 🔄🧠",
                style: SCRTypography.heading.copyWith(
                  color: neonYellowGreen,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "🎯 Enter a topic and get instant AI-powered flashcards! Tap to flip and reveal answers — perfect for quick reviews. ⚡",
                style: SCRTypography.body.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                style: SCRTypography.body.copyWith(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Type a topic like “Machine Learning” 🤖',
                  hintStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey.shade900,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: neonYellowGreen),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send, color: Color(0xFFE7FF3E)),
                    onPressed: _handleSubmit,
                  ),
                ),
                onSubmitted: (_) => _handleSubmit(),
              ),
              const SizedBox(height: 24),
              if (_isLoading)
                const Center(
                    child: CircularProgressIndicator(color: neonYellowGreen)),
              if (!_isLoading && _flashcards.isNotEmpty)
                Expanded(
                  child: GridView.builder(
                    itemCount: _flashcards.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio:
                          1.2, // Adjusted the aspect ratio for a smaller size
                    ),
                    itemBuilder: (context, index) {
                      final flashcard = _flashcards[index];
                      final isFlipped = _showAnswer[index];

                      return GestureDetector(
                        onTap: () => _toggleCard(index),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [orangeAccent, neonPurple],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(18),
                            border:
                                Border.all(color: Colors.white10, width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: neonYellowGreen.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 1,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        isFlipped
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        isFlipped
                                            ? flashcard['answer'] ?? 'No answer'
                                            : flashcard['question'] ??
                                                'No question',
                                        textAlign: TextAlign.center,
                                        style: SCRTypography.body.copyWith(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
