import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  String homePageContent = '正在获取数据';

  ScrollController controller = ScrollController();

  @override
  void initState() {
    getHomePageContent().then((val) {
      setState(() {
        homePageContent = val.toString();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('查券商城')),
        body: FutureBuilder(
            //异步方法
            future: getHomePageContent(),
            // 构造器 都需要接受上下文参数 和 snapshot
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = json.decode(snapshot.data.toString());
                List<Map> swiper = (data['data']['slides'] as List).cast();
                List<Map> navitor = (data['data']['category'] as List).cast();
                String adPicture = data['data']['advertesPicture']['PICTURE_ADDRESS'];
                String leaderImage = data['data']['shopInfo']['leaderImage'];
                String leaderPhone = data['data']['shopInfo']['leaderPhone'];
                List<Map> recommendList = (data['data']['recommend'] as List).cast();
                String floor1Title = data['data']['floor1Pic']['PICTURE_ADDRESS']; //楼层1的标题图片
                String floor2Title = data['data']['floor2Pic']['PICTURE_ADDRESS']; //楼层1的标题图片
                String floor3Title = data['data']['floor3Pic']['PICTURE_ADDRESS']; //楼层1的标题图片
                List<Map> floor1 = (data['data']['floor1'] as List).cast(); //楼层1商品和图片
                List<Map> floor2 = (data['data']['floor2'] as List).cast(); //楼层1商品和图片
                List<Map> floor3 = (data['data']['floor3'] as List).cast(); //楼层1商品和图片
                print(recommendList);
                if (navitor.length > 10) {
                  navitor.removeRange(10, navitor.length);
                }
                return SingleChildScrollView(
                    controller: controller,
                    child: Column(
                      children: <Widget>[
                        SwiperDiy(swiperDataList: swiper),
                        TopNavigator(
                          navigatorList: navitor,
                        ),
                        AdBanner(
                          adPicture: adPicture,
                        ),
                        Leader(
                          leaderImage: leaderImage,
                          leaderPhone: leaderPhone,
                        ),
                        Recommend(
                          recommendList: recommendList,
                        ),
                        FloorTitle(picture_address: floor1Title),
                        FloorContent(floorGoodsList: floor1),
                        FloorTitle(picture_address: floor2Title),
                        FloorContent(floorGoodsList: floor2),
                        FloorTitle(picture_address: floor3Title),
                        FloorContent(floorGoodsList: floor3),
                      ],
                    ));
              } else {
                return Center(
                  child: Text(
                    '加载中',
                    style: TextStyle(fontSize: ScreenUtil().setSp(28)),
                  ),
                );
              }
            }));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

// 首页轮播组件
class SwiperDiy extends StatelessWidget {
  // 声明数组
  final List swiperDataList;

  //构造函数
  SwiperDiy({Key key, this.swiperDataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //设置布局自适应
    return Container(
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        //构造
        itemBuilder: (BuildContext context, int index) {
          return Image.network(
            "${swiperDataList[index]['image']}",
            fit: BoxFit.fill,
          );
        },
        //数量
        itemCount: swiperDataList.length,
        // 是否有导航系
        pagination: new SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

// 顶部分类
class TopNavigator extends StatelessWidget {
  final List navigatorList;

  TopNavigator({Key key, this.navigatorList}) : super(key: key);

  Widget _gridViewItemUi(BuildContext, item) {
    return InkWell(
      onTap: () {
        print('点击了导航');
      },
      child: Column(
        children: <Widget>[
          Image.network(
            item['image'],
            width: ScreenUtil().setWidth(95),
          ),
          Text(item['mallCategoryName'])
        ],
      ),
    );
  }

// 顶部分类
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(320),
      padding: EdgeInsets.all(3),
      // grid view 布局
      child: GridView.count(
        // 一行几个
        crossAxisCount: 5,
        //外边距
        padding: EdgeInsets.all(4),
        children: navigatorList.map((item) {
          return _gridViewItemUi(context, item);
        }).toList(),
        //禁止GridView滑动
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }
}

// 广告条
class AdBanner extends StatelessWidget {
  final String adPicture;
  AdBanner({Key key, this.adPicture}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(adPicture),
    );
  }
}

// 店长电话模块
class Leader extends StatelessWidget {
  //店长图片
  final String leaderImage;
  //店长电话
  final String leaderPhone;
  Leader({Key key, this.leaderImage, this.leaderPhone}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _launchURL,
        child: Image.network(leaderImage),
      ),
    );
  }

  void _launchURL() async {
    String url = 'tel:' + leaderPhone;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

// 商品推荐
class Recommend extends StatelessWidget {
  final List recommendList;
  Recommend({Key key, this.recommendList}) : super(key: key);
  // 标题组件
  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10, 2, 0, 5),
      decoration: BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(width: 0.5, color: Colors.black12))),
      child: Text('商品推荐', style: TextStyle(color: Colors.pink)),
    );
  }

  //商品推荐列表
  Widget _item(index) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: ScreenUtil().setHeight(330),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(color: Colors.white, border: Border(left: BorderSide(width: 0.5, color: Colors.black12))),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text('${recommendList[index]['mallPrice']}'),
            Text(
              '${recommendList[index]['price']}',
              style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // 组合成横向列表
  Widget _recommendList() {
    return Container(
      height: ScreenUtil().setHeight(280),
      margin: EdgeInsets.only(top: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendList.length,
        itemBuilder: (context, index) {
          return _item(index);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(347),
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[_titleWidget(), _recommendList()],
      ),
    );
  }
}

// 楼层标题
class FloorTitle extends StatelessWidget {
  final String picture_address;

  const FloorTitle({Key key, this.picture_address}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Image.network(picture_address),
    );
  }
}

// 楼层商品列表
class FloorContent extends StatelessWidget {
  final List floorGoodsList;

  const FloorContent({Key key, this.floorGoodsList}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[_firstRow(), _otherGoods()],
      ),
    );
  }

  Widget _firstRow() {
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[0]),
        Column(
          children: <Widget>[_goodsItem(floorGoodsList[1]), _goodsItem(floorGoodsList[2])],
        )
      ],
    );
  }

  Widget _otherGoods() {
    return Row(
      children: <Widget>[_goodsItem(floorGoodsList[3]), _goodsItem(floorGoodsList[4])],
    );
  }

  Widget _goodsItem(Map goods) {
    return Container(
        width: ScreenUtil().setWidth(375),
        // inkwell 事件响应用
        child: InkWell(
          onTap: () {
            print('点击了楼层商品按钮');
          },
          child: Image.network(goods['image']),
        ));
  }
}
