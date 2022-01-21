// ignore_for_file: camel_case_types, curly_braces_in_flow_control_structures, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(title: const Text('Tic Tac Toe')),
          body: Center(child: tictactoe()),
        ));
  }
}

class tictactoe extends StatelessWidget {
  tictactoe({Key? key}) : super(key: key);
  var mygrid;
  final ValueNotifier<String> text = ValueNotifier<String>('Next turn is 0');
  void setText(String inn) {
    text.value = inn;
  }

  @override
  Widget build(BuildContext context) {
    mygrid = board_grid(setText);
    return Column(children: [
      Container(
        child: const Text('Tic Tac Toe', style: TextStyle(fontSize: 25)),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      ),
      Expanded(
          flex: 2,
          child: AspectRatio(
              //constraints: BoxConstraints(maxHeight: 300, maxWidth: 100),
              aspectRatio: 1 / 1,
              child: Column(children: [
                mygrid,
              ]))),
      ValueListenableBuilder<String>(
        valueListenable: text,
        builder: (BuildContext context, String value, Widget? child) {
          return Text(value);
        },
      ),
      Expanded(
          child: Center(
              child: Row(
            children: [
              TextButton(onPressed: mygrid.reset, child: const Text('reset')),
              TextButton(
                  onPressed: () => {mygrid.ai_easy(context)},
                  child: const Text('Ai Easy')),
              TextButton(
                  onPressed: () => mygrid.ai_med(context),
                  child: const Text('Ai Medium')),
              TextButton(
                  onPressed: () => mygrid.ai_hard(context),
                  child: const Text('Ai Hard')),
              TextButton(
                  onPressed: () => mygrid.ai_harder(context),
                  child: const Text('Ai Harder')),
              TextButton(
                  onPressed: () => mygrid.ai_hardest(context),
                  child: const Text('Ai Hardest')),
            ],
          )),
          flex: 1)
    ]);
  }
}

class board_grid extends StatelessWidget {
  Function settext;
  bool play = true;
  int turn = 1;
  var board;
  var board_state = List.generate(9, (index) => 0);

  //Ai 1
  void ai_easy(BuildContext context) {
    if (play == false) return;

    for (int c = 0; c < 9; c++) {
      if (board_state[c] == 0) {
        board[c].taketurn(_getturn(c, context));
        break;
      }
    }
  }

  void ai_med(BuildContext context) {
    if (play == false) return;

    var possible = [];

    for (int c = 0; c < 9; c++) {
      if (board_state[c] == 0) possible.add(c);
    }
    final rand = math.Random();
    int index = possible[rand.nextInt(possible.length)];
    board[index].taketurn(_getturn(index, context));
  }

  void ai_hard(BuildContext context) {
    if (play == false) return;

    int res = checkwincondition(turn);
    if (res == -1)
      ai_med(context);
    else {
      board[res].taketurn(_getturn(res, context));
    }
  }

  void ai_harder(BuildContext context) {
    if (play == false) return;

    int res = checkwincondition(turn);
    if (res == -1) {
      res = checkwincondition(turn == 1 ? 2 : 1);
      if (res == -1)
        ai_hard(context);
      else {
        board[res].taketurn(_getturn(res, context));
      }
    } else {
      board[res].taketurn(_getturn(res, context));
    }
  }

  void ai_hardest(BuildContext context) {
    if (play == false) return;
    int res = checkwincondition(turn);

    if (res == -1) {
      res = checkwincondition(turn == 1 ? 2 : 1);
      if (res == -1) {
        if (board_state[4] == 0) {
          board[4].taketurn(_getturn(4, context));
        } else {
          var corners = [0, 2, 6, 8];
          bool worked = false;
          for (int c = 0; c < 4; c++) {
            if (board_state[corners[c]] == 0) {
              board[corners[c]].taketurn(_getturn(corners[c], context));
              worked = true;
              break;
            }
          }
          if (!worked) ai_med(context);
        }
      } else {
        board[res].taketurn(_getturn(res, context));
      }
    } else {
      board[res].taketurn(_getturn(res, context));
    }
  }

  int checkwincondition(valTurn) {
    //check rows
    for (int c = 0; c < 7; c += 3)
      if (checkifpossible(valTurn, c, c + 1, c + 2) != -1)
        return checkifpossible(valTurn, c, c + 1, c + 2);

    //check cols
    for (int c = 0; c < 3; c++)
      if (checkifpossible(valTurn, c, c + 3, c + 6) != -1)
        return checkifpossible(valTurn, c, c + 3, c + 6);

    //check diagonals
    if (checkifpossible(valTurn, 0, 4, 8) != -1)
      return checkifpossible(valTurn, 0, 4, 8);
    if (checkifpossible(valTurn, 2, 4, 6) != -1)
      return checkifpossible(valTurn, 2, 4, 6);
    return -1;
  }

  int checkifpossible(checkTurn, val1, val2, val3) {
    if (board_state[val1] == checkTurn &&
        board_state[val2] == checkTurn &&
        board_state[val3] == 0) return val3;
    if (board_state[val2] == checkTurn &&
        board_state[val1] == 0 &&
        board_state[val3] == checkTurn) return val1;
    if (board_state[val1] == checkTurn &&
        board_state[val3] == checkTurn &&
        board_state[val2] == 0) return val2;
    return -1;
  }

  ValueNotifier<bool> resetme = ValueNotifier(false);
  bool getplay() {
    return play;
  }

  board_grid(this.settext, {Key? key}) : super(key: key) {
    board =
        List.generate(9, (index) => square(index, _getturn, resetme, getplay));
  }

  void _showWinDialog(String winner, BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('$winner is winner'),
            actions: [
              TextButton(
                child: const Text('Play Again'),
                onPressed: () {
                  Navigator.of(context).pop();
                  reset();
                },
              ),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Ok'))
            ],
          );
        });
  }

  void _showDrawDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Draw'),
            actions: [
              TextButton(
                child: const Text('Play Again'),
                onPressed: () {
                  Navigator.of(context).pop();
                  reset();
                },
              ),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Ok'))
            ],
          );
        });
  }

  int _getturn(int index, BuildContext context) {
    board_state[index] = turn;
    settext('Next turn is ' + (turn == 1 ? 'X' : 'O'));
    turn = turn == 1 ? 2 : 1;
    if (checkwinner() != -1 && checkwinner() != 0) {
      play = false;
      for (int c = 0; c < 9; c++) {
        print(c);
        print(board_state[c]);
      }
      _showWinDialog(checkwinner() == 1 ? 'O' : 'X', context);
    } else if (checkwinner() == 0) {
      _showDrawDialog(context);
    }
    return turn;
  }

  int checkwinner() {
    for (int c = 0; c < 7; c += 3)
      if (board_state[c] == board_state[c + 1] &&
          board_state[c + 1] == board_state[c + 2] &&
          board_state[c] != 0) return board_state[c];
    for (int c = 0; c < 3; c++)
      if (board_state[c] == board_state[c + 3] &&
          board_state[c + 3] == board_state[c + 6] &&
          board_state[c] != 0) return board_state[c];

    if (board_state[0] == board_state[4] &&
        board_state[0] == board_state[8] &&
        board_state[4] != 0) return board_state[0];
    if (board_state[2] == board_state[4] &&
        board_state[2] == board_state[6] &&
        board_state[4] != 0) return board_state[2];
    bool full = true;
    for (int c = 0; c < 9; c++) {
      if (board_state[c] == 0) {
        full = false;
        break;
      }
    }
    return full ? 0 : -1;
  }

  void reset() {
    for (int c = 0; c < 9; c++) board_state[c] = 0;
    board.forEach((element) => element.reset());
    play = true;
    resetme.value = !resetme.value;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 1 / 1,
        child: GridView.count(
          crossAxisCount: 3,
          children: board,
          crossAxisSpacing: 0,
        ));
  }
}

class square extends StatefulWidget {
  final int index;
  final Function func;
  var iconstate = null;
  bool enabled = true;
  Function getplay;
  ValueNotifier<bool> change;
  square(this.index, this.func, this.change, this.getplay, {Key? key})
      : super(key: key);

  void reset() {
    iconstate = null;
    enabled = true;
  }

  void taketurn(int turn) {
    enabled = false;
    iconstate = turn == 1 ? const Icon(Icons.add) : const Icon(Icons.circle);
    change.value = !change.value;
  }

  @override
  _squareState createState() => _squareState();
}

class _squareState extends State<square> {
  void _settype(BuildContext context) {
    if (widget.getplay() == false) return;
    var turn = widget.func(widget.index, context);
    setState(() {
      widget.iconstate =
          turn == 1 ? const Icon(Icons.add) : const Icon(Icons.circle);
      widget.enabled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
        child: Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: Transform.rotate(
                angle: -math.pi / 4,
                child: ValueListenableBuilder<bool>(
                    builder: (BuildContext context, bool value, Widget? child) {
                      return IconButton(
                          icon: widget.iconstate ?? Container(),
                          color: Colors.black,
                          onPressed: widget.enabled
                              ? () => _settype(context)
                              : () => {});
                    },
                    valueListenable: widget.change))));
  }
}
