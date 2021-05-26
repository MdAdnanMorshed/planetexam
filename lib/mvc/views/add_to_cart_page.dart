import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:planetexam/mvc/controllers/add_to_cart_controller.dart';


class AddToCartPage extends StatefulWidget {
  @override
  _AddToCartPageState createState() => _AddToCartPageState();
}

class _AddToCartPageState extends State<AddToCartPage> {
  final addToCartController = Get.put(AddToCartController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add to Cart '),),
      body: Container(
        child: GetX<AddToCartController>(
          builder: (cartController) {
            return ListView.builder(
              itemCount: cartController.productInfoWithQty.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return _listItem(cartController, index);
              },
            );
          },
        ),
      ),
      bottomNavigationBar: addToCartCalculation(),
    );
  }
  Widget _listItem(AddToCartController cartController, int index) {
    return Card(
      elevation: 1,
      child: Row(
        children: [
          // left side
          Expanded(
              flex: 2,
              child: Container(
                child: Image.network(
                  'https://i.pinimg.com/originals/b0/e9/a0/b0e9a00985bc87279a40406d132ea671.jpg',
                  /* Links.globalUrl +
                      cartController
                          .productInfoWithQty[index].productInfo.thumbnailImage,*/
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset('assets/images/logo.png');
                  },
                ),
              )),
          //right side
          Expanded(
            flex: 4,
            child: Container(
              margin: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    children: [
                      Text(
                        cartController
                            .productInfoWithQty[index].productInfo.name,
                      ),
                    ],
                  ),
                  Text('\u09F3' +
                      cartController
                          .productInfoWithQty[index].productInfo.basePrice
                          .toString()),
                  Text(
                    '\u09F3' +
                        cartController.productInfoWithQty[index].productInfo
                            .baseDiscountedPrice
                            .toString(),
                    style: TextStyle(
                        fontSize: 14, decoration: TextDecoration.lineThrough),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Decrement button
                      Card(
                        elevation: 1,
                        child: InkWell(
                          onTap: () {
                            // remove product list

                            int removeQty = cartController
                                .productInfoWithQty[index].productQty;

                            removeQty > 1
                                ? addToCartController.addToCartQtyDecrement(
                                cartController
                                    .productInfoWithQty[index].productInfo,
                                index)
                                : print('Remove Qty  :' +
                                cartController
                                    .productInfoWithQty[index].productQty
                                    .toString());
                            setState(() {});
                          },
                          child: Icon(Icons.remove),
                        ),
                      ),
                      SizedBox(width: 10),
                      GetX<AddToCartController>(
                        builder: (cartController) {
                          return Text(
                            cartController.productInfoWithQty[index].productQty
                                .toString(),
                            style: TextStyle(fontSize: 18),
                          );
                        },
                      ),
                      SizedBox(width: 10),
                      //Increment button
                      Card(
                        elevation: 1,
                        child: InkWell(
                          onTap: () {
                            // add product list

                            int qty = cartController
                                .productInfoWithQty[index].productQty;

                            qty < 10
                                ? addToCartController.addToCartQtyIncrement(
                                cartController
                                    .productInfoWithQty[index].productInfo,
                                index)
                                : print('Add  Qty  :' +
                                cartController
                                    .productInfoWithQty[index].productQty
                                    .toString());
                            setState(() {});
                          },
                          child: Icon(Icons.add),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () {
                      setState(() {
                        AwesomeDialog(
                          context: context,
                          customHeader: Icon(
                            Icons.delete,
                            size: 50,
                            color: Colors.red,
                          ),
                          dialogType: DialogType.INFO,
                          animType: AnimType.BOTTOMSLIDE,
                          btnCancelIcon: Icons.cancel,
                          btnOkIcon: Icons.check_circle,
                          title: 'Delete',
                          desc: 'Are you sure you want to delete this item ?',
                          btnCancelOnPress: () {},
                          btnOkOnPress: () {
                            addToCartController.removeFromCart(index);
                          },
                        )..show();
                      });
                    },
                    child: Icon(Icons.delete)),
                SizedBox(
                  height: 40,
                ),
              /*  InkWell(
                    onTap: () {
                      setState(() {
                        //TODO
                      });
                    },
                    child: Icon(Icons.favorite_border)),*/
              ],
            ),
          ),
        ],
      ),
    );
  }

  addToCartCalculation() {
    return Container(
      color: Colors.grey.shade100,
      height: 60,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GetX<AddToCartController>(
                builder: (cartController) {
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                        'Total Price : ' +
                            '\u09F3' +
                            cartController.totalPrice.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green)),
                  );
                },
              ),
            ],
          ),
          NiceButton(
            width: 120,
            elevation: 1.0,
            text: "checkout",
            fontSize: 15,
            radius: 50.0,
            background: Colors.green,
            icon: Icons.fact_check_outlined,
            onPressed: () {
              print('checkout ');
            },

          ),
        ],
      ),
    );
  }
}
