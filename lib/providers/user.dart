import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class User with ChangeNotifier {
  final String id;
  final String firstName;
  final String lastName;
  final String address;
  final String mobile;
  final String userRole;
  final String uid;
  final String email;
  final String date;
  User({this.id, this.mobile, this.firstName, this.lastName, this.address, this.userRole,this.uid,this.email,this.date});
  List<User> _profileItems = [];

  List<User> get profileItems {
    return [..._profileItems];
  }

  Future<dynamic> getProfileData() async {
    const url = 'https://handy-3439a-default-rtdb.firebaseio.com/profiles.json';
    final response = await http.get(Uri.parse(url));
    final profileData = jsonDecode(response.body) as Map<String,dynamic>;
    final List<User> loadedData = [];
    profileData.forEach((key, value) {
      loadedData.insert(0,User(
        id: key,
        uid: value['uid'],
        address: value['address'],
        userRole: value['userRole'],
        mobile: value['mobile'],
        firstName: value['firstName'],
        lastName: value['lastName'],
        email: value['email'],
        date: value['joinedDate']
      ));
    });
    _profileItems = loadedData;
    notifyListeners();
    return profileData;
  }

  User searchForProfile(String uid){
    return profileItems.firstWhere((element) => element.uid == uid);
  }

}