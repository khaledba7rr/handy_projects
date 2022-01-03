import 'package:flutter/material.dart';
import 'dart:convert';


import 'cart.dart';

import 'package:http/http.dart' as http;

class OrderItem {
  final DateTime time;
  final String id;
  final double amount;
  final List<CartItem> products;
  final String uid;
  bool isExpanded = false;
  final customerName;
  final customerMobile;
  final customerAddress;
  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.time,
    this.customerName,
    this.customerMobile,
    this.customerAddress,
    this.uid
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  List<OrderItem> _receivedOrders = [];

  List<OrderItem> get receivedOrders {
    return [..._receivedOrders];
  }

  Future<void> addOrder ({List<CartItem> products, double amount, String uid,date}) async {
    const url = 'https://handy-3439a-default-rtdb.firebaseio.com/profiles.json';
    final response = await http.get(Uri.parse(url));
    final profileData = jsonDecode(response.body) as Map<String,dynamic>;
    String profile;
    profileData.forEach((key, value) async {
      if(value['uid'] == uid){
        profile = key;
        final activeProfile = 'https://handy-3439a-default-rtdb.firebaseio.com/profiles/$profile/orders.json';
        await http.post(Uri.parse(activeProfile) ,body: jsonEncode({
            'products' : products.map((e) => {
              'id' : e.id,
              'title' : e.title,
              'quantity' : e.quantity,
              'price' : e.price,
              'sellerUid' : e.sellerUid,
            }).toList(),
            'amount' : amount,
            'date' : date,
          }));
      }
    });
    notifyListeners();
  }

  Future<void> fetchOrders (String uid) async {
    const url = 'https://handy-3439a-default-rtdb.firebaseio.com/profiles.json';
    final response = await http.get(Uri.parse(url));
    final List<OrderItem> loadedOrders = [];
    String profile;
    final profileData = jsonDecode(response.body) as Map<String,dynamic> ;
    profileData.forEach((key, value) async {
      if(value['uid'] == uid){
        profile = key;
        final ordersUrl = 'https://handy-3439a-default-rtdb.firebaseio.com/'
            'profiles/$profile/orders.json';
        final ordersResponse = await http.get(Uri.parse(ordersUrl));
        final orders = await jsonDecode(ordersResponse.body) as Map<String,dynamic>;
        orders.forEach((orderId,order) {
          loadedOrders.add( OrderItem(
            id: orderId,
            amount: order['amount'],
            products: (order['products'] as List<dynamic>).map((item) => CartItem(
              title: item['title'],
              quantity: item['quantity'],
              price: item['price'],
              id: item['id'],
              sellerUid: item['sellerUid'],
            ),).toList(),
            time: DateTime.parse(order['date']),
            uid: order['uid'],
          ));
          _orders = loadedOrders;
          notifyListeners();
          });
      }
    });
  }

  Future<void> sellerOrder({List<CartItem> products, double amount , date , customerUid}) async{
    const url = 'https://handy-3439a-default-rtdb.firebaseio.com/profiles.json';
    final response = await http.get(Uri.parse(url));
    final profileData = jsonDecode(response.body) as Map<String,dynamic>;
    String sellerProfile;
    var customerMobile;
    String customerName;
    String customerAddress;
    profileData.forEach((key, value) async {
      if(value['uid'] == customerUid){
        customerName = value['firstName'] + value['lastName'];
        customerMobile = value['mobile'];
        customerAddress = value['address'];
      }
    });
    products.forEach((element) {
      profileData.forEach((key, value) async {
        if(value['uid'] == element.sellerUid){
          sellerProfile = key;
          final activeSeller = 'https://handy-3439a-default-rtdb.firebaseio.com/'
              'profiles/$sellerProfile/orders.json';
          final activeProducts = products.where((element) => element.sellerUid == value['uid']);
          await http.post(Uri.parse(activeSeller),body: jsonEncode({
            'products' : activeProducts.map((e) => {
              'id' : e.id,
              'title' : e.title,
              'quantity' : e.quantity,
              'price' : e.price,
            }).toList(),
            'amount' : amount,
            'date' : date,
            'customerMobile' : customerMobile.toString(),
            'customerAddress' : customerAddress.toString(),
            'customerName' : customerName.toString(),
          }));
        }
      });
    });
    notifyListeners();
  }

  Future<void> fetchSellerOrders (String uid) async {
    const url = 'https://handy-3439a-default-rtdb.firebaseio.com/profiles.json';
    final response = await http.get(Uri.parse(url));
    final List<OrderItem> loadedOrders = [];
    String profile;
    final profileData = jsonDecode(response.body) as Map<String,dynamic> ;
    profileData.forEach((key, value) async {
      if(value['uid'] == uid){
        profile = key;
        final ordersUrl = 'https://handy-3439a-default-rtdb.firebaseio.com/'
            'profiles/$profile/orders.json';
        final ordersResponse = await http.get(Uri.parse(ordersUrl));
        final orders = await jsonDecode(ordersResponse.body) as Map<String,dynamic>;
        orders.forEach((orderId,order) {
          loadedOrders.add( OrderItem(
            id: orderId,
            amount: order['amount'],
            products: (order['products'] as List<dynamic>).map((item) => CartItem(
              title: item['title'],
              quantity: item['quantity'],
              price: item['price'],
              id: item['id'],
              sellerUid: item['sellerUid'],
            ),).toList(),
            time: DateTime.parse(order['date']),
            uid: order['uid'],
            customerAddress: order['customerAddress'],
            customerMobile: order['customerMobile'].toString(),
            customerName: order['customerName'],
          ));
        });
        _receivedOrders = loadedOrders;
        notifyListeners();
      }
    });
  }

  }
