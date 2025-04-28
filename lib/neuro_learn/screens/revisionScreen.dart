import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:neuro_learn/common/colors.dart';
import 'package:neuro_learn/common/typography.dart';
import 'package:neuro_learn/neuro_learn/service/contentService.dart';
import 'package:http/http.dart' as http;

class Revisionscreen extends StatefulWidget {
  
  const Revisionscreen({super.key});

  @override
  State<Revisionscreen> createState() => _RevisionscreenState();
}

class _RevisionscreenState extends State<Revisionscreen> {
 
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _revisionItems = [];
  bool _isLoading = false;

  void _handleSubmit() async {
    final topic = _controller.text.trim();
    if (topic.isEmpty) return;

    setState(() {
      _isLoading = true;
      _revisionItems = [];
    });

    try {
      final http.Response result = await ContentService().getRevisionContent(topic);

      if (result.statusCode == 200) {
        final decoded = json.decode(result.body);
        if (decoded is List) {
          setState(() => _revisionItems = List<Map<String, dynamic>>.from(decoded));
        } else {
          setState(() => _revisionItems = []);
        }
      } else {
        setState(() => _revisionItems = []);
      }
    } catch (e) {
      print("Error parsing revision content: $e");
      setState(() => _revisionItems = []);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildTopicExplanation(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item['topic'] ?? 'No topic',
            style: SCRTypography.heading.copyWith(
              color: neonYellowGreen,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item['explanation'] ?? 'No explanation',
            style: SCRTypography.body.copyWith(
              color: white70,
              height: 1.5,
              fontSize: 14.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormattedResponse() {
    if (_revisionItems.isEmpty) {
      return const SizedBox();
    }

    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: neonYellowGreen.withOpacity(0.7)),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _revisionItems
                    .map((item) => _buildTopicExplanation(item))
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "AI Revision Buddy 🤖📚",
                style: SCRTypography.heading.copyWith(
                  color: neonYellowGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "✨ Stressed about last-minute revision? Just drop your topic and let the AI create super-concise, exam-ready notes for you in seconds! Works like magic. 🪄",
                style: SCRTypography.body.copyWith(
                  color: white70,
                  fontSize: 14.5,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                style: SCRTypography.body.copyWith(color: white),
                decoration: InputDecoration(
                  hintText: 'Enter a topic like “Photosynthesis” 🌿',
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
                onSubmitted: (_) => _handleSubmit(),
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? Center(child: CircularProgressIndicator(color: neonYellowGreen))
                  : _buildFormattedResponse(),
            ],
          ),
        ),
      ),
    );
  }
}
