import 'package:flutter/foundation.dart';
import 'sentence.dart';

class FlashcardSentence {
  int key;
  SourceSentence source;
  List<TargetSentence> targets;

  FlashcardSentence({
    required this.key,
    required this.source,
  required this.targets,
  });
}


