import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:news_app/models/news_models.dart';
class ApiController extends GetxController{
  var newsList=<NewsModels>[].obs;
  var isLoading=true.obs;
  var type="india".obs;
  var filter='everything'.obs;
  var queryfilter=''.obs;
  final String apiKey='65b8dbd14ecb4e119791a3ec53bc998f';
  final String base='https://newsapi.org/v2/';
  @override
  void onInit(){
    fetchnews();
    super.onInit();
  }
  Future<void> fetchnews()async{
    print('$base${filter.value}?apiKey=$apiKey&q=${type.value}${queryfilter.value}');
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
       { print(response.body);
         print(response.statusCode);
         Get.snackbar('Error in life', '${response.body}');
         return;
       }
   }
   catch(e){
     Get.snackbar('Error', '$e');
   }
   return;
  }
}