import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../widgets/drawer.dart';

import 'category_items.dart';
import 'product_detail.dart';

import '../constants.dart';
import '../providers/products.dart';

class CustomerHome extends StatefulWidget {
  static const routeName = '/customer-home';
  @override
  _CustomerHomeState createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  @override
  @override
  Widget build(BuildContext context) {
    final uid = ModalRoute.of(context).settings.arguments as String;
    final data = Provider.of<Products>(context,listen: false).productsItems;
    final newProducts = data.getRange(0,(data.length- data.length+7)).toList();
    MediaQueryData deviceInfo = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: Center(child: Text('Handy',style: kBigTextStyle,)),
      ),
      drawer: AppDrawer('customer',uid),
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
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              Container(
                width: deviceInfo.size.width*0.29,
              height: deviceInfo.size.height*0.29,
              child: Hero(child: Image.asset('./assets/images/logo.png'),tag: 'logo',),
              ),
              Center(child: Text('Shop by category' , style: kBigTextStyle,),),
              Container(
                height: deviceInfo.size.height*0.25,
                margin : EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: GridView.builder(
                            itemCount: categories.length,
                            itemBuilder: (context,i) => GestureDetector(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: GridTile(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context, CategoryItems.routeName,arguments: {
                                        'title' : categories[i]['title'],
                                        'uid' : uid,
                                      });
                                    },
                                    child: Image.network(
                                      categories[i]['image'],
                                      fit: BoxFit.fill,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding: const EdgeInsets.all(16.0),
                                              child: FittedBox(
                                                  fit: BoxFit.fitHeight,
                                                  child: Image.asset('./assets/images/imageError.png')),
                                            ),
                                          );
                                        },
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if(loadingProgress == null) return child;
                                          return Center(child: SpinKitCubeGrid(color: kFirstButtonColor,),);
                                        }
                                    ),
                                  ),
                                  footer: GridTileBar(
                                    backgroundColor: kGridTileColor,
                                    title: Center(
                                        child : FittedBox(
                                          fit: BoxFit.cover,
                                            child: Text(categories[i]['title'],style: kVerySmallTextStyle,)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 5/4,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                            ),
                          ),
                        ),
                    ),
                  ],
                ),
              ),
              Container(
                  child: Center(child: Text('New products' , style: kBigTextStyle,),)),
              Container(
                height: deviceInfo.size.height*0.25,
                margin: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: GridView.builder(
                          itemCount: newProducts.length,
                          itemBuilder: (context,i) => GestureDetector(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: GridTile(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, ProductDetail.routeName,arguments: {
                                      'id' : newProducts[i].id,
                                      'uid' : uid,
                                    });
                                  },
                                  child: Image.network(
                                    newProducts[i].imageURL,
                                    fit: BoxFit.fill,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: FittedBox(
                                              fit: BoxFit.fitHeight,
                                                child: Image.asset('./assets/images/imageError.png')),
                                          ),
                                        );
                                      },
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if(loadingProgress == null) return child;
                                        return Center(child: SpinKitCubeGrid(color: kFirstButtonColor,),);
                                      }
                                  ),
                                ),
                                footer: GridTileBar(
                                  backgroundColor: kGridTileColor,
                                  title: Center(child : FittedBox(
                                    fit: BoxFit.cover,
                                      child: Text(newProducts[i].title,style: kVerySmallTextStyle,))),
                                ),
                              ),
                            ),
                          ),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 5/4,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
