import 'dart:async';
import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pumpkin_app/result_screen.dart';
import 'package:pumpkin_app/top_bar.dart';

class SecondScreen extends StatefulWidget {
  final Map<String, Map<String, dynamic>> selectedTasks;
  final String videoId;

  const SecondScreen(
      {required this.selectedTasks, required this.videoId, super.key});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  final Map<int, bool> trueFalseAnswers = {};
  final Map<int, String?> choiceAnswers = {};

  final Map<int, bool> correctTrueFalseAnswers =
      {}; // Правильные true/false ответы
  final Map<int, String> correctChoiceAnswers = {}; // Правильные choice ответы

  late Map<String, dynamic> serverResponse;

  late Future<Map<String, dynamic>?> futureQuestions;
  late Future<String?> futureTitle;

  @override
  void initState() {
    super.initState();
    futureQuestions = _fetchQuestions();
    futureTitle = _fetchTitle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            const TopBar(),
            const SizedBox(height: 20),
            FutureBuilder<String?>(
              future: futureTitle,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    snapshot.data!,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
            const SizedBox(height: 50),
            const Text(
              'Tasks',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: FutureBuilder<Map<String, dynamic>?>(
                  future: futureQuestions,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var data = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (data.containsKey('true_false'))
                            _buildTrueFalseSection(
                              taskTitle: "True / False",
                              questions: data['true_false'],
                            ),
                          if (data.containsKey('choice'))
                            _buildChoiceSection(
                              taskTitle: "Choice",
                              questions: data['choice'],
                            ),
                        ],
                      );
                    }
                    return const CircularProgressIndicator();
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _handleCheckButtonPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(235, 103, 27, 1),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                child: const Text(
                  "Check",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildTrueFalseSection({
    required String taskTitle,
    required List<dynamic> questions,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color.fromRGBO(235, 103, 27, 1),
                  width: 2,
                ),
              ),
              child: const Center(
                child: Text(
                  '1', // Номер секции
                  style: TextStyle(
                    color: Color.fromRGBO(235, 103, 27, 1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              taskTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...questions.asMap().entries.map((entry) {
          int index = entry.key;
          String question = entry.value['question'];
          return _buildTrueFalseQuestion(question, index);
        }),
      ],
    );
  }

  Widget _buildTrueFalseQuestion(String question, int questionIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "${questionIndex + 1}. ", // Номер вопроса
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Text(
                  question,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: RadioListTile<bool>(
                  value: true,
                  groupValue: trueFalseAnswers[questionIndex],
                  onChanged: (value) {
                    setState(() {
                      trueFalseAnswers[questionIndex] = value!;
                    });
                  },
                  activeColor: const Color.fromRGBO(235, 103, 27, 1),
                  title: const Text('True'),
                ),
              ),
              Expanded(
                child: RadioListTile<bool>(
                  value: false,
                  groupValue: trueFalseAnswers[questionIndex],
                  onChanged: (value) {
                    setState(() {
                      trueFalseAnswers[questionIndex] = value!;
                    });
                  },
                  activeColor: const Color.fromRGBO(235, 103, 27, 1),
                  title: const Text('False'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChoiceSection({
    required String taskTitle,
    required List<dynamic> questions,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color.fromRGBO(235, 103, 27, 1),
                  width: 2,
                ),
              ),
              child: const Center(
                child: Text(
                  '2', // Номер секции
                  style: TextStyle(
                    color: Color.fromRGBO(235, 103, 27, 1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              taskTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...questions.asMap().entries.map((entry) {
          int index = entry.key;
          String question = entry.value['question'];
          List<dynamic> variants = entry.value['variants'];

          return _buildChoiceQuestion(question, variants, index);
        }),
      ],
    );
  }

  Widget _buildChoiceQuestion(
      String question, List<dynamic> variants, int questionIndex) {
    if (!choiceAnswers.containsKey(questionIndex)) {
      choiceAnswers[questionIndex] = null;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "${questionIndex + 1}. ", // Номер вопроса
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Text(
                  question,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Column(
            children: variants.map((variant) {
              return RadioListTile<String>(
                value: variant,
                groupValue: choiceAnswers[questionIndex],
                onChanged: (value) {
                  setState(() {
                    choiceAnswers[questionIndex] = value;
                  });
                },
                activeColor: const Color.fromRGBO(235, 103, 27, 1),
                title: Text(variant, style: const TextStyle(fontSize: 16)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Future<String?> _fetchTitle() async {
    final String url =
        'http://localhost:8000/title/?video_id=${widget.videoId}';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as Map<String, dynamic>;
      return json['title'];
    }
    return null;
  }

  Future<Map<String, dynamic>?> _fetchQuestions() async {
    Map<String, int> questionTypes = {};
    if (widget.selectedTasks['trueFalse']!['checked']) {
      questionTypes['true_false'] = widget.selectedTasks['trueFalse']!['count'];
    }
    if (widget.selectedTasks['choice']!['checked']) {
      questionTypes['choice'] = widget.selectedTasks['choice']!['count'];
    }

    var requestBody = json.encode({
      'video_id': widget.videoId,
      'question_types': questionTypes,
    });

    var response = await http.post(
      Uri.parse('http://localhost:8000/questions'),
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as Map<String, dynamic>;

      print("Response from server: $json");

      serverResponse = json; // Сохраняем полный ответ сервера
      _parseCorrectAnswers(json);
      return json;
    } else {
      print("Failed to fetch questions. Status code: ${response.statusCode}");
    }
    return null;
  }

  void _parseCorrectAnswers(Map<String, dynamic> data) {
    print("Parsing correct answers...");

    // Обработка True/False вопросов
    if (data.containsKey('true_false')) {
      print("True/False questions: ${data['true_false']}");
      List<dynamic> trueFalseQuestions = data['true_false'];
      for (int i = 0; i < trueFalseQuestions.length; i++) {
        correctTrueFalseAnswers[i] = trueFalseQuestions[i]['answer'];
      }
    } else {
      print("No 'true_false' key in the response.");
    }

    // Обработка Choice вопросов
    if (data.containsKey('choice')) {
      print("Choice questions: ${data['choice']}");
      List<dynamic> choiceQuestions = data['choice'];
      for (int i = 0; i < choiceQuestions.length; i++) {
        correctChoiceAnswers[i] =
            choiceQuestions[i]['variants'][choiceQuestions[i]['answer']];
      }
    } else {
      print("No 'choice' key in the response.");
    }

    print("Correct True/False Answers: $correctTrueFalseAnswers");
    print("Correct Choice Answers: $correctChoiceAnswers");
  }

  void _handleCheckButtonPressed() {
    print("User's True/False Answers: $trueFalseAnswers");
    print("User's Choice Answers: $choiceAnswers");
    print("Correct True/False Answers: $correctTrueFalseAnswers");
    print("Correct Choice Answers: $correctChoiceAnswers");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          userTrueFalseAnswers: trueFalseAnswers,
          userChoiceAnswers: choiceAnswers,
          correctTrueFalseAnswers: correctTrueFalseAnswers,
          correctChoiceAnswers: correctChoiceAnswers,
          serverResponse: serverResponse,
        ),
      ),
    );
  }
}
