import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:invoice_maker/model/product.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class CustomRow {
  final String itemName;
  final String itemPrice;
  final String amount;
  final String total;

  CustomRow(
    this.itemName,
    this.itemPrice,
    this.amount,
    this.total,
  );
}

class PdfInvoiceService {
  Future<Uint8List> createInvoice(
      List<Map<String, dynamic>> soldProducts) async {
    List<Widget> widgets = [];

    final pdf = Document();

    final List<CustomRow> elements = [
      CustomRow("المجموع", "العدد", "السعر", "اسم المنتج"),
      for (var product in soldProducts)
        CustomRow(
            ((product['price'] / product['start']) * product['amount'])
                .toStringAsFixed(2),
            product['amount'].toStringAsFixed(1),
            product['price'].toStringAsFixed(2),
            product['name']),
      // CustomRow(
      //   "Sub Total",
      //   "",
      //   "",
      //   "",
      //   "${getSubTotal(soldProducts)} EUR",
      // ),
    ];

    // final image = ClipOval(
    //   child: Image(
    //     await imageFromAssetBundle("assets/logo.png"),
    //     fit: BoxFit.cover,
    //     width: 300,
    //     height: 300,
    //   ),
    // );
    var font = await rootBundle.load("assets/Tajawal-Medium.ttf");
    widgets.add(Container(
        alignment: Alignment.center,
        child: Text("فاتورة طلبات",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                font: Font.ttf(font)))));
    widgets.add(SizedBox(height: 50));
    // widgets.add(Theme(
    //     data: ThemeData(defaultTextStyle: TextStyle(font: textFont)),
    //     child: Column(
    //       children: [
    //         Row(
    //           // mainAxisAlignment: MainAxisAlignment.end,
    //           children: [
    //             Column(
    //               children: [
    //                 Text("أسم الزبون"),
    //                 // Text("Customer Address"),
    //                 // Text("Customer City"),
    //               ],
    //             ),
    //             // Column(
    //             //   children: [
    //             //     Text("Max Weber"),
    //             //     Text("Weird Street Name 1"),
    //             //     Text("77662 Not my City"),
    //             //     Text("Vat-id: 123456"),
    //             //     Text("Invoice-Nr: 00001")
    //             //   ],
    //             // )
    //           ],
    //         ),
    //         SizedBox(height: 50),
    //         itemColumn(elements),
    //       ],
    //     )));
    widgets.add(itemColumn(elements, font));

    pdf.addPage(
      MultiPage(
        textDirection: TextDirection.rtl,
        pageFormat: PdfPageFormat.a4,
        build: (Context context) {
          return widgets;
        },
      ),
    );
    return pdf.save();
  }

  Theme itemColumn(List<CustomRow> elements, font) {
    var textFont = Font.ttf(font);
    return Theme(
        data: ThemeData(defaultTextStyle: TextStyle(font: textFont)),
        child: Column(
          children: [
            for (var element in elements)
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(element.itemName, textAlign: TextAlign.right),
                    Text(element.itemPrice, textAlign: TextAlign.right),
                    Text(element.amount, textAlign: TextAlign.right),
                    Text(element.total, textAlign: TextAlign.right),
                  ],
                ),
              ),
            SizedBox(height: 20),
            Container(
                padding: EdgeInsets.all(10),
                width: 200,
                decoration: BoxDecoration(
                    border: Border.all(color: PdfColors.black, width: 1)),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('ريال عماني'),
                  SizedBox(width: 10),
                  Text(getSubTotal()),
                  SizedBox(width: 5),
                  Text('الإجمالي:'),
                ]))
          ],
        ));
  }

  String getSubTotal() {
    return selected
        .fold(
            0.0,
            (double prev, element) =>
                prev +
                ((element["price"] / element["start"]) * element["amount"]))
        .toStringAsFixed(2);
  }
}
