import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:news_app/models/news_models.dart';
class ApiController extends GetxController{
  var newsList=<NewsModels>[].obs;
  var isLoading=true.obs;
  var isMoreLoading=false.obs;
  var type="india".obs;
  var filter='everything'.obs;
  var queryfilter=''.obs;
  var page=1.obs;
  final String apiKey='d7be72230da14405b4107dbca7d0e91e';
  final String base='https://newsapi.org/v2/';
  @override
  void onInit(){
    fetchnews();
    super.onInit();

  }
  Future<void> fetchnews()async{
   try{
     isLoading(true);
     final response = await http.get(Uri.parse('$base${filter.value}?page=1&pageSize=21&apiKey=$apiKey&q=${type.value}${queryfilter.value}'));
     if(response.statusCode==200)
       { isLoading.value=false;
         var data=jsonDecode(response.body);
         List articles=data['articles'];
         newsList.value= articles.map((element)=>NewsModels.fromJson(element)).toList();

       }
     else
       {
         Get.snackbar('Error in life', '$response.body');
         return;
       }
   }
   catch(e){
     Get.snackbar('Error', '$e');
   }
   return;
  }
  Future<void> loadnews()async{
    try{
      isMoreLoading(true);
      page.value++;
      final response = await http.get(Uri.parse('$base${filter.value}?page=${page.toString()}&pageSize=21&apiKey=$apiKey&q=${type.value}${queryfilter.value}'));
      if(response.statusCode==200)
      { isLoading.value=false;
      var data=jsonDecode(response.body);
      List articles=data['articles'];

      var newArticles = articles.map((element) => NewsModels.fromJson(element)).toList();
      newsList.addAll(newArticles);
      }
      else
      { page.value--;
        print(response.body);
      print(response.statusCode);
      Get.snackbar('Error in life', '$response.body');
      return;
      }
    }
    catch(e){
      page.value--;
      Get.snackbar('Error', '$e');
    }
    finally{
      isMoreLoading(false);
    }
  }
}
