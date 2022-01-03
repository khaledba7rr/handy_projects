import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import 'add_products.dart';
import '../constants.dart';

import '../providers/order.dart';

class ReceivedOrders extends StatefulWidget {
  static const routeName = '/received-orders';
  @override
  _ReceivedOrdersState createState() => _ReceivedOrdersState();
}

class _ReceivedOrdersState extends State<ReceivedOrders> {
  bool _isLoading = true;
  bool _isExecuted;
  @override
  void initState() {
    _isExecuted = false;
    super.initState();
  }
  void didChangeDependencies() {
    final uid = ModalRoute.of(context).settings.arguments as String;
    if(!_isExecuted){
      Provider.of<Order>(context,listen: false).fetchSellerOrders(uid)
          .then((value) => _isLoading = false);
    }
    _isExecuted = true;
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceInfo = MediaQuery.of(context);
    final ordersData = Provider.of<Order>(context).receivedOrders;
    return Scaffold(
      appBar: AppBar(title: Text('Received orders'),),
      body: _isLoading ? Center(child: SpinKitCubeGrid(color: kFirstButtonColor,)) :
      ordersData.isEmpty ?
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
                Navigator.pushNamed(context,AddProducts.routeName);
              },
                child: Text.rich(
                  TextSpan(
                      text: 'You don\'t have any orders yet.  ',style: kSmallTextStyle,
                      children: [
                        TextSpan(text: 'Add more products',style: TextStyle(
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
                backgroundColor: kGridTileColor,
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListView(
                      children: [
                        ...ordersData[i].products.map((order) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                          Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('${order.title}',style:kSmallTextStyle,),
                          ],
                        ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('${order.quantity} x ${order.price} \$',style:kVerySmallTextStyle,),
                            ],
                          ),
                    ],
                  ),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Customer name ',style: kSmallTextStyle,),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(ordersData[i].customerName,style: kSmallTextStyle,),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Customer address ',style: kSmallTextStyle,),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(ordersData[i].customerAddress,style: kSmallTextStyle,),
                              ],
                            ),
                        ],),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Customer mobile ',style: kSmallTextStyle,),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(ordersData[i].customerMobile,style: kSmallTextStyle,),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
