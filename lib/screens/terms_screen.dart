import 'package:flutter/material.dart';

import '../constants.dart';

class TermsScreen extends StatelessWidget {
  static const routeName = 'terms-screen';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text( kTermsText,style: kTermsStyle,),
                  Text('How it works',style: kMainTextStyle,),
                  Text(kHowitWorks,style: kTermsStyle,),
                  Container(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: kFirstButtonColor,
                        elevation: 5,
                      ),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Text('Back to registration screen',style: kButtonTextStyle,),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
