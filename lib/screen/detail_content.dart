import 'package:carousel_slider/carousel_slider.dart';
import 'package:carrot_market_clone/components/manner_temp_widget.dart';
import 'package:carrot_market_clone/repository/contents_repository.dart';
import 'package:carrot_market_clone/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailContent extends StatefulWidget {

  final Map<String, String> data;

  const DetailContent({Key? key, required this.data}) : super(key: key);

  @override
  State<DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends State<DetailContent> with SingleTickerProviderStateMixin{

  late ContentsRepository contentsRepository;
  late Size size;
  late List<Map<String, String>> imgList;
  late int _current;
  double scrollPositionToAlpha = 0.0;
  final ScrollController _controller = ScrollController();
  late AnimationController _animationController;
  late Animation _colorTween;
  late bool isMyFavoriteContent;
  
  @override
  void initState() {
    super.initState();
    contentsRepository = ContentsRepository();
    isMyFavoriteContent = false;
    _animationController = AnimationController(vsync: this);
    _colorTween = ColorTween(begin: Colors.white, end: Colors.black).animate(_animationController);
    _controller.addListener(() {
      setState(() {
        if(_controller.offset > 255){
          scrollPositionToAlpha = 255;
        }else{
          scrollPositionToAlpha = _controller.offset;
        }

        _animationController.value = scrollPositionToAlpha / 255.0;

      });
    });
    _loadMyFavoriteContentState();
  }

  _loadMyFavoriteContentState() async {
    bool isFavorite = await contentsRepository.isMyFavoriteContent(widget.data['cid']!);
    setState((){
      isMyFavoriteContent = isFavorite;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    size = MediaQuery.of(context).size;
    imgList = [
      {'id' : '0', 'url' : widget.data['image']!},
      {'id' : '1', 'url' : widget.data['image']!},
      {'id' : '2', 'url' : widget.data['image']!},
      {'id' : '3', 'url' : widget.data['image']!},
      {'id' : '4', 'url' : widget.data['image']!},
    ];
    _current = 0;
  }

  Widget _makeIcon(IconData icon){
    return AnimatedBuilder(
      animation: _colorTween,
        builder: (context, child) {
          return Icon(
            icon,
            color: _colorTween.value,
          );
        }
    );
  }

  AppBar _initAppbar(){
    return AppBar(
      backgroundColor: Colors.white.withAlpha(scrollPositionToAlpha.toInt()),
      elevation: 0,
      leading: IconButton(
        onPressed: (){
          Navigator.pop(context);
        },
        icon: _makeIcon(Icons.arrow_back),
      ),
      actions: [
        IconButton(
          onPressed: (){},
          icon: _makeIcon(Icons.share,)
        ),
        IconButton(
          onPressed: (){},
          icon: _makeIcon(Icons.more_vert,)
        ),
      ],
    );
  }

  Widget _makeSliderImage() {
    return Stack(
      children: [
        Hero(
          tag: widget.data['image']!,
          child: CarouselSlider(
            items: imgList.map((map) {
              return Image.asset(
                map['url']!,
                width: size.width,
                fit: BoxFit.fill,
              );
            }).toList(),
            options: CarouselOptions(
                height: size.width,
                initialPage: 0,
                enableInfiniteScroll: false,
                viewportFraction: 1,
                onPageChanged: (index, reason){
                  debugPrint(index.toString());
                  setState(() {
                    _current = index;
                  });
                }
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imgList.map((map){
              return Container(
                width: 10.0,
                height: 10.0,
                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == int.parse(map['id']!)
                        ? Colors.white
                        : Colors.white.withOpacity(0.4)
                ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }

  Widget _sellerSimpleInfo(){
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: Image.asset('assets/images/user.png').image,
          ),
          const SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                '개발하는남자',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text('제주시 도담동')
            ],
          ),
          Expanded(
            child: MannerTempWidget(mannerTemp: 37.5)
          ),
        ],
      ),
    );
  }
  
  Widget _line(){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      height: 1,
      color: Colors.grey.withOpacity(0.3),
    );
  }

  Widget _contentsDetail(){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20,),
          Text(
            widget.data['title']!,
            style: const TextStyle (
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const Text(
            '디지털/가전 22시간 전',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12
            ),
          ),
          const SizedBox(height: 15,),
          const Text(
            '선물받은 새상품이고\n상품 꺼내보기만 했습니다\n거래는 직거래만 합니다.',
            style: TextStyle(
                fontSize: 15,
                height: 1.5,
            ),
          ),
          const SizedBox(height: 15,),
          const Text(
            '채팅 3 - 관심 17 - 조회 295',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey
            ),
          ),
          const SizedBox(height: 15,),
        ],
      ),
    );
  }

  Widget _otherCellContents(){
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            '판매자님의 판매 상품',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '모두보기',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
    );
  }

  Widget _initBody(){
    return CustomScrollView(
      controller: _controller,
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              _makeSliderImage(),
              _sellerSimpleInfo(),
              _line(),
              _contentsDetail(),
              _line(),
              _otherCellContents(),
            ]
          )
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10
            ),
            delegate: SliverChildListDelegate(List.generate(20, (index){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey,
                      ),
                      height: 120,
                    ),
                    const Text(
                      '상품 제목',
                      style: TextStyle(
                        fontSize: 14
                      ),
                    ),
                    const Text(
                      '금액',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  ],
                );
              }).toList(),
            ),
          ),
        )
      ],
    );
  }

  Widget _initBottom(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: size.width,
      height: 55,
      child: Row(
        children: [
          GestureDetector(
            onTap: () async{
              if(isMyFavoriteContent){
                await contentsRepository.deleteMyFavoriteContent(widget.data['cid']!);
              }else{
                await contentsRepository.addMyFavoriteContent(widget.data);
              }

              setState(() {
                isMyFavoriteContent = !isMyFavoriteContent;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isMyFavoriteContent ? '관심목록에 추가됐습니다.' : '관심목록에 제거됐습니다.'
                  ),
                  duration: const Duration(seconds: 1),
                )
              );
            },
            child: SvgPicture.asset(
              isMyFavoriteContent
              ? 'assets/svg/heart_on.svg'
              : 'assets/svg/heart_off.svg',
              width: 25,
              height: 25,
              color: const Color(0xfff08f4f),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 15, right: 10),
            width: 1,
            height: 40,
            color: Colors.grey.withOpacity(0.3),
          ),
          Column(
            children: [
              Text(
                Utils.calcStringToWon(widget.data['price']!),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                '가격제안불가',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey
                ),
              )
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: const Color(0xfff08f4f),
                  ),
                  child: const Text(
                    '채팅으로 거래하기',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            )
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _initAppbar(),
      body: _initBody(),
      bottomNavigationBar: _initBottom(),
    );
  }
}
