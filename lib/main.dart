import 'dart:convert';

import 'package:app_api/models/Gif.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'Flutter API'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //
  late Future<List<Gif>> _listGif;

  Future<List<Gif>> _getGif() async {
    var url = Uri.parse(
        "https://api.giphy.com/v1/gifs/trending?api_key=3sTx9jSexS0iFHfqZGoj7RhBO4nznFBJ&limit=10&rating=g");
    final response = await http.get(url);

    List<Gif> gifs = [];

    if (response.statusCode != 200) {
      throw Exception("Algo salio mal");
    } else {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);

      for (var item in jsonData["data"]) {
        gifs.add(Gif(item["title"], item["images"]["downsized"]["url"]));
      }
      return gifs;
    }
  }

  //
  @override
  void initState() {
    super.initState();
    _listGif = _getGif();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: _listGif,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.count(
              crossAxisCount: 2,
              children: _listGifw(snapshot.data),
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Text("Error");
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

List<Widget> _listGifw(data) {
  List<Widget> gifs = [];
  List<Gif> dato = data;
  for (var gif in dato) {
    gifs.add(Card(child: Column(children: [
      Expanded(
      child: Image.network(gif.url, fit: BoxFit.fill,),
      ),
    ]),),
    );
  }
  return gifs;
}
