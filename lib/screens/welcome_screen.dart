import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';

import 'package:handy_projects/screens/registration_screen.dart';

import '../constants.dart';
import 'login_screen.dart';
enum pageMode {Login,Signup}
class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceInfo = MediaQuery.of(context);
    AppBar appBar =AppBar(title: Center(child: Text('Handy',style: kMainTextStyle,),),);
    final appBarHeight = appBar.preferredSize.height;
    final buttonSize = (deviceInfo.size.width)*0.3;
    return WillPopScope(
      child: Scaffold(
        appBar: appBar,
        body: Center(
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: (deviceInfo.size.height-appBarHeight)*0.4,
                      child: Hero(
                        child: Image.asset('./assets/images/logo.png',fit: BoxFit.fill,),
                        tag: 'logo',
                      ),
                    ),
                    Container(
                        height: deviceInfo.size.height*0.1,
                        child: Text('Goods for good deeds',style: kAnimatedText,)
                    ),
                  ],
                ),
                    ConstrainedBox(  //Customer Button
                      constraints: BoxConstraints.tightFor(
                        width: buttonSize,
                      ),
                      child: ElevatedButton(
                        onPressed: (){
                          Navigator.pushNamed(context,LoginScreen.routeName);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: kFirstButtonColor,
                          elevation: 5,
                        ),
                        child: Text('Login',style: kButtonTextStyle,),
                      ),
                    ),
                    Container(
                  child: TextButton.icon(
                    icon: Icon(Icons.app_registration),
                      label: Text('Sign up instead ?'),
                    onPressed: (){
                      Navigator.pushNamed(context,RegistrationScreen.routeName);
                    },
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.resolveWith((states) => kAppbarColor),
                      textStyle: MaterialStateProperty.resolveWith((states) => TextStyle(
                        decoration: TextDecoration.underline,
                        decorationThickness: 2,
                      ),),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ),
      onWillPop: () => showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          elevation: 2,
          title: Text(
            'Warning',
            style: TextStyle(color: kErrorColor),
          ),
          backgroundColor: kBackgroundColor,
          content: Text(
            'Do you really want to exit ?',
            style: kSmallTextStyle,
          ),
          actions: [
            ElevatedButton(
                child: Text(
                  'Yes',
                  style: kSmallTextStyle,
                ),
                style: ElevatedButton.styleFrom(
                  primary: kErrorColor,
                ),
                onPressed: () {
                  setState(() {
                    SystemNavigator.pop();
                    exit(0);
                  });
                }
            ),
            ElevatedButton(
              child: Text(
                'No',
                style: kSmallTextStyle,
              ),
              style: ElevatedButton.styleFrom(
                primary: kFirstButtonColor,
              ),
              onPressed: () => Navigator.pop(c, false),
            ),
          ],
        ),
      ),
    );
  }
}
