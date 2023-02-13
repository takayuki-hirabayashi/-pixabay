import 'package:dio/dio.dart';
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
  Future<void> fetchImages() async {
    Response response = await Dio().get(
        'https://newsapi.org/v2/everything?q=apple&from=2023-02-12&to=2023-02-12&sortBy=popularity&apiKey=3a6625b8dff64baeb4e049bd17a501fc');
    int totalResults = response.data['totalResults'];
    print(totalResults);
  }

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
