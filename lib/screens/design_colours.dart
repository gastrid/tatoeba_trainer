import 'package:flutter/material.dart';

class DesignColours extends StatelessWidget {
  const DesignColours({Key? key}) : super(key: key);

  static const route = "/design-colours";

  @override
  Widget build(BuildContext context) {
    final colours = [
      ["backgroundColor", Theme.of(context).backgroundColor],
      ["bottomAppBarColor", Theme.of(context).bottomAppBarColor],
      ["canvasColor", Theme.of(context).canvasColor],
      ["cardColor", Theme.of(context).cardColor],
      ["dialogBackgroundColor", Theme.of(context).dialogBackgroundColor],
      ["disabledColor", Theme.of(context).disabledColor],
      ["dividerColor", Theme.of(context).dividerColor],
      ["errorColor", Theme.of(context).errorColor],
      ["focusColor", Theme.of(context).focusColor],
      ["highlightColor", Theme.of(context).highlightColor],
      ["hintColor", Theme.of(context).hintColor],
      ["hoverColor", Theme.of(context).hoverColor],
      ["indicatorColor", Theme.of(context).indicatorColor],
      ["primaryColor", Theme.of(context).primaryColor],
      ["primaryColorDark", Theme.of(context).primaryColorDark],
      ["primaryColorLight", Theme.of(context).primaryColorLight],
      ["scaffoldBackgroundColor", Theme.of(context).scaffoldBackgroundColor],
      ["secondaryHeaderColor", Theme.of(context).secondaryHeaderColor],
      ["selectedRowColor", Theme.of(context).selectedRowColor],
      ["shadowColor", Theme.of(context).shadowColor],
      ["splashColor", Theme.of(context).splashColor],
      ["toggleableActiveColor", Theme.of(context).toggleableActiveColor],
      ["unselectedWidgetColor", Theme.of(context).unselectedWidgetColor],
    ];
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Colours"),
        ),
        body: 
          ListView.builder(
            scrollDirection: Axis.vertical,
    shrinkWrap: true,
            padding: EdgeInsets.all(20),
            itemCount: colours.length,
            itemBuilder: ((context, index) {
              return Container(
                height: 30,
                key: Key(index.toString()),
                color: colours[index][1] as Color,
                child: Text(colours[index][0] as String),
              );
            }),
          )
        );
  }
}
