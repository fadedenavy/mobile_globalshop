class HistoryModel {
  final String idfaktur;
  final String tgljual;
  final String image;
  final String grandtotal;
  final String nilaibayar;
  final String nilaikembali;
  final List<HistoryDetailModel> detail;

  HistoryModel({
    this.idfaktur,
    this.tgljual,
    this.image,
    this.grandtotal,
    this.nilaibayar,
    this.nilaikembali,
    this.detail,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    var list = json['detail'] as List;
    List<HistoryDetailModel> dataList =
        list.map((e) => HistoryDetailModel.fromJson(e)).toList();
    return HistoryModel(
      idfaktur: json['id_faktur'],
      tgljual: json['tgl_jual'],
      image: json['image'],
      grandtotal: json['grandtotal'],
      nilaibayar: json['nilaibayar'],
      nilaikembali: json['nilaikembali'],
      detail: dataList,
    );
  }
}

class HistoryDetailModel {
  final String id;
  final String idfaktur;
  final String idbarang;
  final String image;
  final String namabarang;
  final String qty;
  final String harga;

  HistoryDetailModel(
      {this.id,
      this.idfaktur,
      this.idbarang,
      this.image,
      this.namabarang,
      this.qty,
      this.harga});

  factory HistoryDetailModel.fromJson(Map<String, dynamic> json) {
    return HistoryDetailModel(
      id: json['id'],
      idfaktur: json['id_faktur'],
      idbarang: json['id_barang'],
      image: json['image'],
      namabarang: json['nama_barang'],
      qty: json['qty'],
      harga: json['harga'],
    );
  }
}
