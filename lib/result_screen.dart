import 'package:flutter/material.dart';
import 'package:pumpkin_app/main.dart';
import 'package:pumpkin_app/top_bar.dart';

class ResultScreen extends StatelessWidget {
  final Map<int, bool> userTrueFalseAnswers;
  final Map<int, String?> userChoiceAnswers;
  final Map<int, bool> correctTrueFalseAnswers;
  final Map<int, String> correctChoiceAnswers;
  final Map<String, dynamic> serverResponse; // Новый параметр

  const ResultScreen({
    super.key,
    required this.userTrueFalseAnswers,
    required this.userChoiceAnswers,
    required this.correctTrueFalseAnswers,
    required this.correctChoiceAnswers,
    required this.serverResponse, // Новый параметр
  });

  @override
  Widget build(BuildContext context) {
    final trueFalseScore =
        _calculateScore(userTrueFalseAnswers, correctTrueFalseAnswers);
    final choiceScore =
        _calculateScore(userChoiceAnswers, correctChoiceAnswers);

    final totalQuestions =
        userTrueFalseAnswers.length + userChoiceAnswers.length;
    final totalScore = trueFalseScore + choiceScore;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            const TopBar(), // Верхняя панель
            const SizedBox(height: 20),
            const Text(
              'Your Score',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                '$totalScore / $totalQuestions',
                style: const TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildResultSection(
                      'True/False',
                      userTrueFalseAnswers,
                      correctTrueFalseAnswers,
                      1, // Номер секции
                    ),
                    _buildResultSection(
                      'Choice',
                      userChoiceAnswers,
                      correctChoiceAnswers,
                      2, // Номер секции
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MainScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(235, 103, 27, 1),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                child: const Text(
                  'Restart with new link',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  int _calculateScore<K>(
      Map<K, dynamic> userAnswers, Map<K, dynamic> correctAnswers) {
    int score = 0;
    userAnswers.forEach((index, answer) {
      if (correctAnswers.containsKey(index) &&
          correctAnswers[index] == answer) {
        score++;
      }
    });
    return score;
  }

  String _getQuestionText(int index, String type) {
    // Определяем правильный ключ для типа вопросов
    final key = type == "choice" ? "choice" : "true_false";

    // Получаем список вопросов по ключу
    final questions = serverResponse[key];

    // Проверяем, существует ли список и корректен ли индекс
    if (questions != null && index >= 0 && index < questions.length) {
      return questions[index]['question'] ?? 'No question text available';
    }

    // Возвращаем сообщение, если вопрос не найден
    return 'Question not found';
  }

  Widget _buildResultSection<K>(String title, Map<K, dynamic> userAnswers,
      Map<K, dynamic> correctAnswers, int sectionNumber) {
    if (userAnswers.isEmpty || correctAnswers.isEmpty) {
      return const SizedBox.shrink();
    }

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
              child: Center(
                child: Text(
                  '$sectionNumber',
                  style: const TextStyle(
                    color: Color.fromRGBO(235, 103, 27, 1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...userAnswers.keys.map((index) {
          final userAnswer = userAnswers[index];
          final correctAnswer = correctAnswers[index];
          final isCorrect = userAnswer != null &&
              correctAnswer != null &&
              userAnswer == correctAnswer;

          // Приведение индекса к типу int
          final questionText =
              _getQuestionText(index as int, title.toLowerCase());

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${index+1}. $questionText', // Номер и текст вопроса
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  'Your Answer: ${userAnswer ?? "-"}\nCorrect Answer: ${correctAnswer ?? "-"}',
                  style:
                      TextStyle(color: isCorrect ? Colors.green : Colors.red),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 20),
      ],
    );
  }
}
