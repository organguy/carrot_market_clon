import 'package:carrot_market_clone/repository/contents_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String currentLocation;
  late ContentsRepository contentsRepository;
  final Map<String, String> locationTypeToString = {
    "ara" : "아라동",
    "ora" : "오라동",
    "donam" : "도남동",
  };

  @override
  void initState() {
    super.initState();
    currentLocation = 'ara';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    contentsRepository = ContentsRepository();
  }

  AppBar _initAppbar(){
    return AppBar(
      title: GestureDetector(
        onTap: (){
          debugPrint('click');
        },
        child: PopupMenuButton<String>(
          offset: const Offset(-5, 30),
          shape: ShapeBorder.lerp(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              1
          ),
          onSelected: (String where){
            setState(() {
              currentLocation = where;
            });
          },
          itemBuilder: (context){
            return [
              const PopupMenuItem(value: 'ara', child: Text('아라동')),
              const PopupMenuItem(value: 'ora', child: Text('오라동')),
              const PopupMenuItem(value: 'donam', child: Text('도남동')),
            ];
          },
          child: Row(
            children: [
              Text(locationTypeToString[currentLocation]!),
              const Icon(Icons.arrow_drop_down)
            ],
          ),
        ),
      ),
      elevation: 1,
      actions: [
        IconButton(onPressed: (){}, icon: const Icon(Icons.search)),
        IconButton(onPressed: (){}, icon: const Icon(Icons.tune)),
        IconButton(onPressed: (){}, icon: SvgPicture.asset('assets/svg/bell.svg', width: 22,)),
      ],
    );
  }

  String calcStringToWon(String priceString){

    if(priceString == '무료나눔'){
      return priceString;
    }

    String price = NumberFormat('#,###', 'ko_KR').format(int.parse(priceString));
    return '$price원';
  }

  _loadContents(){
    return contentsRepository.loadContentsFromLocation(currentLocation);
  }

  _makeDataList(List<Map<String, String>> datas){
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemBuilder: (context, index){
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Image.asset(
                    datas[index]['image']!,
                    width: 100,
                    height: 100,
                  )
              ),
              Expanded(
                child: Container(
                  height: 100,
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        datas[index]['title']!,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 15,),
                      ),
                      const SizedBox(height: 10,),
                      Text(
                        datas[index]['location']!,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black.withOpacity(0.3)
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Text(
                        calcStringToWon(datas[index]['price']!),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: SvgPicture.asset(
                                'assets/svg/heart_off.svg',
                                width: 13,
                                height: 13,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(datas[index]['likes']!),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
      separatorBuilder: (context, index){
        return Container(
          height: 1,
          color: Colors.black.withOpacity(0.4),
        );
      },
      itemCount: datas.length,
    );
  }

  Widget _initBody(){
    return FutureBuilder(
      future: _loadContents(),
      builder: (context, snapshot){

        if(snapshot.connectionState != ConnectionState.done){
          return const Center(child: CircularProgressIndicator(
            color: Colors.blue,
          ),);
        }

        if(!snapshot.hasData){
          return const Center(
            child: Text('해당지역에 데이터가 없습니다.'),
          );
        }

        if(snapshot.hasError){
          return const Center(
            child: Text('데이터가 오류!!!'),
          );
        }

        List<Map<String, String>> datas = snapshot.data as List<Map<String, String>>;
        return _makeDataList(datas);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _initAppbar(),
      body: _initBody(),
    );
  }
}
