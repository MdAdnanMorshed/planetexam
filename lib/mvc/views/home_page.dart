
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planetexam/mvc/controllers/add_to_cart_controller.dart';
import 'package:planetexam/mvc/controllers/product_controller.dart';
import 'package:planetexam/mvc/models/productinfo_model.dart';
import 'package:planetexam/mvc/views/add_to_cart_page.dart';

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  final  ProductController _productController = Get.put(ProductController());
  final addToCartController = Get.put(AddToCartController());
  NewProductModel cartProducts;
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
                    child: GetX<AddToCartController>(
                      builder: (shopController) {
                        return shopController.productInfoWithQty.length == 0
                            ? Text('0')
                            : Text(Get.find<AddToCartController>()
                            .productInfoWithQty
                            .length
                            .toString()
                            ,style: TextStyle(color: Colors.white));
                      },
                    ),
                  ),
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
              cartProducts=controller.newProductList[index];
              return InkWell(
                onTap: (){
                  print('product details');
            //      Get.to(ProductDetailsPage(controller.newProductList[index]));
                },
                child: Container(
                  width: 300,
                  height: 300,
                  child: Card(
                      elevation: 2,
                      margin: EdgeInsets.all(5),
                      child:
                      Column(
                        children: [
                          Image.network(
                            "https://i.pinimg.com/originals/b0/e9/a0/b0e9a00985bc87279a40406d132ea671.jpg",
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Text(controller.newProductList[index].name.toString()),
                          Text(controller.newProductList[index].basePrice.toString()),
                          InkWell(
                            onTap: (){
                              print('Add to Cart ');

                              addToCartController.addToCart(controller.newProductList[index]);
                              Get.snackbar(
                                'Item has been added',
                                controller.newProductList[index].name,
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                                duration: Duration(seconds: 2),
                              );
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
                ),
              );
            });
      },),
    );
  }
}