import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import './screens/welcome_screen.dart';
import './screens/registration_screen.dart';
import './screens/login_screen.dart';
import './screens/seller_home.dart';
import './screens/terms_screen.dart';
import './screens/customer_home.dart';
import './screens/products_screen.dart';
import './screens/product_detail.dart';
import './screens/shopping_cart_screen.dart';
import './screens/categories_page.dart';
import './screens/my_products.dart';
import './screens/add_products.dart';
import './screens/profile_screen.dart';
import './screens/orders_screen.dart';
import './screens/favourites_screen.dart';
import './screens/category_items.dart';
import './screens/received_orders_screen.dart';

import 'providers/auth.dart';
import 'providers/user.dart';
import 'providers/products.dart';
import 'providers/cart.dart';
import 'providers/order.dart';

import 'constants.dart';

void main() {
  runApp(Phoenix(child: MyApp()));
}

class MyApp extends StatelessWidget {
  var _darkMode = ThemeData.dark().copyWith(
    primaryColor: Color(0xFFf0e3ca),
    scaffoldBackgroundColor: Color(0xFFf0e3ca),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: Color(0xff1b1a17),
      ),
    ),
    accentColor: Color(0xffff8303),
    backgroundColor: Colors.red,
  );
  bool _isDark = false;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProvider(
            create: (ctx) => User()
        ),
        ChangeNotifierProvider(
            create: (ctx) => Products() ),
        ChangeNotifierProvider(
            create: (ctx) => Cart() ),
        ChangeNotifierProvider(
          create: (ctx) => Order(),
        ),
      ],
      child: MaterialApp(
        home: WelcomeScreen(),
        debugShowCheckedModeBanner: false,
        title: 'Handy',
        darkTheme: _darkMode,
        theme: ThemeData(
          inputDecorationTheme: InputDecorationTheme(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: kFirstButtonColor),
            )
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: kBackgroundColor.withOpacity(0.5),
          ),
          primaryColor: kBackgroundColor,
          scaffoldBackgroundColor: kBackgroundColor,
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              primary: kMainTextColor,
            ),
          ),
          accentColor: kAppbarColor,
          accentColorBrightness: Brightness.light,
        ),
        themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
        routes: {
          RegistrationScreen.routeName : (ctx) => RegistrationScreen(),
          LoginScreen.routeName : (ctx) => LoginScreen(),
          CustomerHome.routeName : (ctx) => CustomerHome(),
          SellerHome.routeName : (ctx) => SellerHome(),
          ProductsScreen.routeName : (ctx) => ProductsScreen(),
          ProductDetail.routeName : (ctx) => ProductDetail(),
          TermsScreen.routeName : (ctx) => TermsScreen(),
          ShoppingCart.routeName : (ctx) => ShoppingCart(),
          CategoryScreen.routeName : (ctx) => CategoryScreen(),
          MyProducts.routeName : (ctx) => MyProducts(),
          AddProducts.routeName : (ctx) => AddProducts(),
          ProfileScreen.routeName : (ctx) => ProfileScreen(),
          OrderScreen.routeName : (ctx) => OrderScreen(),
          FavouritesScreen.routeName : (ctx) => FavouritesScreen(),
          CategoryItems.routeName : (ctx) => CategoryItems(),
          ReceivedOrders.routeName : (ctx) => ReceivedOrders(),
        },
      ),
    );
  }
}
