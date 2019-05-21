import 'package:flutter/material.dart';
import 'pages/index_page.dart';
import 'package:provide/provide.dart';
import './provide/counter.dart';
import './provide/child_category.dart';
import './provide/category_goods_list.dart';
// import 'dart:io' show Platform;

// import 'package:flutter/foundation.dart'
//     show debugDefaultTargetPlatformOverride;

// 应用程序主入口
void main() {
  //debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  var counter = Counter();
  var providers = Providers();
  var childCategory = ChildCategory();
  var categoryGoodsProvide = CategoodsListProvide();
  providers
    ..provide(Provider<Counter>.value(counter))
    ..provide(Provider<CategoodsListProvide>.value(categoryGoodsProvide))
    ..provide(Provider<ChildCategory>.value(childCategory));
  runApp(ProviderNode(child: MyApp(), providers: providers));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 套布局容器 扩展容易
    return Container(
      child: MaterialApp(
        title: '查券特卖',
        // debug标签是否显示
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            // 主题颜色
            primarySwatch: Colors.pink),
        home: IndexPage(),
      ),
    );
  }
}
