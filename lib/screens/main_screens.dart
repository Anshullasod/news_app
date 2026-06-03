import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/login/login_controller.dart';
import 'package:news_app/screens/bottom_navigagtion/bottom_controller.dart';
import 'package:news_app/screens/bottom_navigagtion/my_profile_screen.dart';
import 'package:news_app/screens/bottom_navigagtion/home_screens.dart';

class MainScreens extends StatelessWidget{
  final controller=Get.put(BottomController());
  final List<Widget> screens=[HomeScreens(),MyProfileScreen()];
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: Obx(() => IndexedStack(
       index: controller.currentIdx.value,
       children: screens,
     )),
     bottomNavigationBar: Obx(() => BottomNavigationBar(
       currentIndex: controller.currentIdx.value,
       onTap: (index) => controller.change(index),
       selectedItemColor: Colors.yellow[800],
       items: const [
         BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
         BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
       ],
     )),
   );

  }

}