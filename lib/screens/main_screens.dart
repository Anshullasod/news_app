import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/login/login_controller.dart';
import 'package:news_app/screens/bottom_navigagtion/bottom_controller.dart';
import 'package:news_app/screens/bottom_navigagtion/my_profile_screen.dart';
import 'package:news_app/screens/bottom_navigagtion/home_screens.dart';
import 'package:news_app/screens/responsive/desktopui.dart';
import 'package:news_app/screens/responsive/responsive_ui.dart';

class MainScreens extends StatelessWidget {
  final controller = Get.put(BottomController());
  final List<Widget> screens = [
    ResponsiveUi(
      mobilebody: HomeScreens(),
      desktopbody: Desktopui(),
    ),
    const MyProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
        index: controller.currentIdx.value,
        children: screens,
      )),

      // YAHAN BADLAV KIYA HAI: Desktop par bottom bar ko hide karne ke liye condition
      bottomNavigationBar: MediaQuery.of(context).size.width < 600
          ? Obx(() => BottomNavigationBar(
        currentIndex: controller.currentIdx.value,
        onTap: (index) => controller.change(index),
        selectedItemColor: Colors.yellow[800],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ))
          : const SizedBox.shrink(), // Desktop par ye khali box return karega aur bar hat jayega
    );
  }
}