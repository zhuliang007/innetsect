import 'package:flutter/material.dart';
import 'package:innetsect/base/app_config.dart';
import 'package:innetsect/data/commodity_feature_model.dart';
import 'package:innetsect/data/commodity_models.dart';
import 'package:innetsect/data/commodity_skus_model.dart';
import 'package:innetsect/utils/screen_adapter.dart';
import 'package:innetsect/view_model/mall/commodity/commodity_detail_provide.dart';
import 'package:innetsect/view_model/widget/commodity_and_cart_provide.dart';

/// 单选
class CommoditySelectWidget extends StatefulWidget {
  final CommodityAndCartProvide _cartProvide;
  final CommodityDetailProvide _detailProvide;
  CommoditySelectWidget(this._cartProvide,this._detailProvide);

  @override
  _CommoditySelectWidgetState createState() => new _CommoditySelectWidgetState();
}

class _CommoditySelectWidgetState extends State<CommoditySelectWidget> {
  CommodityAndCartProvide _cartProvide;
  CommodityDetailProvide _detailProvide;

  @override
  Widget build(BuildContext context) {
    return new SingleChildScrollView(
      child: new Column(
        children: <Widget>[
          _topContentWidget(_detailProvide),
          _bottomContentWidget(_detailProvide)
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      this._cartProvide = widget._cartProvide;
      this._detailProvide = widget._detailProvide;
    });
    this._detailProvide.setInitData();
  }

  /// 上半部分
  Widget _topContentWidget(CommodityDetailProvide provide){
    CommodityModels model = provide.commodityModels;
    CommoditySkusModel skusModel = provide.skusModel;
    List<CommodityFeatureModel> features = model.features;
    List<CommoditySkusModel> skuModelGroup = provide.skusList;
    return new Container(
      width: double.infinity,
      child: new Column(
        children: skuModelGroup.map((item){
          return new InkWell(
            onTap: (){
              provide.setSelectColor(item);
              setState(() {});
            },
            child: new Container(
              width: double.infinity,
              margin: EdgeInsets.only(left: 10,right: 10),
              height: ScreenAdapter.height(160),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: new Border(bottom: new BorderSide(
                      width: 1,
                      color: AppConfig.assistLineColor
                  )
                  )
              ),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  new Container(
                    width: ScreenAdapter.width(120),
                    height: ScreenAdapter.height(120),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color:Colors.white,
                        border: new Border.all(width: 2,
                          color:skusModel.skuCode==item.skuCode?AppConfig.fontBackColor:Colors.white
                        )
                    ),
                    child: Image.network(item.skuPic,fit: BoxFit.fill,),
                  ),
                  new Container(
                    width: ScreenAdapter.getScreenWidth()-100,
                    color: Colors.white,
                    child: new Text(item.skuName,softWrap: true,
                      style: TextStyle(
                          fontSize: ScreenAdapter.size(32)
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// 下半部分，尺寸的选择
  Widget _bottomContentWidget(CommodityDetailProvide provide){
    CommodityModels model = provide.commodityModels;
    CommoditySkusModel skusModel = provide.skusModel;
    List<CommodityFeatureModel> features = model.features;
    return new Scrollbar(child: new SingleChildScrollView(
      scrollDirection:Axis.horizontal,
      child: new Center(
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: features.map((CommodityFeatureModel item){
            // 选中尺码
            return new InkWell(
              onTap: (){
                provide.setSelectSku(item);
                setState(() {});
              },
              child: item.featureGroup=="尺码" ?new Container(
                width: ScreenAdapter.width(100),
                height: ScreenAdapter.height(100),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 2,
                      color: skusModel.features.any((items)=>items.featureCode==item.featureCode)?AppConfig.fontBackColor:Colors.white
                    )
                ),
                alignment: Alignment.center,
                child: new Text(item.featureValue,style: TextStyle(
                    fontSize: ScreenAdapter.size(32),
                    fontWeight: FontWeight.w900
                ),),
              ):new Text(""),
            );
          }).toList(),
        ),
      ),
    ));
  }
}