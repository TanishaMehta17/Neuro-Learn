import 'package:flutter/material.dart';
import 'package:neuro_learn/common/colors.dart';
import 'package:neuro_learn/common/typography.dart';
import 'package:neuro_learn/model/task.dart';
import 'package:neuro_learn/neuro_learn/screens/flashcardScreen.dart';
import 'package:neuro_learn/neuro_learn/screens/mcqScreen.dart';
import 'package:neuro_learn/neuro_learn/screens/recommendationScreen.dart';
import 'package:neuro_learn/neuro_learn/screens/revisionScreen.dart';
import 'package:neuro_learn/neuro_learn/service/contentService.dart';
import 'package:neuro_learn/providers/userProvider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  final String userName;

  const HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ContentService contentService = ContentService();
  late UserProvider userProvider;
  final TextEditingController _taskController = TextEditingController();
  List<Task> _tasks = [];

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      _fetchTasks();
    });
  }

  void _fetchTasks() async {
    try {
      final fetchedTasks =
          await contentService.getAllTask(userProvider.user.id.toString());
      setState(() => _tasks = fetchedTasks);
    } catch (e) {
      print("Error fetching tasks: $e");
    }
  }

  void _addTask(String taskText) async {
    try {
      final Map<String, dynamic> taskRequest = {
        "description": taskText,
        "user": {"id": int.parse(userProvider.user.id.toString())}
      };
      await contentService.saveTask(taskRequest);
      _taskController.clear();
      _fetchTasks();
    } catch (e) {
      print("Error adding task: $e");
    }
  }

  void _markTaskCompleted(String taskId) async {
    try {
      await contentService.markTaskAsCompleted(
          taskId, userProvider.user.id.toString());
      _fetchTasks();
    } catch (e) {
      print("Error marking task completed: $e");
    }
  }

  void _removeTask(String taskId) async {
    try {
      await contentService.deleteTask(taskId, userProvider.user.id.toString());
      _fetchTasks();
    } catch (e) {
      print("Error deleting task: $e");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildHomeContent() {
    final pendingTasks = _tasks.where((task) => !task.isCompleted).toList();
    final completedTasks = _tasks.where((task) => task.isCompleted).toList();
    final totalTasks = _tasks.isEmpty ? 1 : _tasks.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Welcome to NeuroLearn, ${widget.userName}!",
              style: SCRTypography.heading.copyWith(color: neonYellowGreen),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Your AI-powered learning companion — track your learning journey, revise smarter, and achieve your goals effortlessly!",
            style: SCRTypography.body.copyWith(color: white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),

          // Add task bar
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _taskController,
                  style: SCRTypography.body.copyWith(color: white),
                  decoration: InputDecoration(
                    hintText: 'Add a new task',
                    hintStyle: const TextStyle(color: white70),
                    filled: true,
                    fillColor: Colors.grey.shade900,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.add_circle,
                    color: neonYellowGreen, size: 32),
                onPressed: () {
                  if (_taskController.text.trim().isNotEmpty) {
                    _addTask(_taskController.text.trim());
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Status Cards
          Row(
            children: [
              _buildTaskStatusCard(
                title: "Pending",
                color: redAccent,
                value: pendingTasks.length / totalTasks,
                count: pendingTasks.length,
              ),
              const SizedBox(width: 16),
              _buildTaskStatusCard(
                title: "Completed",
                color: greenAccent,
                value: completedTasks.length / totalTasks,
                count: completedTasks.length,
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Pending Tasks Section
          if (pendingTasks.isNotEmpty) ...[
            Text(
              "Pending Tasks",
              style: SCRTypography.subHeading.copyWith(color: neonYellowGreen),
            ),
            const SizedBox(height: 10),
            ...pendingTasks.map((task) => _buildTaskTile(task)).toList(),
            const SizedBox(height: 30),
          ],

          // Completed Tasks Section
          if (completedTasks.isNotEmpty) ...[
            Text(
              "Completed Tasks",
              style: SCRTypography.subHeading.copyWith(color: greenAccent),
            ),
            const SizedBox(height: 10),
            ...completedTasks.map((task) => _buildTaskTile(task)).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildTaskTile(Task task) {
    return Card(
      color: Colors.grey.shade800,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(
          task.description,
          style: SCRTypography.body.copyWith(
            color: white,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            task.isCompleted ? Icons.delete_forever : Icons.check_circle,
            color: task.isCompleted ? redAccent : greenAccent,
          ),
          onPressed: () {
            if (task.isCompleted) {
              // Now delete completely if already completed
              _removeTask(task.id.toString());
            } else {
              // Mark as completed
              _markTaskCompleted(task.id.toString());
            }
          },
        ),
      ),
    );
  }

  Widget _buildTaskStatusCard({
    required String title,
    required Color color,
    required double value,
    required int count,
  }) {
    return Expanded(
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 70,
                  height: 70,
                  child: CircularProgressIndicator(
                    value: value,
                    color: color,
                    backgroundColor: white70,
                    strokeWidth: 6,
                  ),
                ),
                Text(
                  "$count",
                  style: SCRTypography.body
                      .copyWith(color: white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: SCRTypography.subHeading.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      _buildHomeContent(),
      McqScreen(),
      Recommendationscreen(),
      Revisionscreen(),
      FlashcardScreen(),
    ];

    return Scaffold(
      backgroundColor: black,
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: black,
        selectedItemColor: neonYellowGreen,
        unselectedItemColor: white70,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz),
            label: 'MCQs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.recommend),
            label: 'Recommendations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.replay_circle_filled),
            label: 'Revision',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb),
            label: 'Flashcards',
          ),
        ],
      ),
    );
  }
}
