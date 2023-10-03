import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:confetti/confetti.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> questions = [];
  List<String> correctAnswers = [];
  List<List<String>> answers = [];
  bool checkeScore = false;
  bool started = false;
  Map<String, String> playerAnswers = {};
  int totalScore = 0;
  List<T> insertItemRandomly<T>(List<T> incorrect, T correct) {
    final random = Random();
    final randomIndex = random.nextInt(incorrect.length + 1);
    incorrect.insert(randomIndex, correct);
    return incorrect;
  }

  void fetch() async {
    questions = [];
    answers = [];
    correctAnswers = [];
    playerAnswers = {};
    totalScore = 0;
    checkeScore = false;
    started = true;
    var response = await http.post(Uri.parse(
        'https://opentdb.com/api.php?amount=10&category=31&diffriculty=medium&type=multiple'));
    Map<String, dynamic> jsonData = json.decode(response.body);
    List<dynamic> results = jsonData['results'];
    // print(results);
    for (int i = 0; i < results.length; i++) {
      var cleanDataQuestions = results[i]['question'].replaceAll("&quot;", '"');
      var choices = insertItemRandomly(
          results[i]['incorrect_answers'], results[i]['correct_answer']);
      setState(() {
        questions.add(cleanDataQuestions.replaceAll("&#039;s", '"'));
        answers.add(choices.map((item) => item.toString()).toList());
        correctAnswers.add(results[i]['correct_answer']);
      });
    }

    print(playerAnswers);
    // print(questions.length);
    // print(answers);r
    // setState(() {
    //   text = results[0]['question'].replaceAll("&quot;", "''");
    // });
  }

  void checkAnswers() {
    if (checkeScore) {
      return;
    }
    for (int i = 0; i < correctAnswers.length; i++) {
      if (playerAnswers[(i + 1).toString()] == correctAnswers[i]) {
        setState(() {
          totalScore++;
        });
      }
    }
    checkeScore = true;
    print(correctAnswers);
    print(totalScore);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Quizzical"),
        ),
        body: Column(
          children: [
            !started
                ? Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(top: 180.0),
                        child: Stack(
                          children: [
                            ClipOval(
                              child: SizedBox.fromSize(
                                size: const Size.fromRadius(
                                    150), // Increase the image radius
                                child: Image.network(
                                  'https://media.tenor.com/B4-WJwqtPzUAAAAM/kikuri-hiroi-bocchi-the-rock.gif',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const Positioned(
                              top:
                                  135.0, // Adjust the top position of the text as needed
                              left:
                                  60.0, // Adjust the left position of the text as needed
                              child: Text(
                                'Quizzical Yey!', // Replace with your text
                                style: TextStyle(
                                  color: Colors.pink, // Text color

                                  shadows: [
                                    Shadow(
                                      color: Colors.black, // Shadow color
                                      offset: Offset(
                                          2, 2), // X and Y offset of the shadow
                                      blurRadius:
                                          4, // Blur radius of the shadow
                                    ),
                                  ],
                                  fontSize: 35.0, // Text font size
                                  fontWeight:
                                      FontWeight.bold, // Text font weight
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(),
            Expanded(
              child: Center(
                child: Container(
                  // color: Colors.yellow,

                  child: ListView.builder(
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      return Container(
                        child: Column(children: [
                          Container(
                              width: 400.0,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 30),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.deepPurple,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                "${index + 1}. ${questions[index]}",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: answers[index].length,
                                  itemBuilder:
                                      (BuildContext context, int indexs) {
                                    return Column(
                                      children: [
                                        SizedBox(
                                          width:
                                              300.0, // Set the width as needed
                                          child: TextButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        // checkeScore ? playerAnswers[(index + 1).toString()] == correctAnswers[index] && answers[index][indexs] == correctAnswers[index] ? Colors.green :  Colors.red : Colors.purple[100]
                                                        // checkeScore ? playerAnswers[(index + 1).toString()] != correctAnswers[index] && answers[index][indexs] == playerAnswers[(index + 1).toString()] : Colors.red ?
                                                        // if(checkeScore){
                                                        //   if(playerAnswers[(index + 1).toString()] != correctAnswers[index] && answers[index][indexs] == playerAnswers[(index + 1).toString()] ){
                                                        //     return Colors.red
                                                        //   }else if(playerAnswers[(index + 1).toString()] == correctAnswers[index] && answers[index][indexs] == correctAnswers[index]){
                                                        //     return Colors.green
                                                        //   }else if(answers[index][indexs] == correctAnswers[index]){
                                                        //     return Colors.green
                                                        //   }else{
                                                        //    return Colors.purple[100]
                                                        // }else if(playerAnswers[(index + 1).toString()] == answers[index][indexs]){
                                                        //     return Colors.purple[300]
                                                        //   }
                                                        // }
                                                        checkeScore
                                                            ? (playerAnswers[(index + 1).toString()] !=
                                                                        correctAnswers[
                                                                            index] &&
                                                                    answers[index][indexs] ==
                                                                        playerAnswers[(index +
                                                                                1)
                                                                            .toString()])
                                                                ? Colors.red
                                                                : (playerAnswers[(index + 1).toString()] == correctAnswers[index] &&
                                                                        answers[index][indexs] ==
                                                                            correctAnswers[
                                                                                index])
                                                                    ? Colors
                                                                        .green
                                                                    : (answers[index][indexs] ==
                                                                            correctAnswers[
                                                                                index])
                                                                        ? Colors
                                                                            .green
                                                                        : Colors.purple[
                                                                            100]
                                                            : (playerAnswers[(index + 1).toString()] ==
                                                                    answers[index]
                                                                        [indexs])
                                                                ? Colors.purple[300]
                                                                : Colors.purple[100])),
                                            onPressed: () => setState(() {
                                              if (checkeScore) {
                                                return;
                                              }
                                              playerAnswers[
                                                      (index + 1).toString()] =
                                                  answers[index][indexs];
                                            }),
                                            child: Text(answers[index][indexs],
                                                style: TextStyle(
                                                    color: checkeScore
                                                        ? (playerAnswers[(index +
                                                                            1)
                                                                        .toString()] ==
                                                                    answers[index]
                                                                        [
                                                                        indexs] ||
                                                                answers[index][
                                                                        indexs] ==
                                                                    correctAnswers[
                                                                        index])
                                                            ? Colors.white
                                                            : null
                                                        : (playerAnswers[(index +
                                                                        1)
                                                                    .toString()] ==
                                                                answers[index]
                                                                    [indexs])
                                                            ? Colors.white
                                                            : null)

                                                // if(checkeScore){
                                                //   if(playerAnswers[(index + 1)
                                                //         .toString()] ==
                                                //     answers[index][indexs] ||  answers[index][indexs] == correctAnswer[index]){
                                                //       return Colors.white;
                                                //     }
                                                // }else if(playerAnswers[(index + 1)
                                                //         .toString()] ==
                                                //     answers[index][indexs]){
                                                //       return Colors.white;
                                                //     }
                                                ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ]),
                      );
                    },
                  ),
                ),
              ),
            ),
            playerAnswers.length == 10
                ? Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: SizedBox(
                      width: 250.0,
                      height: 50,
                      child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Colors.deepPurple[300]),
                          ),
                          onPressed: () => checkAnswers(),
                          child: Text(
                            checkeScore
                                ? "Total Score: $totalScore"
                                : "Check Answers",
                            style: const TextStyle(color: Colors.white),
                          )),
                    ))
                : Container(),
          ],
        ),
        floatingActionButton: SizedBox(
          height: 50,
          width: !started ? 150 : 50,
          child: FloatingActionButton(
            onPressed: () => fetch(),
            tooltip: 'Increment',
            child: started
                ? const Icon(Icons.restart_alt_rounded)
                : const Text("Start the Quiz"),
          ),
        ));
  }
}
