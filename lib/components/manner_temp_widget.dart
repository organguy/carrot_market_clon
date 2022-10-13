import 'package:flutter/material.dart';

class MannerTempWidget extends StatelessWidget {

  final double mannerTemp;
  late int level;
  final List<Color> tempColors = [
    const Color(0xff072038),
    const Color(0xff0d3a65),
    const Color(0xff186ec0),
    const Color(0xff37b24d),
    const Color(0xffffad13),
    const Color(0xfff76707),
  ];

  MannerTempWidget({super.key, required this.mannerTemp}){
    _calcTempLevel();
  }

  void _calcTempLevel(){
    if(mannerTemp <= 20){
      level = 0;
    }else if(mannerTemp <= 32){
      level = 1;
    }else if(mannerTemp <= 36.5){
      level = 2;
    }else if(mannerTemp <= 40){
      level = 3;
    }else if(mannerTemp <= 50){
      level = 4;
    }else{
      level = 5;
    }
  }

  Widget _makeTempLabelAndBar(){

    double barWidth = 63.0;

    return Container(
      width: barWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${mannerTemp}ºC',
            style: TextStyle(
              color: tempColors[level],
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black.withOpacity(0.2),
            ),
            height: 6,
            child: Row(
              children: [
                Container(
                  height: 6,
                  width: barWidth / level,
                  color: tempColors[level],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _makeTempLabelAndBar(),
              Container(
                margin: const EdgeInsets.only(left: 7),
                width: 30,
                height: 30,
                child: Image.asset('assets/images/level-${level}.jpg'),
              )
            ],
          ),
          const Text(
            '매너온도',
            style: TextStyle(
              decoration: TextDecoration.underline,
              fontSize: 12,
              color: Colors.grey
            ),
          )
        ],
      ),
    );
  }
}
