import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


import '../screens/shopping_cart_screen.dart';
import '../screens/my_products.dart';
import '../screens/products_screen.dart';
import '../screens/categories_page.dart';
import '../screens/add_products.dart';
import '../screens/profile_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/favourites_screen.dart';
import '../screens/received_orders_screen.dart';

import '../constants.dart';

import '../providers/user.dart';
import '../providers/order.dart';

class AppDrawer extends StatefulWidget {
  final String type;
  final String uid;

  AppDrawer(this.type,this.uid);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool onOrOff = false;
  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<User>(context).searchForProfile(widget.uid);
    final type = this.widget.type;
    final order = Provider.of<Order>(context);
    return type == 'seller' ?
    Drawer(
      elevation: 4,
      child: Container(
        color: kBackgroundColor,
        child: ListView(
          children: [
            AppBar(title: Text('Handy'), automaticallyImplyLeading: false,),
            Divider(color: Colors.black),
            Card(
              elevation: 2,
              child: ListTile(
                tileColor: kBackgroundColor,
                leading: CircleAvatar(backgroundImage: AssetImage('./assets/images/60111.jpg'),),
                title: Column(
                  children: [
                    Text('${userInfo.firstName} ${userInfo.lastName}',style: kBigTextStyle,),
                    Text('(${userInfo.userRole})',style: kSmallTextStyle,)
                ],),
                trailing: Icon(FontAwesomeIcons.angleDoubleRight , color: Colors.black45,),
                onTap: (){
                  Navigator.pushNamed(context,ProfileScreen.routeName,arguments: widget.uid);
                },
              ),
            ),
            // Divider(color: Colors.black),
            // ListTile(
            //   leading: Icon(FontAwesomeIcons.shoppingBag,color: kFieldTextColor,),
            //   tileColor: kAppbarColor,
            //   title: Text('All products',style: kSmallTextStyle,),
            //   trailing: Icon(FontAwesomeIcons.angleDoubleRight , color: Colors.black45,),
            //   onTap: (){
            //     Navigator.pushNamed(context,ProductsScreen.routeName,arguments:widget.uid);
            //   },
            // ),
            Divider(color: Colors.black),
            ListTile(
              leading: Icon(FontAwesomeIcons.edit , color: kFieldTextColor,),
              tileColor: kAppbarColor,
              title: Text('Manage products',style: kSmallTextStyle,),
              trailing: Icon(FontAwesomeIcons.angleDoubleRight , color: Colors.black45,),
              onTap: (){
                Navigator.pushNamed(context,MyProducts.routeName,arguments: this.widget.uid);
              },
            ),
            Divider(color: Colors.black),
            ListTile(
              leading: Icon(FontAwesomeIcons.plus,color: kFieldTextColor,),
              tileColor: kAppbarColor,
              title: Text('Add product',style: kSmallTextStyle,),
              trailing: Icon(FontAwesomeIcons.angleDoubleRight , color: Colors.black45,),
              onTap: (){
                Navigator.pushNamed(context,AddProducts.routeName);
              },
            ),
            Divider(color: Colors.black),
            ListTile(
              leading: Icon(FontAwesomeIcons.list,color: kFieldTextColor,),
              tileColor: kAppbarColor,
              title: Text('Received orders',style: kSmallTextStyle,),
              trailing: Icon(FontAwesomeIcons.angleDoubleRight , color: Colors.black45,),
              onTap: (){
                order.fetchSellerOrders(widget.uid).then((value) =>
                    Navigator.pushNamed(context,ReceivedOrders.routeName, arguments: widget.uid));
              },
            ),
            Divider(color: Colors.black),
            Card(
              elevation: 2,
              child: ListTile(
                tileColor: kBackgroundColor,
                leading: Icon(FontAwesomeIcons.phone,color: kFieldTextColor,),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Text('Facing a problem ?',style: kBigTextStyle,)),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Call us on  ',style: kSmallTextStyle,),
                          Text('\"00000\"',style: kErrorTextStyle,),
                        ],),
                    )
                  ],),
              ),
            ),
          ],
        ),
      ),
    ) :
    Drawer(
      elevation: 4,
      child: Container(
        color: kBackgroundColor,
        child: ListView(
          children: [
            AppBar(title: Text('Handy'), automaticallyImplyLeading: false,),
            Divider(color: Colors.black),
            Card(
              elevation: 2,
              child: ListTile(
                tileColor: kBackgroundColor,
                leading: CircleAvatar(backgroundImage: AssetImage('./assets/images/60111.jpg'),),
                title: Column(
                  children: [
                    Text('${userInfo.firstName} ${userInfo.lastName}',style: kBigTextStyle,),
                    Text('(${userInfo.userRole})',style: kSmallTextStyle,)
                  ],),
                trailing: Icon(FontAwesomeIcons.angleDoubleRight , color: Colors.black45,),
                onTap: (){
                  Navigator.pushNamed(context,ProfileScreen.routeName,arguments: widget.uid);
                },
              ),
            ),
            Divider(color: Colors.black),
            ListTile(
              leading: Icon(FontAwesomeIcons.shoppingBag,color: kFieldTextColor,),
              tileColor: Colors.white,
              title: Text('All products',style: kSmallTextStyle,),
              trailing: Icon(FontAwesomeIcons.angleDoubleRight , color: Colors.black45,),
              onTap: (){
                Navigator.pushNamed(context,ProductsScreen.routeName,arguments:widget.uid);
              },
            ),
            Divider(color: Colors.black),
            ListTile(
              leading: Icon(FontAwesomeIcons.layerGroup,color: kFieldTextColor,),
              tileColor: kAppbarColor,
              title: Text('Categories',style: kSmallTextStyle,),
              trailing: Icon(FontAwesomeIcons.angleDoubleRight , color: Colors.black45,),
              onTap: (){
                Navigator.pushNamed(context,CategoryScreen.routeName,arguments: widget.uid);
              },
            ),
            Divider(color: Colors.black),
            ListTile(
              tileColor: kAppbarColor,
              leading: Icon(FontAwesomeIcons.cartPlus,color: kFieldTextColor,),
              title: Text('Cart',style: kSmallTextStyle,),
              trailing: Icon(FontAwesomeIcons.angleDoubleRight , color: Colors.black45,),
              onTap: (){
               Navigator.pushNamed(context,ShoppingCart.routeName,arguments: widget.uid);
              },
            ),
            Divider(color: Colors.black),
            ListTile(
              leading: Icon(FontAwesomeIcons.list,color: kFieldTextColor,),
              tileColor: kAppbarColor,
              title: Text('Your orders',style: kSmallTextStyle,),
              trailing: Icon(FontAwesomeIcons.angleDoubleRight , color: Colors.black45,),
              onTap: ()  {
                Navigator.pushNamed(context,OrderScreen.routeName,arguments: widget.uid);
              },
            ),
            Divider(color: Colors.black),
            ListTile(
              leading: Icon(FontAwesomeIcons.solidHeart,color: kFieldTextColor,),
              tileColor: kAppbarColor,
              title: Text('Favorites',style: kSmallTextStyle,),
              trailing: Icon(FontAwesomeIcons.angleDoubleRight , color: Colors.black45,),
              onTap: (){
                Navigator.pushNamed(context,FavouritesScreen.routeName,arguments: widget.uid);
              },
            ),
            Divider(color: Colors.black),
            Card(
              elevation: 2,
              child: ListTile(
                tileColor: kBackgroundColor,
                leading: Icon(FontAwesomeIcons.phone,color: kFieldTextColor,),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Text('Facing a problem ?',style: kBigTextStyle,)),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        Text('Call us on  ',style: kSmallTextStyle,),
                        Text('\"00000\"',style: kErrorTextStyle,),
                      ],),
                    )
                  ],),
              ),
            ),
          ],
        ),
      ),
    );
  }
}