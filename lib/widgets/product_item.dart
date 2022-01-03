import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../providers/products.dart';
import '../constants.dart';
import '../screens/product_detail.dart';

class ProductItem extends StatefulWidget {
  final String category;
  final String uid;
  ProductItem(this.category,this.uid);
  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  bool _isExecuted;
  bool _isLoading =true;
  @override
  void initState() {
    _isExecuted = false;
    super.initState();
  }
  @override
  void didChangeDependencies() {
    if(!_isExecuted){
      Provider.of<Products>(context,listen: false).getProductsData()
          .then((value) => _isLoading = false);
      _isExecuted = true;
    }
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    var categoryTitle = widget.category;
    final productsData = Provider.of<Products>(context).productsItems;
    final categorizedData = Provider.of<Products>(context).productsItems.
    where((element) => element.category == categoryTitle).toList();
    return  _isLoading ? Center(child: SpinKitCubeGrid(color: kFirstButtonColor,),) : Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          // Container(margin: EdgeInsets.only(bottom: 10), child: Center(child: Text(categoryTitle == null ? 'All products' : '$categoryTitle' , style: kMainTextStyle,))),
          Expanded(
            child: GridView.builder(
              itemCount: categoryTitle == null ? productsData.length : categorizedData.length,
              itemBuilder: (context,i) => ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: GridTile(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context,ProductDetail.routeName,arguments:{
                        'id' : widget.category == null ? productsData[i].id : categorizedData[i].id,
                        'uid' : widget.uid,
                      });
                    },
                    child: Image.network(
                      categoryTitle == null ? productsData[i].imageURL : categorizedData[i].imageURL,
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
                    backgroundColor: Colors.white70,
                    title: Center(
                        child : FittedBox(
                        fit: BoxFit.fill,
                          child: Text( categoryTitle == null ? productsData[i].title : categorizedData[i].title
                      ,style: kSmallTextStyle,),
                        )),
                    ),
                  ),
                ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 3/2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              ),
          ),
        ],
      ),
    );
  }
}
