import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
class LoginController extends GetxController{
  final box=GetStorage();
  var isLoading=false.obs;
  var token="".obs;
  final String baseURL='https://api.escuelajs.co/api/v1/';


  Future<void> signUp(String name,String email,String pass) async {
    isLoading.value = true;
    try{
      final response= await http.post(Uri.parse("${baseURL}users/"),
        headers: {"Content-Type":"application/json"},
        body: jsonEncode({
          "name":name,
          "email":email,
          "password":pass,
          "avatar":"https://picsum.photos/800",
        })
      );
      if(response.statusCode==201)
        {
          Get.snackbar("Success", "Account Activated! Now Login.");
          Get.offAllNamed('login');
        }
      else{
        print(response.statusCode.toString());
        Get.snackbar("Error", "Sign Up failed....");
      }
    }
    finally {
      isLoading.value=false;
    }
  }
  var currentUser = {}.obs;

  Future<void> fetchUserProfile() async {
    // 1. Initial stage par loading true kiya
    isLoading.value = true;

    String? token = GetStorage().read('token');
    print('Token for fetching: $token');

    try {
      final response = await http.get(
        Uri.parse("${baseURL}auth/profile"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      );

      print('Response Status for fetching:::: ${response.statusCode}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        currentUser.value = data;
        // Agar custom model hai toh user Model.fromJson(data) use karein
      } else {
        // Handle non-200 status codes (Unauthorized, Server Error etc.)
        print('Failed to load profile. Status: ${response.statusCode}');
      }
    } catch (e) {
      // 2. Network timeout ya parsing error yahan catch hogi
      print('Catch Error in fetchUserProfile: $e');
    } finally {
      // 3. Kuch bhi ho jaye (Success ya Failure), loading yahan aakar hamesha close hogi
      isLoading.value = false;
    }
  }

  Future<void> login(String email,String pass) async{
    isLoading.value=true;
    try{
      final response = await http.post(Uri.parse("${baseURL}auth/login"),
      headers: {"Content-Type":"application/json"},
      body: jsonEncode({
        "email":email,
        "password":pass,
      }));
      if (response.statusCode == 201) {
        var data = jsonDecode(response.body);
        String access_token = data['access_token'];

        final storage = GetStorage();
        await storage.write('token', access_token);

        token.value = access_token;

        Get.offAllNamed('/home');
      }
      else{
        Get.snackbar("Error", "Login failed");
      }
    }
    catch(e){
    Get.snackbar('Error', '$e');
    }
    finally{
      isLoading.value=false;
    }
  }

  void logout() {
    box.remove('token');
    token.value = "";
    currentUser.value = {};
    Get.offAllNamed('/login');
  }

}