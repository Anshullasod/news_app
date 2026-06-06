import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
class LoginController extends GetxController{
  final box=GetStorage();
  var isLoading=false.obs;
  var token="".obs;
  final String baseURL='https://api.escuelajs.co/api/v1/';

  @override
  void onReady() {
    super.onReady();
    fetchUserProfile();
  }
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
      // Branch 1: Check if the user is logged in via Firebase (Google Sign-In)
      User? firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser != null) {
        print('Fetching profile from Firebase');
        // Standardize the map keys to match your API structure
        currentUser.value = {
          "name": firebaseUser.displayName ?? "No Name",
          "email": firebaseUser.email ?? "No Email",
          "avatar": firebaseUser.photoURL ?? "https://picsum.photos/800",
        };
        return;
      }

      // Branch 2: Fallback to Custom API
      String? token = GetStorage().read('token');

      if (token == null || token.isEmpty) {
        print('No valid token or Firebase session found.');
        return;
      }

      print('Fetching profile from Custom API');
      final response = await http.get(
        Uri.parse("${baseURL}auth/profile"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        currentUser.value = data;
      } else {
        print('Failed to load profile. Status: ${response.statusCode}');
        Get.snackbar("Error", "Could not load profile data.");
      }
    }
     catch (e) {
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

  void logout() async {
    try {
      isLoading.value = true;

      // 1. Firebase aur Google ka session clear karo
      if (FirebaseAuth.instance.currentUser != null) {
        await GoogleSignIn.instance.signOut();
        await FirebaseAuth.instance.signOut();
      }

      // 2. Custom API ka token clear karo
      box.remove('token');
      token.value = "";
      currentUser.value = {};

      // 3. Clear karke login page par phenko
      Get.offAllNamed('/login');
    } catch (e) {
      print("Logout error: $e");
      Get.snackbar("Error", "Logout failed: $e");
    } finally {
      isLoading.value = false;
    }
  }
}