import 'package:flutter/material.dart';

class LanguagePicker extends StatelessWidget {
  const LanguagePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final image_width = deviceSize.width / 3;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Tatoeba trainer"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text("Pick a language",
                      style: Theme.of(context).textTheme.headline3),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed("/russian");
                      },
                      style: ButtonStyle(
                        padding:
                            MaterialStateProperty.all(EdgeInsets.all(10.0)),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.asset(
                              "assets/images/russian-flag.jpeg",
                              width: image_width,
                            ),
                          ),
                          Text("Russian")
                        ],
                      )),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed("/chinese");
                      },
                      style: ButtonStyle(
                        padding:
                            MaterialStateProperty.all(EdgeInsets.all(10.0)),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.asset(
                              "assets/images/chinese-flag.png",
                              width: image_width,
                            ),
                          ),
                          Text("Chinese")
                        ],
                      )),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Container(
              height: 50,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorDark,
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, -.1),
                        blurRadius: 0)
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed("/design-colours");
                      },
                      child: Text(
                          style:
                              TextStyle(color: Theme.of(context).canvasColor),
                          "Design colours")),
                  TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).primaryColorDark),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed("/design-texts");
                      },
                      child: Text(
                        style: TextStyle(color: Theme.of(context).canvasColor),
                        "Design texts",
                      ))
                ],
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
