import 'package:flutter/material.dart';
import 'package:neuro_learn/common/colors.dart';
import 'package:neuro_learn/common/typography.dart';
import 'package:neuro_learn/neuro_learn/service/contentService.dart';
import 'package:url_launcher/url_launcher.dart';

class Recommendationscreen extends StatefulWidget {
   
  const Recommendationscreen({super.key});

  @override
  State<Recommendationscreen> createState() => _RecommendationscreenState();
}

class _RecommendationscreenState extends State<Recommendationscreen> {
  
  final TextEditingController _controller = TextEditingController();

  bool _isLoading = false;
  String? _textResponse;
  String? _courseResponse;
  String? _youtubeResponse;

  void _handleSubmit() async {
    final topic = _controller.text.trim();
    if (topic.isEmpty) return;

    setState(() {
      _isLoading = true;
      _textResponse = null;
      _courseResponse = null;
      _youtubeResponse = null;
    });

    try {
      final responses = await Future.wait([
        ContentService().getTextContent(topic),
        ContentService().getCourseLinks(topic),
        ContentService().getYoutubeVideos(topic),
      ]);

      setState(() {
        _textResponse = responses[0];
        _courseResponse = responses[1];
        _youtubeResponse = responses[2];
      });
    } catch (e) {
      setState(() {
        _textResponse = 'Failed to load text content';
        _courseResponse = 'Failed to load course links';
        _youtubeResponse = 'Failed to load YouTube videos';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildSection(String title, String? content) {
    if (content == null) return const SizedBox.shrink();

    final lines = content.split('\n');

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: neonYellowGreen.withOpacity(0.7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: SCRTypography.heading.copyWith(
              color: neonYellowGreen,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          ...lines.map((line) {
            final urlRegex = RegExp(r'(https?:\/\/[^\s]+)');
            final match = urlRegex.firstMatch(line);
            if (match != null) {
              final url = match.group(0)!;
              final title = line.replaceAll(url, '').trim();
              return InkWell(
                onTap: () async {
                  final uri = Uri.parse(url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    debugPrint("⚠️ Could not launch $url");
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text.rich(
                    TextSpan(
                      text: title.isNotEmpty ? "$title → " : '',
                      style: SCRTypography.body.copyWith(
                        color: white,
                        fontSize: 15.5,
                      ),
                      children: [
                        TextSpan(
                          text: url,
                          style: TextStyle(
                            color: neonYellowGreen,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Text(
                line,
                style: SCRTypography.body.copyWith(
                  color: white,
                  fontSize: 15.5,
                ),
              );
            }
          }).toList(),
        ],
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
              Text("AI Recommendations 🎯🔗",
                  style: SCRTypography.heading.copyWith(
                    color: neonYellowGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  )),
              const SizedBox(height: 10),
              Text(
                "🚀 Want to study smarter? Enter any topic and instantly get high-quality links and resources handpicked by our AI engine!",
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
                  hintText: 'Try “Machine Learning Basics” 🤖',
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
                  : Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSection("📘 Text Summary", _textResponse),
                            _buildSection("🎓 Course Links", _courseResponse),
                            _buildSection("📺 YouTube Videos", _youtubeResponse),
                          ],
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
