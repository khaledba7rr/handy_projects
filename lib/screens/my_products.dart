import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:provider/provider.dart';

import '../constants.dart';

import 'add_products.dart';

import '../providers/products.dart';

class MyProducts extends StatefulWidget {
  static const routeName = 'my-products';
  @override
  _MyProductsState createState() => _MyProductsState();
}
class _MyProductsState extends State<MyProducts> {
  bool _isLoading = true;
  @override
  void didChangeDependencies() {
    Provider.of<Products>(context,listen: false).getProductsData()
        .then((value) => _isLoading = false);
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    final uid = ModalRoute.of(context).settings.arguments as String;
    final productsData = Provider.of<Products>(context);
    final myProducts = productsData.productsItems.
    where((element) => element.uid == uid ).toList();
    MediaQueryData deviceInfo = MediaQuery.of(context);
    final deviceWidth = deviceInfo.size.width;
    return Scaffold(
      body: _isLoading ? Center(child: SpinKitCubeGrid(color: kFirstButtonColor,),)
          : myProducts.length == 0 ? Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Center(child: Image.asset('./assets/images/add-notes.png'),),
            Center(
              child: TextButton(onPressed: (){
                Navigator.pushNamed(context, AddProducts.routeName);
              },
                child: Text.rich(
                  TextSpan(
                      text: 'You don\'t have products yet.  ',style: kSmallTextStyle,
                      children: [
                        TextSpan(text: 'Add some ?',style: TextStyle(
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
          ],
        ),
      )
          :
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: myProducts.length,
            itemBuilder: (context,i) => Container(
              margin: EdgeInsets.all(5),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),color: kGridTileColor,
                ),
                child: Column(
                  children: [
                    ListTile(
                      tileColor: Colors.transparent,
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            myProducts[i].imageURL),
                        onBackgroundImageError: (exception, stackTrace)  {
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
                      ),
                      title: Text(myProducts[i].title,style: kSmallTextStyle,),
                      trailing: Container(
                        width: deviceInfo.size.width*0.33,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(onPressed: (){
                              Navigator.pushNamed(context,AddProducts.routeName , arguments: myProducts[i].id);
                            },
                                icon: Icon(FontAwesomeIcons.solidEdit,color: Colors.black87,size: 20,)),
                            IconButton(onPressed: (){
                                Alert(
                                  context: context,
                                  style: kAlert,
                                  type: AlertType.error,
                                  title: "Deleting a product...!",
                                  desc: 'Do you want to delete this product ? it can\'t be undone once deleted !',
                                  buttons: [
                                    DialogButton(
                                      child: Text(
                                        "Yes",softWrap: false, overflow: TextOverflow.visible,
                                        style: TextStyle(color: Colors.white, fontSize:deviceWidth <= 320 ? 12 : 20),
                                      ),
                                      onPressed: () {
                                        productsData.deleteProduct(myProducts[i].id);
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          backgroundColor: kFirstButtonColor,
                                          content: Text('Item \'s been deleted ',textAlign: TextAlign.center, style: kSmallTextStyle,),
                                          duration: Duration(seconds: 3),
                                        ),);
                                      },
                                      color: kErrorColor,
                                      radius: BorderRadius.circular(10),
                                    ),
                                    DialogButton(
                                      child: Text(
                                        "No",
                                        style: TextStyle(color: Colors.white, fontSize:deviceWidth <= 320 ?12 : 20),
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                      color: kFirstButtonColor,
                                      radius: BorderRadius.circular(10),
                                    ),
                                  ],
                                ).show();
                            },
                                icon: Icon(FontAwesomeIcons.trashAlt,color: kErrorColor,size: 20,)),
                          ],),
                      ),
                    ),
                    Container(
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('${myProducts[i].uploadedDate}',style: TextStyle(color: Colors.white),),
                          Text('${myProducts[i].category}',style: TextStyle(color: Colors.white),),
                          Text('\$${myProducts[i].price}',style: TextStyle(color: Colors.white),),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
        ),
      ),
    );
  }
}
