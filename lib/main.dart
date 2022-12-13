import 'package:flutter/material.dart';
import 'package:tatoeba_trainer/providers/db_provider.dart';
import 'package:tatoeba_trainer/screens/design_colours.dart';
import 'package:tatoeba_trainer/screens/design_texts.dart';
import 'package:tatoeba_trainer/screens/language_picker.dart';
import 'package:tatoeba_trainer/screens/mode_picker.dart';
import 'package:provider/provider.dart';

const russian = "russian";
const chinese = "chinese";

void main() {
  runApp(const MyApp());
}

// rgba(13,112,223,255)
// red: rgba(232,102,102,255)
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: DbProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorSchemeSeed: Color.fromARGB(255,13,112,223),
          ),
        home: const LanguagePicker(),
        routes: {
          ModePicker.chineseRoute: (ctx) => ModePicker(language: ModePicker.chinese),
          ModePicker.russianRoute: (ctx) => ModePicker(language: ModePicker.russian),
          DesignColours.route: (ctx) => DesignColours(),
          DesignTexts.route: (ctx) => DesignTexts(),
        },
      ),
    );
  }
}




  