import 'package:flutter/material.dart';
import 'package:tatoeba_trainer/models/sentence.dart';
import 'package:lpinyin/lpinyin.dart';

class PairRow extends StatelessWidget {
  const PairRow(
      {Key? key,
      required this.sourceSentence,
      required this.targetSentence,
      required this.language})
      : super(
          key: key,
        );
  final String sourceSentence;
  final String targetSentence;
  final String language;

  @override
  Widget build(BuildContext context) {
    final pinyin = language == "chinese"
        ? PinyinHelper.getPinyin(targetSentence,
            format: PinyinFormat.WITH_TONE_MARK).trim()
        : null;
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      width: deviceSize.width,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              sourceSentence,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            // Expanded(
            //   flex: 4,
            //   child:
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 10,
                ),
                // Icon(Icons.subdirectory_arrow_right,
                //     color: Theme.of(context).disabledColor, size: 20),
                pinyin == null
                    ? ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 50),
                        child: Text(
                          targetSentence,
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                color: Theme.of(context).hintColor,
                              ),
                        ))
                    : ConstrainedBox(
                        constraints:
                            BoxConstraints(maxHeight: 100, minHeight: 50),
                        child: 
                            Text(
                              "${targetSentence} ${pinyin}",
                              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                color: Theme.of(context).hintColor,
                              ),
                            ),

                      )
              ],
            ),
            // ),
            Divider(
              height: 1,
            )
          ]),
    );
  }
}
