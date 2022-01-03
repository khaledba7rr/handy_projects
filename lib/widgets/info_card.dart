import 'package:flutter/material.dart';

import '../constants.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    @required this.title,
    @required this.text,
  });
  final String title;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10 , vertical: 5),
        color: kGridTileColor,
        elevation: 4,
        child: Container(
          margin: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('$title' , style: kMainTextStyle,),
              Text('$text',softWrap: false, overflow: TextOverflow.visible, style: kSmallTextStyle,)
            ],
          ),
        ),
      ),
    );
  }
}
