import 'package:flutter/material.dart';
import 'package:abi/Thirdpage.dart';

import 'package:abi/services/api_service.dart';
import 'package:abi/models/project.dart';
import 'TaskCreatePage.dart';



class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}
  class _SecondPageState extends State<SecondPage> {
  final _nameCtrl = TextEditingController(text: 'Grocery Shopping App');
  final _descCtrl = TextEditingController(text: 'This application is designed for super shops...');
  bool _loading = false;

  @override
  void dispose() {
  _nameCtrl.dispose();
  _descCtrl.dispose();
  super.dispose();
  }



  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/MainBg.png"), // задний фон
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// Верхние иконки (назад и уведомления)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset("assets/ArrowLeft.png", width: 28),
                      Image.asset("assets/notification.png", width: 28),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// Заголовок
                  Center(
                    child: Text(
                      "Add Project",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Task Group
                  _buildDropdownTile(
                    icon: "assets/Case.png",
                    title: "Task Group",
                    value: "Work",
                  ),

                  const SizedBox(height: 16),

                  /// Project Name
                  _buildTextField("Project Name", _nameCtrl),

                  const SizedBox(height: 16),

                  /// Description
                _buildDescriptionField(_descCtrl),


                  const SizedBox(height: 16),

                  /// Start Date
                  _buildDropdownTile(
                    icon: "assets/Calendar.png",
                    title: "Star Date",
                    value: "01 May, 2022",
                  ),

                  const SizedBox(height: 16),

                  /// End Date
                  _buildDropdownTile(
                    icon: "assets/Calendar.png",
                    title: "End Date",
                    value: "30 June, 2022",
                  ),

                  const SizedBox(height: 16),

                  /// Logo
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset("assets/LogoExample.png",
                            width: 60, height: 60),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          final stubProject = Project(name: 'Stub', description: 'N/A');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Thirdpage(project: stubProject), // <--- ПЕРЕДАЛИ ОБЪЕКТ
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("Change Logo",
                            style: TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  /// Add Project button
                  Center(
                    child: ElevatedButton(
                      onPressed: _loading ? null : () async {
                        setState(() => _loading = true);
                        try {
                          final project = Project(name: _nameCtrl.text, description: _descCtrl.text);
                          final created = await ApiService.createProject(project);
                          // можно показать SnackBar и вернуться
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Project created: ${created.name}')));
                          // импорт: import 'package:abi/task_create_page.dart';
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskCreatePage(project: created),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                        } finally {
                          setState(() => _loading = false);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _loading ? CircularProgressIndicator(color: Colors.white) : const Text("Add Project", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Виджет для инпутов типа "Task Group", "Start Date", "End Date"
  Widget _buildDropdownTile({
    required String icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Image.asset(icon, width: 24, height: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                Text(value,
                    style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Image.asset("assets/ArrowRight.png", width: 20, height: 20),
        ],
      ),
    );
  }

  /// Текстовое поле для названия проекта
  Widget _buildTextField(String label, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            decoration: const InputDecoration(border: InputBorder.none),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  /// Поле для описания
  Widget _buildDescriptionField(TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Description", style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            maxLines: 4,
            decoration: const InputDecoration(border: InputBorder.none),
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

