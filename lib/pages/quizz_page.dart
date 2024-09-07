import 'package:flutter/material.dart';
import 'package:quizz/datas/app_datas.dart';
import 'package:quizz/model/Question.dart';

class QuizzPage extends StatefulWidget {

  const QuizzPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _QuizzPageState();
  }

}

class _QuizzPageState extends State<QuizzPage> {
  int _score = 0;
  int _index = 0;
  final List<Question> _questions = AppDatas().listeQuestions;
  final EdgeInsets _insets =  const EdgeInsets.all(16);

  void _answerQuestion() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: _insets,
                  child: Text(
                    "Ma réponse est:",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                answerRow("C'est vrai", Icons.check, Colors.green, true),
                answerRow("C'est faux", Icons.cancel_outlined, Colors.red, false),
                answerRow("Je ne sais pas", Icons.question_mark, Colors.grey, null)
              ],
            ),
          );
        }
    );
  }
  
  InkWell answerRow(String text, IconData iconData, Color color, bool? isTrue) {
    return InkWell(
      onTap: () {
        _checkAnswer(isTrue);
      },
      child: Padding(
        padding: _insets,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData, color: color,),
            const SizedBox(width: 32),
            Text(text)
          ],
        ),
      ),
    );
  }

  void _checkAnswer(bool? isTrue) {
    Navigator.pop(context);
    if (isTrue == null) {
      return;
    }
    final question = _questions[_index];
    final answer = question.reponse;
    final myAnswer = isTrue! == answer;
    if (myAnswer == true) {
      setState(() {
        _score++;
      });
    }
    _showAnswer(myAnswer, question);

  }

  void _showAnswer(bool isSuccess, Question question) {
    String title = (isSuccess) ? "C'est gagné" : "Raté!";
    String img = (isSuccess) ? 'vrai.jpg': "faux.jpg";
    String imageUrl = "images/$img";
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(imageUrl),
                Text(question.explication)
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    toNextQuestion();
                },
                  child: const Text("OK")
              )
            ],
          );
        }
    );
  }

  void toNextQuestion() {
    if (_index < _questions.length - 1) {
      setState(() {
        _index++;
      });
    } else {
      finalPop();
    }
  }

  void finalPop() {
    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("C'est fini pour le quizz !"),
            content: Text("Votre score est de $_score points"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text("OK")
              )
            ],
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    Question question = _questions[_index];
    return Scaffold(
      appBar: AppBar(
        title: Text("Score: $_score"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Text(
              "Question numéro: ${_index + 1} / ${_questions.length}",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Card(
            clipBehavior: Clip.antiAlias,
            margin: _insets,
            elevation: 7,
            child: Column(
              children: [
                Image.asset(question.imageString),
                Padding(
                    padding: _insets,
                  child: Text(
                      question.question,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary
                    ),
                  ),
                )
              ],
            ),
          ),
          OutlinedButton(
              onPressed: _answerQuestion,
              child: const Text("Je réponds")
          )
        ],
      ),
    );
  }
}