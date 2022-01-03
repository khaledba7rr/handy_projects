import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants.dart';

import 'registration_screen.dart';
import 'seller_home.dart';
import 'customer_home.dart';

import '../providers/auth.dart';
import '../providers/user.dart';
import '../providers/products.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  @override
  _LoginScreenState createState() => _LoginScreenState();

}
class _LoginScreenState extends State<LoginScreen> {
  var email;
  var password;
  bool isLoading = false;
  bool isFormValid = false;
  bool showPassword = false;
  var _formKey = GlobalKey<FormState>();
  bool formValid = false;
  void _verify() {
    final isValid = _formKey.currentState.validate();
    if(isValid){
      formValid = true;
    }else{
      formValid =false;
    }
  }
  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceInfo = MediaQuery.of(context);
    AppBar appBar =AppBar(title: Text('Handy'),);
    final appBarHeight = appBar.preferredSize.height;
    final buttonSize = (deviceInfo.size.width)*0.7;
    final deviceWidth = deviceInfo.size.width;
    void _showError(String error,var deviceWidth) {
      var errorMessage = 'Signing up failed';
      if(error.toString().contains('EMAIL_NOT_FOUND')){
        errorMessage = 'This email is not registered';
        Alert(
          context: context,
          style: kAlert,
          type: AlertType.error,
          title: "Login failed",
          desc: errorMessage,
          buttons: [
            DialogButton(
              child: Text(
                " Register",softWrap: false, overflow: TextOverflow.visible,
                style: TextStyle(color: Colors.white, fontSize:deviceWidth <= 320 ? 12 : 20),
              ),
              onPressed: () => Navigator.popAndPushNamed(context,RegistrationScreen.routeName),
              color: kFirstButtonColor,
              radius: BorderRadius.circular(10),
            ),
            DialogButton(
              child: Text(
                " Try again!",
                style: TextStyle(color: Colors.white, fontSize:deviceWidth <= 320 ?12 : 20),
              ),
              onPressed: () => Navigator.pop(context),
              color: kErrorColor,
              radius: BorderRadius.circular(10),
            ),
          ],
        ).show();
      }
      else if(error.toString().contains('INVALID_EMAIL')){
        errorMessage = 'The email address you provided is not valid.';
        Alert(
          context: context,
          style: kAlert,
          type: AlertType.error,
          title: "Registration failed",
          desc: errorMessage,
          buttons: [
            DialogButton(
              child: Text(
                " Try again!",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              color: kErrorColor,
              radius: BorderRadius.circular(10),
            ),
          ],
        ).show();
      }
      else if(error.toString().contains('INVALID_PASSWORD')){
        errorMessage = 'The password you entered is not correct.';
        Alert(
          context: context,
          style: kAlert,
          type: AlertType.error,
          title: "Login failed",
          desc: errorMessage,
          buttons: [
            DialogButton(
              child: Text(
                " Try again!",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              color: kErrorColor,
              radius: BorderRadius.circular(10),
            ),
          ],
        ).show();
      }
      else{
        errorMessage = 'An error has occurred';
        Alert(
          context: context,
          style: kAlert,
          type: AlertType.error,
          title: "Login failed",
          desc: errorMessage,
          buttons: [
            DialogButton(
              child: Text(
                " Try again!",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              color: kErrorColor,
              radius: BorderRadius.circular(10),
            ),
          ],
        ).show();
      }
    }
    final data = Provider.of<User>(context,listen: false);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(
              children: [
                Container(
                  height: (deviceInfo.size.height-appBarHeight)*0.4,
                  child: Hero(
                      child: Image.asset('./assets/images/logo.png',fit: BoxFit.fill,),
                    tag: 'logo',
                  ),
                ),
                Container(
                  width: deviceInfo.size.width <= 320 ? deviceInfo.size.width*0.95 : deviceInfo.size.width*0.8,
                  color: kBackgroundColor,
                  child: Form(
                    key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextFormField(
                              style: kFieldTextStyle,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: kLabelTextStyle,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color : kFirstButtonColor),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (_){
                                _verify();
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'This field cannot be empty';
                                }
                                if(!value.contains('@') || !value.contains('.')){
                                  return 'enter a valid email address';
                                }
                                email = value.trim();
                                return null;
                              },
                            ),
                            TextFormField(
                              style: kFieldTextStyle,
                              enableSuggestions: false,
                              textDirection: TextDirection.ltr,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(FontAwesomeIcons.eye,size: 20,),
                                  color: showPassword ? Colors.blueAccent : kFieldTextColor,
                                  onPressed: (){
                                    setState(() {showPassword=!showPassword;});
                                  },),
                                labelText: 'Password',
                                labelStyle: kLabelTextStyle,
                                hintText: 'Enter your password',
                                hintStyle: kLabelTextStyle,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              obscureText: showPassword ? false : true,
                              onChanged: (_){
                                _verify();
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'This field cannot be empty';
                                }
                                if(value.length < 8){
                                  return 'Minimum 8 characters';
                                }
                                password = value;
                                return null;
                              },
                            ),
                           isLoading ?
                           Padding(
                             padding: const EdgeInsets.all(15.0),
                             child: CircularProgressIndicator(color: kFirstButtonColor,),
                           ):
                           Container(
                             margin: EdgeInsets.only(top: 20),
                              width: buttonSize,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: kFirstButtonColor,
                                  elevation: 5,
                                ),
                                onPressed: () async{
                                  var loggedUser;
                                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                                  setState(() {isLoading = true;});
                                  if(formValid){
                                    final login = await Provider.of<Auth>(context,listen: false).logIn(email, password)
                                        .catchError((error){
                                      showDialog(context: context, builder: (ctx) => AlertDialog(
                                        title: Text('An error has occurred !'),
                                        content: Text('Something went wrong'),
                                      )).then((value) => setState((){isLoading = false;}));
                                    });
                                    loggedUser = login;
                                  }
                                  if(!formValid){
                                    //field values are wrong
                                    Alert(
                                      context: context,
                                      style: kAlert,
                                      type: AlertType.error,
                                      title: "Login failed",
                                      desc: 'Please provide data correctly',
                                      buttons: [
                                        DialogButton(
                                          child: Text(
                                            " Try again!",
                                            style: TextStyle(color: Colors.white, fontSize: 20),
                                          ),
                                          onPressed: () => Navigator.pop(context),
                                          color: kErrorColor,
                                          radius: BorderRadius.circular(10),
                                        ),
                                      ],
                                    ).show();
                                    setState(() {isLoading=false;});
                                    return;
                                  }
                                  if(loggedUser['error'] != null || loggedUser == null){
                                    //logging in failed
                                    print('we are here');
                                    setState(() {isLoading = false;});
                                    _showError(loggedUser['error']['message'],deviceWidth);
                                    return ;
                                  }
                                  if(loggedUser['error'] == null ){
                                    //logging in succeeded
                                    await Provider.of<User>(context,listen: false).getProfileData();
                                    setState(() {isLoading = false;});
                                    final loggedInProfiled =  data.searchForProfile(loggedUser['localId']);
                                    await Provider.of<Products>(context,listen: false).getProductsData();
                                    //page routing
                                    loggedInProfiled.userRole == 'customer' ?
                                    Navigator.popAndPushNamed(context,CustomerHome.routeName,arguments: loggedUser['localId'])
                                    : Navigator.popAndPushNamed(context,SellerHome.routeName,arguments: loggedUser['localId']);
                                  }
                                },
                                child: Text('Login',style: kButtonTextStyle,),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

