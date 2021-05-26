
import 'package:get/get.dart';
import 'package:planetexam/mvc/controllers/network_services/get_service_api.dart';
import 'package:planetexam/mvc/models/productinfo_model.dart';

class ProductController extends GetxController{
  /// new Products
  var newProductList = List<NewProductModel>.empty(growable: true).obs;
  var newProductDataLoaded = false.obs;


  @override
  void onInit() {
    newProducts();
    super.onInit();
  }

  void newProducts() async {
    var responseData = await ApiService().getProductList();
    // newProductList.clear();
    newProductDataLoaded.value = true;
    newProductList.addAll(responseData);
  }

}