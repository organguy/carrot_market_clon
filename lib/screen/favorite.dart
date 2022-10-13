import 'package:carrot_market_clone/repository/contents_repository.dart';
import 'package:carrot_market_clone/screen/detail_content.dart';
import 'package:carrot_market_clone/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Favorite extends StatefulWidget {
  const Favorite({Key? key}) : super(key: key);

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {

  late ContentsRepository contentsRepository;

  @override
  void initState() {
    super.initState();
    contentsRepository = ContentsRepository();
  }

  AppBar _initAppbar(){
    return AppBar(
      title: const Text(
        '관심목록',
        style: TextStyle(
          fontSize: 15,
        ),
      ),
    );
  }

  _makeDataList(List<dynamic> datas){
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemBuilder: (context, index){
        return GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(
                builder: (context){
                  Map<String, dynamic> mapDynamic =  Map<String, dynamic>.from(datas[index]);
                  Map<String, String> mapString = mapDynamic.map((key, value) => MapEntry(key, value.toString()));
                  return DetailContent(data: mapString);
                }));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: Hero(
                      tag: datas[index]['image']!,
                      child: Image.asset(
                        datas[index]['image']!,
                        width: 100,
                        height: 100,
                      ),
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
                          Utils.calcStringToWon(datas[index]['price']!),
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
        future: _loadFavorites(),
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

          List<dynamic> datas = snapshot.data as List<dynamic>;
          return _makeDataList(datas);
        }
    );
  }

  Future<List<dynamic>> _loadFavorites() async{
    return await contentsRepository.loadFavoriteContents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _initAppbar(),
      body: _initBody(),
    );
  }
}
