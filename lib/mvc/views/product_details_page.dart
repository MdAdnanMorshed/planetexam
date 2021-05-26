import 'package:flutter/material.dart';
import 'package:planetexam/mvc/models/productinfo_model.dart';

class ProductDetailsPage extends StatefulWidget {
  NewProductModel productDetails;
  ProductDetailsPage(this.productDetails);
  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Product Details'),
        ),
        body: Container(
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                "https://i.pinimg.com/originals/b0/e9/a0/b0e9a00985bc87279a40406d132ea671.jpg",
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Text(widget.productDetails.name.toString()),
              Text(widget.productDetails.basePrice.toString()),

            ],
          ),
          ),

        ),
    );
  }
}
