import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_globalshop/model/HistoryModel.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_globalshop/model/api.dart';

class HistoryRepository {
  Future fetchdata(
    List<HistoryModel> list,
    String idUsers,
    VoidCallback reload,
    bool cekData,
  ) async {
    reload();
    list.clear();
    final response = await http.get(BaseUrl.urlHistory + idUsers);
    if (response.statusCode == 200) {
      reload();
      if (response.contentLength == 2) {
        cekData = false;
      } else {
        final data = jsonDecode(response.body);
        for (Map i in data) {
          list.add(HistoryModel.fromJson(i));
        }
        cekData = true;
        print(cekData);
      }
    } else {
      cekData = false;
      reload();
    }
  }
}
