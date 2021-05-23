
import 'package:flutter/material.dart';

class AddToCartPage extends StatefulWidget {
  @override
  _AddToCartPageState createState() => _AddToCartPageState();
}

class _AddToCartPageState extends State<AddToCartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(title: Text('Add to Cart '),),
        body: Column(
          children: [

            Container(child: Text('Build Cart Item'),),
            Container(child: Text('Total Price '),),
            Container(child: Text('Place Order '),),
          ],
        ));
  }
}
