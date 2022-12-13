import 'package:flutter/material.dart';
import 'package:tatoeba_trainer/models/flashcardSentence.dart';
import 'package:provider/provider.dart';
import 'package:tatoeba_trainer/providers/db_provider.dart';
import 'package:tatoeba_trainer/screens/review_saved_sentences.dart';
import 'package:tatoeba_trainer/widgets/pair_row.dart';
import 'package:tatoeba_trainer/widgets/flashcards.dart';

class SavedSentences extends StatefulWidget {
  const SavedSentences({Key? key, required this.language}) : super(key: key);

  final String language;

  @override
  _SavedSentencesState createState() => _SavedSentencesState();
}

class _SavedSentencesState extends State<SavedSentences> {
  late List<FlashcardSentence> _sentences;

  final controller = ScrollController();
  var _isInit = true;
  var _isLoading = false;
  var _hasMore = true;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
         Provider.of<DbProvider>(context, listen: false).getSaved(
          widget.language,
          false,
        ).then((value) => _hasMore = value);
      }
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit && mounted) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<DbProvider>(context, listen: false)
          .getSaved(
            widget.language,
            true,
          )
          .then((hasMore) {
            setState(() {
              _hasMore = hasMore;
              _isLoading = false;
              print("is loading false");
              
            });
          } );
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Saved sentences"),
        ),
        body: _isLoading
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(child: CircularProgressIndicator()))
            : Selector<DbProvider, int>(
                selector: (_, db) => db.sentence_count,
                builder: (context, value, child) {
                  return ListView.builder(
                  controller: controller,
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                  itemCount: value + 1,
                  itemBuilder: ((context, index) {
                    if (index < value) {
                      final saved_sentences =
                          Provider.of<DbProvider>(context, listen: false).saved_sentences;
                      final sentence = saved_sentences[index];
                      // return ListTile(title: 
                      // Text(sentence.source.sentence));
                      return PairRow(sourceSentence: sentence.source.sentence, targetSentence: sentence.target.sentence, language: widget.language);
                    } else {
                      return _hasMore ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32),
                          child: Center(child: CircularProgressIndicator())) : Container();
                    }
                  }),
                );
                }
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.menu_book),
                onPressed: () {
                  Navigator.of(context).push<void>(MaterialPageRoute(
                              builder: ((context) =>
                                  ReviewSavedSentences(language: widget.language))));
                },), // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
