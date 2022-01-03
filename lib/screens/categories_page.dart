import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


import '../screens/category_items.dart';
import '../constants.dart';

class CategoryScreen extends StatefulWidget {
  static const routeName = '/category-screen';
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    final uid = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                  child: Image.network
                    (categories[i]['image'],
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
                  title: Center(child :
                  FittedBox(
                    fit: BoxFit.fill,
                      child: Text(categories[i]['title'],style: kVerySmallTextStyle,))),
                ),
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
    );
  }
}
