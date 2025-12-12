import 'package:flutter/material.dart';
import 'package:abi/services/api_service.dart';
import 'package:abi/models/project.dart';
import 'package:abi/models/task.dart';
import 'package:abi/Thirdpage.dart'; // путь к Thirdpage (у вас может отличаться)

class TaskCreatePage extends StatefulWidget {
  final Project project;
  const TaskCreatePage({required this.project, Key? key}) : super(key: key);

  @override
  _TaskCreatePageState createState() => _TaskCreatePageState();
}

class _TaskCreatePageState extends State<TaskCreatePage> {
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _timeCtrl = TextEditingController();
  String _status = 'To-do';
  bool _loading = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _timeCtrl.dispose();
    super.dispose();
  }

  Future<void> _createTaskAndOpenList() async {
    if (_titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Введите название задачи')));
      return;
    }

    setState(() => _loading = true);
    try {
      final task = Task(
        projectId: widget.project.id!, // Убедись, что ID проекта не null
        title: _titleCtrl.text.trim(),
        time: _timeCtrl.text.trim(),
        status: _status,
      );

      // --- ИСПРАВЛЕНИЕ: Сначала сохраняем в БД ---
      await ApiService.createTask(task);
      // -------------------------------------------

      if (!mounted) return; // Проверка, что экран еще существует

      // Теперь переходим на экран списка задач
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Thirdpage(project: widget.project),
        ),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ошибка создания задачи: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Визуально совпадает с SecondPage: используем похожую разметку, но минимально изменённую
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/MainBg.png"), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Верхняя строка — стрелка назад + заголовок (название проекта)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset("assets/ArrowLeft.png", width: 28),
                    ),
                    Text(
                      'Add Task to "${widget.project.name}"',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Container(width: 28), // пустой элемент для симметрии
                  ],
                ),

                const SizedBox(height: 20),

                // Title
                const Text('Task Title', style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: TextField(
                    controller: _titleCtrl,
                    decoration: const InputDecoration(border: InputBorder.none, hintText: 'Enter task title'),
                  ),
                ),

                const SizedBox(height: 16),

                // Time
                const Text('Time', style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: TextField(
                    controller: _timeCtrl,
                    decoration: const InputDecoration(border: InputBorder.none, hintText: 'e.g. 10:00 AM'),
                  ),
                ),

                const SizedBox(height: 16),

                // Status (dropdown)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                  child: Row(
                    children: [
                      const Text('Status: ', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 12),
                      DropdownButton<String>(
                        value: _status,
                        items: const [
                          DropdownMenuItem(value: 'To-do', child: Text('To-do')),
                          DropdownMenuItem(value: 'In Progress', child: Text('In Progress')),
                          DropdownMenuItem(value: 'Done', child: Text('Done')),
                        ],
                        onChanged: (v) => setState(() => _status = v ?? 'To-do'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                Center(
                  child: ElevatedButton(
                    onPressed: _loading ? null : _createTaskAndOpenList,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Add Task', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
