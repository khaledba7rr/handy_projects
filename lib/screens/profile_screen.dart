import 'package:flutter/material.dart';
import 'dart:io';

import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../constants.dart';
import '../widgets/info_card.dart';
import '../providers/user.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile-screen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}
File _image;
ImagePicker _imagePicker = ImagePicker();
class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final uid = ModalRoute.of(context).settings.arguments as String;
    final profileData = Provider.of<User>(context).searchForProfile(uid);
    MediaQueryData deviceInfo = MediaQuery.of(context);
    final buttonSize = (deviceInfo.size.width)*0.7;
    final imageWidth  = deviceInfo.size.width*0.7;
    final imageHeight = deviceInfo.size.height*0.3;
    final deviceWidth = deviceInfo.size.width;
    _takePicture(var source) async {
      final _pickedImage = await _imagePicker.getImage(
        source: source,
        maxHeight: imageHeight,
        maxWidth: imageWidth,
      );
      if(_pickedImage != null){
        setState(() {
          _image = File(_pickedImage.path);
        });
      }
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Profile'),),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            children: [
              // Stack(
              //   children: [
              //     Container(
              //       height: deviceInfo.size.height*0.4,
              //       width: double.infinity,
              //       child:
              //       _image == null ? Image.asset("./assets/images/60111.jpg",fit: BoxFit.fill,)
              //           : Image.file(_image, fit: BoxFit.fill,),
              //     ),
              //     Positioned(
              //         right: 15,
              //         bottom: 15,
              //         child: IconButton(icon: Icon(Icons.add_a_photo_outlined,color: Colors.black, size: 40,), onPressed: (){
              //           _takePicture(ImageSource.gallery);
              //         },)
              //     ),
              //   ],
              // ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Profile info",
                      textAlign: TextAlign.center,
                      style: kMainTextStyle,
                    ),
                    Container(
                      child: Card(
                        margin: EdgeInsets.symmetric(horizontal: 10 , vertical: 5),
                        color: kGridTileColor,
                        elevation: 4,
                        child: Container(
                          margin: EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(child: Column(children: [
                                Text('Role',style: kMainTextStyle,),
                                Text('${profileData.userRole}',softWrap: false, overflow: TextOverflow.visible, style: kSmallTextStyle,),
                              ],),),
                              Expanded(child: Column(children: [
                                Text('Joined date',style: kMainTextStyle,),
                                Text('${profileData.date}' ,softWrap: false, overflow: TextOverflow.visible, style: kSmallTextStyle,),
                              ],),),
                            ],
                          ),
                        ),
                      ),
                    ),
                    InfoCard(title: 'Full name :',text: '${profileData.firstName} ${profileData.lastName}',),
                    InfoCard(title: 'Email :',text: '${profileData.email}',),
                    InfoCard(title: 'Mobile :',text: '${profileData.mobile}',),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      width: buttonSize,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: kErrorColor,
                          elevation: 5,
                        ),
                        onPressed: (){
                          Alert(
                            context: context,
                            style: kAlert,
                            type: AlertType.error,
                            title: "Sign out !",
                            desc: 'are you sure you want to sign out ?',
                            buttons: [
                              DialogButton(
                                child: Text(
                                  "Yes",softWrap: false, overflow: TextOverflow.visible,
                                  style: TextStyle(color: Colors.white, fontSize:deviceWidth <= 320 ? 12 : 20),
                                ),
                                onPressed: () => Navigator.popAndPushNamed(context,'/'),
                                color: kErrorColor,
                                radius: BorderRadius.circular(10),
                              ),
                              DialogButton(
                                child: Text(
                                  "No",
                                  style: TextStyle(color: Colors.white, fontSize:deviceWidth <= 320 ?12 : 20),
                                ),
                                onPressed: () => Navigator.pop(context),
                                color: kFirstButtonColor,
                                radius: BorderRadius.circular(10),
                              ),
                            ],
                          ).show();
                        },
                        child: Text('Sign out',style: kButtonTextStyle,),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
