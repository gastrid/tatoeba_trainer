import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:tatoeba_trainer/widgets/reuseable_card.dart';
import 'package:lpinyin/lpinyin.dart';


import '../models/flashcardSentence.dart';

class Flashcard extends StatefulWidget {
  const Flashcard(
      {Key? key,
      required FlashcardSentence this.sentence,
      this.isChinese = false})
      : super(key: key);

  final FlashcardSentence sentence;
  final bool isChinese;

  @override
  _FlashcardState createState() => _FlashcardState();
}

class _FlashcardState extends State<Flashcard> {
  final flipcardController = FlipCardController();

  void reset() {
    flipcardController.controller!.reset();
  }

  @override
  Widget build(BuildContext context) {
    return FlipCard(
        controller: flipcardController,
        direction: FlipDirection.VERTICAL,
        front: ReusableCard(text: widget.sentence.source.sentence),
        back: ReusableCard(
          text: widget.sentence.target.sentence,
          pinyin: widget.isChinese
              ? PinyinHelper.getPinyin(widget.sentence.target.sentence,
                  format: PinyinFormat.WITH_TONE_MARK)
              : null,
        ));
  }
}
