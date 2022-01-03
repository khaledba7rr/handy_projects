import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../screens/products_screen.dart';

import '../providers/order.dart';

import '../constants.dart';

class OrderItem extends StatefulWidget {
  final uid;
  OrderItem(this.uid);
  @override
  _OrderItemState createState() => _OrderItemState();
}
class _OrderItemState extends State<OrderItem> {
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
      Provider.of<Order>(context,listen: false).fetchOrders(widget.uid).catchError((error){
        showDialog(context: context, builder: (ctx) => AlertDialog(
          title: Text('An error has occurred !'),
          content: Text('Something went wrong'),
        ));
      }).then((value) => _isLoading = false);
      _isExecuted = true;
    }
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Order>(context).orders;
    MediaQueryData deviceInfo = MediaQuery.of(context);
    return _isLoading ? Center(child: SpinKitCubeGrid(color: kFirstButtonColor,),) :
      ordersData.length == 0 ?
    Container(
      width: deviceInfo.size.width*0.95,
      height: double.infinity,
      margin: EdgeInsets.only(top: 30),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset('./assets/images/new-entries.png',),
            Spacer(flex: 3,),
            FittedBox(
              fit: BoxFit.contain,
              child: TextButton(onPressed: (){
                Navigator.pushNamed(context, ProductsScreen.routeName, arguments: widget.uid);
              },
                child: Text.rich(
                  TextSpan(
                      text: 'You don\'t have previous orders. ',style: kSmallTextStyle,
                      children: [
                        TextSpan(text:'shop now !',style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          decoration: TextDecoration.underline,
                          decorationThickness: 2,
                        ),
                        ),
                      ]
                  ),
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    ) : ListView.builder(
      itemCount: ordersData.length,
      itemBuilder: (ctx,i) => Card(
        margin: EdgeInsets.all(15),
        child: ExpansionPanelList(
          expansionCallback: (__,_){
            setState(() {ordersData[i].isExpanded = !ordersData[i].isExpanded;});
          },
          elevation: 4,
          dividerColor: Colors.white,
          children: [
            ExpansionPanel(
              canTapOnHeader: true,
              isExpanded: ordersData[i].isExpanded,
              backgroundColor: kGridTileColor
              ,
              headerBuilder : (context,isOpen){
                return ListTile(
                  contentPadding: EdgeInsets.all(15),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Total :  ${ordersData[i].amount.toStringAsFixed(2)} EGP',style:kBigTextStyle,),
                      SizedBox(height: 20,),
                      Text('Date : ${DateFormat('dd MM yyyy hh:mm').format(ordersData[i].time)}',style: kVerySmallTextStyle,),
                      Text('Order ID : ${ordersData[i].id}',style: kVerySmallTextStyle,),
                    ],),
                );
              },
              body: Container(
                key: ValueKey(ordersData[i].id.toString()),
                height: min(ordersData.length*50+40.0,100),
                child: ListView(
                  children: [
                    ...ordersData[i].products.map((order) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('${order.title}',style:kSmallTextStyle,),
                            Text('${order.quantity} x ${order.price} \$',style:kVerySmallTextStyle,),
                          ],
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