import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'home_page.dart';
import 'member_page.dart';
import 'cart_page.dart';
import 'category_page.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  //图标列表
  final List<BottomNavigationBarItem> bottomTabs = [
    BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), title: Text("首页")),
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.search), title: Text("分类")),
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.shopping_cart), title: Text("购物车")),
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.profile_circled), title: Text("我的"))
  ];
  //索引
  int currentIndex = 0;
  var currentPage;

  @override
  void initState() {
    currentPage = tabBodies[currentIndex];
    super.initState();
  }

  //页面切换
  final List tabBodies = [HomePage(), CartPage(), CategoryPage(), MemberPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 默认底色
      backgroundColor: Color.fromRGBO(233, 245, 245, 1.0),
      bottomNavigationBar: BottomNavigationBar(
        // 导航栏类型
        type: BottomNavigationBarType.fixed,
        // 索引
        currentIndex: currentIndex,
        items: bottomTabs,
        onTap: (index) {
          // 按下后调用 →setState() 重绘界面
          setState(() {
            currentIndex = index;
            currentPage = tabBodies[currentIndex];
          });
        },
      ),
      body: currentPage,
    );
  }
}
