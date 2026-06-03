import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/screens/newsdetails_screens.dart';

import '../../api/api_controller.dart';

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
    return Obx(()=> ListView.builder(shrinkWrap: true,
    physics: NeverScrollableScrollPhysics()
    ,itemCount:  data.newsList.length,
          itemBuilder: (context,index){
            return InkWell(onTap: (){Get.to(()=>NewsdetailsScreens(),arguments: data.newsList[index]);},
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.newsList[index].title,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {Get.to(()=>NewsdetailsScreens(),arguments: data.newsList[index]);},
                              child: Text(
                                "see more...",
                                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(flex: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            data.newsList[index].urlToImage,
                            errorBuilder: (ctx,err,stack){

                            return Image.network('https://picsum.photos/100/100');},
                            width: 100, // Fixed width
                            height: 100, // Fixed height
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            );
          }));
  }
  void check(String imagetoUrl,int  index){
    if(imagetoUrl=="https://via.placeholder.com/150")
    {
      print(data.newsList[index].title);
    }}

}
