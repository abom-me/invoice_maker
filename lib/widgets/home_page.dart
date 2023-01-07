import 'dart:async';

import 'package:custom_save_pdf/custom_save_pdf.dart';
import 'package:flutter/material.dart';
import 'package:invoice_maker/settings.dart';

import '../invoice_service.dart';
import '../model/product.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription<Map<String, dynamic>>? _subscription;

  TextEditingController text = TextEditingController();

  final PdfInvoiceService service = PdfInvoiceService();

  getdata() async {
    await db.collection('category').get().then((value) => {
          category.clear(),
          value!.forEach((key, Cvalue) {
            category.add(Cvalue);
          }),
          setState(() {})
        });

    await db.collection('products').get().then((value) => {
          products.clear(),
          value!.forEach((key, pvalue) {
            products.add(pvalue);
          })
        });
  }

  @override
  void initState() {
    getdata();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: const DrawerWidget(),
        appBar: AppBar(
          actions: [
            TextButton(
                onPressed: () async {
                  // List<Map<String, dynamic>> selected = [];
                  products
                      .where((element) => element['amount'] > 0)
                      .forEach((e) async {
                    setState(() {
                      selected.add(e);
                    });
                  });

                  if (selected.isNotEmpty) {
                    final data = await service.createInvoice(selected);
                    CustomPdfFolder.save(
                        byteList: data,
                        nameOfFolder: 'invoice',
                        openPDF: true,
                        onSaved: (v) {},
                        onError: (error, code) {
                          // print(error);
                          print(code);
                        });
                    selected.clear();
                  } else {
                    ScaffoldMessenger.of(context)
                        .showMaterialBanner(MaterialBanner(
                            backgroundColor: appColor.withOpacity(0.2),
                            onVisible: () {
                              Timer(const Duration(seconds: 2), () {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentMaterialBanner();
                              });
                            },
                            content: Text(
                              'يجب عليك اختيار منتج واحد على الأقل',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: textColorDark),
                            ),
                            actions: const [
                          SizedBox(),
                        ]));
                  }
                },
                child: const Text(
                  'إنشاء',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "المجموع:",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      getTotal(),
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'ريال',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  child: SingleChildScrollView(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: category.length,
                      itemBuilder: (context, i) {
                        List<Map<String, dynamic>> finalPod = [];
                        products
                            .where((element) =>
                                element['category'] == category[i]['id'])
                            .forEach((element) {
                          finalPod.add(element);
                        });

                        return Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Column(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      category[i]['state'] =
                                          !category[i]['state'];
                                    });
                                  },
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    // margin: EdgeInsets.symmetric(vertical: 10),
                                    alignment: Alignment.center,
                                    width: size.width,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: category[i]['state'] ==
                                                true
                                            ? BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10))
                                            : BorderRadius.circular(10),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.08),
                                              blurRadius: 15)
                                        ]),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          category[i]['name'],
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: textColorDark),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        category[i]['state'] == true
                                            ? const Icon(Icons.expand_less)
                                            : const Icon(Icons.expand_more)
                                      ],
                                    ),
                                  )),
                              category[i]['state'] == true
                                  ? Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10)),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.05),
                                                blurRadius: 20,
                                                offset: Offset(0, 10))
                                          ]),
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: finalPod.length,
                                          itemBuilder:
                                              (BuildContext context, index) {
                                            return Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        child: Text(
                                                            finalPod[index]
                                                                ['name'])),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                              "سعر | ${finalPod[index]['start']}"),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                              "${finalPod[index]['price'].toStringAsFixed(2)}"),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text("مجموع"),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                              "${((finalPod[index]['price'] / finalPod[index]['start']) * finalPod[index]['amount']).toStringAsFixed(2)}"),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        children: [
                                                          IconButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                finalPod[index][
                                                                    'amount'] = finalPod[
                                                                            index]
                                                                        [
                                                                        'amount'] +
                                                                    finalPod[
                                                                            index]
                                                                        [
                                                                        'start'];
                                                              });
                                                            },
                                                            icon: const Icon(
                                                                Icons.add),
                                                          ),
                                                          Text(
                                                            finalPod[index]
                                                                    ['amount']
                                                                .toString(),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          IconButton(
                                                            onPressed: () {
                                                              (finalPod[index][
                                                                          'amount'] >=
                                                                      finalPod[
                                                                              index]
                                                                          [
                                                                          'start'])
                                                                  ? setState(
                                                                      () {
                                                                      finalPod[
                                                                              index]
                                                                          [
                                                                          'amount'] = finalPod[index]
                                                                              [
                                                                              'amount'] -
                                                                          finalPod[index]
                                                                              [
                                                                              'start'];
                                                                    })
                                                                  : print('no');
                                                            },
                                                            icon: const Icon(
                                                                Icons.remove),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                const Divider()
                                              ],
                                            );
                                          }),
                                    )
                                  : SizedBox.shrink(),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getTotal() => products
      .fold(
          0.0,
          (double prev, element) =>
              prev +
              ((element["price"] / element["start"]) * element["amount"]))
      .toStringAsFixed(2);
}
