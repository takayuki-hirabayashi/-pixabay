import 'dart:math';
import 'apikey.dart';
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
  DateTime now = DateTime.now();
  DateTime yesterday = DateTime.now().add(const Duration(days: 1) * -1);
  String APIKey = api_key;
  final _formKey = GlobalKey<FormState>();

  Future<void> fetchImages(String text) async {
    Response response =
        await Dio().get('https://newsapi.org/v2/everything', queryParameters: {
      'q': '$text',
      'from': '$yesterday',
      'to': '$now',
      'sortBy': '',
      'apiKey': APIKey,
    });
    articles = response.data['articles'];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchImages('日本');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: AppBar(
            title: Form(
              key: _formKey,
              child: TextFormField(
                initialValue: '日本',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'テキストを入力してください。';
                  }
                },
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  helperText: 'search',
                ),
                onFieldSubmitted: (text) {
                  if (_formKey.currentState!.validate()) {
                    fetchImages(text);
                  }
                },
              ),
            ),
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
