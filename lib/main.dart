import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

void main() {
  runApp(const StoneScissorsPaper());
}

class StoneScissorsPaper extends StatefulWidget {
  const StoneScissorsPaper({Key? key}) : super(key: key);

  @override
  State<StoneScissorsPaper> createState() => _StoneScissorsPaperState();
}

class _StoneScissorsPaperState extends State<StoneScissorsPaper> {

  AudioPlayer player = AudioPlayer();

  int playerCount = 0;
  int gameCount = 0;

  Choice playerChoice = Choice.scissors;
  Choice gameChoice = Choice.scissors;

  String playerChoiceImg = 'assets/paper.png';
  String gameChoiceImg = 'assets/paper.png';

  void onStone() {
    setState(() {
      playerChoice = Choice.stone;
      playerChoiceImg = 'assets/stone.png';
      evaluate();
    });
  }
  void onPaper() {
    setState(() {
      playerChoice = Choice.paper;
      playerChoiceImg = 'assets/paper.png';
      evaluate();
    });
  }
  void onScissors() {
    setState(() {
      playerChoice = Choice.scissors;
      playerChoiceImg = 'assets/scissors.png';
      evaluate();
    });
  }
  void onReset() {
    setState(() {
      playerCount = 0;
      gameCount = 0;
    });
  }
  void doRandomGameChoice() {
    Choice randomChoice = Choice.values[Random().nextInt(Choice.values.length)];
    String img;
    switch (randomChoice) {
      case Choice.stone :
        img = 'assets/stone.png';
        break;
      case Choice.paper :
        img = 'assets/paper.png';
        break;
      default:
        img = 'assets/scissors.png';
        break;
    }

    setState(() {
      gameChoice = randomChoice;
      gameChoiceImg = img;
    });

  }
  void evaluate() {
    setState(() {
      doRandomGameChoice();

      int score = 0;
      if (gameChoice == playerChoice) {
        score = 0;
      }
      else if (gameChoice == Choice.scissors) {
        score += (playerChoice == Choice.stone) ? 1 : -1;
      }
      else if (gameChoice == Choice.paper) {
        score += (playerChoice == Choice.scissors) ? 1 : -1;
      }
      else if (gameChoice == Choice.stone) {
        score += (playerChoice == Choice.paper) ? 1 : -1;
      }

      if (score > 0) {
        playerCount += score;
        playSound('assets/win.wav');
      } else if (score < 0) {
        gameCount -= score;
        playSound('assets/lose.wav');
      } else {
        playSound('assets/draw.wav');
      }
    });
  }

  void playSound(String path) async {
    player.stop();
    ByteData data = await rootBundle.load(path);
    await player.playBytes(data.buffer.asUint8List());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'stone scissors paper',
      home: Scaffold(
        appBar: AppBar (
          title: const Text('Stone Scissors Paper'),
          backgroundColor: Colors.redAccent,
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 20.0),
          child: Column(
            children: [
              //scores
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      const Text('Your score '),
                      Text(
                        '$playerCount',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '$gameCount',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        ),
                      ),
                      const Text(' Game score'),
                    ],
                  ),
                ],
              ),
              const Spacer(),

              //choices
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: Center(
                        child: Image(
                          image: AssetImage(playerChoiceImg),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: Center(
                        child: Image(
                          image: AssetImage(gameChoiceImg),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),

              //buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: onStone,
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.redAccent),

                      ),
                      child: const Text('Stone'),
                  ),
                  ElevatedButton(
                    onPressed: onScissors,
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.redAccent),

                    ),
                    child: const Text('Scissors'),
                  ),
                  ElevatedButton(
                    onPressed: onPaper,
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.redAccent),

                    ),
                    child: const Text('Paper'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: onReset,
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.redAccent),

                    ),
                    child: const Text('Reset'),
                  ),
                ],
              ),
              const Spacer(),
            ],
          )
        )
      ),
    );
  }
}

enum Choice {
  stone,
  paper,
  scissors
}
