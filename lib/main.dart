import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'second_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Переменные для состояния чекбоксов
  bool trueFalseChecked = false;
  bool choiceChecked = false;
  late TextEditingController _controller;

  // Переменные для количества заданий
  int trueFalseCount = 1;
  int choiceCount = 1;

  static const int maxCount = 5; // Максимальное значение
  static const int minCount = 1; // Минимальное значение
  static RegExp linkRegExp = RegExp(
    r'(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})',
    caseSensitive: false,
  );

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Чисто белый фон
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Верхняя часть с логотипом
            const Spacer(flex: 1),
            Center(
              child: SvgPicture.asset(
                'assets/logo.svg',
                width: 120,
                height: 120,
              ),
            ),
            const Spacer(flex: 2), // Пространство между логотипом и полем ввода

            // Поле для ввода YouTube-ссылки
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Paste YouTube video link',
                filled: true,
                fillColor: Colors.grey[200], // Светло-серый цвет
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0), // Скругленные края
                  borderSide: BorderSide.none, // Убрать границу
                ),
              ),
            ),
            const SizedBox(height: 50), // Отступ 50 пикселей

            // Нижняя часть с чекбоксами и number selectors
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Choose types of tasks',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),

                    // True / False с кнопками +/-
                    _buildTaskRow(
                      "True / False",
                      trueFalseChecked,
                      trueFalseCount,
                      onCheckboxChanged: (value) {
                        setState(() {
                          trueFalseChecked = value!;
                        });
                      },
                      onIncrement: () {
                        setState(() {
                          if (trueFalseCount < maxCount) trueFalseCount++;
                        });
                      },
                      onDecrement: () {
                        setState(() {
                          if (trueFalseCount > minCount) trueFalseCount--;
                        });
                      },
                    ),

                    // Choice с кнопками +/-
                    _buildTaskRow(
                      "Choice",
                      choiceChecked,
                      choiceCount,
                      onCheckboxChanged: (value) {
                        setState(() {
                          choiceChecked = value!;
                        });
                      },
                      onIncrement: () {
                        setState(() {
                          if (choiceCount < maxCount) {
                            choiceCount++;
                          }
                        });
                      },
                      onDecrement: () {
                        setState(() {
                          if (choiceCount > minCount) {
                            choiceCount--;
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 100), // Отступ 100 пикселей
                  ],
                ),
              ),
            ),

            // Кнопка "Let's go"
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Действие при нажатии

                  String userInput = _controller.text;
                  var match = linkRegExp.firstMatch(userInput);
                  if (match == null) {
                    // Оповестить пользователя о некорректной ссылке
                    _controller.clear();
                  }

                  var uuid = match!.group(1)!;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SecondScreen(
                        videoId: uuid,
                        selectedTasks: {
                          'trueFalse': {
                            'checked': trueFalseChecked,
                            'count': trueFalseCount,
                          },
                          'choice': {
                            'checked': choiceChecked,
                            'count': choiceCount,
                          },
                        },
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(235, 103, 27, 1),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(25.0), // Скругленные края
                  ),
                ),
                child: const Text(
                  "Let's go",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold, // Жирный текст
                  ),
                ),
              ),
            ),
            const Spacer(flex: 1), // Пространство под кнопкой
          ],
        ),
      ),
    );
  }

  // Виджет для строки с задачами
  Widget _buildTaskRow(
    String title,
    bool isChecked,
    int count, {
    required ValueChanged<bool?> onCheckboxChanged,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Row(
      children: [
        Checkbox(
          value: isChecked,
          onChanged: onCheckboxChanged,
          activeColor: const Color.fromRGBO(235, 103, 27, 1),
        ),
        Expanded(
          child: Text(title),
        ),
        IconButton(
          onPressed: onDecrement,
          icon: const Icon(Icons.remove),
          color: const Color.fromRGBO(235, 103, 27, 1),
        ),
        Text(
          count.toString(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: onIncrement,
          icon: const Icon(Icons.add),
          color: const Color.fromRGBO(235, 103, 27, 1),
        ),
      ],
    );
  }
}
