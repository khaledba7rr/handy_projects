import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../providers/cart.dart';
import '../constants.dart';

class ProductDetail extends StatefulWidget {
  static const routeName = '/product-detail';
  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  bool changed = false;
  bool error = false;
  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceInfo = MediaQuery.of(context);
    final arguments = ModalRoute.of(context).settings.arguments as Map<String,dynamic>;
    final productData = Provider.of<Products>(context).productsItems.firstWhere((element) => element.id == arguments['id']);
    final cartData = Provider.of<Cart>(context);
    final products = Provider.of<Products>(context);

    void addItemToCart(){
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: kAppbarColor,
        content: Text('Item \'s been added'),
        duration: Duration(seconds: 2),
        action: SnackBarAction(
          label: 'undo',
          textColor: Colors.white,
          onPressed: () => cartData.undo(productData.id,arguments['uid'],'undo'),
        ),
      ),);
    }
    bool isItemFavorite(){
      bool favorite;
      if(products.favoriteProductsItems.isEmpty){
        favorite = false;
        return favorite;
      }
      if(products.favoriteProductsItems.isNotEmpty){
        final  existingProduct = products.favoriteProductsItems.singleWhere((element) => element.id == arguments['id'] , orElse: ()=> null);
        if(existingProduct == null){
          favorite = false;
          return favorite;
        }
        if(existingProduct.isFavourite){
          favorite = true;
          return favorite;
        }
        if(!existingProduct.isFavourite){
          favorite = false;
          return favorite;
        }
      }
    }

    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Container(
                    height: deviceInfo.size.height*0.35,
                    width: double.infinity,
                    child: Stack(
                      children: <Widget>[
                        Image.network(
                          productData.imageURL,
                          fit: BoxFit.fill,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Image.asset('./assets/images/imageError.png')),
                              ),
                            );
                          },
                            loadingBuilder: (context, child, loadingProgress) {
                              if(loadingProgress == null) return child;
                              return Center(child: SpinKitCubeGrid(color: kFirstButtonColor,),);
                            }
                        ), //This
                        // should be a paged
                        Positioned(
                          bottom: 10,
                          right: 20,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black87,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(40)),
                              color: Colors.white,
                            ),
                            child: IconButton(
                              onPressed: () async {
                                setState(() {changed = true;});
                                await products.toggleFavourite(arguments['id'], arguments['uid'])
                                .catchError((error){
                                  showDialog(context: context, builder: (ctx) => AlertDialog(
                                    title: Text('An error has occurred !'),
                                    content: Text('Something went wrong'),
                                  )).then((value) => setState(()=> changed=false));
                                });
                               Future.delayed(Duration(seconds: 2))
                                .then((value) => products.getFavoriteProductsData(arguments['uid']))
                                .then((value) {if(mounted)setState((){changed=false;});});
                               if(!mounted) return;
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    backgroundColor: kFirstButtonColor,
                                    content: Text( isItemFavorite() ? 'removed from favourites!' : 'Added to favourites!' ,textAlign: TextAlign.center, style: kSmallTextStyle,),
                                    duration: Duration(seconds: 3),
                                  ),);
                              },
                              icon: changed ? CircularProgressIndicator(color: kFirstButtonColor, strokeWidth: 2,)
                              : Icon( isItemFavorite() ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,color: Colors.red,),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 20,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black87,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(40)),
                              color: Colors.white,
                            ),
                            child: IconButton(
                              icon: Icon(FontAwesomeIcons.shoppingBag,color: Colors.black87,),
                              onPressed: (){
                                cartData.addItemToCart(productData.id, productData.imageURL, productData.title, productData.price,arguments['uid'],productData.uid)
                                .catchError((error){
                                  showDialog(context: context, builder: (ctx) => AlertDialog(
                                    title: Text('An error has occurred !'),
                                    content: Text('Something went wrong'),
                                  ));
                                });
                                addItemToCart();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white38,
                    margin: EdgeInsets.only(bottom: 10),
                    child: Column(
                    children: [
                        Text(productData.title,
                          softWrap: true,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 12,
                            fontFamily: 'DelaGothic',
                          ),),
                        Text('${productData.price} EGP' , style: kBigTextStyle),
                    ],
                  ),),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Center(
                      child: Text(productData.description ,textAlign: TextAlign.center, style: kVerySmallTextStyle,),),
                  ),
                  Divider(color: Colors.white,),
                  Row( mainAxisAlignment : MainAxisAlignment.spaceAround,
                    children: [Text('Uploaded by',style: kVerySmallTextStyle,),Text(productData.userName ,textAlign: TextAlign.center, style: kVerySmallTextStyle,),],),
                  Divider(color: Colors.white,),
                  Row( mainAxisAlignment : MainAxisAlignment.spaceAround,
                    children: [Text('Upload date',style: kVerySmallTextStyle,),Text(productData.uploadedDate ,textAlign: TextAlign.center, style: kVerySmallTextStyle,),],),
                  Divider(color: Colors.white,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        fit: BoxFit.contain,
                          child: Text('Products takes 3 to 5 days to be delivered.',style: kSmallErrorTextStyle,)),
                    ],)
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 15),
              width: deviceInfo.size.width*0.6,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFf3ab00),
                  elevation: 4,
                ),
                onPressed: (){
                  cartData.addItemToCart(productData.id, productData.imageURL, productData.title, productData.price,arguments['uid'],productData.uid)
                      .catchError((error){
                    showDialog(context: context, builder: (ctx) => AlertDialog(
                      title: Text('An error has occurred !'),
                      content: Text('Something went wrong'),
                    ));
                  });
                  addItemToCart();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(FontAwesomeIcons.shoppingBag),
                    Text('Add to cart',style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontFamily: 'DelaGothic',
                    ),),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
