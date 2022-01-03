import 'package:flutter/material.dart';

import '../widgets/shopping_cart_items.dart';

class ShoppingCart extends StatelessWidget {
  static const routeName = '/shopping-cart';
  @override
  Widget build(BuildContext context) {
    final uid = ModalRoute.of(context).settings.arguments as String ;
    return Scaffold(
        appBar: AppBar(title: Center(child: Text('Cart')),),
        body:  ShoppingCartItem(uid),
    );
  }
}
