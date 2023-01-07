import 'package:flutter/material.dart';
import 'package:invoice_maker/widgets/category_page.dart';
import 'package:invoice_maker/widgets/home_page.dart';
import 'package:invoice_maker/widgets/product_page.dart';
import 'package:localstore/localstore.dart';

Color appColor = Color(0xff52796f);
Color textColorLight = Color(0xffcce3de);
Color textColorDark = Color(0xff2f3e46);
const Color inputBack = Color(0xffF0F2F3);
const Color inputText = Color(0xffC8C7CB);
const Color gray = Color(0xffF0F2F3);
String appFont = 'Tajawal-Medium';
Localstore db = Localstore.instance;

class Sizeclass {
  static size(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return size;
  }
}

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: EdgeInsets.only(top: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListTile(
              onTap: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => HomePage()));
              },
              title: Text('الرئيسية',
                  style: TextStyle(
                      fontSize: Sizeclass.size(context).width * 0.048,
                      color: textColorDark,
                      fontWeight: FontWeight.bold)),
            ),
            ListTile(
              onTap: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => Categorys()));
              },
              title: Text('الأقسام',
                  style: TextStyle(
                      fontSize: Sizeclass.size(context).width * 0.048,
                      color: textColorDark,
                      fontWeight: FontWeight.bold)),
            ),
            ListTile(
              onTap: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => Products()));
              },
              title: Text('المنتجات',
                  style: TextStyle(
                      fontSize: Sizeclass.size(context).width * 0.048,
                      color: textColorDark,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
