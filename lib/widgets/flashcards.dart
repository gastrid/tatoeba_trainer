import 'package:flip_card/flip_card.dart';
import 'package:tatoeba_trainer/widgets/reuseable_card.dart';

import '../models/flashcardSentence.dart';
import 'package:flutter/material.dart';

class Flashcards extends StatefulWidget {
  const Flashcards({Key? key, required List<FlashcardSentence> this.sentences})
      : super(key: key);
  final List<FlashcardSentence> sentences;
  @override
  _FlashcardsState createState() => _FlashcardsState();
}

class _FlashcardsState extends State<Flashcards> {
  int _index = 0;
  late double _dragStartPosition;

  void _onDragStart(DragStartDetails details) {
    _dragStartPosition = details.localPosition.dx;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    var isSwipingLeft = (details.localPosition.dx - _dragStartPosition) < 0;
    if (isSwipingLeft) {
      _previousCard();
    } else {
      _nextCard();
    }
  }

  void _previousCard() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final snackbar = SnackBar(content: Text("swipe left"));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
    setState(() {
      if (_index > 0) {
        _index -= 1;
      }
    });
  }

  void _nextCard() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final snackbar = SnackBar(content: Text("swipe right"));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
    setState(() {
      if (_index < widget.sentences.length - 1) {
        _index += 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.sentences.length > 0
        ? Center(
            child: GestureDetector(
            onHorizontalDragStart: _onDragStart,
            onHorizontalDragUpdate: _onDragUpdate,
            child: Column(
              children: [
                Text("Question $_index of 10 Completed"),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),
                    minHeight: 5,
                    value: 5, // TODO: change
                  ),
                ),
                SizedBox(height: 25),
                SizedBox(
                    width: 300,
                    height: 300,
                    child: FlipCard(
                        direction: FlipDirection.VERTICAL,
                        front: ReusableCard(
                            text: widget.sentences[_index].source.sentence),
                        back: ReusableCard(
                            text:
                                widget.sentences[_index].targets[0].sentence))),
                SizedBox(height: 20),
                // Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                //     children: <Widget>[
                //       ElevatedButton.icon(
                //           onPressed: () {
                //             showPreviousCard();
                //             updateToPrev();
                //           },
                //           icon: Icon(FontAwesomeIcons.handPointLeft, size: 30),
                //           label: Text(""),
                //           style: ElevatedButton.styleFrom(
                //               primary: mainColor,
                //               shape: RoundedRectangleBorder(
                //                   borderRadius: BorderRadius.circular(10)),
                //               padding: EdgeInsets.only(
                //                   right: 20, left: 25, top: 15, bottom: 15))),
                //       ElevatedButton.icon(
                //           onPressed: () {
                //             showNextCard();
                //             updateToNext();
                //           },
                //           icon: Icon(FontAwesomeIcons.handPointRight, size: 30),
                //           label: Text(""),
                //           style: ElevatedButton.styleFrom(
                //               primary: mainColor,
                //               shape: RoundedRectangleBorder(
                //                   borderRadius: BorderRadius.circular(10)),
                //               padding: EdgeInsets.only(
                //                   right: 20, left: 25, top: 15, bottom: 15)))
                //     ])
              ],
            ),
          ))
        : Text("no sentences");
  }
}
