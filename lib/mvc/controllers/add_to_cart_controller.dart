
import 'package:get/get.dart';
import 'package:planetexam/mvc/models/productinfo_model.dart';

class AddToCartController extends GetxController{
  var productInfoWithQty = List<ProductCart>.empty(growable: true).obs;

  double get totalPrice => productInfoWithQty.fold(
      0,
          (sum, price) => sum = sum +
          double.parse(price.productInfo.basePrice.toString()) *
              double.parse(price.productQty.toString()));

  addToCart(NewProductModel _products){
    for (var i = 0; i < productInfoWithQty.length; i++) {
      ProductCart temp = productInfoWithQty[i];

      if (temp.productInfo.id == _products.id) {
        productInfoWithQty[i].productQty++;
        return;
      }
    }

    ProductCart itemCart = ProductCart(_products, 1);
    productInfoWithQty.add(itemCart);
  }

  removeFromCart(int index){
    productInfoWithQty.removeAt(index);
  }
  removeAllCart(){
    productInfoWithQty.clear();
  }
  addToCartQtyIncrement( NewProductModel _products ,int index){
    productInfoWithQty[index].productQty++;
  }
  addToCartQtyDecrement(NewProductModel _products ,int index){
    productInfoWithQty[index].productQty--;
  }
}

class ProductCart{
  NewProductModel productInfo;
  int productQty ;

  ProductCart(this.productInfo, this.productQty);

  void setQty(int i) {
    if (i < 1) {
      productQty = i;
    } else {
      productQty = i;
    }
  }
}