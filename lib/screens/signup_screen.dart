import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/login/login_controller.dart';

class SignupScreen extends StatefulWidget{
  const SignupScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SignupScreen();

}
class _SignupScreen extends State<SignupScreen>{
  final nameController=TextEditingController();
  final emailController=TextEditingController();
  final passController=TextEditingController();
  final logincontroller=Get.find<LoginController>();
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      leading: ElevatedButton(onPressed: (){Get.offAllNamed('/login');},
        child: Center(child: Icon(Icons.arrow_back)),),
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          children: [
            const Icon(Icons.person_add_alt_1, size: 80, color: Colors.blueAccent),
            const SizedBox(height: 20),
            const Text("Create Account", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const Text("Join our news community today", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 40),

            // 1. Name Field
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person_outline),
                labelText: "Full Name",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),

            // 2. Email Field
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email_outlined),
                labelText: "Email Address",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),

            // 3. Password Field
            TextField(
              controller: passController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_outline),
                labelText: "Password",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 40),

            // Signup Button
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
                  if (nameController.text.isNotEmpty &&
                      emailController.text.isNotEmpty &&
                      passController.text.isNotEmpty) {

                    // Controller ke signUp function ko call karo
                    logincontroller.signUp(
                      nameController.text.trim(),
                      emailController.text.trim(),
                      passController.text.trim(),
                    );
                  } else {
                    Get.snackbar("Required", "Fill all the sections",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.redAccent,
                        colorText: Colors.white);
                  }
                },
                child: logincontroller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Sign Up", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            )),
          ],
        ),
      ),
    ),
  );
  }

}