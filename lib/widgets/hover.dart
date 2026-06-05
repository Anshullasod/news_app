import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/api/api_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../screens/newsdetails_screens.dart';

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
        return const Center(child: CircularProgressIndicator());
      }

      if (data.newsList.isEmpty) {
        return const SizedBox.shrink();
      }

      // Screen size check karne ke liye variable
      final isDesktop = MediaQuery.of(context).size.width >= 600;

      return SizedBox(
        height: isDesktop?360:210,
        child: Card(
          elevation: 4,
          clipBehavior: Clip.antiAlias, // Isse child corners card ke sath round rahenge
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: CarouselSlider.builder(
            itemCount: data.newsList.length > 7 ? 7 : data.newsList.length,
            itemBuilder: (BuildContext context, int index, int pageViewIndex) {
              final news = data.newsList[index];

              return InkWell(
                onTap: () {
                  Get.to(() => NewsdetailsScreens(), arguments: news);
                },
                child: Container(
                  width: double.infinity,
                  color: Colors.grey[50], // Premium neutral background

                  // === RESPONSIVE LAYOUT SWITCHING ===
                  child: isDesktop
                      ? _buildDesktopSliderItem(news) // Desktop Par Banner Design
                      : _buildMobileSliderItem(news), // Mobile Par Purana Design
                ),
              );
            },
            options: CarouselOptions(
              scrollDirection: Axis.horizontal,
              autoPlay: true,
              // Desktop par poori height safely use karega aur mobile par 200px
              height: isDesktop ? 340 : 190,
              viewportFraction: 1.0, // Full width slide cover karne ke liye
              enlargeCenterPage: false,
              scrollPhysics: const BouncingScrollPhysics(
                decelerationRate: ScrollDecelerationRate.normal,
              ),
            ),
          ),
        ),
      );
    });
  }
}
// 1. MOBILE SLIDER DESIGN (Cleaned version of your code)
Widget _buildMobileSliderItem(var news) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        flex: 3,
        child: SizedBox(
          width: double.infinity,
          child: Image.network(
            news.urlToImage,
            errorBuilder: (ctx, err, stack) => Image.network('https://picsum.photos/400/200', fit: BoxFit.cover),
            fit: BoxFit.cover,
          ),
        ),
      ),
      Container(
        padding: const EdgeInsets.all(8.0),
        color: Colors.yellow.shade100,
        width: double.infinity,
        child: Text(
          news.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
        ),
      ),
    ],
  );
}

// 2. DESKTOP SLIDER DESIGN (Modern Magazine Hero Style)
Widget _buildDesktopSliderItem(var news) {
  return Row(
    children: [
      // Left Part: Badi Screen Par Half Side Image Cover Karegi
      Expanded(
        flex: 4,
        child: SizedBox(
          height: double.infinity,
          child: Image.network(
            news.urlToImage,
            errorBuilder: (ctx, err, stack) => Image.network('https://picsum.photos/600/350', fit: BoxFit.cover),
            fit: BoxFit.cover,
          ),
        ),
      ),

      // Right Part: Content aur Description Title Box
      Expanded(
        flex: 3,
        child: Container(
          padding: const EdgeInsets.all(24),
          color: Colors.yellow.shade50, // Soft theme matching layout
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.yellow[700],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  "TRENDING",
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                news.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black87,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 16),
              const Text(overflow:TextOverflow.ellipsis ,
                "Click to read the full coverage on this breaking story...",
                style: TextStyle(color: Colors.black54, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
