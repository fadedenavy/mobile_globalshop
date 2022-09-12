import 'package:flutter/material.dart';
import 'package:mobile_globalshop/model/KeranjangModelLaris.dart';
import 'package:mobile_globalshop/model/ProdukTerlarisModel.dart';
import 'package:mobile_globalshop/model/api.dart';
import 'package:mobile_globalshop/custom/constans.dart';
import 'package:mobile_globalshop/views/Cart.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DetailProdukLaris extends StatefulWidget {
  final ProdukTerlarisModel listlaris;

  DetailProdukLaris({@required this.listlaris});

  @override
  _DetailProdukLarisState createState() => _DetailProdukLarisState();
}

class _DetailProdukLarisState extends State<DetailProdukLaris> {
  int _currentImage = 0;
  final money = NumberFormat("#,##0", "en_US");
  String idUsers;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsers = preferences.getString("userid");
    });
    _countCart();
  }

  // String jumlahnya;

  List<Widget> listL = [];
  List<Widget> buildPageIndicator() {
    for (var i = 0; i < widget.listlaris.image.length; i++) {
      listL.add(
          i == _currentImage ? buildIndicator(true) : buildIndicator(false));
    }
    return listL;
  }

  Widget buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 6.0),
      height: 8.0,
      width: isActive ? 20.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.grey[400],
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
    );
  }

  // add to cart
  tambahKeranjang(String idProduk, String harga) async {
    final responseLaris = await http.post(Uri.parse(BaseUrl.urlAddCart),
        body: {"userid": idUsers, "id_barang": idProduk, "harga": harga});

    final dataLaris = jsonDecode(responseLaris.body);
    int valueLaris = dataLaris['success'];
    String pesanLaris = dataLaris['message'];

    if (valueLaris == 1) {
      print(pesanLaris);
      _countCart();
    } else {
      print(pesanLaris);
    }
  }

  var loadingLaris = false;
  String jumlahnyaLaris = "0";
  final exLaris = List<KeranjangModelLaris>();
  _countCart() async {
    if (this.mounted) {
      setState(() {
        loadingLaris = true;
      });
    }
    exLaris.clear();
    final responseLaris = await http.get(Uri.parse(BaseUrl.urlCountCart + idUsers));
    final dataLaris = jsonDecode(responseLaris.body);
    dataLaris.forEach((api) {
      final expLaris = new KeranjangModelLaris(api['jumlah']);
      exLaris.add(expLaris);
      if (this.mounted) {
        setState(() {
          jumlahnyaLaris = expLaris.jumlahLaris;
        });
      }
    });
    if (this.mounted) {
      setState(() {
        _countCart();
        loadingLaris = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          "assets/img/logo.png",
        ),
        backgroundColor: Color(0xffb4b4b4),
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            size: 32,
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          Stack(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => new Cart()));
                },
              ),
              jumlahnyaLaris == "0"
                  ? Container()
                  : Positioned(
                      right: 0.0,
                      child: Stack(
                        children: [
                          Icon(
                            Icons.brightness_1,
                            size: 20.0,
                            color: Colors.white,
                          ),
                          Positioned(
                            top: 3.0,
                            right: 6.0,
                            child: Text(
                              jumlahnyaLaris,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 11.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
            ],
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  physics: BouncingScrollPhysics(),
                  onPageChanged: (int page) {
                    setState(() {
                      _currentImage = page;
                    });
                  },
                  children: <Widget>[
                    Container(
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                          spreadRadius: 5,
                          color: Colors.black.withOpacity(0.1),
                        )
                      ]),
                      child: Hero(
                        tag: widget.listlaris.nama_barang,
                        child: Image.network(
                          BaseUrl.paths + widget.listlaris.image,
                          width: 100,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(color: Colors.white),
                child: Image.asset(
                  "assets/img/nikelogo.png",
                  width: 70,
                  fit: BoxFit.cover,
                  color: Color(0xffb4b4b4),
                ),
              ),
              Container(
                height: size.height * 0.5,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(6),
                      child: Container(
                        height: size.height * 0.2,
                        padding: EdgeInsets.all(32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              widget.listlaris.nama_barang,
                              style: TextStyle(
                                fontFamily: "Averta",
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Rp. " +
                                      money.format(
                                          int.parse(widget.listlaris.harga)),
                                  style: TextStyle(
                                      fontFamily: "Averta",
                                      fontSize: 20,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.star,
                              size: 16,
                              color: kStarsColor,
                            ),
                            Icon(
                              Icons.star,
                              size: 16,
                              color: kStarsColor,
                            ),
                            Icon(
                              Icons.star,
                              size: 16,
                              color: kStarsColor,
                            ),
                            Icon(
                              Icons.star,
                              size: 16,
                              color: kStarsColor,
                            ),
                            Icon(
                              Icons.star_half,
                              size: 16,
                              color: kStarsColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 120,
                    ),

                    Center(
                      child: Container(
                        width: size.width * 0.5,
                        decoration: BoxDecoration(
                            color: Color(0xfffbc30b),
                            borderRadius: BorderRadius.circular(12)),
                        padding: EdgeInsets.all(16),
                        child: GestureDetector(
                          onTap: () {
                            tambahKeranjang(widget.listlaris.id_barang,
                                widget.listlaris.harga);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_basket,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 25,
                              ),
                              Text(
                                "Add To Cart",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Container(
                    //   height: size.height * 0.1,
                    //   decoration: BoxDecoration(
                    //     color: Color(0xff497786),
                    //     borderRadius: BorderRadius.circular(40),
                    //   ),
                    //   child: GestureDetector(
                    //     onTap: () {},
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: <Widget>[
                    //         Text(
                    //           "Add To Cart",
                    //           style: TextStyle(
                    //             fontWeight: FontWeight.bold,
                    //             fontSize: 18,
                    //             color: Colors.white,
                    //           ),
                    //         ),
                    //         SizedBox(
                    //           width: 16,
                    //         ),
                    //         Icon(
                    //           Icons.shopping_basket,
                    //           color: Colors.white,
                    //           size: 30,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
