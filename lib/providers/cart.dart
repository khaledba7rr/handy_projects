import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CartItem{
  final String id;
  final String price;
  final int quantity;
  final String title;
  final String image;
  final String sellerUid;
  CartItem({
    this.image,
    this.title,
    this.quantity,
    this.price,
    this.id,
    this.sellerUid,
  });
}
class Cart with ChangeNotifier {

  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems {
    return [..._cartItems];
  }

  double get totalPrice {
    var total = 0.0;
    _cartItems.forEach((element) {
      total = double.parse(element.price) * element.quantity + total;
    });
    return total;
  }

  Future<void> addItemToCart (String id,image,title,price,uid,sellerUid) async{
    final url = 'https://handy-3439a-default-rtdb.firebaseio.com/profiles.json';
    final response = await http.get(Uri.parse(url));
    final profileData = jsonDecode(response.body) as Map<String,dynamic>;
    String profile;
    profileData.forEach((key, value) async {
    try{
      if(value['uid'] == uid){
        profile = key;
        final cartUrl = 'https://handy-3439a-default-rtdb.firebaseio.com/profiles/$profile/cartData.json';
        if(value['cartData'] == null){
          await http.post(Uri.parse(cartUrl),body: jsonEncode({
            'id' : id,
            'image' : image,
            'title' : title,
            'price' : price,
            'quantity' : 1,
            'sellerUid' : sellerUid,
          }));
        }
        if(value['cartData'] != null){
          final response = await http.get(Uri.parse(cartUrl));
          final cartData = jsonDecode(response.body) as Map<String,dynamic>;
          cartData.forEach((key, value) async{
            if(value['id'] == id){
              final existingCartItem = 'https://handy-3439a-default-rtdb.firebaseio.com/profiles/$profile/cartData/$key.json';
              await http.patch(Uri.parse(existingCartItem),body: jsonEncode({
                'quantity' : value['quantity']+1,
              }));
            }
          });
          final existedProduct = cartData.values.where((element) => element['id'] == id);
          if(existedProduct.isEmpty){
            http.post(Uri.parse(cartUrl),body: jsonEncode({
              'id' : id,
              'image' : image,
              'title' : title,
              'price' : price,
              'quantity' : 1,
              'sellerUid' : sellerUid,
            }));
          }
        }
      }
    }catch(e){
      throw e;
    }
      });
  }

  Future<void> getCartItems(String uid) async{
    final url = 'https://handy-3439a-default-rtdb.firebaseio.com/profiles.json';
    final response = await http.get(Uri.parse(url));
    final profileData = jsonDecode(response.body) as Map<String,dynamic>;
    List<CartItem> loadedCart = [];
    String profile;
    profileData.forEach((key, value) async {
      if (value['uid'] == uid) {
        profile = key;
          final cartUrl = 'https://handy-3439a-default-rtdb.firebaseio.com/'
              'profiles/$profile/cartData.json';
          final response = await http.get(Uri.parse(cartUrl));
          final cartData = jsonDecode(response.body) as Map<String,dynamic>;
          if(cartData != null){
            cartData.forEach((key, value) {
              loadedCart.add(
                CartItem(
                  id: value['id'],
                  image: value['image'],
                  price: value['price'],
                  quantity: value['quantity'],
                  title: value['title'],
                  sellerUid: value['sellerUid'],
                )
              );
            });
          }
          _cartItems = loadedCart;
          notifyListeners();
      }
    });
  }

  Future<void> undo (String id,uid,type) async{
    final url = 'https://handy-3439a-default-rtdb.firebaseio.com/profiles.json';
    final response = await http.get(Uri.parse(url));
    final profileData = jsonDecode(response.body) as Map<String,dynamic>;
    String profile;
    profileData.forEach((key, value) async {
      try{
        if(value['uid'] == uid){
          profile = key;
          final cartUrl = 'https://handy-3439a-default-rtdb.firebaseio.com/profiles/$profile/cartData.json';
          if(value['cartData'] != null){
            final response = await http.get(Uri.parse(cartUrl));
            final cartData = jsonDecode(response.body) as Map<String,dynamic>;
            cartData.forEach((key, value) async{
              if(value['id'] == id){
                final existingCartItem = 'https://handy-3439a-default-rtdb.firebaseio.com/profiles/$profile/cartData/$key.json';
                if(type == 'undo'){
                  if(value['quantity'] > 1){
                    await http.patch(Uri.parse(existingCartItem),body: jsonEncode({
                      'quantity' : value['quantity'] - 1,
                    }));
                  }
                  if(value['quantity'] == 1){
                    await http.delete(Uri.parse(existingCartItem));
                  }
                }
                if(type == 'decrease'){
                  if(value['quantity'] > 1){
                    await http.patch(Uri.parse(existingCartItem),body: jsonEncode({
                      'quantity' : value['quantity'] - 1,
                    }));
                    return;
                  }
                  if(value['quantity'] == 1){
                    await http.delete(Uri.parse(existingCartItem));
                    return;
                  }
                }
                if(type == 'increase'){
                  await http.patch(Uri.parse(existingCartItem),body: jsonEncode({
                    'quantity' : value['quantity'] + 1,
                  }));
                }
              }
            });
          }
        }
      }catch(e){
        throw e;
      }
    });
  }

  Future<void> clearItems(String uid) async{
    _cartItems.clear();
    final url = 'https://handy-3439a-default-rtdb.firebaseio.com/profiles.json';
    final response = await http.get(Uri.parse(url));
    final profileData = jsonDecode(response.body) as Map<String,dynamic>;
    String profile;
    profileData.forEach((key, value) async {
      if (value['uid'] == uid) {
        profile = key;
        final cartUrl = 'https://handy-3439a-default-rtdb.firebaseio.com/profiles/$profile/cartData.json';
        await http.delete(Uri.parse(cartUrl));
      }
      });

  }
  
}