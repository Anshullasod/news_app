import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/login/login_controller.dart';

import '../login/authcontroller.dart';
class LoginScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _LoginScreen();
}
class _LoginScreen extends State<LoginScreen>{
  @override
  final AuthController authController = Get.put(AuthController());
  final emailcontroller=TextEditingController();
  final passcontroller=TextEditingController();
  final LoginController logincontroller=Get.find<LoginController>();
  Widget build(BuildContext context) {
   return Scaffold(
     body: SingleChildScrollView(
       padding: const EdgeInsets.symmetric(horizontal: 25.0),
       child: Column(
         children: [
           const SizedBox(height: 100,),
           const Text('Welcome Back',style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold),),
           const Text('Login to your Account',style: TextStyle(color: Colors.grey),),
           const SizedBox(height: 50,),
           TextField(
             controller: emailcontroller,
             keyboardType: TextInputType.emailAddress,
             decoration: InputDecoration(
               prefixIcon: const Icon(Icons.email_outlined),
               labelText: "Email Address",
               border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
             ),
           ),
           const SizedBox(height: 20),

           // 3. Password Field (With Toggle)
           TextField(
             controller: passcontroller,
             decoration: InputDecoration(
               prefixIcon: const Icon(Icons.lock_outline),
               labelText: "Password",
               border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
             ),
           ),
           const SizedBox(height: 10),

           Align(
             alignment: Alignment.centerRight,
             child: TextButton(onPressed: () {}, child: const Text("Forgot Password?")),
           ),
           const SizedBox(height: 30),
           Obx(() => SizedBox(
             width: double.infinity,
             height: 55,
             child: ElevatedButton(
               style: ElevatedButton.styleFrom(
                 backgroundColor: Colors.blueAccent,
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
               ),
               onPressed: logincontroller.isLoading.value
                   ? null
                   : () {
                 if (emailcontroller.text.isNotEmpty && passcontroller.text.isNotEmpty) {
                   logincontroller.login(emailcontroller.text.trim(), passcontroller.text.trim());
                 } else {
                  Get.snackbar("Error", "Please fill all fields", snackPosition: SnackPosition.BOTTOM);
                 }
               },
               child: logincontroller.isLoading.value
                   ? const CircularProgressIndicator(color: Colors.white)
                   : const Text("Login", style: TextStyle(fontSize: 18, color: Colors.white)),
             ),
           )),

           const SizedBox(height: 20),
           Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               const Text("Don't have an account?"),
               TextButton(
                 onPressed: () => Get.toNamed('/signup'),
                 child: const Text("Sign Up", style: TextStyle(fontWeight: FontWeight.bold)),
               ),
             ],
           ),
           const SizedBox(height: 20),
           OutlinedButton.icon(
             style: OutlinedButton.styleFrom(
               minimumSize: const Size(double.infinity, 55),
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
             ),
             icon: const Icon(Icons.g_mobiledata, size: 30),
             label: const Text("Sign in with Google", style: TextStyle(fontSize: 16)),
             onPressed: () => authController.signInWithGoogle(),
           ),

         ],
       ),
     )
   );
  }

}