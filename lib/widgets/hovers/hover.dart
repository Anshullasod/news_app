import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/api/api_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../screens/newsdetails_screens.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class Hover extends StatefulWidget {
  const Hover({super.key});
  @override
  State<StatefulWidget> createState() {
    return _Hover();
  }
}

class _Hover extends State<Hover> {
  final ApiController data = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (data.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }
      return Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        shadowColor: Colors.black38,
        child: CarouselSlider.builder(
          itemCount: data.newsList.length > 7 ? 7 : data.newsList.length,
          itemBuilder: (BuildContext context, int index, int pageViewIndex) =>
              InkWell(
                onTap: () {
                  Get.to(
                    () => NewsdetailsScreens(),
                    arguments: data.newsList[index],
                  );
                },
                child: Container(
                  width: 300,
                  height: 200,
                  color: Colors.yellow.shade100,
                  child: Column(
                    children: [
                      Text(data.newsList[index].title, maxLines: 3),
                      Expanded(
                        child: Image.network(
                          data.newsList[index].urlToImage,
                          errorBuilder: (ctx, err, stack) =>
                              Image.network('https://picsum.photos/200/200'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          options: CarouselOptions(
            scrollDirection: Axis.horizontal,
            autoPlay: true,
            scrollPhysics: BouncingScrollPhysics(
              decelerationRate: ScrollDecelerationRate.normal,
            ),
          ),
        ),
      );
    });
  }
}
