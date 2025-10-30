import 'package:flutter/material.dart';
import 'package:abi/services/api_service.dart';
import 'package:abi/models/task.dart';


class Thirdpage extends StatefulWidget {
  @override
  _ThirdpageState createState() => _ThirdpageState();
}
class _ThirdpageState extends State<Thirdpage> {
  List<Task> _tasks = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    try {
      final tasks = await ApiService.fetchTasks(); // или fetchTasks(projectId: 1)
      setState(() {
        _tasks = tasks;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ошибка загрузки: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // внутри того же UI, в месте где были статические _buildTaskCard вызовы:
    // заменяем статично заданные карточки на динамические:
    Widget tasksList;
    if (_loading) {
      tasksList = Center(child: CircularProgressIndicator());
    } else if (_tasks.isEmpty) {
      tasksList = const Center(child: Text('No tasks'));
    } else {
      tasksList = Column(
        children: _tasks.map((t) {
          return _buildTaskCard(
            project: 'Project #${t.projectId}',
            title: t.title,
            time: t.time ?? '',
            status: t.status ?? 'To-do',
            statusColor: _statusColor(t.status),
            icon: 'assets/Case.png',
          );
        }).toList(),
      );
    }
    // в основном build — просто вставьте tasksList вместо статичной последовательности карточек.
  }

  Color _statusColor(String? status) {
    switch (status) {
      case 'Done': return Colors.deepPurpleAccent;
      case 'In Progress': return Colors.orange;
      case 'To-do': return Colors.blue;
      default: return Colors.grey;
    }
  }
}

  Widget build(BuildContext context) {
    return Scaffold(
      // чтобы фон шел за нижним меню
      extendBody: true,

      body: Stack(
        children: [
          /// Фон на весь экран
          Positioned.fill(
            child: Image.asset(
              'assets/MainBg.png',
              fit: BoxFit.cover,
            ),
          ),

          /// Контент
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Верхние иконки
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset('assets/ArrowLeft.png', width: 28),
                      const Text(
                        "Today's Tasks",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Image.asset('assets/notification.png', width: 28),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// Даты
                  SizedBox(
                    height: 80,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildDateTile('May', '23', 'Fri', false),
                        _buildDateTile('May', '24', 'Sat', false),
                        _buildDateTile('May', '25', 'Sun', true),  // выбранная дата
                        _buildDateTile('May', '26', 'Mon', false),
                        _buildDateTile('May', '27', 'Tue', false),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Фильтры задач
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildFilterButton("All", true),
                      _buildFilterButton("To do", false),
                      _buildFilterButton("In Progress", false),
                      _buildFilterButton("Completed", false),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// Список задач
                  _buildTaskCard(
                    project: 'Grocery shopping app design',
                    title: 'Market Research',
                    time: '10:00 AM',
                    status: 'Done',
                    statusColor: Colors.deepPurpleAccent,
                    icon: 'assets/Case.png',
                  ),
                  _buildTaskCard(
                    project: 'Grocery shopping app design',
                    title: 'Competitive Analysis',
                    time: '12:00 PM',
                    status: 'In Progress',
                    statusColor: Colors.orange,
                    icon: 'assets/Case.png',
                  ),
                  _buildTaskCard(
                    project: 'Uber Eats redesign challange',
                    title: 'Create Low-fidelity Wireframe',
                    time: '07:00 PM',
                    status: 'To-do',
                    statusColor: Colors.blue,
                    icon: 'assets/Case.png',
                  ),
                  _buildTaskCard(
                    project: 'About design sprint',
                    title: 'How to pitch a Design Sprint',
                    time: '09:00 PM',
                    status: 'To-do',
                    statusColor: Colors.blue,
                    icon: 'assets/Case.png',
                  ),


                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),

      /// Нижняя панель навигации + плавающая кнопка
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        elevation: 4,
        shape: const CircleBorder(),
        onPressed: () {},
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  /// Виджет даты
  Widget _buildDateTile(String month, String day, String weekDay, bool selected) {
    return Container(
      width: 70,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: selected ? Colors.deepPurple : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            month,
            style: TextStyle(
              fontSize: 12,
              color: selected ? Colors.white : Colors.black54,
            ),
          ),
          Text(
            day,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: selected ? Colors.white : Colors.black,
            ),
          ),
          Text(
            weekDay,
            style: TextStyle(
              fontSize: 12,
              color: selected ? Colors.white : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  /// Кнопки фильтров
  Widget _buildFilterButton(String text, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? Colors.deepPurple : Colors.deepPurple[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: selected ? Colors.white : Colors.deepPurple,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Карточка задачи
  Widget _buildTaskCard({
    required String project,
    required String title,
    required String time,
    required String status,
    required Color statusColor,
    required String icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Название проекта и иконка
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                project,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
              Image.asset(icon, width: 20, height: 20),
            ],
          ),
          const SizedBox(height: 8),

          /// Заголовок задачи
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          /// Время и статус
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time, size: 18, color: Colors.deepPurple),
                  const SizedBox(width: 4),
                  Text(
                    time,
                    style: const TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Нижнее меню
  Widget _buildBottomNav() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      color: Colors.white.withOpacity(0.9),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.home_outlined),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.calendar_month_outlined),
              onPressed: () {},
            ),
            const SizedBox(width: 40), // место для FAB
            IconButton(
              icon: const Icon(Icons.description_outlined),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.group_outlined),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

