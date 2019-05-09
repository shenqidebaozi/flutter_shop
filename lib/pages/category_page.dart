import 'package:flutter/material.dart';
import '../service/service_method.dart';
import '../model/category.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../provide/child_category.dart';
import 'package:provide/provide.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('商品分类')),
      body: Container(
        child: Row(
          children: <Widget>[
            LeftCategoryNav(),
            Column(
              children: <Widget>[RightCategory()],
            )
          ],
        ),
      ),
    );
  }
}

// 左侧大分类导航
class LeftCategoryNav extends StatefulWidget {
  @override
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {
  @override
  void initState() {
    super.initState();
    _getCategory();
  }

  List list = [];
  var listIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      decoration: BoxDecoration(border: Border(right: BorderSide(width: 1, color: Colors.black12))),
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return _leftInkWell(index);
        },
      ),
    );
  }

  Widget _leftInkWell(int index) {
    bool isClick = false;
    isClick=(index ==listIndex)?true:false;
    return InkWell(
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(left: 10, top: 20),
        decoration: BoxDecoration( color: isClick?Color.fromRGBO(236, 238, 239, 1.0):Colors.white, border: Border(bottom: BorderSide(width: 1, color: Colors.black12))),
        child: Text(
          list[index].mallCategoryName,
          style: TextStyle(fontSize: ScreenUtil().setSp(28)),
        ),
      ),
      onTap: () {
        setState(() {
          listIndex = index;
        });
        var childList = list[index].bxMallSubDto;
        Provide.value<ChildCategory>(context).getChildCategory(childList);
      },
    );
  }

  void _getCategory() async {
    await request('getCategory').then((val) {
      var data = json.decode(val.toString());
      CategoryModel category = CategoryModel.fromJson(data);
      setState(() {
        list = category.data;
      });
      Provide.value<ChildCategory>(context).getChildCategory( list[0].bxMallSubDto);
    });
  }
}

class RightCategory extends StatefulWidget {
  @override
  _RightCategoryState createState() => _RightCategoryState();
}

class _RightCategoryState extends State<RightCategory> {
  @override
  Widget build(BuildContext context) {
    return Provide<ChildCategory>(
      builder: (context, child, childCategory) {
        return Container(
          decoration: BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(width: 1, color: Colors.black12))),
          height: ScreenUtil().setHeight(80),
          width: ScreenUtil().setWidth(570),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: childCategory.childCategoryList.length,
            itemBuilder: (context, index) {
              return Center(child: _rightInkWell(childCategory.childCategoryList[index]));
            },
          ),
        );
      },
    );
  }

  Widget _rightInkWell(BxMallSubDto item) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
        child: Text(item.mallSubName, style: TextStyle(fontSize: ScreenUtil().setSp(28))),
      ),
      onTap: () {},
    );
  }
}
