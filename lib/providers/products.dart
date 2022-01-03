import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String price;
  final String imageURL;
  final String uploadedDate;
  final String userName;
  final String uid;
  final String category;
  bool isFavourite;

  Products({
    this.title, this.description, this.price, this.imageURL,
    this.uid, this.uploadedDate, this.userName, this.id, this.category,
    this.isFavourite = false,
  });

  List<Products> _productsItems = [];

  List<Products> get productsItems {
    return [..._productsItems];
  }

  List<Products> _favoriteProductsItems = [];

  List<Products> get favoriteProductsItems {
    return [..._favoriteProductsItems];
  }

  Future<void> getProductsData() async {
    const url = 'https://handy-3439a-default-rtdb.firebaseio.com/products.json';
    final response = await http.get(Uri.parse(url));
    final profileData = jsonDecode(response.body) as Map<String, dynamic>;
    final List<Products> loadedData = [];
    profileData.forEach((key, value) {
      loadedData.insert(0, Products(
        id: key,
        price: value['price'],
        description: value['description'],
        title: value['title'],
        uid: value['uid'],
        imageURL: value['image'],
        uploadedDate: value['date'],
        userName: value['uploadedBy'],
        category: value['category'],
        isFavourite: value['isFavourite'],
      ));
    });
    _productsItems = loadedData;
    notifyListeners();
  }

  Products findById(String id) {
    return _productsItems.singleWhere((element) => element.id == id);
  }

  String testById(String id) {
    final test = favoriteProductsItems.singleWhere((element) => element.id == id).toString();
    if(test.isNotEmpty){
      print(test);
      return test;
    }
    if(test.isEmpty){
      print(test);
      return null;
    }
  }

  Future<dynamic> getFavoriteProductsData(String uid) async {
    const url = 'https://handy-3439a-default-rtdb.firebaseio.com/profiles.json';
    final response = await http.get(Uri.parse(url));
    final profileData = jsonDecode(response.body) as Map<String,dynamic>;
    final List<Products> loadedData = [];
    String profile;
    profileData.forEach((key, value) async{
      if(value['uid'] == uid) {
        try {
          profile = key;
          final profileUrl = 'https://handy-3439a-default-rtdb.firebaseio.com/'
              'profiles/$profile/favProducts.json';
          final favoriteResponse = await http.get(Uri.parse(profileUrl));
          final favoriteData = jsonDecode(favoriteResponse.body) as Map<
              String,
              dynamic>;
          if (favoriteData != null) {
            favoriteData.forEach((key, value) {
              loadedData.add(Products(
                id: value['id'],
                isFavourite: value['isFavorite'],
              ));
              _favoriteProductsItems = loadedData;
              notifyListeners();
              return _favoriteProductsItems;
            });
          }
        }catch(error){
          throw error;
        }
        _favoriteProductsItems = loadedData;
        notifyListeners();
      }
    });
    return profileData;
  }

  Future<void> toggleFavourite(String id,uid) async {
    final url = 'https://handy-3439a-default-rtdb.firebaseio.com/profiles.json';
    final response = await http.get(Uri.parse(url));
    final profileData = jsonDecode(response.body) as Map<String,dynamic>;
    String profile;
    profileData.forEach((key, value) async {
      try{
        if(value['uid'] == uid){
          profile = key;
          final profileUrl = 'https://handy-3439a-default-rtdb.firebaseio.com/profiles/$profile/favProducts.json';
          if(value['favProducts'] == null){
            await http.post(Uri.parse(profileUrl),body: jsonEncode({
              'id' : id,
              'isFavorite' : true,
            }));
          }
          if(value['favProducts'] != null){
            final response = await http.get(Uri.parse(profileUrl));
            final favProducts = jsonDecode(response.body) as Map<String,dynamic>;
            favProducts.forEach((key,value) async{
              if(value['id'] == id){
                final newProductUrl = 'https://handy-3439a-default-rtdb.firebaseio.com'
                    '/profiles/$profile/favProducts/$key.json';
                await http.patch(Uri.parse(newProductUrl),body: jsonEncode({
                  'isFavorite' : !value['isFavorite']
                }));
                return;
              }
            });
            final existedProduct = favProducts.values.where((element) => element['id'] == id);
            if(existedProduct.isEmpty){
              await http.post(Uri.parse(profileUrl),body: jsonEncode({
                'id' : id,
                'isFavorite' : true,
              }));
            }
          }
        }
      }catch(e){
        print(e);
        throw e;
      }
      notifyListeners();
    });
  }

  Future<void> updateProduct({String id, price, description, category, image, title}) async {
    final productIndex = _productsItems.indexWhere((element) =>
    element.id == id);
    if (productIndex >= 0) {
      final url = 'https://handy-3439a-default-rtdb.firebaseio.com/products/$id.json';
      await http.patch
        (Uri.parse(url),
          body: jsonEncode(
              {
                'price': price,
                'title': title,
                'description': description,
                'image': image,
                'category': category,
              }
          )
      );
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = 'https://handy-3439a-default-rtdb.firebaseio.com/products/$id.json';
    final existingProductIndex = _productsItems.indexWhere((prod) => prod.id == id);
    var existingProduct = _productsItems[existingProductIndex];
    _productsItems.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _productsItems.insert(existingProductIndex, existingProduct);
      notifyListeners();
    }
    existingProduct = null;
  }
}