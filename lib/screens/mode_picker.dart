import 'package:flutter/material.dart';
import 'package:tatoeba_trainer/providers/db_provider.dart';
import 'package:tatoeba_trainer/screens/new_sentences.dart';
import 'package:provider/provider.dart';


class ModePicker extends StatelessWidget {
const ModePicker({ Key? key, required String this.language }) : super(key: key);

  static const chineseRoute = '/chinese';
  static const russianRoute = '/russian';
  static const chinese = 'chinese';
  static const russian = 'russian';

  final String language; 




  @override
  Widget build(BuildContext context){
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
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Column(
              // Column is also a layout widget. It takes a list of children and
              // arranges them vertically. By default, it sizes itself to fit its
              // children horizontally, and tries to be as tall as its parent.
              //
              // Invoke "debug painting" (press "p" in the console, choose the
              // "Toggle Debug Paint" action from the Flutter Inspector in Android
              // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
              // to see the wireframe for each widget.
              //
              // Column has various properties to control how it sizes itself and
              // how it positions its children. Here we use mainAxisAlignment to
              // center the children vertically; the main axis here is the vertical
              // axis because Columns are vertical (the cross axis would be
              // horizontal).
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(onPressed: () {
                  Navigator.of(context).push<void>(
                    MaterialPageRoute(builder: ((context) => NewSentences(language: language)))
                  );
                }
                , child: 
                Text("New Set")),
                TextButton(onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  final snackbar = SnackBar(content: Text("You picked 'Saved'"));
                  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                }
                , child: 
                Text("Saved")),
              ],
            ),
          );
          }
        }
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}