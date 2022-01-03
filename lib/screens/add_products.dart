import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../providers/auth.dart';
import '../providers/user.dart';
import '../providers/products.dart';

class AddProducts extends StatefulWidget {
  static const routeName = '/add-products';
  @override
  _AddProductsState createState() => _AddProductsState();
}
final _formKey = GlobalKey<FormState>();
bool formValid = false;
bool isLoading = false;
bool isFinished = false;
String dropDownValue;

void _verify() {
  final isValid = _formKey.currentState.validate();
  if(isValid){
    formValid = true;
  }else{
    formValid =false;
  }
}

List<DropdownMenuItem> dropDown({String first,second,third,fourth,fifth}){
  return [
    DropdownMenuItem(
      child: Text(''), value: '',),
    DropdownMenuItem(
    child: Text(first), value: first,),
    DropdownMenuItem(
      child: Text(second),
      value: second,
    ),
    DropdownMenuItem(
      child: Text(third),
      value: third,
    ),
    DropdownMenuItem(
      child: Text(fourth),
      value: fourth,
    ),
    DropdownMenuItem(
      child: Text(fifth),
      value: fifth,
    ),
  ];
}

TextEditingController titleController = TextEditingController();
TextEditingController descriptionController = TextEditingController();
TextEditingController priceController = TextEditingController();
TextEditingController imageUrlController = TextEditingController();

Widget textOrPhoto (){
  if(imageUrlController.text == null){
    return Center(child: Text('provide an image URL',style: kMainTextStyle,),);
  }
  if(imageUrlController.text != null){
    if(imageUrlController.text.contains('https:')){
    }
    return Image.network(imageUrlController.text,
      errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
        return Center(child: Text('provide a valid image URL',style: kMainTextStyle,));
      },);
  }
}
bool _isInit = true;
class _AddProductsState extends State<AddProducts> {
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if(productId == null){
      }
      if (productId != null) {
        final _editedProduct = Provider.of<Products>(context, listen: false).findById(productId);
        dropDownValue = _editedProduct.category;
        titleController.text = _editedProduct.title;
        descriptionController.text = _editedProduct.description;
        imageUrlController.text = _editedProduct.imageURL;
        priceController.text = _editedProduct.price;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }
  @override
  void dispose() {
      _isInit =true;
      dropDownValue = '';
      titleController.text = '';
      descriptionController.text = '';
      imageUrlController.text = '';
      priceController.text = '';
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context);
    final productData = Provider.of<Products>(context);
    final profileData = Provider.of<User>(context);
    MediaQueryData deviceInfo = MediaQuery.of(context);
    final buttonSize = (deviceInfo.size.width)*0.7;
    final imageHeight = deviceInfo.size.height*0.33;
    final imageWidth = deviceInfo.size.width*0.7;
    final productId = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(
              children: [
                Container(
                  width: deviceInfo.size.width <= 320 ? deviceInfo.size.width*0.95 : deviceInfo.size.width*0.8,
                  color: kBackgroundColor,
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('Add a new product',style: deviceInfo.size.width <= 320 ? kSmallTextStyle :kBigTextStyle,),
                          TextFormField(
                            style: kFieldTextStyle,
                            decoration: InputDecoration(
                              labelText: 'Title',
                              labelStyle: kLabelTextStyle,
                            ),
                            keyboardType: TextInputType.text,
                            controller: titleController,
                            onChanged: (_){
                              _verify();
                              },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'This field cannot be empty';
                              }
                              if(value.length < 4){
                                return 'enter a valid title';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            style: kFieldTextStyle,
                            decoration: InputDecoration(
                              labelText: 'Description',
                              labelStyle: kLabelTextStyle,
                              hintText: 'describe your product',
                              hintStyle: kLabelTextStyle,
                            ),
                            controller: descriptionController,
                            keyboardType: TextInputType.text,
                            maxLines: 2,
                            onChanged: (_){
                              _verify();
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'This field cannot be empty';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            style: kFieldTextStyle,
                            decoration: InputDecoration(
                              labelText: 'price',
                              labelStyle: kLabelTextStyle,
                            ),
                            keyboardType: TextInputType.phone,
                            controller: priceController,
                            onChanged: (_){
                              _verify();
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'This field cannot be empty';
                              }
                              return null;
                            },
                          ),
                          Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                           Text('Category : ' , style: kLabelTextStyle,),
                           ConstrainedBox(
                             constraints: BoxConstraints(
                               minWidth: deviceInfo.size.width*0.3,
                               maxWidth: deviceInfo.size.width*0.4,
                             ),
                             child: DropdownButton(
                               elevation: 4,
                               style: kVerySmallTextStyle,
                               isExpanded: true,
                               dropdownColor: kBackgroundColor,
                               onChanged: (value){
                                 setState(() {
                                   dropDownValue = value;
                                 });
                               },
                               value: dropDownValue,
                               items: dropDown(
                                 first: 'Accessories',
                                 second: 'Decoration & crafting',
                                 third: 'Fashion & clothing',
                                 fourth: 'Art & collectibles',
                                 fifth: 'Gift & wrapping',
                               ),),
                           ),
                         ],),
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: TextFormField(
                              style: kFieldTextStyle,
                              decoration: InputDecoration(
                                labelText: 'ImageURL',
                                labelStyle: kLabelTextStyle,
                              ),
                              controller: imageUrlController,
                              keyboardType: TextInputType.text,
                              onChanged: (_){
                                _verify();
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'This field cannot be empty';
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            height: imageHeight,
                            width: imageWidth,
                            child: textOrPhoto(),
                          ),
                          isLoading ? CircularProgressIndicator(): Container(
                            margin: EdgeInsets.only(top: 20),
                            width: buttonSize,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: kFirstButtonColor,
                                elevation: 5,
                              ),
                              onPressed: () async {
                                setState(() {isLoading = true;});
                                if(!formValid){
                                  Alert(
                                    context: context,
                                    style: kAlert,
                                    type: AlertType.error,
                                    title: "Failed",
                                    desc: 'Please provide data correctly',
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                          " Try again!",
                                          style: TextStyle(color: Colors.white, fontSize: 20),
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                        color: kErrorColor,
                                        radius: BorderRadius.circular(10),
                                      ),
                                    ],
                                  ).show();
                                  setState(() {isLoading=false;});
                                  return;
                                }
                                if(dropDownValue == ''){
                                  setState(() {isLoading = false;});
                                  Alert(
                                    context: context,
                                    style: kAlert,
                                    type: AlertType.error,
                                    title: "Failed",
                                    desc: 'Please choose a category',
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                          " Try again!",
                                          style: TextStyle(color: Colors.white, fontSize: 20),
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                        color: kErrorColor,
                                        radius: BorderRadius.circular(10),
                                      ),
                                    ],
                                  ).show();
                                  return;
                                }
                                if(formValid){
                                  setState(() {isFinished = true;});
                                  if(productId == null){
                                    await authData.uploadProductsData(
                                      title: titleController.text.trim(),
                                      description: descriptionController.text.trim(),
                                      price: priceController.text.trim(),
                                      imageUrl: imageUrlController.text.trim(),
                                      uid: profileData.profileItems[0].uid,
                                      date: DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()).toString(),
                                      uploadedBy:
                                      '${profileData.profileItems[0].firstName} '
                                          '${profileData.profileItems[0].lastName}',
                                      category: dropDownValue,
                                    );
                                    setState(() {isLoading = false;});
                                    Alert(
                                      context: context,
                                      style: kAlert,
                                      type: AlertType.success,
                                      title: "Product added",
                                      desc: '',
                                      buttons: [
                                        DialogButton(
                                          child: Text(
                                            "okay",
                                            style: TextStyle(color: Colors.white, fontSize: 20),
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          color: kFirstButtonColor,
                                          radius: BorderRadius.circular(10),
                                        ),
                                      ],
                                    ).show().then((_) {
                                      titleController.clear();
                                      descriptionController.clear();
                                      imageUrlController.clear();
                                      priceController.clear();
                                      setState(() {
                                        dropDownValue = '';
                                      });
                                    });
                                  }
                                  if(productId != null){
                                    await productData.updateProduct(
                                      id: productId,
                                      price: priceController.text,
                                      title: titleController.text,
                                      image: imageUrlController.text,
                                      category: dropDownValue,
                                      description: descriptionController.text,
                                    );
                                    setState(() {isLoading = false;});
                                    Alert(
                                      context: context,
                                      style: kAlert,
                                      type: AlertType.success,
                                      title: "Product updated",
                                      desc: '',
                                      buttons: [
                                        DialogButton(
                                          child: Text(
                                            "okay",
                                            style: TextStyle(color: Colors.white, fontSize: 20),
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          color: kFirstButtonColor,
                                          radius: BorderRadius.circular(10),
                                        ),
                                      ],
                                    ).show().then((_) {
                                      titleController.clear();
                                      descriptionController.clear();
                                      imageUrlController.clear();
                                      priceController.clear();
                                      setState(() {
                                        dropDownValue = '';
                                      });
                                      productData.getProductsData();
                                      Navigator.pop(context);
                                    });
                                    return;
                                  }
                                }
                              },
                              child: Text(productId == null ? 'Add' : 'Change',style: kButtonTextStyle,),
                              ),
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
      ),
    );
  }
}
