import 'package:flutter/material.dart';

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

import 'terms_screen.dart';
import '../providers/auth.dart';
import '../constants.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const routeName = '/customer-registration';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  var _checkBox = false;
  var _formKey = GlobalKey<FormState>();
  var isLoading = false;
  var formValid = false;
  String dropDownValue = '';
  Map<String, dynamic> signUpValues = {
    'email': '',
    'password': '',
    'firstName': '',
    'lastName': '',
    'address': '',
    'mobile': '',
  };
  void _verify() {
    final isValid = _formKey.currentState.validate();
    if(isValid){
      formValid = true;
    }else{
      formValid =false;
    }
  }
  List<DropdownMenuItem> dropDown({String first,second,}){
    return [
      DropdownMenuItem(
        child: Text(''), value: '',),
      DropdownMenuItem(
        child: Text(first), value: first,),
      DropdownMenuItem(
        child: Text(second),
        value: second,
      ),
    ];
  }
  @override
  Widget build(BuildContext context) {
    void _showError(String error) {
      var errorMessage = 'Signing up failed';
      if(error.toString().contains('EMAIL_EXISTS')){
        errorMessage = 'This email address is already in use.';
        Alert(
          context: context,
          style: kAlert,
          type: AlertType.error,
          title: "Registration failed",
          desc: errorMessage,
          buttons: [
            DialogButton(
              child: Text(
                " Login",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.popAndPushNamed(context,LoginScreen.routeName),
              color: kFirstButtonColor,
              radius: BorderRadius.circular(10),
            ),
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
      else if(error.toString().contains('WEAK_PASSWORD')){
        errorMessage = 'This password is too weak.';
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
      else{
        errorMessage = 'An error has occurred';
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
    }
    final authData = Provider.of<Auth>(context);
    MediaQueryData deviceInfo = MediaQuery.of(context);
    AppBar appBar =AppBar(title: Text('Handy'),);
    final appBarHeight = appBar.preferredSize.height;
    final buttonWidth = (deviceInfo.size.width)*0.7;
    final formHeight = ((deviceInfo.size.height-appBarHeight)*0.8);
    final buttonHeight = formHeight*0.1;
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: ((deviceInfo.size.height-appBarHeight)*0.4),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Sign up ',style: deviceInfo.size.width <= 320 ? kSmallTextStyle :kBigTextStyle,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(child: TextFormField(
                              style: kFieldTextStyle,
                              decoration: InputDecoration(
                                labelText: 'First name',
                                labelStyle: kLabelTextStyle,
                              ),
                              keyboardType: TextInputType.text,
                              onChanged: (_){
                                _verify();
                                print(deviceInfo.size.width);
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'This field cannot be empty';
                                }
                                if(value.length < 3){
                                  return 'enter a valid name';
                                }
                                signUpValues['firstName'] = value;
                                return null;
                              },
                            ),),
                              SizedBox(width: 30,),
                              Expanded(child: TextFormField(
                                style: kFieldTextStyle,
                                decoration: InputDecoration(
                                  labelText: 'Last name',
                                  labelStyle: kLabelTextStyle,
                                ),
                                keyboardType: TextInputType.text,
                                onChanged: (_){
                                  _verify();
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'This field cannot be empty';
                                  }
                                  if(value.length < 3){
                                    return 'enter a valid name';
                                  }
                                  signUpValues['lastName'] = value;
                                  return null;
                                },
                              ),),
                          ],),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Role : ' , style: kLabelTextStyle,),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: deviceInfo.size.width*0.3,
                                  maxWidth: deviceInfo.size.width*0.4,
                                ),
                                child: DropdownButton(
                                  elevation: 4,
                                  style: kVerySmallTextStyle,
                                  isExpanded: true,
                                  dropdownColor: kBackgroundColor,
                                  onChanged: (value){
                                    setState(() {
                                      dropDownValue = value;
                                    });
                                  },
                                  value: dropDownValue,
                                  items: dropDown(
                                    first: 'customer',
                                    second: 'seller',
                                  ),),
                              ),
                            ],),
                          TextFormField(
                            style: kFieldTextStyle,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: kLabelTextStyle,
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
                              signUpValues['email'] = value.trim();
                              return null;
                            },
                          ),
                          TextFormField(
                            style: kFieldTextStyle,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: kLabelTextStyle,
                              hintText: 'Enter your password',
                              hintStyle: kLabelTextStyle,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            obscureText: true,
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
                              signUpValues['password'] = value;
                              return null;
                            },
                          ),
                          TextFormField(
                            style: kFieldTextStyle,
                            decoration: InputDecoration(
                              labelText: 'Mobile number',
                              labelStyle: kLabelTextStyle,
                            ),
                            keyboardType: TextInputType.phone,
                            onChanged: (_){
                              _verify();
                            },
                            validator: (value) {
                              if (!value.startsWith('0')) {
                                return 'please enter a valid phone number';
                              }
                              if(value.isEmpty){
                                return 'This field cannot be empty';
                              }
                              if(value.length < 11){
                                return 'should be 11 digits';
                              }
                              signUpValues['mobile'] = value;
                              return null;
                            },
                          ),
                          TextFormField(
                            style: kFieldTextStyle,
                            decoration: InputDecoration(
                              labelText: 'Address',
                              labelStyle: kLabelTextStyle,
                            ),
                            keyboardType: TextInputType.text,
                            onChanged: (_){
                              _verify();
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'This field cannot be empty';
                              }
                              if(value.length < 6){
                                return 'enter a valid address';
                              }
                              signUpValues['address'] = value;
                              return null;
                            },
                          ),
                          isLoading ?
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: CircularProgressIndicator(),
                          ) : Container(
                            margin: EdgeInsets.only(top: 20),
                            width: buttonWidth,
                            height: buttonHeight,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: kFirstButtonColor,
                                elevation: 5,
                              ),
                              onPressed: () async{
                                var newUser;
                                setState(() {isLoading = true;});
                                if(formValid){
                                  final signUp = await authData.signUp(signUpValues['email'], signUpValues['password'])
                                  .catchError((error){
                                    showDialog(context: context, builder: (ctx) => AlertDialog(
                                      title: Text('An error has occurred !'),
                                      content: Text('Something went wrong'),
                                    )).then((value) => setState((){isLoading = false;}));
                                  });
                                  newUser = signUp;
                                }
                                if(!formValid){
                                  //field values are wrong
                                  Alert(
                                    context: context,
                                    style: kAlert,
                                    type: AlertType.error,
                                    title: "Registration failed",
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
                                if(!_checkBox){
                                  Alert(
                                    context: context,
                                    style: kAlert,
                                    type: AlertType.error,
                                    title: "Registration failed",
                                    desc: 'Please read and agree to our terms before register.',
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
                                else if(newUser['error'] != null || newUser == null){
                                  //registration failed
                                  setState(() {isLoading = false;});
                                  _showError(newUser['error']['message']);
                                  return;
                                }
                                else if(newUser['error'] == null ){
                                  //registration  succeeded
                                  print('user UID : ');
                                  print(newUser['localId']);
                                  await authData.uploadProfileData(
                                    firstName: signUpValues['firstName'],
                                    lastName: signUpValues['lastName'],
                                    email: signUpValues['email'],
                                    mobile: signUpValues['mobile'],
                                    address: signUpValues['address'],
                                    type: dropDownValue,
                                    uid: newUser['localId'],
                                    date: DateFormat('yyyy-MM-dd').format(DateTime.now()).toString(),
                                  );
                                  setState(() {isLoading = false;});
                                }
                                Alert(
                                  context: context,
                                  style: kAlert,
                                  type: AlertType.success,
                                  title: "Registration success",
                                  desc: 'Please,login to continue',
                                  buttons: [
                                    DialogButton(
                                      child: Text(
                                        " Login",
                                        style: TextStyle(color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () =>
                                          Navigator.popAndPushNamed
                                            (context, LoginScreen.routeName),
                                      color: kFirstButtonColor,
                                      radius: BorderRadius.circular(10),
                                    ),
                                  ],
                                ).show();
                              },
                              child: Text('Sign up',maxLines: 1,style: kButtonTextStyle,),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton.icon(
                                  onPressed: (){
                                    Navigator.pushNamed(context, TermsScreen.routeName);
                                  },
                                  icon: Icon(Icons.insert_drive_file_sharp),
                                  label: Text('I read & agreed to all terms',style: TextStyle(fontSize: 12,decoration: TextDecoration.underline),)),
                              Expanded(
                                flex: 3,
                                child: Checkbox(
                                  checkColor: kFirstButtonColor,
                                  value: _checkBox,
                                  onChanged: (_){
                                    setState(() {
                                      _checkBox = !_checkBox;
                                    });
                                  },
                                ),
                              ),
                            ],
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
