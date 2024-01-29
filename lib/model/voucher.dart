// To parse this JSON data, do
//
//     final voucher = voucherFromJson(jsonString);

import 'dart:convert';

Voucher voucherFromJson(String str) => Voucher.fromJson(json.decode(str));

String voucherToJson(Voucher data) => json.encode(data.toJson());

class Voucher {
  int statusCode;
  Datas datas;

  Voucher({
    required this.statusCode,
    required this.datas,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) => Voucher(
        statusCode: json["status_code"],
        datas: Datas.fromJson(json["datas"]),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "datas": datas.toJson(),
      };
}

class Datas {
  int id;
  String kode;
  int nominal;
  DateTime createdAt;
  DateTime updatedAt;

  Datas({
    required this.id,
    required this.kode,
    required this.nominal,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Datas.fromJson(Map<String, dynamic> json) => Datas(
        id: json["id"],
        kode: json["kode"],
        nominal: json["nominal"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "kode": kode,
        "nominal": nominal,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
