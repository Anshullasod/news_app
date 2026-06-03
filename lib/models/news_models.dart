import 'dart:convert';

class NewsModels {
  final String title;
  final String author;
  final String description;
  final String url;
  final String publishedAt;
  final String content;
  final String urlToImage;
  NewsModels({
    required this.title,
    required this.author,
    required this.content,
    required this.description,
    required this.publishedAt,
    required this.urlToImage,
    required this.url
});
  factory NewsModels.fromJson(Map<String,dynamic> data){
    return NewsModels(title: data['title']??"No title",
                      author: data['author']??"unknown",
                      content: data['content']??"",
                      description: data['description']??"No description",
                      publishedAt: data['publishedAt']??"",
                      urlToImage: data['urlToImage']??"https://placehold.co/400",
                      url: data['url']??"",

    );

  }
}