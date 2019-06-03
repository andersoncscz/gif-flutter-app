import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

import '../utils/utils.dart' as utils;
import 'gif-page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _search;
  int _limit = 19;
  int _offset = 75;

  Future<Map> _getGifs() async {
    http.Response response;

    if (_search == null || _search.isEmpty) {
      response = await http.get(utils.getUrlTrending(_limit));
    }
    else {
      response = await http.get(utils.getUrlSearch(_search, _limit, _offset));      
    }
    return json.decode(response.body);
  }
  
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }

  void _handleSubmit(String text) {
    setState(() { 
      _search = text; 
      _offset = 0;
    });    
  }

  void _handleTapped(BuildContext context, AsyncSnapshot snapshot, int index) => Navigator.push(
    context, 
    MaterialPageRoute(
      builder: (context) => GifPage(snapshot.data['data'][index])
    )
  );

  void _handleLongPress(AsyncSnapshot snapshot, int index) => Share.share(snapshot.data['data'][index]['images']['fixed_height']['url']);

  void _handleLoadMore() {
    setState(() {
      _offset += 19; 
    });
  }

  int _getCount(List data) {
    if (_search == null)
      return data.length;

    return data.length + 1;
  }



  Widget _appBar() => AppBar(
    title: Image.network('https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif'),
    centerTitle: true,
  );



  Widget _body() => Column(
    children: <Widget>[
      Padding(
        padding: EdgeInsets.all(10),
        child: TextField(
          decoration: InputDecoration(
            labelText: 'Search',
            labelStyle: TextStyle(color: Colors.blueAccent),
            border: OutlineInputBorder()
          ),
          style: TextStyle(color: Colors.blueAccent, fontSize: 18),
          textAlign: TextAlign.center,
          onSubmitted: (text) => _handleSubmit(text),
        ),
      ),
      Expanded(
        child: FutureBuilder(
          future: _getGifs(),
          builder: _itemsBuilder,
        ),
      )
    ],
  );



  Widget _itemsBuilder(BuildContext context, AsyncSnapshot snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.waiting:
      case ConnectionState.none:
          return Container(
            width: 200, height: 200, alignment: Alignment.center,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              strokeWidth: 5,
            ),
          );
        break;
      default:
        if (snapshot.hasError)
          return Container();
        return _createGifTable(context, snapshot);
    }
  }



  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) => GridView.builder(
    padding: EdgeInsets.all(10),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10
    ),
    itemCount: _getCount(snapshot.data['data']),
    itemBuilder: (context, index) => _tableItemBuilder(context, snapshot, index),
  );



  Widget _tableItemBuilder(BuildContext context, AsyncSnapshot snapshot, int index) {
    
    //If not searching OR if not the last element, renders it!
    if(_search == null || index < snapshot.data['data'].length) {
      return GestureDetector(
        child: FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: snapshot.data['data'][index]['images']['fixed_height']['url'],
          height: 300,
          fit: BoxFit.cover,
        ),
        onTap: () => _handleTapped(context, snapshot, index),
        onLongPress: () => _handleLongPress(snapshot, index),
      );
    }

    return Container(
      child: GestureDetector(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.add, color: Colors.blueAccent, size: 70)
          ],
        ),
        onTap: () => _handleLoadMore(),
      ),
    );
  }
}