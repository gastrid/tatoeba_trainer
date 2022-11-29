import 'package:flutter/foundation.dart';

class SourceSentence {
  String id;
  String lang;
  String sentence;

  SourceSentence({
    required this.id,
  required this.lang,
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
  String id;
  String source_id;
  String lang;
  String sentence;
  bool saved;
  bool hide;

  TargetSentence({
    required this.id,
  required this.source_id,
  required this.lang,
  required this.sentence,
  required this.saved,
  required this.hide,
  });

  @override
  String toString() {
    return """
    id: ${this.id},
    source_id: ${this.source_id},
    lang: ${this.lang},
    sentence: ${this.sentence},
    saved: ${this.saved},
    hide: ${this.hide},
""";
  }
}
