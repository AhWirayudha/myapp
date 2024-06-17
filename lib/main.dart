import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(AnimalKidGamesApp());
}

class AnimalKidGamesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animal Kid Games',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.orange,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.orange,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            textStyle: TextStyle(fontSize: 18),
          ),
        ),
      ),
      home: MainMenu(),
    );
  }
}

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animal Kid Games'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AnimalGuessingGame()),
                );
              },
              child: Text('Animal Guessing Game'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FixAnimalNameGame()),
                );
              },
              child: Text('Fix Animal Name Game'),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimalGuessingGame extends StatefulWidget {
  @override
  _AnimalGuessingGameState createState() => _AnimalGuessingGameState();
}

class _AnimalGuessingGameState extends State<AnimalGuessingGame> {
  final List<String> animalNames = ['Cat', 'Dog', 'Elephant', 'Lion'];
  final List<String> animalImages = [
    'assets/cat.png',
    'assets/dog.png',
    'assets/elephant.png',
    'assets/lion.png'
  ];
  late int correctAnswerIndex;
  int score = 0;
  int totalQuestions = 0;
  String message = '';

  @override
  void initState() {
    super.initState();
    setNewQuestion();
  }

  void setNewQuestion() {
    setState(() {
      if (totalQuestions < animalNames.length) {
        correctAnswerIndex = Random().nextInt(animalNames.length);
        message = '';
      } else {
        message = 'Game Over! Your final score is $score/${animalNames.length}.';
      }
    });
  }

  void checkAnswer(String selectedAnswer) {
    if (selectedAnswer == animalNames[correctAnswerIndex]) {
      setState(() {
        message = 'Correct!';
        score++;
        totalQuestions++;
      });
    } else {
      setState(() {
        message = 'Wrong! Try again.';
        totalQuestions++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animal Guessing Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (totalQuestions < animalNames.length)
              Column(
                children: [
                  Image.asset(
                    animalImages[correctAnswerIndex],
                    height: 200,
                  ),
                  ...animalNames.map((name) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        onPressed: () => checkAnswer(name),
                        child: Text(name),
                      ),
                    );
                  }).toList(),
                ],
              )
            else
              Text(
                message,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            if (message.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: ElevatedButton(
                  onPressed: setNewQuestion,
                  child: Text('Next'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class FixAnimalNameGame extends StatefulWidget {
  @override
  _FixAnimalNameGameState createState() => _FixAnimalNameGameState();
}

class _FixAnimalNameGameState extends State<FixAnimalNameGame> {
  final List<String> animalNames = ['Cat', 'Dog', 'Elephant', 'Lion'];
  final List<String> animalImages = [
    'assets/cat.png',
    'assets/dog.png',
    'assets/elephant.png',
    'assets/lion.png'
  ];
  final List<String> correctLetters = ['a', 'o', 'e', 'i'];
  final List<List<String>> optionsList = [
    ['a', 'o', 'e'],
    ['o', 'a', 'e'],
    ['e', 'a', 'o'],
    ['i', 'a', 'o']
  ];
  late int animalIndex;
  String currentAnswer = '';

  @override
  void initState() {
    super.initState();
    setNewQuestion();
  }

  void setNewQuestion() {
    setState(() {
      animalIndex = Random().nextInt(animalNames.length);
      currentAnswer = '';
    });
  }

  void checkAnswer(String selectedLetter) {
    setState(() {
      if (selectedLetter == correctLetters[animalIndex]) {
        currentAnswer = 'Correct! The answer is ${animalNames[animalIndex]}.';
      } else {
        currentAnswer = 'Wrong! Try again.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fix Animal Name Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              animalImages[animalIndex],
              height: 200,
            ),
            Text(
              animalNames[animalIndex].replaceFirst(correctLetters[animalIndex], '_'),
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: optionsList[animalIndex].map((option) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => checkAnswer(option),
                    child: Text(option),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text(
              currentAnswer,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: setNewQuestion,
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
