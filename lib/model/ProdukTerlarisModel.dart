class ProdukTerlarisModel {
  String id_barang;
  String nama_barang;
  String harga;
  String image;

  ProdukTerlarisModel(this.id_barang, this.nama_barang, this.harga,
    this.image);

  ProdukTerlarisModel.fromJson(Map<String, dynamic> json) {
    id_barang = json['id_barang'];
    nama_barang = json['nama_barang'];
    harga = json['harga'];
    image = json['image'];
  }
}