import 'dart:async';

import 'package:flutter/material.dart';
import 'package:innetsect/base/base.dart';
import 'package:innetsect/utils/screen_adapter.dart';
import 'package:innetsect/view_model/registered/registered_provide.dart';
import 'package:provide/provide.dart';

class RegisteredPage extends PageProvideNode {
  final RegisteredProvide _provide = RegisteredProvide();
  RegisteredPage() {
    mProviders.provide(Provider<RegisteredProvide>.value(_provide));
  }

  @override
  Widget buildContent(BuildContext context) {
    return RegidterContentPage(_provide);
  }
}

class RegidterContentPage extends StatefulWidget {
  final RegisteredProvide provide;
  RegidterContentPage(this.provide);
  @override
  _RegidterContentPageState createState() => _RegidterContentPageState();
}

class _RegidterContentPageState extends State<RegidterContentPage> {
  ///文本编辑控制器
  TextEditingController mController = TextEditingController();

  ///倒计时定时器
  Timer timer;

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        title: Text('注册'),
        centerTitle: true,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(
              'assets/images/xiangxia.png',
              fit: BoxFit.none,
              width: ScreenAdapter.width(38),
              height: ScreenAdapter.width(38),
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: ScreenAdapter.height(180),
            ),
            //注册
            _setupTextFields(),
            SizedBox(
              height: ScreenAdapter.height(545),
            ),
            //勾选条款
            _setupAgreeTerms(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: ScreenAdapter.width(750),
        height: ScreenAdapter.height(166),
        child: Center(
          child: GestureDetector(
            onTap: (){
              print('注册按钮被点击');
            },
            child: Container(
              width: ScreenAdapter.width(705),
              height: ScreenAdapter.height(95),
              color: Colors.black,
              child: Center(
                child: Text(
                  '注册',
                  style: TextStyle(
                      color: Colors.white, fontSize: ScreenAdapter.size(38)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _setupTextFields() {
    return new Column(
      children: _setupContent(),
    );
  }

  List<Provide<RegisteredProvide>> _setupContent() {
    return new List<Provide<RegisteredProvide>>.generate(
        2, (int index) => _setupItem(index));
  }

  Provide<RegisteredProvide> _setupItem(int index) {
    if (index == 0) {
      return Provide<RegisteredProvide>(
        builder:
            (BuildContext context, Widget child, RegisteredProvide provide) {
          return Container(
            margin: EdgeInsets.fromLTRB(
                ScreenAdapter.width(70), 0, ScreenAdapter.width(70), 0),
            child: new Column(
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new TextField(
                        enabled: true,
                        style: new TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: provide.placeHoderText[index],
                          hintStyle: new TextStyle(color: Colors.grey),
                          focusedBorder: InputBorder.none,
                        ),
                        onChanged: (str) {
                          provide.userCode = str;
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        },
      );
    }
    return Provide<RegisteredProvide>(
      builder: (BuildContext context, Widget child, RegisteredProvide provide) {
        return Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  // border: Border(bottom: BorderSide(color: Colors.grey))
                  ),
              margin: EdgeInsets.fromLTRB(
                  ScreenAdapter.width(70), 0, ScreenAdapter.width(70), 0),
              child: new Column(
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new TextField(
                          enabled: true,
                          style: new TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: provide.placeHoderText[index],
                            hintStyle: new TextStyle(color: Colors.grey),
                            focusedBorder: InputBorder.none,
                          ),
                          onChanged: (str) {
                            provide.userCode = str;
                          },
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: ScreenAdapter.height(18),
                  left: ScreenAdapter.width(485)),
              child: Container(
                width: ScreenAdapter.width(170),
                height: ScreenAdapter.height(60),
                child: FlatButton(
                  disabledColor: Colors.grey.withOpacity(0.1),
                  disabledTextColor: Colors.white,
                  textColor:
                      provide.isButtonEnable ? Colors.white : Colors.white,
                  color: provide.isButtonEnable
                      ? Colors.black
                      : Colors.grey.withOpacity(0.8),
                  onPressed: () {
                    _buttonClickListen();
                  },
                  child: Text(
                    provide.buttonText,
                    style: TextStyle(fontSize: ScreenAdapter.size(22)),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _buttonClickListen() {
    if (widget.provide.isButtonEnable) {
      print('获取验证码');
      widget.provide.isButtonEnable = false;
      _initTimer();
      return null;
    } else {
      return null;
    }
  }

  void _initTimer() {
    timer = new Timer.periodic(Duration(seconds: 1), (Timer timer) {
      widget.provide.count--;

      if (widget.provide.count == 0) {
        timer.cancel();
        widget.provide.isButtonEnable = true;
        widget.provide.count = 60;
        widget.provide.buttonText = '获取验证码';
      } else {
        widget.provide.buttonText = '重发(${widget.provide.count})';
      }
    });
  }

  Provide<RegisteredProvide> _setupAgreeTerms() {
    return Provide<RegisteredProvide>(
      builder: (BuildContext context, Widget child, RegisteredProvide provide) {
        return Container(
          width: ScreenAdapter.width(705),
          height: ScreenAdapter.height(95),
        //  color: Colors.yellow,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: ScreenAdapter.width(20),
              ),
              Checkbox(
                checkColor: Colors.white,
                value: provide.checkSelected,
                activeColor: Colors.black,
                onChanged: (value) {
                  provide.checkSelected = value;
                },
              ),
              
              Center(child: Text('注册即代表同意INNERSECT服务条款',style: TextStyle(fontSize: ScreenAdapter.size(28)),))
            ],
          ),
        );
      },
    );
  }
}
