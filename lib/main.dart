import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:news_app/login/login_controller.dart';
import 'package:news_app/screens/login_screen.dart';
import 'package:news_app/screens/main_screens.dart';
import 'package:news_app/screens/signup_screen.dart';
import 'package:news_app/screens/splash_screen.dart';
import 'screens/bottom_navigagtion/home_screens.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(LoginController());
  runApp(const NewsApp());
}

class NewsApp extends StatefulWidget {
  const NewsApp({super.key});
  @override
  State<NewsApp> createState() => _NewsAppState();
}

class _NewsAppState extends State<NewsApp> {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Global News',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // Universal Text Theme
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
      ),
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: ()=>SplashScreen()),
        GetPage(name: '/login', page: ()=>LoginScreen()),
        GetPage(name: '/signup', page: ()=>SignupScreen()),
        GetPage(name: '/home', page: ()=>MainScreens()),
      ],
    );
  }
}