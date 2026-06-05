import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/models/news_models.dart';
import 'package:url_launcher/url_launcher.dart';


class NewsdetailsScreens extends StatelessWidget {
  final NewsModels news = Get.arguments;

  NewsdetailsScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(news.author,maxLines: 1,overflow: TextOverflow.ellipsis,),),
      body: SingleChildScrollView(
        child: Center(
          child: Container(width: 500,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    news.title,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    "Published at: ${news.publishedAt}",
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 15),

                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        news.urlToImage,
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Image.network('https://picsum.photos/200/200'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  SelectableText(
                    news.description,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 15),

                  Text(
                    news.content,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 30),

                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                      launchUrl(Uri.parse(news.url));
                      },
                      icon: const Icon(Icons.launch),
                      label: const Text("Read Full Article"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

    );
  }
}