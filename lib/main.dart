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
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
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
  late int selectedAnswerIndex;
  int score = 0;
  int totalQuestions = 0;
  String message = '';
  bool gameOver = false;

  @override
  void initState() {
    super.initState();
    setNewQuestion();
  }

  void setNewQuestion() {
    setState(() {
      if (totalQuestions < animalNames.length) {
        correctAnswerIndex = Random().nextInt(animalNames.length);
        selectedAnswerIndex = -1;
        message = '';
        gameOver = false;
      } else {
        message = 'Game Over! Your final score is $score/${animalNames.length}.';
        gameOver = true;
      }
    });
  }

  void checkAnswer(int index) {
    setState(() {
      selectedAnswerIndex = index;
      if (animalNames[index] == animalNames[correctAnswerIndex]) {
        message = 'Correct!';
        score++;
      } else {
        message = 'Wrong! Try again.';
      }
      totalQuestions++;
      // Automatically move to the next question after a short delay
      Future.delayed(Duration(seconds: 2), () {
        if (totalQuestions < animalNames.length) {
          setNewQuestion();
        } else {
          setState(() {
            message = 'Game Over! Your final score is $score/${animalNames.length}.';
            gameOver = true;
          });
        }
      });
    });
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
            if (!gameOver)
              Column(
                children: [
                  Image.asset(
                    animalImages[correctAnswerIndex],
                    height: 200,
                  ),
                  ...animalNames.asMap().entries.map((entry) {
                    int idx = entry.key;
                    String name = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        onPressed: () => checkAnswer(idx),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: idx == selectedAnswerIndex
                              ? (idx == correctAnswerIndex ? Colors.green : Colors.red)
                              : null,
                        ),
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
            if (gameOver)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      score = 0;
                      totalQuestions = 0;
                      setNewQuestion();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text('Restart'),
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
  List<List<String>> optionsList = [
    ['a', 'o', 'e'],
    ['o', 'a', 'e'],
    ['e', 'a', 'o'],
    ['i', 'a', 'o']
  ];
  late int animalIndex;
  String currentAnswer = '';
  int selectedOptionIndex = -1;

  @override
  void initState() {
    super.initState();
    randomizeOptions();
    setNewQuestion();
  }

  void randomizeOptions() {
    setState(() {
      optionsList = optionsList.map((options) {
        options.shuffle();
        return options;
      }).toList();
    });
  }

  void setNewQuestion() {
    setState(() {
      animalIndex = Random().nextInt(animalNames.length);
      currentAnswer = '';
      selectedOptionIndex = -1;
    });
  }

  void checkAnswer(int optionIndex) {
    setState(() {
      selectedOptionIndex = optionIndex;
      if (optionsList[animalIndex][optionIndex] == correctLetters[animalIndex]) {
        currentAnswer = 'Correct! The answer is ${animalNames[animalIndex]}.';
      } else {
        currentAnswer = 'Wrong! Try again.';
      }
      // Automatically move to the next question after a short delay
      Future.delayed(Duration(seconds: 2), () {
        setNewQuestion();
      });
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
              children: optionsList[animalIndex].asMap().entries.map((entry) {
                int idx = entry.key;
                String option = entry.value;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => checkAnswer(idx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: idx == selectedOptionIndex
                          ? (option == correctLetters[animalIndex] ? Colors.green : Colors.red)
                          : null,
                    ),
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
          ],
        ),
      ),
    );
  }
}
