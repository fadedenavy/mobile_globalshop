import 'package:flutter/material.dart';
import 'package:mobile_globalshop/model/api.dart';
import 'package:intl/intl.dart';
import 'package:mobile_globalshop/views/LoadingPageOne.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_globalshop/model/HistoryModel.dart';
import 'package:mobile_globalshop/custom/historyRepository.dart';

import 'historyDetail.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final price = NumberFormat("#,##0", 'en_US');
  bool login = false;
  String idUsers;
  HistoryRepository historyRepository = HistoryRepository();
  List<HistoryModel> list = [];
  var loading = false;
  var cekData = false;
  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      idUsers = pref.getString("userid");
    });
    await historyRepository.fetchdata(list, idUsers, () {
      setState(() {
        loading = false;
      });
    }, cekData);
  }

  Future<void> refresh() async {
    getPref();
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color(0xffb4b4b4),
        elevation: 1,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                "Riwayat Transaksi",
                style: TextStyle(color: Colors.black, fontSize: 20.0),
              ),
            )
          ],
        ),
      ),
      body: Container(
          child: RefreshIndicator(
        onRefresh: refresh,
        child: ListView(
          children: [
            ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: list.length,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, i) {
                final a = list[i];
                return Container(
                    child: Card(
                      margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Image.asset("assets/img/invoices.png", width: 75,),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 35,),
                                Text("Tanggal Transaksi : ${a.tgljual}"),
                                Text("Total Belanja : Rp. ${price.format(int.parse(a.grandtotal))}")
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 50,),
                                MaterialButton(
                                  onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => new HistoryDetail(a)));
                                  },
                                  child: new Text(
                                    "Detail", style: TextStyle(color: Colors.black),
                                  ),
                                  color: Color(0xfffbc30b),
                                ),
                              ],                            ),
                          )
                        ],
                      ),
                    ),
                );
              },
            ),
          ],
        ),
      )),
    );
  }
}
