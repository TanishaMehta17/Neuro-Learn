import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:neuro_learn/common/colors.dart';
import 'package:neuro_learn/common/typography.dart';
import 'package:neuro_learn/neuro_learn/service/contentService.dart';

class McqScreen extends StatefulWidget {
 
  const McqScreen({super.key});

  @override
  State<McqScreen> createState() => _McqScreenState();
}

class _McqScreenState extends State<McqScreen> {
  
  final TextEditingController _controller = TextEditingController();
  ContentService contentService = ContentService();
  bool _isLoading = false;
  List<MCQ> _questions = [];

  void _handleSubmit() async {
    final topic = _controller.text.trim();
    if (topic.isEmpty) return;

    setState(() {
      _isLoading = true;
      _questions.clear();
    });

    try {
      final result = await contentService.fetchMCQs(topic);
      setState(() {
        _questions = result.map((q) => MCQ.fromJson(q)).toList();
      });
    } catch (e) {
      setState(() {
        _questions = [];
      });
      print("Error fetching MCQs: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                "MCQ Generator 🎯",
                style: SCRTypography.heading.copyWith(
                  color: neonYellowGreen,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Get multiple-choice questions instantly! Just enter a topic and let the AI quiz your brain. 💡",
                style: SCRTypography.body.copyWith(color: white70),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                style: TextStyle(color: white),
                decoration: InputDecoration(
                  hintText: 'Enter a topic like “Python” 🐍',
                  hintStyle: TextStyle(color: white70),
                  filled: true,
                  fillColor: Colors.grey.shade900,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: neonYellowGreen, width: 1.5),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send, color: neonYellowGreen),
                    onPressed: _handleSubmit,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator(color: neonYellowGreen))
                  : _questions.isEmpty
                      ? const SizedBox()
                      : Expanded(
                          child: ListView.builder(
                            itemCount: _questions.length,
                            itemBuilder: (context, index) {
                              return MCQCard(mcq: _questions[index]);
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

class MCQ {
  final String question;
  final List<String> options;
  final String answer;
  bool isAnswerVisible;

  MCQ(this.question, this.options, this.answer, {this.isAnswerVisible = false});

  factory MCQ.fromJson(Map<String, dynamic> json) {
    return MCQ(
      json['questionText'] as String,
      List<String>.from(json['options']),
      json['answer'] as String,
    );
  }
}

class MCQCard extends StatefulWidget {
  final MCQ mcq;
  const MCQCard({super.key, required this.mcq});

  @override
  State<MCQCard> createState() => _MCQCardState();
}

class _MCQCardState extends State<MCQCard> {
  late bool _showAnswer;

  @override
  void initState() {
    _showAnswer = widget.mcq.isAnswerVisible;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: neonYellowGreen.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.mcq.question,
                style: SCRTypography.body.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: white,
                ),
              ),
              const SizedBox(height: 10),
              ...widget.mcq.options.map((option) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      option,
                      style: SCRTypography.body.copyWith(
                        color: white70,
                        fontSize: 14.5,
                      ),
                    ),
                  )),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showAnswer = !_showAnswer;
                    widget.mcq.isAnswerVisible = _showAnswer;
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      _showAnswer ? Icons.visibility_off : Icons.visibility,
                      color: neonYellowGreen,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _showAnswer ? "Hide Answer" : "Show Answer",
                      style: SCRTypography.body.copyWith(
                        color: neonYellowGreen,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              if (_showAnswer)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    "✅ Correct Answer: ${widget.mcq.answer}",
                    style: SCRTypography.body.copyWith(
                      color: white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.5,
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
