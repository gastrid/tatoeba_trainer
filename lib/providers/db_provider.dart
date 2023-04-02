import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:tatoeba_trainer/models/flashcardSentence.dart';

import 'package:sqflite/sqflite.dart';

import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:tatoeba_trainer/models/sentence.dart';

class DbProvider extends ChangeNotifier {
  static final DbProvider _instance = new DbProvider.internal();
  factory DbProvider() => _instance; 
  final _completer = Completer<void>();
  
  static late Database _db;

  DbProvider.internal() {
    _initDb();
  }

  Future<void> get initialization => _completer.future;

  Future<void> _initDb() async {
    var databasesPath = await getDatabasesPath();
    path = join(databasesPath, "sentences.db");

    // Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "sentences.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);

    }
    _db = await openDatabase(path);

    _completer.complete();
  }

  static const target_table = "targets";
  static const source_table = "sources";

  final Map<String, String> language_map = {"russian": "ru", "chinese": "cn"};

  late String path;

  List<FlashcardSentence> saved_sentences = [];
  var sentence_count = 0;



  Future<bool> getSaved(String language, bool erase,
      {int limit = 10}) async {
    if (erase) {
      saved_sentences = [];
    }
    bool hasMore = true;
    final start = DateTime.now().millisecondsSinceEpoch;
    await _db.rawQuery("""
    select 
      sources.id as source_id,
      sources.sentence as source_sentence,
      targets.id as target_id,
      targets.sentence as target_sentence
    from sources join targets on sources.id = targets.source_ID
    where 
      targets.hide=0 and
      targets.saved=1 and
      targets.lang='${language_map[language]}'
    order by 
      sources.id 
    limit ${limit}
    offset ${saved_sentences.length};
      """).then((value) {
      final timeElapsted = DateTime.now().millisecondsSinceEpoch - start;
      print("time elapsed ${timeElapsted}");
      if (value.length < limit) {
        hasMore = false;
      }
      value.forEach((element) {
        saved_sentences.add(FlashcardSentence(
            key: element["source_id"] as int,
            source: SourceSentence(
              id: element["source_id"] as int,
              sentence: element["source_sentence"] as String,
            ),
            target: 
              TargetSentence(
                id: element["target_id"] as int,
                lang: language,
                sentence: element["target_sentence"] as String,
              )
            ));
      });
    });
    sentence_count = saved_sentences.length;
    _db.close();
    notifyListeners();
    return hasMore;
  }

  Future<List<FlashcardSentence>> getRandom(String language, int limit,
      {bool saved = false, bool hide = false}) async {

    List<FlashcardSentence> sentences = [];

    print(this.hashCode);


    final start = DateTime.now().millisecondsSinceEpoch;

    await _db.rawQuery("""
    select 
      sources.id as source_id,
      sources.sentence as source_sentence,
      targets.id as target_id,
      targets.sentence as target_sentence
    from sources join targets on sources.id = targets.source_ID
    where 
      targets.hide=${hide ? 1 : 0} and
      targets.saved=${saved ? 1 : 0} and
      targets.lang='${language_map[language]}' 
    order by 
      random() limit ${limit};
      """).then((value) {
      final timeElapsted = DateTime.now().millisecondsSinceEpoch - start;
      print("time elapsed ${timeElapsted}");
      value.forEach((element) {
        sentences.add(FlashcardSentence(
            key: element["source_id"] as int,
            source: SourceSentence(
              id: element["source_id"] as int,
              sentence: element["source_sentence"] as String,
            ),
            target: 
              TargetSentence(
                id: element["target_id"] as int,
                lang: language,
                sentence: element["target_sentence"] as String,
              )
            ));
      });
    });

    _db.close();
    return sentences;
  }

  Future<void> saveSentence(int id) async {
    await _db
        .rawUpdate("update targets set saved=1 where id=${id};"); // PICKUP HERE
  }

  Future<void> unsaveSentence(int id) async {
    await _db
        .rawUpdate("update targets set saved=0 where id=${id};"); // PICKUP HERE
  }

  Future<void> hideSentence(int id) async {
    await _db
        .rawUpdate("update targets set hide=1 where id=${id};"); // PICKUP HERE
  }

  Future<void> unhideSentence(int id) async {
    await _db
        .rawUpdate("update targets set hide=0 where id=${id};"); // PICKUP HERE
  }
}
