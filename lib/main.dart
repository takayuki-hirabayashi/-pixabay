import 'dart:math';

import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: NewsPage(),
    );
  }
}

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List articles = [];

  Future<void> fetchImages(String text) async {
    Response response =
        await Dio().get('https://newsapi.org/v2/everything', queryParameters: {
      'q': '$text',
      'from': '2023-02-14',
      'to': '2023-02-14',
      'sortBy': '',
      'apiKey': '3a6625b8dff64baeb4e049bd17a501fc',
    });
    articles = response.data['articles'];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    //後でここを変更する必要あり
    fetchImages('apple');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: TextFormField(
            //ここも同様に変更の必要あり
            initialValue: 'apple',
            decoration: const InputDecoration(
              fillColor: Colors.white,
              filled: true,
            ),
            onFieldSubmitted: (text) {
              fetchImages(text);
            },
          ),
        ),
        body: ListView.builder(
          itemCount: articles.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> article = articles[index];
            if (article['urlToImage'] != null) {
              return Card(
                child: ListTile(
                  leading: SizedBox(
                    height: 100,
                    width: 100,
                    child: Image.network(
                      article['urlToImage'],
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    ),
                  ),
                  title: Text(article['title']),
                  onTap: () {
                    final url = Uri.parse(article['url']);
                    launchUrl(url);
                  },
                ),
              );
            } else {
              return Card(
                child: ListTile(
                  leading: SizedBox(
                    height: 100,
                    width: 100,
                    child: Container(
                      color: Colors.green,
                    ),
                  ),
                  title: Text(article['title']),
                  onTap: () {
                    final url = Uri.parse(article['url']);
                    launchUrl(url);
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}



//タイトルのみ一覧で表示することができた
// body: ListView.builder(
//           itemCount: articles.length,
//           itemBuilder: (context, index) {
//             Map<String, dynamic> article = articles[index];
//             if (article['title'] != null) {
//               return Text(article['title']);
//             } else {
//               return Text('No Image');
//             }
//           },
//         ),

// 画像のみ一覧で表示することができた
// body: GridView.builder(
//           gridDelegate:
//               SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
//           itemCount: articles.length,
//           itemBuilder: (context, index) {
//             Map<String?, dynamic> article = articles[index];
//             if (Image.network(article['urlToImage']) == Null)
//               return Text('No Image');
//             else
//               return Image.network(article['urlToImage']);
//           },
//         ),
