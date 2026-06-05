import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/screens/newsdetails_screens.dart';

import '../api/api_controller.dart';

class NewsCard extends StatefulWidget{
  const NewsCard({super.key});
  @override
  State<StatefulWidget> createState() {
   return _NewsCard();
  }
}
class _NewsCard extends State<NewsCard>{
  final ApiController data = Get.find<ApiController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() => GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: data.newsList.length,

      // === GRID DELEGATE: Yeh automatic detect karega screen size ===
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        // Agar screen width 600px se badi (Desktop) hai toh 2 ya 3 columns dikhao, mobile par 1
        crossAxisCount: MediaQuery.of(context).size.width >= 600 ? 2 : 1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        // Card ke aspect ratio ko desktop aur mobile ke hisab se setup kiya
        mainAxisExtent: MediaQuery.of(context).size.width >= 600 ? 280 : 130,
      ),

      itemBuilder: (context, index) {
        final news = data.newsList[index];

        return InkWell(
          onTap: () {
            Get.to(() => NewsdetailsScreens(), arguments: news);
          },
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(10),

              // === RESPONSIVE LAYOUT IMPLEMENTATION ===
              child: MediaQuery.of(context).size.width >= 600
                  ? _buildDesktopCard(news) // Desktop Layout
                  : _buildMobileCard(news), // Mobile Layout (Aapka purana layout)
            ),
          ),
        );
      },
    ));
  }
  void check(String imagetoUrl,int  index){
    if(imagetoUrl=="https://via.placeholder.com/150")
    {
      print(data.newsList[index].title);
    }}

}
Widget _buildMobileCard(var news) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        flex: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              news.title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const Spacer(), // Safe space layout
            const Text(
              "see more...",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
      const SizedBox(width: 10),
      ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          news.urlToImage,
          errorBuilder: (ctx, err, stack) => Image.network('https://picsum.photos/100/100'),
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
      ),
    ],
  );
}

// 2. DESKTOP CARD LAYOUT (Modern Magazine/Grid Style)
Widget _buildDesktopCard(var news) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Desktop par image upar badi dikhegi
      Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: double.infinity,
            child: Image.network(
              news.urlToImage,
              errorBuilder: (ctx, err, stack) => Image.network('https://picsum.photos/300/200'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      const SizedBox(height: 10),
      // Title niche aayega
      Text(
        news.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      const SizedBox(height: 6),
      const Text(
        "see more...",
        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
      ),
    ],
  );
}
