import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_globalshop/model/HistoryModel.dart';
import 'package:mobile_globalshop/model/api.dart';

class HistoryDetail extends StatefulWidget {
  final HistoryModel model;
  HistoryDetail(this.model);
  @override
  _HistoryDetailState createState() => _HistoryDetailState();
}

class _HistoryDetailState extends State<HistoryDetail> {
  final price = NumberFormat("#,##0", 'en_US');

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
                "Transaksi Detail",
                style: TextStyle(color: Colors.black, fontSize: 20.0),
              ),
            )
          ],
        ),
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 25,),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Text("Tanggal Pembelian: ${widget.model.tgljual}", 
                  style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                SizedBox(height: 10,),
                ],
              ),
            ),
            ListView.builder(
              itemCount: widget.model.detail.length,
              shrinkWrap: true,
              itemBuilder: (context, i) {
                final a = widget.model.detail[i];
                var totalPrice = (int.parse(a.harga));
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Image.network(BaseUrl.paths + "${a.image}", width: 100, height: 100,),
                                Text("${a.namabarang}", style: TextStyle(fontWeight: FontWeight.bold),),
                              ]
                            ),

                            SizedBox(width: 20,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                SizedBox(height: 15,),
                                Text("No. Faktur: PRO${a.idfaktur}2021"),
                                Text("Quantity: ${a.qty}"),
                                Text("Harga: ${price.format(int.parse(a.harga) / int.parse(a.qty))}"),
                                SizedBox(height: 5.0,),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(right: 1),
                                child: Column(
                                  children: [
                                    SizedBox(height: 85,),
                                    Text("Total : ${price.format(totalPrice)}", style: TextStyle(fontWeight: FontWeight.bold),),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 25),
                  child: Text(
                    "Total Belanja:  ${price.format(int.parse(widget.model.grandtotal))}", 
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                    ),),
              ],
            ),
          ],
        ),
        
      ), 
      
    );
  }
}
