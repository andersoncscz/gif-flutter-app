import 'package:flutter/material.dart';
import 'package:share/share.dart';

class GifPage extends StatelessWidget {

  final Map _gifData;
  GifPage(this._gifData);

  void _handleOnShare() => Share.share(_gifData['images']['fixed_height']['url']);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }

  Widget _appBar() => AppBar(
    title: Text(_gifData['title']),
    centerTitle: true,
    backgroundColor: Colors.blueAccent,
    actions: <Widget>[
      IconButton(
        icon: Icon(Icons.share),
        onPressed: () => _handleOnShare(),
      )
    ],
  );

  Widget _body() => Center(
    child: Image.network(_gifData['images']['fixed_height']['url']),
  );
}