import 'package:flutter/material.dart';
import 'package:innetsect/base/base.dart';
import 'package:innetsect/utils/screen_adapter.dart';
import 'package:innetsect/view/draw/registration_successful_provide.dart';
import 'package:provide/provide.dart';

///登记成功
class RegistrationSuccessfulPage extends PageProvideNode {
  final RegistrationSuccessfulProvide _provide =
      RegistrationSuccessfulProvide();
  RegistrationSuccessfulPage() {
    mProviders.provide(Provider<RegistrationSuccessfulProvide>.value(_provide));
  }
  @override
  Widget buildContent(BuildContext context) {
    return RegistrationSuccessfulContentPage(_provide);
  }
}

class RegistrationSuccessfulContentPage extends StatefulWidget {
  final RegistrationSuccessfulProvide provide;
  RegistrationSuccessfulContentPage(this.provide);
  @override
  _RegistrationSuccessfulContentPageState createState() =>
      _RegistrationSuccessfulContentPageState();
}

class _RegistrationSuccessfulContentPageState
    extends State<RegistrationSuccessfulContentPage> {
  RegistrationSuccessfulProvide provide;
  @override
  void initState() {
    super.initState();
    provide ??= widget.provide;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('登记信息'),
        centerTitle: true,
        elevation: 0.0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.chevron_left,
            size: ScreenAdapter.size(60),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
     
          _setupBody(),
       
        ],
      ),
    );
  }


  Provide<RegistrationSuccessfulProvide> _setupBody() {
    return Provide<RegistrationSuccessfulProvide>(
      builder: (BuildContext context, Widget child,
          RegistrationSuccessfulProvide provide) {
        return Column(
          children: <Widget>[
            SizedBox(
              height: ScreenAdapter.height(180),
            ),
            Center(
              child: Image.asset(
                'assets/images/registration_successful.jpg',
                width: ScreenAdapter.width(135),
                height: ScreenAdapter.width(135),
              ),
            ),
            SizedBox(
              height: ScreenAdapter.height(50),
            ),
            Center(
              child: Text(
                '恭喜你, 你已完成信息登记!',
                style: TextStyle(
                    fontSize: ScreenAdapter.size(35), color: Colors.black54),
              ),
            ),
            SizedBox(
              height: ScreenAdapter.height(135),
            ),
            Container(
              width: ScreenAdapter.width(690),
              height: ScreenAdapter.height(1),
              color: Colors.black12,
            ),
            SizedBox(
              height: ScreenAdapter.height(110),
            ),
            InkWell(
              onTap: (){
                Navigator.pushNamed(context, '/checkTheRegistrationPage');
              },
              child: Container(
                width: ScreenAdapter.width(690),
                height: ScreenAdapter.height(90),
                color: Colors.black,
                child: Center(
                  child: Text('查看登记',style: TextStyle(color:Colors.white,fontSize: ScreenAdapter.size(30),fontWeight: FontWeight.w800),),
                ),
              ),
            ),
            SizedBox(
              height: ScreenAdapter.height(55),
            ),
            InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                width: ScreenAdapter.width(690),
                height: ScreenAdapter.height(90),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black87
                  )
                ),
                child: Center(
                  child: Text('返回',style: TextStyle(color:Colors.black,fontSize: ScreenAdapter.size(30),fontWeight: FontWeight.w800),),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

 
}
