import 'package:flutter/material.dart';
import 'package:innetsect/base/app_config.dart';
import 'package:innetsect/base/base.dart';
import 'package:innetsect/data/provinces_model.dart';
import 'package:innetsect/utils/screen_adapter.dart';
import 'package:innetsect/view/my/address_management/city/provinces_page.dart';
import 'package:innetsect/view/widget/customs_widget.dart';
import 'package:innetsect/view_model/my/address_management/new_address/new_address_provide.dart';
import 'package:provide/provide.dart';

class CountryPage extends PageProvideNode{

  final NewAddressProvide _provide = NewAddressProvide.instance;

  CountryPage(){
    mProviders.provide(Provider<NewAddressProvide>.value(_provide));
  }

  @override
  Widget buildContent(BuildContext context) {
    // TODO: implement buildContent
    return CountryContentPage(_provide);
  }
}

class CountryContentPage extends StatefulWidget {
  final NewAddressProvide _provide;
  CountryContentPage(this._provide);

  @override
  _CountryContentPageState createState() => _CountryContentPageState();
}

class _CountryContentPageState extends State<CountryContentPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: CustomsWidget().customNav(context: context,
            widget: new Text("选择国家",style: TextStyle(fontSize: ScreenAdapter.size((30)),
                fontWeight: FontWeight.w900
            ),
            )
        ),
      body: Provide<NewAddressProvide>(
        builder: (BuildContext context,Widget widget,NewAddressProvide provide){
          return Container(
            color: Colors.white,
            child: ListView.builder(
                itemCount: provide.cityList.length,
                itemBuilder:(BuildContext context, int index){
                  return new InkWell(
                    onTap: (){
                      // 选中国家
                      provide.selectCity(provide.cityList[index]);
                      provide.getProvices(provide.cityList[index].countryCode)
                          .doOnListen(() {}).doOnCancel(() {})
                          .listen((items) {
                            if(items.data!=null&&items.data.length>0){
                              // 跳转到省份界面
                              provide.addProvincesList(ProvincesModelList.fromJson(items.data).list);
                              Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context){
                                  return ProvincesPage();
                                }
                              ));
                            }else{
                              Navigator.pop(context);
                            }
                            print('listen data->$items');
                          }, onError: (e) {});
                    },
                    child: new Container(
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 1,color:AppConfig.assistLineColor))
                      ),
                      padding: EdgeInsets.all(10),
                      child: new Text(provide.cityList[index].briefName),
                    ),
                  );
                }
            ),
          );
        },
      ),
    );
  }
}