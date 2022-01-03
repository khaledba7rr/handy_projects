import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:provider/provider.dart';

import 'product_detail.dart';
import 'products_screen.dart';
import '../providers/products.dart';

import '../constants.dart';

class FavouritesScreen extends StatefulWidget {
  static const routeName = '/favourites-screen';
  @override
  _FavouritesScreenState createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  bool _isExecuted;
  bool _isLoading = true;
  @override
  void initState() {
    _isExecuted = false;
    super.initState();
  }
  @override
  void didChangeDependencies() {
    final uid = ModalRoute.of(context).settings.arguments as String;
    if(!_isExecuted){
      Provider.of<Products>(context,listen: false).getFavoriteProductsData(uid)
          .then((value) => _isLoading = false);
      _isExecuted = true;
    }
    super.didChangeDependencies();
  }
  Widget build(BuildContext context) {
    MediaQueryData deviceInfo = MediaQuery.of(context);
    final uid = ModalRoute.of(context).settings.arguments as String;
    final product = Provider.of<Products>(context);
    final favoritesData = product.favoriteProductsItems.
    where((element) => element.isFavourite == true).toList();
    List<Products> productsData = [];
    favoritesData.forEach((element) {
      productsData.add(product.findById(element.id));
    });
    return Scaffold(
      appBar: AppBar(
        backwardsCompatibility: false,
        title: Text('Favorites',style: kMainTextStyle,),
        iconTheme: IconThemeData(
          color: Colors.black87,
        ),
      ),
      body: _isLoading ?
      Center(child: SpinKitPumpingHeart(color: kErrorColor,duration: Duration(seconds: 3),),) :
      favoritesData.isEmpty ?
      Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                margin: EdgeInsets.only(top: 30),
                width: deviceInfo.size.width*0.95,
                child: Column(
                  children: [
                    Image.asset('./assets/images/love.png'),
                    Spacer(flex: 3,),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('You don\'t have any favorite items yet',style: kVerySmallTextStyle,),
                            TextButton(onPressed: (){
                              Navigator.pushNamed(context, ProductsScreen.routeName);
                            }, child: Text('shop now !',style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              decoration: TextDecoration.underline,
                              decorationThickness: 2,

                            ),),),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            )
          :
      Container(
            margin: EdgeInsets.all(8),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 15 , bottom: 15,),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Favorites', style: kSmallTextStyle,),
                      SizedBox(width: 10,),
                      Icon(FontAwesomeIcons.solidHeart, color: kErrorColor,),
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                      itemCount: productsData.length,
                      itemBuilder: (ctx,i) => ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                  child: GridTile(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, ProductDetail.routeName , arguments: {
                          'id' : productsData[i].id,
                          'uid' : uid,
                        });
                      },
                      child: Image.network(productsData[i].imageURL,fit: BoxFit.fill,),
                    ),
                    footer: GridTileBar(
                      backgroundColor: kGridTileColor,
                      title: Center(child : Text(productsData[i].title,style: kSmallTextStyle,)),
                    ),
                  ),
                      ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3/2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                ),
                ),
              ],
            ),
          ),
    );
  }
}
