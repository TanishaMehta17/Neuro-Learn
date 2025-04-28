import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:neuro_learn/common/global_varibale.dart';
import 'package:neuro_learn/model/task.dart';

class ContentService {
  Future<void> saveTask(Map<String, dynamic> taskRequest) async {
    try {
      final response = await http.post(
        Uri.parse('$uri/api/task/saveTask'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(taskRequest),
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('Failed to save task: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving task: $e');
      rethrow;
    }
  }

  Future<List<Task>> getAllTask(String userId) async {
    final response = await http.get(
      Uri.parse(
          '$uri/api/task/getAll?userId=$userId'), // <-- now uses query param
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Task.fromMap(json)).toList();
    } else {
      throw Exception('Failed to get all tasks');
    }
  }

  Future<void> markTaskAsCompleted(String taskId, String userId) async {
    try {
      final response = await http.put(
        Uri.parse('$uri/api/task/update?taskId=$taskId'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "id": int.parse(taskId),
          "description": "",
          "user": {"id": int.parse(userId)},
          "completed": true,
        }),
      );

      if (response.statusCode == 200) {
        print("Task marked as completed: ${response.body}");
      } else {
        print(
            "Failed to mark task as completed. Status: ${response.statusCode}");
        throw Exception('Failed to mark task as completed');
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> deleteTask(String taskId, String userId) async {
    final response = await http.delete(
      Uri.parse(
          '$uri/api/task/delete?taskId=$taskId&userId=$userId'), // <-- query params
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }

  Future<http.Response> getRevisionContent(String topic) async {
    final url = Uri.parse('$uri/api/revision');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'topic': topic}),
      );

      return response; // Return the full response
    } catch (e) {
      print("Exception in getRevisionContent: $e");
      throw Exception("Failed to connect: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchMCQs(String topic) async {
    final response = await http.post(
      Uri.parse('$uri/api/mcq'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'topic': topic}),
    );

    if (response.statusCode == 200) {
      List<dynamic> responseData = jsonDecode(response.body);
      return responseData.map<Map<String, dynamic>>((question) {
        return {
          'questionText': question['questionText'],
          'options': question['options'],
          'answer': question['answer'],
        };
      }).toList();
    } else {
      throw Exception('Failed to load MCQs');
    }
  }

  Future<String> getTextContent(String topic) async {
    final res = await http.post(
      Uri.parse('$uri/api/recommend/text'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'topic': topic}),
    );
    if (res.statusCode == 200) return res.body;
    throw Exception('Text API failed');
  }

  Future<String> getCourseLinks(String topic) async {
    final res = await http.post(
      Uri.parse('$uri/api/recommend/courses'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'topic': topic}),
    );
    if (res.statusCode == 200) return res.body;
    throw Exception('Courses API failed');
  }

  Future<String> getYoutubeVideos(String topic) async {
    final res = await http.post(
      Uri.parse('$uri/api/recommend/youtube'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'topic': topic}),
    );
    if (res.statusCode == 200) return res.body;
    throw Exception('YouTube API failed');
  }

  Future<List<Map<String, String>>> getFlashcards(String topic) async {
    final response = await http.post(
      Uri.parse('$uri/api/flashcards'),
      body: jsonEncode({'topic': topic}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data =
          jsonDecode(response.body); // <- data is a List of Maps
      return data
          .map<Map<String, String>>((item) => {
                'question': item['question'].toString(),
                'answer': item['answer'].toString(),
              })
          .toList();
    } else {
      throw Exception('Failed to fetch flashcards');
    }
  }
}
