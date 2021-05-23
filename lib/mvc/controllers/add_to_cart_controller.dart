
import 'package:get/get.dart';
import 'package:planetexam/mvc/models/models.dart';

class AddToCartController extends GetxController{
  var productCart = List<ProductCart>.empty(growable: true).obs;

  double get totalPrice => productCart.fold(
      0,
          (sum, price) => sum = sum +
          double.parse(price._productModel.basePrice) *
              double.parse(price.pQty.toString()));

  addToCart(NewProductModel _products){
    for (var i = 0; i < productCart.length; i++) {
      ProductCart temp = productCart[i];

      if (temp._productModel.id == _products.id) {
        productCart[i].pQty++;
        return;
      }
    }

    ProductCart itemCart = ProductCart(_products, 1);
    productCart.add(itemCart);
  }

  removeFromCart(int index){
    productCart.removeAt(index);
  }
  removeAllCart(){
    productCart.clear();
  }
  addToCartQtyIncrement( NewProductModel _products ,int index){
    productCart[index].pQty++;
  }
  addToCartQtyDecrement(NewProductModel _products ,int index){
    productCart[index].pQty--;
  }
}

class ProductCart{
  NewProductModel _productModel;
  int pQty ;

  ProductCart(this._productModel, this.pQty);

  void setQty(int i) {
    if (i < 1) {
      pQty = i;
    } else {
      pQty = i;
    }
  }
}