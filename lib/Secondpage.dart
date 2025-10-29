import 'package:flutter/material.dart';
import 'package:abi/Thirdpage.dart';


class SecondPage extends StatelessWidget {
  @override
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
                  _buildTextField("Project Name", "Grocery Shopping App"),

                  const SizedBox(height: 16),

                  /// Description
                  _buildDescriptionField(),

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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Thirdpage() ),

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
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 80, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Add Project",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
  Widget _buildTextField(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  /// Поле для описания
  Widget _buildDescriptionField() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Description",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          SizedBox(height: 6),
          Text(
            "This application is designed for super shops. By using this application they can enlist all their products in one place and can deliver. Customers will get a one-stop solution for their daily shopping.",
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

