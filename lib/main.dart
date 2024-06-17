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
        primarySwatch: Colors.blue,
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

  @override
  void initState() {
    super.initState();
    setNewQuestion();
  }

  void setNewQuestion() {
    setState(() {
      correctAnswerIndex = Random().nextInt(animalNames.length);
    });
  }

  void checkAnswer(String selectedAnswer) {
    final snackBar = SnackBar(
      content: Text(
          selectedAnswer == animalNames[correctAnswerIndex] ? 'Correct!' : 'Wrong! Try again.'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    setNewQuestion();
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
