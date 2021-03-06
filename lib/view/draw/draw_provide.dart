import 'package:innetsect/base/base.dart';
import 'package:innetsect/data/draw/draw_data.dart';
import 'package:innetsect/model/draw/drawshop_model.dart';
import 'package:rxdart/rxdart.dart';

///抽签数据供应
class DrawProvide extends BaseProvide {


  //DrawsModel
  DrawsModel _drawsModel = DrawsModel();
  DrawsModel get drawsModel=>_drawsModel;
  set drawsModel(DrawsModel drawsModel){
    _drawsModel = drawsModel;
  }

  int _redirectParamId; 
  int get redirectParamId=>_redirectParamId;
  set redirectParamId(int redirectParamId){
    _redirectParamId = redirectParamId;
  }
  ///   "longitude": 121.494523,//经度
  ///    "latitude": 31.318514,//纬度

  double _longitude  = 121.494523;
  double get longitude=>_longitude;
  set longitude(double longitude){
    _longitude = longitude;
  }

  double _latitude = 31.318514;
  double get latitude=>_latitude;
   set latitude(double latitude){
     _latitude = latitude;
  }



  //DrawshopRepo

  DrawshopRepo _repo = DrawshopRepo();
///抽签信息
  Observable draws(){
    return _repo.draws(drawID: redirectParamId).doOnData((item){

    }).doOnError((e,stack){

    }).doOnDone((){

    });
  }

  ///抽签登记
  Observable drawshop() {
    Map body = {
      "drawID": 1,
      "shopID": 37,
      "acctID": 1,
      "realName": "六",
      "telPrefix": "86",
      "mobile": 13718220555,
      "icNo": 331081198903103256,
      "registerDate": "2019-12-25 18:05:23",
      "platform": "ios",
      "longitude": 122,
      "latitude": 0
    };
    return _repo
        .drawshop(body, 1)
        .doOnData((item) {})
        .doOnError((e, stack) {})
        .doOnDone(() {});
  }
}
