import 'package:innetsect/api/net_utils.dart';
import 'package:innetsect/data/base.dart';
import 'package:rxdart/rxdart.dart';

///展会首页请求
class ExhibitionHomeService {
  ///首页banner
  Observable<BaseResponse> bannerData() {
    var url = '/api/society/portals/event';
    var response = get(url);
    return response;
  }

///首页列表请求
  Observable<BaseResponse> listData(int pageNo){
    var url = '/api/society/portals/event/portlets?$pageNo';
    var response = get(url);
    return response;
  }

///展会
  Observable<BaseResponse> exhibitions(int exhibitionsiD){
    var url = '/api/event/exhibitions/$exhibitionsiD';
    var response = get(url);
    return response;
  }
}

///展会首页数据响应
class ExhibitionHomeRepo {
  final ExhibitionHomeService _remote = ExhibitionHomeService();

  ///banner 请求
  Observable bannerData() {
    return _remote.bannerData();
  }

  ///list请求
  Observable listData(int pageNo){
    return _remote.listData(pageNo);
  }
  ///展会
  Observable exhibitions(int exhibitionsiD){
    return _remote.exhibitions(exhibitionsiD);
  }
}
