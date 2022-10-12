import 'package:flutter/material.dart';

class DetailContent extends StatefulWidget {

  final Map<String, String> data;

  const DetailContent({Key? key, required this.data}) : super(key: key);

  @override
  State<DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends State<DetailContent> {

  late Size size;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    size = MediaQuery.of(context).size;
  }

  AppBar _initAppbar(){
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(onPressed: (){}, icon: const Icon(Icons.share)),
        IconButton(onPressed: (){}, icon: const Icon(Icons.more_vert)),
      ],
    );
  }

  Widget _initBody(){
    return Container(
      child: Hero(
        tag: widget.data['image']!,
        child: Image.asset(
          widget.data['image']!,
          width: size.width,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _initAppbar(),
      body: _initBody(),
    );
  }
}
