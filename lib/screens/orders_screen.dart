import 'package:flutter/material.dart';

import '../widgets/orders_item.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/orders-screen';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    final uid = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(title: Text('Orders'),),
      body: OrderItem(uid),
    );
  }
}
