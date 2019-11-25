import 'package:flutter/material.dart';
import 'package:innetsect/base/app_config.dart';
import 'package:innetsect/base/base.dart';
import 'package:innetsect/data/exhibition/ticket_model.dart';
import 'package:innetsect/utils/screen_adapter.dart';
import 'package:innetsect/view/show_tickets/ticket_page.dart';
import 'package:innetsect/view_model/show_tickets/show_tickets_provide.dart';
import 'package:provide/provide.dart';

class ShowTicketsPage extends PageProvideNode {
  final ShowTicketsProvide _provide = ShowTicketsProvide();
  Map showId;
  ShowTicketsPage({this.showId}) {
    mProviders.provide(Provider<ShowTicketsProvide>.value(_provide));
  }
  @override
  Widget buildContent(BuildContext context) {
    return ShowTicketsContentPage(_provide,showId);
  }
}

class ShowTicketsContentPage extends StatefulWidget {
  final ShowTicketsProvide _provide;
  Map showId;
  ShowTicketsContentPage(this._provide,this.showId);
  @override
  _ShowTicketsContentPageState createState() => _ShowTicketsContentPageState();
}

class _ShowTicketsContentPageState extends State<ShowTicketsContentPage> {
ShowTicketsProvide _provide;
  @override
  void initState() { 
    super.initState();
    _provide??= widget._provide;
    _loadTickets();
  }
  _loadTickets(){
    _provide.tickets(widget.showId['shopID']).doOnListen((){

    }).listen((item){
      if (item!= null) {
        setState(() {
        _provide.addTickets(TicketModelList.fromJson(item.data).list);
        print('_provide.showTickets[0].prodPic===>${_provide.showTickets[0].prodPic}');
        });
      }
    },onError: (e, stack){

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          title: Text(
            '展会门票',
            
          ),
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
        body: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            _showTicketsList(),
       
          
          ],
        ));
  }

  Provide<ShowTicketsProvide> _showTicketsList() {
    return Provide<ShowTicketsProvide>(
      builder:
          (BuildContext context, Widget child, ShowTicketsProvide provide) {
        var itemWidth = (ScreenAdapter.getScreenWidth() - 30) / 2;
        return Container(
          padding: EdgeInsets.all(10),
          child: Wrap(
            runSpacing: 10,
            spacing: 10,
            children: provide.showTickets.map((value) {
              return GestureDetector(
                onTap: () {
                  print('value$value');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) {
                            return new TicketPage();
                          },
                          settings: RouteSettings(arguments: value)));
                },
                child: Container(
                  width: itemWidth,
                  decoration: BoxDecoration(
                
                      ),
                  child: Column(
                    children: <Widget>[
                      Container(
                          width: double.infinity,
                          child: Image.network(
                            value.prodPic,
                            fit: BoxFit.fill,
                          )),
                      Padding(
                        padding: EdgeInsets.only(top: ScreenAdapter.height(20)),
                        child: Container(
                          height: ScreenAdapter.height(90),
                          child: Row(
                            children: <Widget>[
                              Text(
                                '￥',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: ScreenAdapter.size(25),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                value.salesPriceRange,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: ScreenAdapter.size(35),
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.only(top: ScreenAdapter.height(10)),
                      //   child: Container(
                      //     child: Text(
                      //       value['describe'],
                      //       style: TextStyle(
                      //         color: Color.fromRGBO(120, 120, 120, 1.0),
                      //       ),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
