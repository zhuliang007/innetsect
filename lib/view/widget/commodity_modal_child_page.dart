import 'package:flutter/material.dart';
import 'package:innetsect/api/loading.dart';
import 'package:innetsect/base/app_config.dart';
import 'package:innetsect/data/order_detail_model.dart';
import 'package:innetsect/enum/commodity_cart_types.dart';
import 'package:innetsect/tools/user_tool.dart';
import 'package:innetsect/utils/screen_adapter.dart';
import 'package:innetsect/view/login/login_page.dart';
import 'package:innetsect/view/mall/order/order_detail_page.dart';
import 'package:innetsect/view/widget/commodity_select_widget.dart';
import 'package:innetsect/view/widget/counter_widget.dart';
import 'package:innetsect/view/widget/customs_widget.dart';
import 'package:innetsect/view_model/mall/commodity/commodity_detail_provide.dart';
import 'package:innetsect/view_model/mall/commodity/order_detail_provide.dart';
import 'package:innetsect/view_model/my_order/after_service_provide.dart';
import 'package:innetsect/view_model/widget/commodity_and_cart_provide.dart';
import 'package:innetsect/base/base.dart';
import 'package:provide/provide.dart';

class CommodityModalChildPage extends PageProvideNode{
  final CommodityAndCartProvide _cartProvide = CommodityAndCartProvide.instance;
  final CommodityDetailProvide _detailProvide = CommodityDetailProvide.instance;
  final OrderDetailProvide _orderDetailProvide = OrderDetailProvide.instance;
  final AfterServiceProvide _afterServiceProvide = AfterServiceProvide.instance;

  CommodityModalChildPage(){
    mProviders.provide(Provider<CommodityAndCartProvide>.value(_cartProvide));
    mProviders.provide(Provider<CommodityDetailProvide>.value(_detailProvide));
    mProviders.provide(Provider<OrderDetailProvide>.value(_orderDetailProvide));
    mProviders.provide(Provider<AfterServiceProvide>.value(_afterServiceProvide));
  }
  @override
  Widget buildContent(BuildContext context) {
    // TODO: implement buildContent
    return CommodityModalChildContent(_cartProvide,_detailProvide,_orderDetailProvide,_afterServiceProvide);
  }
}

class CommodityModalChildContent extends StatefulWidget {
  final CommodityAndCartProvide _cartProvide ;
  final CommodityDetailProvide _detailProvide ;
  final OrderDetailProvide _orderDetailProvide ;
  final AfterServiceProvide _afterServiceProvide;
  CommodityModalChildContent(this._cartProvide,this._detailProvide,this._orderDetailProvide,this._afterServiceProvide);
  @override
  _CommodityModalChildContentState createState() => new _CommodityModalChildContentState();
}

class _CommodityModalChildContentState extends State<CommodityModalChildContent> {
  CommodityAndCartProvide _cartProvide;
  CommodityDetailProvide _detailProvide;
  OrderDetailProvide _orderDetailProvide;
  AfterServiceProvide _afterServiceProvide;

  @override
  Widget build(BuildContext context) {
    return Provide<CommodityDetailProvide>(
      builder: (BuildContext context,Widget widget,CommodityDetailProvide provide){
        Widget widget =Container(height: 0,width: 0,);
        if(provide.afterBtn){
          widget = Container(
            width: double.infinity,
            margin: EdgeInsets.only(left: 20,right: 20,top: 20),
            child: RaisedButton(
              onPressed: (){
                // 判断是否选择颜色
                if(this._detailProvide.skusModel==null
                    ||(this._detailProvide.skusModel.features[0].featureValue==null
                        &&this._detailProvide.skusModel.features[1].featureValue==null)){
                  CustomsWidget().showToast(title: "请选择颜色和尺码");
                }else if(this._detailProvide.skusModel.features[1].featureValue==null){
                  CustomsWidget().showToast(title: "请选择颜色");
                }else if(this._detailProvide.skusModel.features[0].featureValue==null){
                  CustomsWidget().showToast(title: "请选择尺码");
                }else{
                  // 售后选择规格
                  _afterServiceProvide.skusModel = provide.skusModel;
                  Navigator.pop(context);
                }
              },
              color: Colors.black,
              textColor: Colors.white,
              child: new Text("确认"),
            ),
          );
        }else if(provide.pages=="highCommodity"){
          widget = new Container(
            width: double.infinity,
            margin: EdgeInsets.only(left: 20,right: 20,top: 5),
            child: _buyWidget(),
          );
        }else{
          widget = bottomBtn();
        }
        List<Widget> bottomAction = [
          // 加入购物车、立即购买
          widget
        ];
        if(provide.commodityModels.badges!=null&&provide.commodityModels.badges.length>0) {
          provide.commodityModels.badges.forEach((items) {
            if (items.name == "售罄") {
              bottomAction=[
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(left: 20,right: 20,top: 20),
                  child: RaisedButton(
                      disabledColor: Colors.black12,
                      disabledTextColor: Colors.black54,
                      child: Text("已售罄",style: TextStyle(fontWeight: FontWeight.w600),),
                    )
                )
              ] ;
            }
          });
        }
        return new Column(
          children: <Widget>[
            // 返回按钮
            goBackIcon(),
            // 中间部分
            contentWidget(),
            // 计数器
            provide.afterBtn?Container(): counterWidget(provide),
          ]..addAll(bottomAction),
        );
      },
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._cartProvide ??= widget._cartProvide;
    this._detailProvide ??= widget._detailProvide;
    this._orderDetailProvide ??= widget._orderDetailProvide;
    this._afterServiceProvide ??= widget._afterServiceProvide;
    this._cartProvide.setMode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
//    _tabController.dispose();
    _detailProvide.pages = null;
  }

  /// 返回按钮
  Widget goBackIcon(){
    return new Container(
      height: ScreenAdapter.height(60),
      color: Colors.white,
      width: double.infinity,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          new InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: new Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              child: new Icon(Icons.close),
            )
          )
        ],
      ),
    );
  }
  
  /// 中间选择区域
  Widget contentWidget(){
    return new Container(
      width: double.infinity,
      height: ScreenAdapter.getScreenHeight()/1.5,
      color: Colors.white,
      child: new CommoditySelectWidget(),
    );
  }

  /// 计数器
  Widget counterWidget(CommodityDetailProvide provide){
    return new Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: CounterWidget(provide: this._cartProvide,model: provide.commodityModels,detailProvide: _detailProvide,),
    );
  }

  /// 底部按钮
  Widget bottomBtn(){
    return new Container(
      width: double.infinity,
      color: Colors.white,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _detailProvide.isBuy?new Container():new Container(
            width: ScreenAdapter.getScreenWidth()/2-10,
            padding: EdgeInsets.only(left: 10,right: 10),
            margin: EdgeInsets.only(top: 20),
            child: new RaisedButton(
              color: AppConfig.fontBackColor,
              textColor: Colors.white,
              onPressed: (){
                //加入购物车
                if(!isLogin()){
                  // 判断是否选择颜色
                  if(this._detailProvide.skusModel==null
                      ||(this._detailProvide.skusModel.features[0].featureValue==null
                          &&this._detailProvide.skusModel.features[1].featureValue==null)){
                    CustomsWidget().showToast(title: "请选择颜色和尺码");
                  }else if(this._detailProvide.skusModel.features[1].featureValue==null){
                    CustomsWidget().showToast(title: "请选择颜色");
                  }else if(this._detailProvide.skusModel.features[0].featureValue==null){
                    CustomsWidget().showToast(title: "请选择尺码");
                  }else{
                    // 请求
                    if(this._detailProvide.skusModel.qtyInHand>0){
                      if(!Loading.isShow){
                        this._detailProvide.commodityModels.skuPic = this._detailProvide.skusModel.skuPic;
                        this._cartProvide.addCartsRequest(this._detailProvide.commodityModels,
                            context)
                            .doOnListen(() {
                          print('doOnListen');
                        })
                            .doOnCancel(() {})
                            .listen((item) {
                          ///加载数据
                          print('listen data->$item');
                          if(item.data!=null){
                            this._detailProvide.commodityModels.types = CommodityCartTypes.commodity.toString();
                            this._detailProvide.commodityModels.isChecked = false;
                            this._detailProvide.commodityModels.quantity = this._cartProvide.count;
                            CustomsWidget().showToast(title: "添加成功");
                            Navigator.pop(context);
                          }
                        }, onError: (e) {});
                      }else{
                        CustomsWidget().showToast(title: "购物车读取中...");
                      }

                    }else{
                      CustomsWidget().showToast(title: "库存不足");
                    }
                  }
                }else{
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context){
                      return LoginPage();
                    }
                  ));
                }

              },
              child: new Text("加入购物车",style: TextStyle(
                  fontSize: ScreenAdapter.size(30)
                ),
              ),
            ),
          ),
          new Container(
            width: _detailProvide.isBuy?ScreenAdapter.getScreenWidth():ScreenAdapter.getScreenWidth()/2-10,
            padding: _detailProvide.isBuy?EdgeInsets.only(right: 10,left: 10):EdgeInsets.only(right: 5),
            margin: EdgeInsets.only(top: 20),
            child: _buyWidget(),
          )
        ],
      ),
    );
  }

  Widget _buyWidget(){
    return new RaisedButton(
      color: AppConfig.blueBtnColor,
      textColor: AppConfig.whiteBtnColor,
      onPressed: (){
        // 检测本地是否存在token
        if(!isLogin()){
          // 判断规则选项
          if(this._detailProvide.skusModel==null
              ||(this._detailProvide.skusModel.features[0].featureValue==null
                  &&this._detailProvide.skusModel.features[1].featureValue==null)){
            CustomsWidget().showToast(title: "请选择颜色和尺码");
          }else if(this._detailProvide.skusModel.features[1].featureValue==null){
            CustomsWidget().showToast(title: "请选择颜色");
          }else if(this._detailProvide.skusModel.features[0].featureValue==null){
            CustomsWidget().showToast(title: "请选择尺码");
          }else if(_detailProvide.skusModel.qtyInHand ==0){
            CustomsWidget().showToast(title: "没有库存");
          }else{
            // Y跳转订单详情
            List json = [{
              "acctID": UserTools().getUserData()['id'],
              "shopID":_detailProvide.commodityModels.shopID,
              "prodID":_detailProvide.commodityModels.prodID,
              "presale":_detailProvide.commodityModels.presale,
              "skuCode":_detailProvide.skusModel.skuCode,
              "skuName":_detailProvide.skusModel.skuName,
              "skuPic":_detailProvide.skusModel.skuPic,
              "quantity":_cartProvide.count,
              "unit": _detailProvide.commodityModels.unit,
              "prodCode": _detailProvide.commodityModels.prodCode,
              "salesPrice":_detailProvide.commodityModels.salesPrice,
              "allowPointRate":_detailProvide.commodityModels.allowPointRate
            }];
            Loading.ctx = context;
            Loading.show();
            _detailProvide.createShopping(json,context)
                .doOnListen(() {
              print('doOnListen');
            })
                .doOnCancel(() {})
                .listen((item) {
              ///加载数据,订单详情
              print('listen data->$item');
              if(item.data!=null){
                print('==============================>>>>>${item.data}');
                OrderDetailModel model = OrderDetailModel.fromJson(item.data);
                _orderDetailProvide.orderDetailModel = model;

                Loading.remove();
                Navigator.push(context, new MaterialPageRoute(
                    builder: (context){
                      return new OrderDetailPage();
                    })
                );
                print('==============>挑战订单详情');
              }
              //      _provide
            }, onError: (e) {
              print(e);
            });
          }
        }
      },
      child: new Text("立即购买",style: TextStyle(
          fontSize: ScreenAdapter.size(30)
      ),
      ),
    );
  }

  bool isLogin(){
    bool flag = false;
    if(UserTools().getUserData()==null){
      flag = true;
      Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context){
            return LoginPage();
          }
      ));
    }
    return flag;
  }
}