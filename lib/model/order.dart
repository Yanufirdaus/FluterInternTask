// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'dart:convert';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  String nominalDiskon;
  String nominalPesanan;
  List<Item> items;

  Order({
    required this.nominalDiskon,
    required this.nominalPesanan,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        nominalDiskon: json["nominal_diskon"],
        nominalPesanan: json["nominal_pesanan"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "nominal_diskon": nominalDiskon,
        "nominal_pesanan": nominalPesanan,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class Item {
  int id;
  int harga;
  String? catatan;

  Item({
    required this.id,
    required this.harga,
    this.catatan,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        harga: json["harga"],
        catatan: json["catatan"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "harga": harga,
        "catatan": catatan,
      };
}
