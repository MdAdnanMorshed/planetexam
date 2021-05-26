

import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:nice_button/nice_button.dart';
import 'package:planetexam/mvc/controllers/add_to_cart_controller.dart';

class CheckoutPage extends StatefulWidget {
  static String routeName = '/CheckoutPage';
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final addToCartController = Get.put(AddToCartController());
 /* Future<List<ShippingAddressModel>> getShippingAddressFuture;
  List<ShippingAddressModel> shippingAddressList = [];
  ShippingAddressModel shippingAddressModel;*/

  //var _phoneController = TextEditingController(text: shippingAddressModel.phone);
  ProgressDialog pr;

  List<CartProductInfo> productCartList = [];

  ProductItemCart productItemCart;

  int _radioValuePayment = 0;
  String paymentMethod = "Cash on Delivery";
  //String _shippingCost = '0';

  String totalAmount = "00.0";

  String pId;
  String pName;
  int pPrice;
  int pFinalPrice;
  int pQty;
  CartProductInfo cartInfo;

  var phoneNumberController = TextEditingController();
  var addressController = TextEditingController();
  var cityController = TextEditingController();
  var countryController = TextEditingController();
  var postalCodeController = TextEditingController();

  var _formKey = GlobalKey<FormState>();

  String recipientName, recipientNumber, address, city, country, postalCode;

  @override
  void initState() {
    print('_CheckoutPageState.initState reload');
    //getShippingAddressFuture = UserGetServices().getShippingAddressList();
    super.initState();
  }

  void _paymentStatusRadioValueChange(int value) {
    setState(() {
      _radioValuePayment = value;
      switch (_radioValuePayment) {
        case 0:
          paymentMethod = "Cash on Delivery";
          break;
        case 1:
          paymentMethod = "sslcommerz";
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    pr.style(
        message: 'Loading... ',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 10.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w600));
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Checkout Page"),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
        ),
        bottomNavigationBar: _bottomNavBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _getShippingTitle(context),
              _getShippingAddress(),
              _getShippingPhoneTitle(),
              SizedBox(
                height: 5,
              ),
              _getShippingPhoneNumber(),
              SizedBox(
                height: 5,
              ),
              _cartItemTitle(),
              _buildCartItems(),
              SizedBox(
                height: 5,
              ),
              Subhead(title: 'Payment Method', subTitle: '', onTap: () {}),
              _buildPaymentMethod(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getShippingTitle(BuildContext context) {
    return FutureBuilder<List<ShippingAddressModel>>(
      future: getShippingAddressFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.hasData != null) {
          List<ShippingAddressModel> list = snapshot.data;
          if (list.isEmpty) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: Text('Add shipping address'),
                  onPressed: () {
                    Get.to(CreateShippingAddressPage('first'),
                        arguments: firstCall);
                  },
                ),
                InkWell(
                    onTap: () {
                      _modalBottomSheetMenu(context);
                    },
                    child: Icon(FontAwesomeIcons.pen))
              ],
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(2.0),
              child: Subhead(
                  title: 'Shipping Address: ',
                  subTitle: 'Change',
                  onTap: () {
                    Get.to(GetShippingAddressPage(), arguments: change);
                    setState(() {});
                  }),
            );
          }
        }
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: Subhead(
            title: 'Shipping Address: ',
            subTitle: 'Change',
            onTap: () {
              Get.to(GetShippingAddressPage(), arguments: change);
            },
          ),
        );
      },
    );
  }

  Widget _getShippingAddress() {
    return FutureBuilder<List<ShippingAddressModel>>(
      future: getShippingAddressFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            shippingAddressList = snapshot.data;
            for (var v in shippingAddressList) {
              if (v.setDefault == '1') shippingAddressModel = v;
            }
            if (shippingAddressModel == null) {
              return Text('');
            }
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 0.1,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(shippingAddressModel.address + ', '),
                      Text(shippingAddressModel.city + ', '),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(shippingAddressModel.country + ': '),
                          Text(shippingAddressModel.postalCode + '.')
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return CupertinoActivityIndicator();
        }
        return CupertinoActivityIndicator();
      },
    );
  }

  Widget _getShippingPhoneTitle() {
    return Subhead(title: 'Phone Number:', subTitle: '', onTap: () {});
  }

  Widget _getShippingPhoneNumber() {
    return FutureBuilder<List<ShippingAddressModel>>(
      future: getShippingAddressFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            shippingAddressList = snapshot.data;
            for (var v in shippingAddressList) {
              if (v.setDefault == '1') shippingAddressModel = v;
            }
            if (shippingAddressModel == null) {
              return SellerListCardWidget(
                icon: CupertinoIcons.phone,
                name: SPDataProvider.userPhone,
              );
            }
            return SellerListCardWidget(
              icon: CupertinoIcons.phone,
              name: shippingAddressModel.phone,
            );
          }
          return CupertinoActivityIndicator();
        }
        return CupertinoActivityIndicator();
      },
    );
  }

  Widget _cartItemTitle() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Subhead(title: 'Cart Items: ', subTitle: '', onTap: () {}),
    );
  }

  Widget _buildCartItems() {
    return GetX<AddToCartController>(
      builder: (cartController) {
        return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          primary: false,
          itemCount: cartController.productInfoWithQty.length,
          itemBuilder: (context, index) {
            pId = cartController.productInfoWithQty[index].productInfo.id
                .toString();
            pName = cartController.productInfoWithQty[index].productInfo.name;

            pPrice = int.parse(cartController
                .productInfoWithQty[index].productInfo.basePrice
                .toString());
            pFinalPrice = 2;
            pQty = cartController.productInfoWithQty[index].productQty;

            cartInfo = CartProductInfo(
                productId: pId,
                name: cartController.productInfoWithQty[index].productInfo.name,
                price: pPrice,
                finalPrice: pFinalPrice,
                qty: pQty);

            productCartList.add(cartInfo);
            return _cartItems(
                productImage: cartController
                    .productInfoWithQty[index].productInfo.thumbnailImage,
                productName:
                    cartController.productInfoWithQty[index].productInfo.name,
                productPrice: double.parse(cartController
                    .productInfoWithQty[index].productInfo.basePrice
                    .toString()),
                productQuantity:
                    cartController.productInfoWithQty[index].productQty);
          },
        );
      },
    );
  }

  Widget _bottomNavBar() {
    Size size = Get.size;
    return Container(
      height: size.height / 8,
      width: size.width,
      color: kPrimaryLightColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 2,
            child: GetX<AddToCartController>(
              builder: (cartController) {
                totalAmount = cartController.totalPrice.toString();

                print('_CheckoutPageState._bottomNavBar totalPrice:' +
                    totalAmount);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      'Total Price : ' +
                          CustomStrings.uniCodeTk +
                          cartController.totalPrice.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: fontColorDefault)),
                );
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: NiceButton(
              width: 200,
              elevation: 2.0,
              text: "Proceed to pay",
              fontSize: 15,
              radius: 50.0,
              background: kPrimaryColor,
              icon: Icons.money,
              onPressed: () {
                Map<String, dynamic> placeOrderInfo = {
                  'cart': jsonEncode(productCartList),
                  'shop_id': SPDataProvider.currentShopId,
                  'pay': 'cod',

                  /// cod =cash on delivery ssl =online
                  'subtotal': totalAmount,
                };
                pr.show();
                UserPostServices().orderCheckout(placeOrderInfo).then((value) {
                  if (value) {
                    pr.hide();
                    CoolAlert.show(
                      context: context,
                      type: CoolAlertType.success,
                      onConfirmBtnTap: () {
                        Get.back();
                        Get.offAll(HomePage());
                      },
                      text: " \n congratulations! Order has successfully done.",
                    );

                    ///  Full Cart Empty
                    //     .add(RemoveFromALLCartInfo());
                    addToCartController.removeAllCart();
                  } else {
                    pr.hide();
                    CoolAlert.show(
                      context: context,
                      type: CoolAlertType.info,
                      text:
                          "Order Status  \n Server Error  ...Please try again !",
                    );
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  _cartItems(
      {String productImage,
      String productName,
      double productPrice,
      int productQuantity}) {
    Size size = Get.size;
    return Card(
        elevation: 0.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ListTile(
          leading: Image.network(
            Links.globalUrl + productImage,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset('assets/images/logo.png');
            },
          ),
          title: Text(productName,
              style: TextStyle(fontSize: 15, color: kPrimaryColor)),
          subtitle: Text(CustomStrings.uniCodeTk + ' $productPrice'),
          trailing: CircleAvatar(
            backgroundColor: kPrimaryColor,
            child: Text(
              'x' + productQuantity.toString(),
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: backgroundColor),
            ),
          ),
        ));
  }

  addToCartCalculation() {
    return Container(
      color: Colors.grey.shade100,
      height: 60,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // GetX<AddToCartController>(
                //   builder: (cartController) {
                //     return Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: Text(
                //           'Total Price : ' +
                //               CustomStrings.uniCodeTk +
                //               cartController.totalPrice.toString(),
                //           style: TextStyle(fontWeight: FontWeight.bold)),
                //     );
                //   },
                // ),
              ],
            ),
          ),
          RaisedButton(
            onPressed: () {
              Get.to(CheckoutPage());
            },
            color: kPrimaryColor,
            child: Text(
              'CheckOut',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  void firstCall() {
    print('first Call');
  }

  void change(int index1) {
    print('action callback ');
    setState(() {
      for (int i = 0; i < shippingAddressList.length; i++) {
        shippingAddressList[i].setDefault = '0';
      }
      shippingAddressList[index1].setDefault = '1';
    });
  }

  Widget _buildPaymentMethod() {
    return Card(
      // margin: EdgeInsets.symmetric(horizontal: 8),
      elevation: 0.1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Row(
                children: [
                  new Radio(
                    value: 0,
                    groupValue: _radioValuePayment,
                    onChanged: _paymentStatusRadioValueChange,
                  ),
                  Text('Cash on Delivery'),
                ],
              )),
              Expanded(
                child: Row(
                  children: [
                    new Radio(
                      value: 1,
                      groupValue: _radioValuePayment,
                      onChanged: _paymentStatusRadioValueChange,
                    ),
                    Text('SSL Commerz'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _modalBottomSheetMenu(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
            height: 150.0,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: Container(
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      child: InkWell(
                        child: Icon(FontAwesomeIcons.plus),
                        onTap: () {
                          _modalBottomSheetAddress(context);
                        },
                      ),
                      alignment: Alignment.topRight,
                    ),
                    Icon(
                      FontAwesomeIcons.home,
                      size: 50.0,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "No address found",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                )),
          );
        });
  }

  void _modalBottomSheetAddress(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return Container(
            height: 1000.0,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: Container(
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(25.0),
                        topRight: const Radius.circular(25.0))),
                child: Center(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Subhead(
                                title: 'Address: ', subTitle: '', onTap: () {}),
                          ),
                          _textField(
                            controller: addressController,
                            hint: 'Enter address...',
                            icon: FontAwesomeIcons.home,
                            forr: 'address',
                            keyboardType: TextInputType.text,
                            isEmptyMsg: ' Enter Your Address',
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Subhead(
                                title: 'City: ', subTitle: '', onTap: () {}),
                          ),
                          _textField(
                            controller: cityController,
                            hint: 'Enter city...',
                            icon: FontAwesomeIcons.city,
                            forr: 'city',
                            keyboardType: TextInputType.text,
                            isEmptyMsg: 'Enter Your City',
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Subhead(
                                title: 'Country: ', subTitle: '', onTap: () {}),
                          ),
                          _textField(
                            controller: countryController,
                            hint: 'Enter country...',
                            icon: FontAwesomeIcons.flag,
                            forr: 'country',
                            maxlines: 1,
                            keyboardType: TextInputType.text,
                            isEmptyMsg: 'Enter Your Country',
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Subhead(
                                title: 'Phone number: ',
                                subTitle: '',
                                onTap: () {}),
                          ),
                          _textField(
                            controller: phoneNumberController,
                            hint: 'Enter phone number...',
                            icon: FontAwesomeIcons.phone,
                            forr: 'phone number',
                            maxlines: 1,
                            keyboardType: TextInputType.phone,
                            isEmptyMsg: 'Enter Your Phone',
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Subhead(
                                title: 'Postal code: ',
                                subTitle: '',
                                onTap: () {}),
                          ),
                          _textField(
                            controller: postalCodeController,
                            hint: 'Enter postal code...',
                            icon: FontAwesomeIcons.code,
                            forr: 'postal code',
                            maxlines: 1,
                            keyboardType: TextInputType.number,
                            isEmptyMsg: 'Enter Your Postal Code ',
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          RoundedButtonWidget(
                            text: 'ADD',
                            color: kPrimaryColor,
                            press: () {
                              ///first time call
                              createShippingAddress();
                              // firstCallFunction();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          );
        });
  }

  Widget _textField(
      {controller, hint, icon, forr, keyboardType, isEmptyMsg, int maxlines}) {
    return TextFieldContainerWidget(
      child: TextFormField(
        style: TextStyle(color: fontColorDefault),
        controller: controller,
        decoration: InputDecoration(
          icon: Icon(icon, color: kPrimaryColor),
          hintText: hint,
          hintStyle: TextStyle(color: fontColorDefault),
          border: InputBorder.none,
        ),
        keyboardType: keyboardType,
        maxLines: maxlines,
        validator: (value) {
          // return _validate( value, forr,msgTitle);
          return _validate(value: value, forr: forr, msgTitle: isEmptyMsg);
        },
        onSaved: (newValue) {
          return _save(newValue, forr);
        },
      ),
    );
  }

  _validate({String value, String forr, String msgTitle}) {
    if (value.isEmpty) {
      return msgTitle;
    }
    //is not working this logic
    if (forr == "phone Number" && value.length < 11) {
      return "Incorrect Number";
    }
    return null;
  }

  _save(String newValue, forr) {
    if (forr == "phone Number") {
      return recipientNumber = newValue;
    }
    if (forr == "address") {
      return address = newValue;
    }
    if (forr == "city") {
      return city = newValue;
    }
    if (forr == "country") {
      return country = newValue;
    }
    //need integer value
    if (forr == "postal Code") {
      return postalCode = newValue;
    }
  }

  void createShippingAddress() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Map<String, String> body = {
        'address': addressController.text,
        'country': countryController.text,
        'city': cityController.text,
        'postal_code': postalCodeController.text,
        'phone': phoneNumberController.text,
        'type': 'home',
        'set_default': '0'
      };
      /*if (from == 'first') {
        body['set_default'] = '1';
      }*/
      UserPostServices().createShippingAddress(body).then((value) {
        if (value == true) {
          Fluttertoast.showToast(
              msg: "Shipping address has been created ",
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: kPrimaryColor,
              textColor: Colors.white);

          Get.off(GetShippingAddressPage());
        } else {
          Fluttertoast.showToast(
              msg: "Shipping Address creation failed",
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: kPrimaryColor,
              textColor: Colors.white);
        }
      });
    }
  }
}

class CartProductInfo {
  String productId;
  String name;
  int price;
  int finalPrice;
  int qty;

  CartProductInfo(
      {this.productId, this.name, this.price, this.finalPrice, this.qty});

  CartProductInfo.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    name = json['name'];
    price = json['price'];
    finalPrice = json['final_price'];
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['name'] = this.name;
    data['price'] = this.price;
    data['final_price'] = this.finalPrice;
    data['qty'] = this.qty;
    return data;
  }
}
