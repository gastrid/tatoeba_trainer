import 'package:flutter/foundation.dart';

class SourceSentence {
  int id;
  String lang;
  String sentence;

  SourceSentence({
    required this.id,
  this.lang = "english",
  required this.sentence,
  });

  @override
  String toString() {
    return """
    id: ${this.id},
    lang: ${this.lang},
    sentence: ${this.sentence},
""";
  }
}

class TargetSentence {
  int id;
  // String source_id;
  String lang;
  String sentence;
  bool saved;
  bool hide;

  TargetSentence({
    required this.id,
  // required this.source_id,
  required this.lang,
  required this.sentence,
  this.saved = false,
  this.hide = false,
  });

  @override
  String toString() {
    return """
    id: ${this.id},
    lang: ${this.lang},
    sentence: ${this.sentence},
    saved: ${this.saved},
    hide: ${this.hide},
""";
  }
}
