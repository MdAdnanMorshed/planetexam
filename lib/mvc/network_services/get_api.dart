

import 'dart:convert';

import 'package:planetexam/mvc/models.dart';
import 'package:http/http.dart' as http;

class ApiService {

 Future<List<NewProductModel>> getProductList() async{
   List<NewProductModel> productList=[];

   var response=await http.get('https://mudihat.com/api/todays-deal-products/3');
   print('response code :'+response.statusCode.toString());
   print('response :'+response.body);
   if(response.statusCode==200){
   var responseData =jsonDecode(response.body);
     var jsonData= responseData['data'];

       for(var products in jsonData){
         productList.add(NewProductModel.fromJson(products));
       }

   print('product length  :'+productList.length.toString());
    }else{
     print('Error ');
     return [];
    }
   return productList;
  }
}