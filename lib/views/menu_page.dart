// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intern_test/model/menu.dart';
import 'package:intern_test/model/order.dart';
import 'package:intern_test/model/voucher.dart';
import 'package:intern_test/service/ApiService.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  Menu? menus;
  Voucher? vouchers;
  var isLoaded = false;
  var isVoucherLoaded = false;
  var item = 0;
  var total_order = 0;
  var total_price = 0;
  var final_price = 0;
  var total_voucher = 0;

  TextEditingController voucherController = TextEditingController();

  @override
  void initState() {
    super.initState();

    getData();
  }

  getData() async {
    menus = (await ApiService().getPosts())!;
    if (menus != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  getVoucher() async {
    setState(() {
      isVoucherLoaded = true;
    });
    try {
      vouchers = await ApiService().getVoucher(voucherController.text);

      if (vouchers != null) {
        setState(() {
          total_voucher = vouchers!.datas.nominal;
          if (total_price > 0) {
            final_price = total_price - total_voucher;
          }
          isVoucherLoaded = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Voucher berhasil digunakan'),
            backgroundColor: Colors.black));
      } else {
        print('Failed to get vouchers');
      }
    } catch (e) {
      print('Error fetching voucher: $e');
    }
  }

  String dotAdder(String word) {
    if (word.length <= 3) {
      return word;
    }

    int dotIndex = word.length - 3;
    String result =
        word.substring(0, dotIndex) + '.' + word.substring(dotIndex);
    return result;
  }

  List<String> textValues = List.generate(5, (index) => '');
  List<int> countOrder = List.generate(5, (index) => 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20),
              height: 580,
              width: double.infinity,
              child: Visibility(
                  replacement: const Center(
                      child: CircularProgressIndicator(
                    color: Colors.black,
                  )),
                  visible: isLoaded,
                  child: ListView.builder(
                    itemCount: menus?.datas?.length,
                    itemBuilder: (context, index) {
                      return Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey
                                      .withOpacity(0.5), // Color of the shadow
                                  spreadRadius:
                                      5, // Spread radius of the shadow
                                  blurRadius: 7, // Blur radius of the shadow
                                  offset: Offset(
                                      0, 3), // Offset of the shadow (x, y)
                                ),
                              ],
                              color: Color.fromARGB(255, 231, 231, 231),
                              borderRadius: BorderRadius.circular(10)),
                          width: double.infinity,
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                          height: 90,
                          child: Center(
                              child: Row(children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 154, 154, 154),
                                  borderRadius: BorderRadius.circular(10)),
                              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              width: 70,
                              height: 70,
                              child: Image.network(menus!.datas![index].gambar,
                                  fit: BoxFit.contain),
                            ),
                            Container(
                                alignment: Alignment.centerLeft,
                                child: Center(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 10,
                                      color: Colors.blue,
                                    ),
                                    Text(
                                      menus!.datas![index].nama,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15),
                                    ),
                                    Text(
                                      'Rp. ' +
                                          dotAdder(menus!.datas![index].harga
                                              .toString()),
                                      style: TextStyle(
                                          color: Color(0xFF00717F),
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.edit_note,
                                          color: Color(0xFF00717F),
                                        ),
                                        Text('  '),
                                        SizedBox(
                                          width: 150,
                                          height: 30,
                                          child: TextFormField(
                                              maxLines: 1,
                                              decoration: InputDecoration(
                                                hintText:
                                                    'Tambahkan Catatan...',
                                                hintStyle:
                                                    TextStyle(fontSize: 12),
                                                border: InputBorder.none,
                                              ),
                                              onChanged: (value) {
                                                setState(() {
                                                  textValues[index] = value;
                                                });
                                              }),
                                        )
                                      ],
                                    )
                                  ],
                                ))),
                            Expanded(
                              child: Container(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Row(children: [
                                    Expanded(
                                      child: Container(
                                          child: InkWell(
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 3,
                                                          color: Color(
                                                              0xFF00717F)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  alignment: Alignment.center,
                                                  width: 10,
                                                  height: 30,
                                                  child: Text('-',
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF00717F),
                                                          fontWeight: FontWeight
                                                              .bold))),
                                              onTap: () {
                                                debugPrint('test minus');
                                                if (countOrder[index] > 0) {
                                                  setState(() {
                                                    countOrder[index]--;
                                                    total_order--;
                                                    total_price = total_price -
                                                        menus!.datas![index]
                                                            .harga;
                                                  });
                                                }
                                              })),
                                    ),
                                    Expanded(
                                      child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                              countOrder[index].toString())),
                                    ),
                                    Expanded(
                                      child: Container(
                                          child: InkWell(
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Color(0xFF00717F),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  alignment: Alignment.center,
                                                  width: 10,
                                                  height: 30,
                                                  child: Text('+',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight
                                                              .bold))),
                                              onTap: () {
                                                debugPrint('test plus');
                                                setState(() {
                                                  countOrder[index]++;
                                                  total_order++;
                                                  total_price = total_price +
                                                      menus!
                                                          .datas![index].harga;
                                                });
                                              })),
                                    ),
                                  ])),
                            ),
                          ])));
                    },
                  )),
            ),
            Expanded(
                child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 231, 231, 231),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(25),
                            topLeft: Radius.circular(25))),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Row(children: [
                                Expanded(
                                  child: Container(
                                      child: Row(children: [
                                    Text(
                                      'Total Pesanan ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                        '(' + total_order.toString() + ' Menu)')
                                  ])),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: Text('Rp. ' +
                                        dotAdder(dotAdder((total_price > 0)
                                            ? total_price.toString()
                                            : '0'))),
                                  ),
                                ),
                              ])),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          height: 0.2,
                          width: 350,
                          color: Colors.black,
                        ),
                        Expanded(
                            child: InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 20, 20, 20),
                                        height: 200,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(children: [
                                              Icon(
                                                Icons.airplane_ticket,
                                                size: 35,
                                                color: Color(0xFF00717F),
                                              ),
                                              Text(
                                                'PUNYA KODE VOUCHER ?',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w900),
                                              ),
                                            ]),
                                            Text(
                                                'Masukkan kode voucher disini'),
                                            TextFormField(
                                              controller: voucherController,
                                              decoration: InputDecoration(
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 2,
                                                      color: Color(0xFF00717F)),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                width: double.infinity,
                                                child: ElevatedButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStatePropertyAll<
                                                                  Color>(
                                                              Color(
                                                                  0xFF00717F))),
                                                  onPressed: () {
                                                    getVoucher();
                                                    Navigator.pop(context);
                                                    voucherController.clear();
                                                  },
                                                  child: isVoucherLoaded
                                                      ? CircularProgressIndicator(
                                                          color: Color.fromARGB(
                                                              255, 60, 98, 85),
                                                        )
                                                      : Text(
                                                          'Validasi Voucher',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                ))
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    child: Row(children: [
                                      Expanded(
                                        child: Container(
                                            child: Row(children: [
                                          Icon(Icons.airplane_ticket),
                                          Text(' Voucher',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold))
                                        ])),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            total_voucher == 0
                                                ? 'Input voucher  >'
                                                : total_voucher.toString() +
                                                    '  >',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    224, 162, 162, 162)),
                                          ),
                                        ),
                                      ),
                                    ])))),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(25),
                                    topLeft: Radius.circular(25))),
                            child: Row(children: [
                              Expanded(
                                child: Container(
                                    child: Row(children: [
                                  Icon(Icons.shopping_basket,
                                      size: 35, color: Color(0xFF00717F)),
                                  Text('  '),
                                  Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Total Pembayaran',
                                          style: TextStyle(fontSize: 10),
                                        ),
                                        Text(
                                          'Rp ' +
                                              (final_price == 0
                                                  ? dotAdder(
                                                      total_price.toString())
                                                  : final_price > 0
                                                      ? dotAdder(final_price
                                                          .toString())
                                                      : '0'),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              color: Color(0xFF00717F)),
                                        )
                                      ])
                                ])),
                              ),
                              Expanded(
                                  child: Container(
                                alignment: Alignment.centerRight,
                                child: SizedBox(
                                    height: 35,
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll<Color>(
                                                    Color(0xFF00717F))),
                                        child: Text(
                                          'Pesan Sekarang',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () async {
                                          var order = Order(
                                              nominalDiskon:
                                                  total_voucher.toString(),
                                              nominalPesanan: (final_price == 0
                                                  ? dotAdder(
                                                      total_price.toString())
                                                  : final_price > 0
                                                      ? dotAdder(final_price
                                                          .toString())
                                                      : '0'),
                                              items: [
                                                Item(
                                                    id: menus!.datas![0].id,
                                                    harga:
                                                        menus!.datas![0].harga *
                                                            countOrder[0],
                                                    catatan: textValues[0]),
                                                Item(
                                                    id: menus!.datas![1].id,
                                                    harga:
                                                        menus!.datas![1].harga *
                                                            countOrder[1],
                                                    catatan: textValues[1]),
                                                Item(
                                                    id: menus!.datas![2].id,
                                                    harga:
                                                        menus!.datas![2].harga *
                                                            countOrder[2],
                                                    catatan: textValues[2]),
                                                Item(
                                                    id: menus!.datas![3].id,
                                                    harga:
                                                        menus!.datas![3].harga *
                                                            countOrder[3],
                                                    catatan: textValues[3]),
                                              ]);

                                          // debugPrint(order.nominalPesanan);

                                          var response = await ApiService()
                                              .postOrder(order)
                                              .catchError((err) {
                                            err.toString();
                                          });
                                          if (response == null) return;
                                          debugPrint(response.message);
                                        })),
                              )),
                            ]),
                          ),
                        ),
                      ],
                    )))
          ],
        ),
      ),
    );
  }
}
