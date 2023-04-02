import 'package:flutter/material.dart';
import 'package:tatoeba_trainer/models/flashcardSentence.dart';
import 'package:provider/provider.dart';
import 'package:tatoeba_trainer/providers/db_provider.dart';
import 'package:tatoeba_trainer/widgets/flashcard_scroller.dart';



class NewSentences extends StatefulWidget {
  const NewSentences({ Key? key, required this.language }) : super( key: key);

  final String language;

  @override
  _NewSentencesState createState() => _NewSentencesState();
}

class _NewSentencesState extends State<NewSentences> {
  late List<FlashcardSentence> _sentences;

  var _isInit = true;
  var _isLoading = false;

  final limit = 10; 

  @override
  void didChangeDependencies() {
    if (_isInit && mounted) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<DbProvider>(context, listen: false).getRandom(widget.language, limit).then((sentences) {
        setState(() {
          _isLoading = false;
          _sentences = sentences;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Flashcards"),
      ),
      body: _isLoading == true ? 
      const Center(child: CircularProgressIndicator()) : 
      FlashcardScroller(sentences: _sentences, isChinese: widget.language == "chinese",)// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}