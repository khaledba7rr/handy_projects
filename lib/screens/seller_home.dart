import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:provider/provider.dart';

import '../widgets/drawer.dart';

import '../constants.dart';
import 'add_products.dart';
import 'received_orders_screen.dart';

import '../providers/products.dart';
import '../providers/order.dart';

class SellerHome extends StatefulWidget {
  static const routeName = '/seller-home';
  @override
  _SellerHomeState createState() => _SellerHomeState();
}

class _SellerHomeState extends State<SellerHome> {
  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(title: Center(child: Text('Welcome to handy'),),);
    final uid = ModalRoute.of(context).settings.arguments as String;
    final MediaQueryData deviceInfo = MediaQuery.of(context);
    final productsData = Provider.of<Products>(context);
    final myProducts = productsData.productsItems.
    where((element) => element.uid == uid ).toList();
    final order = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: Center(child: Text('Handy',style: kBigTextStyle,)),
      ),
      drawer: AppDrawer('seller',uid),
      body: WillPopScope(
        onWillPop: () => showDialog<bool>(
          context: context,
          builder: (c) => AlertDialog(
            elevation: 2,
            title: Text(
              'Warning',
              style: TextStyle(color: kErrorColor),
            ),
            backgroundColor: kBackgroundColor,
            content: Text(
              'Do you want sign out ?',
              style: kSmallTextStyle,
            ),
            actions: [
              ElevatedButton(
                  child: Text(
                    'Yes',
                    style: kSmallTextStyle,
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: kErrorColor,
                  ),
                  onPressed: () {
                    setState(() {
                      Navigator.popAndPushNamed(context, '/');
                    });
                  }
              ),
              ElevatedButton(
                child: Text(
                  'No',
                  style: kSmallTextStyle,
                ),
                style: ElevatedButton.styleFrom(
                  primary: kFirstButtonColor,
                ),
                onPressed: () => Navigator.pop(c, false),
              ),
            ],
          ),
        ),
        child: ListView(
          children: [
            Container(
              width: deviceInfo.size.width*0.29,
              height: deviceInfo.size.height*0.29,
              child: Hero(child: Image.asset('./assets/images/logo.png'),tag: 'logo',),
            ),
            Column(
              children: [
                Container(
                  height: deviceInfo.size.height*0.2,
                  width: deviceInfo.size.width*0.8,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, AddProducts.routeName);
                    },
                    child: Card(
                      elevation: 5,
                      color: kFirstButtonColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: deviceInfo.size.width*0.4,
                              child: FittedBox(
                                fit: BoxFit.contain,
                                  child: Text('Add new product',style: kMainTextStyle,))),
                          Icon(FontAwesomeIcons.plus,size: 30,),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: deviceInfo.size.height*0.05,),
                Divider(color: Colors.black,),
                SizedBox(height: deviceInfo.size.height*0.05,),
                Container(
                  height: deviceInfo.size.height*0.2,
                  width: deviceInfo.size.width*0.8,
                  child: GestureDetector(
                    onTap: (){
                          Navigator.pushNamed(context,ReceivedOrders.routeName, arguments: uid);
                    },
                    child: Card(
                      elevation: 5,
                      color: kFirstButtonColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              width: deviceInfo.size.width*0.4,
                              child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text('Received orders',style: kMainTextStyle,))),
                          Icon(FontAwesomeIcons.list,size: 30,),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
