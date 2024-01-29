import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intern_test/model/menu.dart';
import 'package:intern_test/model/order.dart';
import 'package:intern_test/model/order_response.dart';
import 'package:intern_test/model/voucher.dart';

const String base_url = 'https://tes-mobile.landa.id/api/';

class ApiService {
  Future<Menu?> getPosts() async {
    var client = http.Client();

    var uri = Uri.parse(base_url + 'menus');
    var response = await client.get(uri);

    if (response.statusCode == 200) {
      var json = response.body;
      return menuFromJson(json);
    }
  }

  Future<Voucher?> getVoucher(String code) async {
    var client = http.Client();

    var uri = Uri.parse(base_url + 'vouchers?kode=' + code);
    var response = await client.get(uri);

    if (response.statusCode == 200) {
      var json = response.body;
      return voucherFromJson(json);
    }
  }

  Future<OrderResponse> postOrder(Order order) async {
    try {
      var url = Uri.parse(base_url + 'order');
      var _payload = json.encode(order.toJson());

      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: _payload,
      );
      debugPrint(response.body);
      return OrderResponse(id: 1, statusCode: 200, message: 'message');
      // if (response.statusCode == 200) {
      //   return response.bo;
      // } else {
      //   throw Exception(
      //       'Failed to post order. Status Code: ${response.statusCode}');
      // }
    } catch (e) {
      throw Exception('Failed to post order. Error: $e');
    }
  }
}
