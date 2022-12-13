import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:tatoeba_trainer/widgets/reuseable_card.dart';
import 'package:provider/provider.dart';
import 'package:tatoeba_trainer/providers/db_provider.dart';

import '../models/flashcardSentence.dart';
import 'package:flutter/material.dart';

class Flashcards extends StatefulWidget {
  const Flashcards({Key? key, required List<FlashcardSentence> this.sentences, this.isChinese = false})
      : super(key: key);
  final List<FlashcardSentence> sentences;
  final bool isChinese;
  @override
  _FlashcardsState createState() => _FlashcardsState();
}

enum SwipeDirection {
  left,
  right
}

class _FlashcardsState extends State<Flashcards> {
  int _index = 0;
  late FlashcardSentence _currentCard;
  double _progressValue = 0.1;
  SwipeDirection swipeDirection = SwipeDirection.left;
  late double _dragStartPosition;
  late int _deckLength;

  final flipcardController = FlipCardController();

  @override
  void initState() {
    _deckLength = widget.sentences.length;
    _currentCard = widget.sentences[_index];
    super.initState();
  }


  void _onDragStart(DragStartDetails details) {
    _dragStartPosition = details.localPosition.dx;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if ((details.localPosition.dx - _dragStartPosition) < -20) {
      swipeDirection = SwipeDirection.right;
    } else if ((details.localPosition.dx - _dragStartPosition) > 20) {
      swipeDirection = SwipeDirection.left;
    }
  }

  void _onDragEnd(DragEndDetails _) {
    if (swipeDirection == SwipeDirection.left) {
      _previousCard();
    } else if (swipeDirection == SwipeDirection.right) {
      _nextCard();
    }
    flipcardController.controller!.reset();
  }

  void _previousCard() {
    setState(() {
      if (_index > 0) {
        _index -= 1;
        _currentCard = widget.sentences[_index];
        _updateProgressValue();
      }
    });
  }

  void _nextCard() {
    setState(() {
      if (_index < _deckLength - 1) {
        _index += 1;
        _currentCard = widget.sentences[_index];
        _updateProgressValue();
      }
    });
  }

  void _updateProgressValue() {
    _progressValue = (_index + 1) / _deckLength;
  }

    void _toggleSaved(int id, bool saved) {
      setState(() {
      _currentCard.target.saved = !saved;
      });
    if (!saved) {
      Provider.of<DbProvider>(context, listen: false).saveSentence(id);
    } else {
      Provider.of<DbProvider>(context, listen: false).unsaveSentence(id);
    }
  }

  void _toggleHide(int id, bool hidden) {
    setState(() {
      _currentCard.target.hide = !hidden;
    });
    if (!hidden) {
      Provider.of<DbProvider>(context, listen: false).hideSentence(id);
    } else {
      Provider.of<DbProvider>(context, listen: false).unhideSentence(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _deckLength > 0
        ? Center( // TODO: look into swipe animations
            child: GestureDetector(
            onHorizontalDragStart: _onDragStart,
            onHorizontalDragUpdate: _onDragUpdate,
            onHorizontalDragEnd: _onDragEnd,
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
                    value: _progressValue, // TODO: change
                  ),
                ),
                SizedBox(height: 25),
                SizedBox(
                    width: 300,
                    height: 300,
                    child: FlipCard(
                      controller: flipcardController,
                        direction: FlipDirection.VERTICAL,
                        front: ReusableCard(
                            text: _currentCard.source.sentence),
                        back: ReusableCard(
                            text:
                                _currentCard.target.sentence,
                            pinyin: widget.isChinese ? PinyinHelper.getPinyin(
                              _currentCard.target.sentence, format: PinyinFormat.WITH_TONE_MARK) : null,))),
                SizedBox(height: 20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      ElevatedButton.icon(
                          onPressed: () {
                            _toggleSaved(
                              _currentCard.target.id,
                              _currentCard.target.saved);
                          },
                          icon: _currentCard.target.saved ?
                            Icon(Icons.favorite, size: 30, color: Colors.red,) :
                            Icon(Icons.favorite_border, size: 30),
                          label: Text(""),
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.only(
                                  right: 20, left: 25, top: 15, bottom: 15))),
                      ElevatedButton.icon(
                          onPressed: () {
                            _toggleHide(
                              _currentCard.target.id,
                              false);
                          },
                          icon: _currentCard.target.hide ? 
                          Icon(Icons.not_interested, size: 30, color: Colors.black) :
                          Icon(Icons.not_interested, size: 30),
                          label: Text(""),
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              padding: EdgeInsets.only(
                                  right: 20, left: 25, top: 15, bottom: 15)))
                    ])
              ],
            ),
          ))
        : Text("no sentences");
  }
}
