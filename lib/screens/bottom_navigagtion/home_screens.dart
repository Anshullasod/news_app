import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/api/api_controller.dart';
import 'package:news_app/widgets/hovers/hover.dart';
import 'package:news_app/widgets/newscards/news_card.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({super.key});
  @override
  State<StatefulWidget> createState() => _HomeScreens();
}

class _HomeScreens extends State<HomeScreens> {
  final ApiController data=Get.put(ApiController());
  @override
  Widget build(BuildContext context) {
     var input=TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Text('Daily News', style: TextStyle(fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: input,
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  data.fetchnews(query: value);
                }
              },
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: RefreshIndicator(onRefresh: ()async {data.fetchnews();},
          child: Column(
            children: [
              SizedBox(height: 200,child: Hover()),
              NewsCard(),
            ],
          ),
        ),
      ),


    );
  }
}
