import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
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
        Get.snackbar("Error", "Sign Up failed....");
      }
    }
    finally {
      isLoading.value=false;
    }
  }
  var currentUser = {}.obs;

  Future<void> fetchUserProfile() async {
    isLoading.value = true;

    String? token = GetStorage().read('token');
    try {
      // Branch 1: Check if the user is logged in via Firebase (Google Sign-In)
      User? firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser != null) {
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
        Get.snackbar("Error", "Could not load profile data.");
      }
    }
     finally {
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

      if (FirebaseAuth.instance.currentUser != null) {
        await GoogleSignIn.instance.signOut();
        await FirebaseAuth.instance.signOut();
      }

      box.remove('token');
      token.value = "";
      currentUser.value = {};

      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar("Error", "Logout failed: $e");
    } finally {
      isLoading.value = false;
    }
  }
}