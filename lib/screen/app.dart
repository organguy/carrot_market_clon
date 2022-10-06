import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'home.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {


  late int _currentIndex;

  @override
  void initState() {
    super.initState();

    _currentIndex = 0;
  }


  Widget _initBody(){

    switch(_currentIndex){
      case 0:
        return const Home();

      case 1:
        return Container();

      case 2:
        return Container();

      case 3:
        return Container();

      case 4:
        return Container();
    }

    return Container();
  }
  
  BottomNavigationBarItem _getBottomItem(String iconName, String label){
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: SvgPicture.asset('assets/svg/${iconName}_off.svg', width: 22,),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: SvgPicture.asset('assets/svg/${iconName}_on.svg', width: 22,),
      ),
      label: label
    );
  }
  
  Widget _initBottom(){
    return BottomNavigationBar(
      items: [
        _getBottomItem('home', '홈'),
        _getBottomItem('notes', '동네생활'),
        _getBottomItem('location', '내 근처'),
        _getBottomItem('chat', '채팅'),
        _getBottomItem('user', '나의 당근'),
      ],
      currentIndex: _currentIndex,
      onTap: (index){
        setState(() {
          _currentIndex = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.black,
      selectedFontSize: 12,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: _initAppbar(),
      body: _initBody(),
      bottomNavigationBar: _initBottom(),
    );
  }
}
