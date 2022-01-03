import 'package:flutter/material.dart';
import 'dart:convert';


import 'package:http/http.dart' as http;
class Auth with ChangeNotifier {

  Future<dynamic> signUp(String email ,String password) async {
    const url = 'https://identitytoolkit.googleapis.com/v1/accounts:'
        'signUp?key=AIzaSyCMdKfAuVfJRtOW6HejQumaM380E-4NX60';
      final response = await http.post(Uri.parse(url), body: jsonEncode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }
      ));
      final data = jsonDecode(response.body);
      return data;
  }

  Future<void> uploadProfileData ({String firstName,lastName,type,address,mobile,uid,email,date}) async {
    const url = 'https://handy-3439a-default-rtdb.firebaseio.com/profiles.json';
    await http.post(Uri.parse(url), body: jsonEncode({
      'email' : email,
      'userRole' : type,
      'firstName' : firstName,
      'lastName' : lastName,
      'address' : address,
      'mobile' : mobile,
      'uid' : uid,
      'joinedDate' : date,
    }));
  }

  Future<dynamic> logIn(String email,password) async {
    try{
      const url = 'https://identitytoolkit.googleapis.com/v1/'
          'accounts:signInWithPassword?key= AIzaSyCMdKfAuVfJRtOW6HejQumaM380E-4NX60';
      final response = await http.post(Uri.parse(url), body:jsonEncode(
          {
            'email' : email,
            'password' : password,
            'returnSecureToken' : true,
          }
      ));
      final responseData = jsonDecode(response.body);
      return responseData;
    }catch(e){
      throw e;
    }
  }

  Future<void> uploadProductsData ({String title,description,price,imageUrl,date,uploadedBy,uid,category, bool isFavourite}) async {
    const url = 'https://handy-3439a-default-rtdb.firebaseio.com/products.json';
    await http.post(Uri.parse(url), body: jsonEncode({
      'title' : title,
      'description': description,
      'price' : price,
      'image' : imageUrl,
      'date' : date,
      'uploadedBy' : uploadedBy,
      'uid': uid,
      'category': category,
      'isFavourite': isFavourite,
    }));
  }


}
