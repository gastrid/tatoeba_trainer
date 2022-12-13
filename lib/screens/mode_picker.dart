import 'package:flutter/material.dart';
import 'package:tatoeba_trainer/providers/db_provider.dart';
import 'package:tatoeba_trainer/screens/new_sentences.dart';
import 'package:provider/provider.dart';
import 'package:tatoeba_trainer/screens/saved_sentences.dart';

class ModePicker extends StatelessWidget {
  const ModePicker({Key? key, required String this.language}) : super(key: key);

  static const chineseRoute = '/chinese';
  static const russianRoute = '/russian';
  static const chinese = 'chinese';
  static const russian = 'russian';

  final String language;

  @override
  Widget build(BuildContext context) {
    final widget_title = (language == chinese ? "Chinese" : "Russian");
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget_title),
      ),
      body: FutureBuilder(
          future: Provider.of<DbProvider>(context).initDb(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Center(
                // Center is a layout widget. It takes a single child and positions it
                // in the middle of the parent.
                child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Text("Pick a mode",
                      style: Theme.of(context).textTheme.headline3),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push<void>(MaterialPageRoute(
                              builder: ((context) =>
                                  NewSentences(language: language))));
                        },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(150, 0),
                        padding:
                            EdgeInsets.all(10.0),
                      ),
                      icon: Icon(Icons.autorenew),
                      label: Text("New Sentences"),),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push<void>(MaterialPageRoute(
                              builder: ((context) =>
                                  SavedSentences(language: language))));
                        },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(150, 0),
                        padding:
                            EdgeInsets.all(10.0),
                      ),
                      icon: Icon(Icons.favorite),
                      label: Text("Saved")),
                  SizedBox(
                    height: 10,
                  ),
                ],
              )
                
              );
            }
          }), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
