import 'package:flutter/material.dart';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:provider/provider.dart';

import '../widgets/product_item.dart';

import '../constants.dart';
import '../providers/products.dart';

class ProductsScreen extends StatefulWidget {
  static const routeName = '/products-screen';

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}
bool isFinished = false;
class _ProductsScreenState extends State<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    final uid = ModalRoute.of(context).settings.arguments as String;
    MediaQueryData deviceInfo = MediaQuery.of(context);
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(title: Text('All Products'),),
      body: RefreshIndicator(
      onRefresh: () => productsData.getProductsData(),
        color: Colors.orange,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: deviceInfo.size.height*0.03,),
                height: deviceInfo.size.height*0.1,
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isFinished ? Text('Welcome to handy !',textAlign: TextAlign.center, style: kAnimatedText) :
                    AnimatedTextKit(
                      pause: Duration(seconds: 2),
                      onFinished: (){
                        setState(() {
                          isFinished = true;
                        });
                      },
                      animatedTexts: [
                        TypewriterAnimatedText('Welcome to handy !',textAlign: TextAlign.center,textStyle: kAnimatedText),
                        TypewriterAnimatedText('Your best handmade shop',textAlign: TextAlign.center, textStyle: kAnimatedText),
                        TypewriterAnimatedText('',textAlign: TextAlign.center,textStyle: kAnimatedText),
                      ],
                    ),],),
              ),
              Expanded(
                child: ProductItem(null,uid),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
