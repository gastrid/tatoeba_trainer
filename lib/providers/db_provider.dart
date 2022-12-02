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
  static const target_table = "targets";
  static const source_table = "sources";

  final Map<String, String> language_map = {
    "russian": "ru",
    "chinese": "cn"
  };

  late String path;

  Future<void> initDb() async {
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
  }

  Future<List<FlashcardSentence>> getRandom(
    String language,
    int limit,
    {bool saved = false,
    bool hide = false}
    ) async{

    final db = await openDatabase(path);


    List<FlashcardSentence> sentences = [];

    await db.rawQuery("""
    select 
      sources.id as source_id,
      sources.sentence as source_sentence,
      targets.id as target_id,
      targets.sentence as target_sentence
    from sources join targets on sources.id = targets.source_ID
    where 
      targets.hide=${hide ? 1 : 0} and
      targets.saved=${saved ? 1 : 0} and
      targets.lang="${language_map[language]}" 
    order by 
      random() limit ${limit};
      """).then((value) {
        // print(value);
        value.forEach((element) {
          sentences.add(FlashcardSentence(
            key: element["source_id"] as int,
            source: SourceSentence(
              id: element["source_id"] as int,
              sentence: element["source_sentence"] as String,
              ),
              targets: [TargetSentence(
                id: element["target_id"] as int,
                lang: language,
                sentence: element["target_sentence"] as String,
                )]));
        });
      });

  db.close();
  return sentences;
  }
}
