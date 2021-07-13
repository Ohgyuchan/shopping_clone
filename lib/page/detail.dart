import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shopping_clone/components/manner_temperature.dart';
import 'package:shopping_clone/utils/data_utils.dart';

class DetailContentsView extends StatefulWidget {
  final Map<String, String> data;
  const DetailContentsView({Key? key, required this.data}) : super(key: key);

  @override
  _DetailContentsViewState createState() => _DetailContentsViewState();
}

class _DetailContentsViewState extends State<DetailContentsView>
    with SingleTickerProviderStateMixin {
  late Size size;
  List<String> imgList = [];
  late int _currentIndex;
  double scrollPositionToAlpha = 0;
  ScrollController _appBarScrollController = ScrollController();
  late AnimationController _appBarAnimationController;
  late Animation _colorTween;
  late bool isMyFavoriteContent;

  @override
  void initState() {
    isMyFavoriteContent = false;
    _appBarAnimationController = AnimationController(vsync: this);
    _colorTween = ColorTween(
      begin: Colors.white,
      end: Colors.black,
    ).animate(_appBarAnimationController);
    _appBarScrollController.addListener(() {
      setState(() {
        if (_appBarScrollController.offset > 255)
          scrollPositionToAlpha = 255;
        else
          scrollPositionToAlpha = _appBarScrollController.offset;
        _appBarAnimationController.value = scrollPositionToAlpha / 255;
      });
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size;
    imgList = [
      "${widget.data['image']}",
      "${widget.data['image']}",
      "${widget.data['image']}",
      "${widget.data['image']}",
    ];
    _currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _appBarWidget(),
      body: _bodyWidget(),
      bottomNavigationBar: _bottomNavigationBarWidget(),
    );
  }

  Widget _bottomNavigationBarWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      width: size.width,
      height: 55,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isMyFavoriteContent = !isMyFavoriteContent;
              });
              Get.showSnackbar(
                GetBar(
                  message: isMyFavoriteContent
                      ? '관심상품 목록에 추가됐습니다.'
                      : '관심상품 목록에 제거됐습니다.',
                  duration: Duration(milliseconds: 1000),
                  snackPosition: SnackPosition.BOTTOM,
                ),
              );
              print("관심상품이벤트발생");
            },
            child: SvgPicture.asset(
              isMyFavoriteContent
                  ? "assets/svg/heart_on.svg"
                  : "assets/svg/heart_off.svg",
              width: 20,
              height: 20,
              color: Color(0xfff08f4f),
            ),
          ),
          SizedBox(width: 15),
          VerticalDivider(width: 1, thickness: 1.0),
          SizedBox(width: 15),
          Column(
            children: [
              Text(
                DataUtils.calcStringToWon("${widget.data["price"]}"),
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "가격제안불가",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              )
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 7.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    // BoxDecoration 사용시에는 color를 BoxDecoration 안에 설정해줘야 함.
                    color: Color(0xfff08f4f),
                  ),
                  child: Text(
                    "채팅으로 거래하기",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _makeAnimatedIcon(IconData iconData) {
    return AnimatedBuilder(
      animation: _colorTween,
      builder: (context, child) => Icon(
        iconData,
        color: _colorTween.value,
      ),
    );
  }

  AppBar _appBarWidget() {
    return AppBar(
      backgroundColor: Colors.white.withAlpha(scrollPositionToAlpha.toInt()),
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: _makeAnimatedIcon(Icons.arrow_back),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: _makeAnimatedIcon(Icons.share_outlined),
        ),
        IconButton(
          onPressed: () {},
          icon: _makeAnimatedIcon(Icons.more_vert),
        ),
      ],
    );
  }

  Widget _bodyWidget() {
    return CustomScrollView(
      controller: _appBarScrollController,
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              _makeSliderImage(),
              _sellerSimpleInfo(),
              Divider(height: 1, thickness: 1),
              _contentDetail(),
              Divider(height: 1, thickness: 1),
              _otherSellContents(),
            ],
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            delegate: SliverChildListDelegate(
              List.generate(20, (index) {
                return Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          color: Colors.grey,
                          height: 120,
                        ),
                      ),
                      Text("상품 제목", style: TextStyle(fontSize: 14.0)),
                      Text("금액",
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        )
      ],
    );
  }

  Widget _makeSliderImage() {
    return Container(
      child: Stack(
        children: [
          Hero(
            tag: "${widget.data['cid']}",
            // Hero애니메이션 도중에 발생하는 오버플로우 때문에 애니매이션 동작 재정의
            flightShuttleBuilder: (
              BuildContext flightContext,
              Animation<double> animation,
              HeroFlightDirection flightDirection,
              BuildContext fromHeroContext,
              BuildContext toHeroContext,
            ) {
              return SingleChildScrollView(
                // fromHeroContext: 시작크기로 애니메이션 진행, toHeroContext: 끝크기로 애니메이션 진행
                child: toHeroContext.widget,
              );
            },
            child: Container(
              child: CarouselSlider(
                items: imgList.map((url) {
                  return Column(
                    children: [
                      Image.asset(
                        url,
                        width: size.width,
                        fit: BoxFit.fill,
                      ),
                    ],
                  );
                }).toList(),
                options: CarouselOptions(
                    height: size.width,
                    initialPage: 0,
                    enableInfiniteScroll: false,
                    viewportFraction: 1,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    }),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imgList.asMap().entries.map((entry) {
                return Container(
                  width: 10.0,
                  height: 10.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white
                          .withOpacity(_currentIndex == entry.key ? 0.9 : 0.4)),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sellerSimpleInfo() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundImage: Image.asset("assets/images/user.png").image,
          ),
          SizedBox(width: 10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "개발하는곰",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text("포항시 양덕동"),
            ],
          ),
          Expanded(
            child: MannerTemperature(mannerTemperature: 37.5),
          ),
        ],
      ),
    );
  }

  Widget _contentDetail() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20.0),
          Text(
            "${widget.data["title"]}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Text(
            "디지털/가전 ・ 22시간 전",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 15.0),
          Text(
            "선물 받은 새상품 입니다.\n상품 꺼내보기만 했습니다.\n거래는 직거래만 합니다.",
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
            ),
          ),
          SizedBox(height: 15.0),
          Text(
            "채팅 3 ・ 관심 17 ・ 조회 235",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 15.0),
        ],
      ),
    );
  }

  Widget _otherSellContents() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "판매자의 다른 판매 상품",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "모두보기",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
