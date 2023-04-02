import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:tatoeba_trainer/widgets/reuseable_card.dart';
import 'package:provider/provider.dart';
import 'package:tatoeba_trainer/providers/db_provider.dart';
import './flashcard.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_controller.dart';

import '../models/flashcardSentence.dart';
import 'package:flutter/material.dart';

class FlashcardScroller extends StatefulWidget {
  const FlashcardScroller(
      {Key? key,
      required List<FlashcardSentence> this.sentences,
      this.isChinese = false})
      : super(key: key);
  final List<FlashcardSentence> sentences;
  final bool isChinese;
  @override
  _FlashcardScrollerState3 createState() => _FlashcardScrollerState3();
}

enum SwipeDirection { left, right }

class _FlashcardScrollerState3 extends State<FlashcardScroller>
    with TickerProviderStateMixin {
  int _index = 0;
  late FlashcardSentence _currentCard;
  double _progressValue = 0.1;
  SwipeDirection swipeDirection = SwipeDirection.left;
  late double _dragStartPosition;
  late int _deckLength;

  CarouselController carouselController = CarouselController();



  @override
  void initState() {
    super.initState();
    _deckLength = widget.sentences.length;
    _currentCard = widget.sentences[0];
  }

  void _updateProgressValue() {
    _progressValue = (_index + 1) / _deckLength;
  }

  void _toggleSaved(int id, bool saved) {
    setState(() {
      _currentCard.target.saved = !saved;
    });
    if (!saved) {
      Provider.of<DbProvider>(context, listen: false).saveSentence(id);
    } else {
      Provider.of<DbProvider>(context, listen: false).unsaveSentence(id);
    }
  }

  void _toggleHide(int id, bool hidden) {
    setState(() {
      _currentCard.target.hide = !hidden;
    });
    if (!hidden) {
      Provider.of<DbProvider>(context, listen: false).hideSentence(id);
    } else {
      Provider.of<DbProvider>(context, listen: false).unhideSentence(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _deckLength > 0
        ? Center(
            child: GestureDetector(
              child: Column(
                children: [
                  Text("Question ${_index+1} of $_deckLength completed"),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),
                      minHeight: 5,
                      value: _progressValue, // TODO: change
                    ),
                  ),
                  SizedBox(height: 30),
                  Expanded(
                      child: CarouselSlider.builder(
                        itemCount: _deckLength,
                        itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                          return SizedBox(
                          key: ValueKey<int>(itemIndex),
                          width: 300,
                          height: 300,
                          child: Flashcard(
                              sentence: widget.sentences[itemIndex],
                              isChinese: widget.isChinese),
                        );
                        },
                        options: CarouselOptions(
                          animateToClosest: true,
                          enableInfiniteScroll: false,
                          onPageChanged:(index, reason) {
                            setState(() {
                              _currentCard = widget.sentences[index];
                              _index = index;
                              _updateProgressValue();
                            });

                          },
                        ),
                      )
                  ),
                  SizedBox(height: 40),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        ElevatedButton.icon(
                            onPressed: () {
                              _toggleSaved(_currentCard.target.id,
                                  _currentCard.target.saved);
                            },
                            icon: _currentCard.target.saved
                                ? Icon(
                                    Icons.favorite,
                                    size: 30,
                                    color: Colors.red,
                                  )
                                : Icon(Icons.favorite_border, size: 30),
                            label: Text(""),
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                padding: EdgeInsets.only(
                                    right: 20, left: 25, top: 15, bottom: 15))),
                        ElevatedButton.icon(
                            onPressed: () {
                              _toggleHide(_currentCard.target.id, false);
                            },
                            icon: _currentCard.target.hide
                                ? Icon(Icons.not_interested,
                                    size: 30, color: Colors.black)
                                : Icon(Icons.not_interested, size: 30),
                            label: Text(""),
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                padding: EdgeInsets.only(
                                    right: 20, left: 25, top: 15, bottom: 15)))
                      ])
                ],
              ),
          ))
        : Text("no sentences");
  }
}

// class _FlashcardScrollerState2 extends State<Flashcards>
//     with TickerProviderStateMixin {
//   int _index = 0;
//   late FlashcardSentence _currentCard;
//   double _progressValue = 0.1;
//   SwipeDirection swipeDirection = SwipeDirection.left;
//   late double _dragStartPosition;
//   late int _deckLength;
//   final flipcardController = FlipCardController();

//   late final _animationController = AnimationController(
//     vsync: this,
//     duration: Duration(
//       milliseconds: 10,
//     ),
//   );
//   late final _slideAnimation = Tween<Offset>(
//     begin: Offset.zero,
//     end: const Offset(1.5, 0.0),

//   ).animate(
//     CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.linear,
//     ),
//   );

//   @override
//   void initState() {
//     super.initState();
//     _deckLength = widget.sentences.length;
//     _currentCard = widget.sentences[_index];
//     _slideAnimation.addListener(() => setState(() {}));
//   }

//   void _onDragStart(DragStartDetails details) {
//     _dragStartPosition = details.localPosition.dx;
//   }

//   void _onDragUpdate(DragUpdateDetails details) {
//     if ((details.localPosition.dx - _dragStartPosition) < -20) {
//       swipeDirection = SwipeDirection.left;
//     } else if ((details.localPosition.dx - _dragStartPosition) > 20) {
//       swipeDirection = SwipeDirection.right;
//     }
//   }

//   void _onDragEnd(DragEndDetails _) {
//     if (swipeDirection == SwipeDirection.right) {
//       _previousCard();
//     } else if (swipeDirection == SwipeDirection.left) {
//       _nextCard();
//     }
//     flipcardController.controller!.reset();
//   }

//   void _previousCard() {
//     setState(() {
//       if (_index > 0) {
//         _index -= 1;
//         _currentCard = widget.sentences[_index];
//         _animationController.forward();
//         _updateProgressValue();
//       }
//     });
//   }

//   void _nextCard() {
//     setState(() {
//       if (_index < _deckLength - 1) {
//         _index += 1;
//         _currentCard = widget.sentences[_index];
//         _updateProgressValue();
//       }
//     });
//   }

//   void _updateProgressValue() {
//     _progressValue = (_index + 1) / _deckLength;
//   }

//   void _toggleSaved(int id, bool saved) {
//     setState(() {
//       _currentCard.target.saved = !saved;
//     });
//     if (!saved) {
//       Provider.of<DbProvider>(context, listen: false).saveSentence(id);
//     } else {
//       Provider.of<DbProvider>(context, listen: false).unsaveSentence(id);
//     }
//   }

//   void _toggleHide(int id, bool hidden) {
//     setState(() {
//       _currentCard.target.hide = !hidden;
//     });
//     if (!hidden) {
//       Provider.of<DbProvider>(context, listen: false).hideSentence(id);
//     } else {
//       Provider.of<DbProvider>(context, listen: false).unhideSentence(id);
//     }
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _deckLength > 0
//         ? Center(
//             // TODO: look into swipe animations
//             child: GestureDetector(
//               onHorizontalDragStart: _onDragStart,
//               onHorizontalDragUpdate: _onDragUpdate,
//               onHorizontalDragEnd: _onDragEnd,
//               child: Column(
//                 children: [
//                   Text("Question $_index of $_deckLength Completed"),
//                   SizedBox(height: 20),
//                   Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: LinearProgressIndicator(
//                       backgroundColor: Colors.white,
//                       valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),
//                       minHeight: 5,
//                       value: _progressValue, // TODO: change
//                     ),
//                   ),
//                   SizedBox(height: 30),
//                   Expanded(
//                     child: SlideTransition(
//                       position: _slideAnimation,
//                       child: SizedBox(
//                             width: 300,
//                             height: 300,
//                             child: 
//                             Flashcard(_currentCard.),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 50),
//                   Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: <Widget>[
//                         ElevatedButton.icon(
//                             onPressed: () {
//                               _toggleSaved(_currentCard.target.id,
//                                   _currentCard.target.saved);
//                             },
//                             icon: _currentCard.target.saved
//                                 ? Icon(
//                                     Icons.favorite,
//                                     size: 30,
//                                     color: Colors.red,
//                                   )
//                                 : Icon(Icons.favorite_border, size: 30),
//                             label: Text(""),
//                             style: ElevatedButton.styleFrom(
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10)),
//                                 padding: EdgeInsets.only(
//                                     right: 20, left: 25, top: 15, bottom: 15))),
//                         ElevatedButton.icon(
//                             onPressed: () {
//                               _toggleHide(_currentCard.target.id, false);
//                             },
//                             icon: _currentCard.target.hide
//                                 ? Icon(Icons.not_interested,
//                                     size: 30, color: Colors.black)
//                                 : Icon(Icons.not_interested, size: 30),
//                             label: Text(""),
//                             style: ElevatedButton.styleFrom(
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10)),
//                                 padding: EdgeInsets.only(
//                                     right: 20, left: 25, top: 15, bottom: 15)))
//                       ])
//                 ],
//               ),
//             ),
//           )
//         : Text("no sentences");
//   }
// }


// class _FlashcardsState extends State<Flashcards>
//     with SingleTickerProviderStateMixin {
//   var _isInit = true;
//   late final AnimationController _controller;
//   late final Animation<Offset> _offsetAnimation;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     );

//     _offsetAnimation = Tween<Offset>(
//       begin: Offset.zero,
//       end: const Offset(1.5, 0.0),
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.elasticIn,
      
//     ))
//       ..addStatusListener((anim) {
//         if (anim == AnimationStatus.forward) {
//           print("animate");
//         }
//         if (_isInit == true) {
//           print(_isInit);
//           setState(() {
//             _isInit == false;
//           });
//         }
//       });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     print("Flashcard widget built");
//     return GestureDetector(
//       onTap: () => _controller.forward(),
//       child: SlideTransition(
//         position: _offsetAnimation,
//         child: const Padding(
//           padding: EdgeInsets.all(8.0),
//           child: FlutterLogo(size: 150.0),
//         ),
//       ),
//     );
//   }
// }
