
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'file:///F:/backup/bottomsheet/planetexam/lib/mvc/views/add_to_cart_page.dart';
import 'file:///F:/backup/bottomsheet/planetexam/lib/mvc/controllers/product_controller.dart';
class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
 final  ProductController _productController = Get.put(ProductController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("E-commerce"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
                onTap: (){
                  print('Go to the Add to cart page ');
                  Get.to(AddToCartPage());
                },
                child: Stack(
                  children: [
                    Icon(Icons.add_shopping_cart,color: Colors.black,),
                    SizedBox(width: 5,),
                    Positioned(
                        right: 0,
                         top: 0,
                    child: Text('2',style: TextStyle(color: Colors.white),)),
                  ],
                ),
            ),
          ),
              ],
      ),
      body: Center(
        child:_productCartUI(),
      ),
    );
  }
  _productCartUI(){
    return Container(
      margin: EdgeInsets.all(5),
      child: GetX<ProductController>(builder: (controller){
        return controller.newProductList.isEmpty ?
            Text('No Product Found '):
            ListView.builder(
              scrollDirection: Axis.vertical,
                itemCount: controller.newProductList.length,
                itemBuilder: ( ctx,index){
                 return Container(
                   width: 300,
                   height: 300,
                   child: Card(
                     elevation: 2,
                     margin: EdgeInsets.all(5),
                     child: Column(
                       children: [
                         Image.network(
                           "https://i.pinimg.com/736x/77/92/6b/77926ba08c726b7685100441f7ef07bd.jpg",
                           height: 200,
                           width: double.infinity,
                           fit: BoxFit.cover,
                         ),
                         Text(controller.newProductList[index].name.toString()),
                         Text(controller.newProductList[index].basePrice.toString()),
                         InkWell(
                           onTap: (){
                             print('Add to Cart ');
                           },
                           child: Container(
                             height: 30,
                             margin: EdgeInsets.all(5),
                             width: double.infinity,
                             color: Colors.green,
                             child: Center(
                               child: Text('Add To Cart',style: TextStyle(
                               fontSize: 20,color: Colors.white

                           ),),
                             ),),
                         ),
                       ],
                     )
                   ),
                 );
                });
      },),
    );
  }
}