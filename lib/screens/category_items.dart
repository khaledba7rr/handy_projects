import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../widgets/product_item.dart';

import '../constants.dart';
import '../providers/products.dart';

class CategoryItems extends StatefulWidget {
  static const routeName = '/category-items';
  @override
  _CategoryItemsState createState() => _CategoryItemsState();
}
bool isFinished = false;
class _CategoryItemsState extends State<CategoryItems> {
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context).settings.arguments as Map<String,dynamic>;
    final productsData = Provider.of<Products>(context);
    return  Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.fill,
          child: Text(arguments['title'],style: kMainTextStyle,)),),
      body: RefreshIndicator(
          onRefresh: () => productsData.getProductsData(),
          child: Column(
            children: [
              Expanded(
                child: ProductItem(arguments['title'],arguments['uid']),
              ),
            ],
          ),
      ),
    );
  }
}
