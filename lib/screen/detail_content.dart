import 'package:flutter/material.dart';

class DetailContent extends StatefulWidget {

  Map<String, String> data;

  DetailContent({Key? key, required this.data}) : super(key: key);

  @override
  State<DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends State<DetailContent> {

  AppBar _initAppbar(){
    return AppBar();
  }

  Widget _initBody(){
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _initAppbar(),
      body: _initBody(),
    );
  }
}
