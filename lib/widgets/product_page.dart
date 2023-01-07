import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:invoice_maker/model/product.dart';
import 'package:localstore/localstore.dart';

import '../settings.dart';

class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  getdata() async {
    await db.collection('category').get().then((value) => {
          category.clear(),
          value!.forEach((key, Cvalue) {
            category.add(Cvalue);
          })
        });

    await db.collection('products').get().then((value) => {
          products.clear(),
          value!.forEach((key, pvalue) {
            products.add(pvalue);
          }),
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: DrawerWidget(),
        appBar: AppBar(
          title: Text(
            'المنتجات',
            style: TextStyle(fontSize: Sizeclass.size(context).width * 0.048),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => AddProduct()));
              },
              icon: const Icon(Icons.add),
            )
          ],
        ),
        body: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 10),
          itemCount: products.length,
          itemBuilder: (context, index) {
            String cate = 'null';
            category
                .where(
                    (element) => element['id'] == products[index]['category'])
                .forEach((element) {
              print(element['name']);

              cate = element['name'];
            });
            final key = products[index]['id'];

            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      products[index]['name'],
                      style: TextStyle(
                          fontSize: Sizeclass.size(context).width * 0.04,
                          fontWeight: FontWeight.bold,
                          color: textColorDark),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_bag,
                          color: textColorDark,
                          size: Sizeclass.size(context).width * 0.05,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(
                            cate,
                            style: TextStyle(
                                fontSize: Sizeclass.size(context).width * 0.04,
                                fontWeight: FontWeight.bold,
                                color: textColorDark),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: appColor,
                          ),
                          onPressed: () {
                            setState(() {
                              deleteProduct(key);
                              // item.delete();
                              // _items.remove(item.id);
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider()
              ],
            );
          },
        ),
      ),
    );
  }

  deleteProduct(id) async {
    await db.collection('products').doc(id).delete().then(
        (value) => {products.removeWhere((element) => element['id'] == id)});
  }
}

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  List<DropdownMenuItem<String>> menuItems = [
    DropdownMenuItem(
        child: Text("أختر قسم", style: TextStyle(color: textColorDark)),
        value: "null"),
  ];
  var categoryInt = 'null';
  TextEditingController productName = TextEditingController();
  TextEditingController productPrice = TextEditingController();
  TextEditingController productStart = TextEditingController();
  getdata() async {
    await db.collection('products').get().then((value) => {
          products.clear(),
          value!.forEach((key, pvalue) {
            products.add(pvalue);
          })
        });
  }

  @override
  void initState() {
    category.forEach((element) {
      menuItems.add(
        DropdownMenuItem(
            child: Text(
              element['name'],
              style: TextStyle(color: textColorDark),
            ),
            value: element['id']),
      );
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          backgroundColor: Colors.white,
          drawer: DrawerWidget(),
          appBar: AppBar(
            title: Text(
              'اضافة منتج',
              style: TextStyle(fontSize: Sizeclass.size(context).width * 0.048),
            ),
          ),
          body: Container(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 25),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ///Name----------------------
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(bottom: 25),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: gray),
                            child: TextFormField(
                              style: TextStyle(
                                  color: textColorDark,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                              controller: productName,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'اسم المنتج',
                                  hintStyle:
                                      TextStyle(color: inputText, fontSize: 15),
                                  icon: Icon(
                                    Icons.add,
                                    color: inputText,
                                  )),
                            ),
                          ),

                          ///Price----------------------
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(bottom: 25),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: gray),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  color: textColorDark,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                              controller: productPrice,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'سعر المنتج',
                                  hintStyle:
                                      TextStyle(color: inputText, fontSize: 15),
                                  icon: Icon(
                                    Icons.add,
                                    color: inputText,
                                  )),
                            ),
                          ),

                          /// Start
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(bottom: 25),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: gray),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  color: textColorDark,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                              controller: productStart,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'الطلب يبدأ من',
                                  hintStyle:
                                      TextStyle(color: inputText, fontSize: 15),
                                  icon: Icon(
                                    Icons.add,
                                    color: inputText,
                                  )),
                            ),
                          ),
                          Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(bottom: 25),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: gray),
                              child: DropdownButtonFormField(
                                style: TextStyle(
                                    fontSize: 15, fontFamily: appFont),
                                value: categoryInt,
// value: dropdownValue,
                                items: menuItems,
                                onChanged: (value) {
                                  setState(() {
                                    categoryInt = value!;
                                  });
                                },
                              )),

                          ElevatedButton(
                              onPressed: () async {
                                final id = Localstore.instance
                                    .collection('products')
                                    .doc()
                                    .id;
                                await db.collection('products').doc(id).set({
                                  'id': id,
                                  'category': categoryInt,
                                  'name': productName.text,
                                  'amount': 0,
                                  'price': double.parse(productPrice.text),
                                  'start': int.parse(productStart.text),
                                }).then((value) {
                                  products.add({
                                    'id': id,
                                    'category': categoryInt,
                                    'name': productName.text,
                                    'amount': 0,
                                    'price': double.parse(productPrice.text),
                                    'start': int.parse(productStart.text),
                                  });
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (builder) => Products()));
                                });
                              },
                              child: const Text("أضافة"))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
