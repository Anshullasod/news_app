import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashScreen();

}
class _SplashScreen extends State<SplashScreen>{
  @override
  void initState(){
    super.initState();
    _checkLoginStatus();
  }
  void _checkLoginStatus() async{
    await Future.delayed(const Duration(seconds: 3));
    final box=GetStorage();
    String? token=box.read('token');
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    if(token!=null || firebaseUser != null)
      {
        Get.offAllNamed('/home');
      }
    else
      {
        Get.offAllNamed('/login');
      }
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: Center(
       child: FlutterLogo(size: 100,),
     ),
   );
  }

}