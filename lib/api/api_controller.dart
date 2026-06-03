import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:news_app/models/news_models.dart';
class ApiController extends GetxController{
  var newsList=<NewsModels>[].obs;
  var isLoading=true.obs;
  final String apiKey='7a28386cb967445baa0c3f65e6658d4d';
  @override
  void onInit(){
    fetchnews();
    super.onInit();
  }

  Future<void> fetchnews()async{
   try{
     isLoading(true);
     final response = await http.get(Uri.parse('https://newsapi.org/v2/everything?q=tesla&from=2026-05-03&sortBy=publishedAt&apiKey=$apiKey'));
     if(response.statusCode==200)
       { isLoading.value=false;
         var data=jsonDecode(response.body);         List articles=data['articles'];
         newsList.value= articles.map((element)=>NewsModels.fromJson(element)).toList();

       }
     else
       { print(response.body);
         Get.snackbar('Error in life', '${response.body}');
         return;
       }
   }
   catch(e){
     Get.snackbar('Error', 'API Calling failed');
   }
   return;
  }
}