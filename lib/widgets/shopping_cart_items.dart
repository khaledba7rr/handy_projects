import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../screens/products_screen.dart';

import '../constants.dart';

import '../providers/cart.dart';
import '../providers/order.dart';

class ShoppingCartItem extends StatefulWidget {
  final String uid;
  ShoppingCartItem(this.uid);
  @override
  _ShoppingCartItemState createState() => _ShoppingCartItemState();

}
class _ShoppingCartItemState extends State<ShoppingCartItem> {
  bool changed = false;
  bool _cashCheck = false;
  bool _fawryCheck = false;
  bool _visaCheck = false;
  bool _isExecuted;
  bool _isLoading = true;
  @override
  void initState() {
    _isExecuted = false;
    super.initState();
  }
  @override
  void didChangeDependencies() {
    if(!_isExecuted){
      Provider.of<Cart>(context,listen: false).getCartItems(widget.uid)
          .then((value) => _isLoading = false)
          .catchError((error){
        showDialog(context: context, builder: (ctx) => AlertDialog(
          title: Text('An error has occurred !'),
          content: Text('Something went wrong'),
        ));
      }).then((value) => _isLoading = false);
    }
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context).cartItems;
    final cart = Provider.of<Cart>(context);
    final order = Provider.of<Order>(context);
    MediaQueryData deviceInfo = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: _isLoading ? Center(child: SpinKitCubeGrid(color: kFirstButtonColor,),) :
      cartData.length == 0 ?
      Column(
        children: [
          Center(child: Hero(
              child: Image.asset('./assets/images/logo.png',),
            tag: 'logo',
          )),
          Spacer(flex: 3,),
          Container(
            width: deviceInfo.size.width*0.95,
            child: FittedBox(
              fit: BoxFit.contain,
              child: TextButton(onPressed: (){
                Navigator.pushNamed(context,ProductsScreen.routeName , arguments: widget.uid);
              },
                child: Text.rich(
                  TextSpan(
                    text: 'Your cart is empty.  ',style: kSmallTextStyle,
                    children: [
                      TextSpan(text: ' shop now !',style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        decoration: TextDecoration.underline,
                        decorationThickness: 2,
                      ),),
                    ]
                  ),
                ),
              ),
            ),
          ),
          Spacer(),
        ],
      )
          :
      Column(
        children: [
          Card(
            color: kFirstButtonColor,
            margin: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Total', style: kBigTextStyle,),
                Chip(
                  label: Text('${cart.totalPrice.toStringAsFixed(2)} EGP', style: kBigTextStyle),
                  backgroundColor:  kBackgroundColor,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                  itemCount: cartData.length,
                  itemBuilder: (context,i) => Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: kAppbarColor),
                    ),
                    margin: EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Container(
                          width: deviceInfo.size.width*0.63,
                          height: deviceInfo.size.height*0.09,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(cartData[i].title,style: kSmallTextStyle,),
                              Text('\$${cartData[i].price}',style: kSmallTextStyle,),
                            ],
                          ),
                        ),
                        Container(
                          height: deviceInfo.size.height*0.25,
                          width: deviceInfo.size.width*0.63,
                          child: Image.network(cartData[i].image,fit: BoxFit.cover,),
                        ),
                        Text('Quantity',style: kSmallTextStyle,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(icon: Icon(FontAwesomeIcons.minus,size: 12,color: kMainTextColor,),
                              onPressed: () {
                              setState(() {changed = true;});
                                cart.undo(cartData[i].id,widget.uid,'decrease');
                                Future.delayed(Duration(seconds: 2)).then((value) => cart.getCartItems(widget.uid))
                                .catchError((error){
                                  showDialog(context: context, builder: (ctx) => AlertDialog(
                                    title: Text('An error has occurred !'),
                                    content: Text('Something went wrong'),
                                  ));
                                }).then((value) => setState((){changed=false;}));
                              }),
                            changed ? CircularProgressIndicator(color: kFirstButtonColor,strokeWidth: 2,)
                                : Text(cartData[i].quantity.toString() , style: kSmallTextStyle,),
                            IconButton(icon: Icon(FontAwesomeIcons.plus,size: 12,color: kMainTextColor,),
                              onPressed: (){
                              setState(() {changed = true;});
                                cart.undo(cartData[i].id,widget.uid,'increase');
                                Future.delayed(Duration(seconds: 2)).then((value) => cart.getCartItems(widget.uid))
                                .catchError((error){
                                  showDialog(context: context, builder: (ctx) => AlertDialog(
                                    title: Text('An error has occurred !'),
                                    content: Text('Something went wrong'),
                                  ));
                                }).then((value) => setState((){changed = false;}));
                              },),
                          ],
                        ),
                      ],
                    ),
                  ),
            ),
          ),
          Text('Payment method', style: kMainTextStyle,),
          Text('Select a method', style: kSmallTextStyle,),
          Container(
            padding: EdgeInsets.all(8),
            child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Cash',style: kMainTextStyle,),
                  Checkbox(
                    checkColor: kFirstButtonColor,
                    value: _cashCheck,
                    onChanged: (_){
                      setState(() {
                        _cashCheck = !_cashCheck;
                        _visaCheck = false;
                        _fawryCheck = false;
                      });
                    },
                  ),
                ],),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Fawry',style: kMainTextStyle,),
                  Checkbox(
                    checkColor: kFirstButtonColor,
                    value: _fawryCheck,
                    onChanged: (_){
                      setState(() {
                        _fawryCheck = !_fawryCheck;
                        _cashCheck = false;
                        _visaCheck = false;
                      });
                    },
                  ),
                ],),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Visa',style: kMainTextStyle,),
                  Checkbox(
                    checkColor: kFirstButtonColor,
                    value: _visaCheck,
                    onChanged: (_){
                      setState(() {
                        _visaCheck = !_visaCheck;
                        _cashCheck= false;
                        _fawryCheck = false;
                      });
                    },
                  ),
                ],),
            ],
          ),),
          Container(
            width: deviceInfo.size.width*0.6,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.orange,
                elevation: 4,
              ),
              onPressed: () async {
                if(!_cashCheck && !_fawryCheck && !_visaCheck){
                  Alert(
                    context: context,
                    style: kAlert,
                    type: AlertType.error,
                    title: "You must select a payment method.",
                    buttons: [
                      DialogButton(
                        child: Text(
                          "Okay",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () => Navigator.pop(context),
                        color: kErrorColor,
                        radius: BorderRadius.circular(10),
                      ),
                    ],
                  ).show();
                }else{
                  await order.addOrder(
                    products:  cart.cartItems,
                    amount: cart.totalPrice,
                    date: DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now()).toString(),
                    uid: widget.uid,
                  );
                  await order.sellerOrder(
                    products : cart.cartItems,
                    amount: cart.totalPrice,
                    date: DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now()).toString(),
                    customerUid: widget.uid,
                  );
                  Alert(
                    context: context,
                    style: kAlert,
                    type: AlertType.success,
                    title: "You order has been sent",
                    buttons: [
                      DialogButton(
                        child: Text(
                          "Okay",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () => Navigator.pop(context),
                        color: kErrorColor,
                        radius: BorderRadius.circular(10),
                      ),
                    ],
                  ).show();
                  cart.clearItems(widget.uid);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(FontAwesomeIcons.truck),
                  Text('Order now',style: TextStyle(
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
    );
  }
}
