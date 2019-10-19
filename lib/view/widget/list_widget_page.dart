import 'package:flutter/material.dart';
import 'package:innetsect/base/base.dart';
import 'package:provide/provide.dart';
import 'package:innetsect/view_model/mall/commodity/list_provide.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:innetsect/view/widget/list_header.dart';

typedef OnRefresh = Future<void> Function();
typedef OnLoad = Future<void> Function();

//class ListPage extends PageProvideNode{
//  LoadData loadData;
//  final ListProvide _provide = ListProvide();
//  ListPage(){
//    mProviders.provide(Provider<ListProvide>.value(_provide));
//    loadData = null;
//  }
//
//  @override
//  Widget buildContent(BuildContext context) {
//
//    return ListContent(_provide,loadData);
//  }
//}

class ListWidgetPage extends StatefulWidget {
  // 上拉刷新
  final OnRefresh onRefresh;
  // 加载更多
  final OnLoad onLoad;
  // 列表视图
  final List<Widget> child;
  // 控制器
  final EasyRefreshController controller;
  ListWidgetPage({
    this.onRefresh,
    this.onLoad,
    this.child,
    this.controller
  });

  @override
  _ListWidgetPageState createState() => new _ListWidgetPageState();
}

class _ListWidgetPageState extends State<ListWidgetPage> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new EasyRefresh.custom(
        header: ListHeader(),
        footer: ClassicalFooter(
            showInfo: false,
            noMoreText: "已经全部加载完毕",
            loadingText:"正在加载更多数据",
            textColor: Colors.grey
        ),
        controller: widget.controller,
        onRefresh:()=>widget.onRefresh(),
        onLoad: ()=>widget.onLoad(),
        slivers: widget.child
      )
    );
  }
}