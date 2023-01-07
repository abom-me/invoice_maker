import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';

import '../model/product.dart';
import '../settings.dart';

class Categorys extends StatefulWidget {
  const Categorys({Key? key}) : super(key: key);

  @override
  State<Categorys> createState() => _CategorysState();
}

class _CategorysState extends State<Categorys> {
  TextEditingController name = TextEditingController();

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
          })
        });
  }

  @override
  void initState() {
    getdata();
    // if (kIsWeb) db.collection('todos').stream.asBroadcastStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: DrawerWidget(),
        appBar: AppBar(
          title: Text(
            'الأقسام',
            style: TextStyle(fontSize: Sizeclass.size(context).width * 0.048),
          ),
          actions: [
            IconButton(
              onPressed: () {
                addCategory();
              },
              icon: const Icon(Icons.add),
            )
          ],
        ),
        body: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 10),
          itemCount: category.length,
          itemBuilder: (context, index) {
            final key = category[index]['id'];

            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      category[index]['name'],
                      style: TextStyle(
                          fontSize: Sizeclass.size(context).width * 0.04,
                          fontWeight: FontWeight.bold,
                          color: textColorDark),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: appColor,
                          ),
                          onPressed: () {
                            setState(() {
                              editCategory(key, category[index]['name']);
                              // item.delete();
                              // _items.remove(item.id);
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: appColor,
                          ),
                          onPressed: () {
                            setState(() {
                              deleteCategory(key);
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

  deleteCategory(id) async {
    await db.collection('category').doc(id).delete().then(
        (value) => {category.removeWhere((element) => element['id'] == id)});
  }

  editCategory(id, name) {
    showDialog(

        // shape: const RoundedRectangleBorder(
        //   borderRadius: BorderRadius.only(
        //       topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        // ),
        context: context,
        builder: (BuildContext context) {
          TextEditingController categoryEdit = TextEditingController();
          categoryEdit.text = name;
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              titlePadding: EdgeInsets.zero,
              title: Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                padding: EdgeInsets.symmetric(vertical: 5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: appColor.withOpacity(0.5),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                ),
                child: Text(
                  " تعديل القسم",
                  style: TextStyle(color: textColorDark, fontSize: 20),
                ),
              ),
              content: Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                width: MediaQuery.of(context).size.width,
                // height: 100,
                child: SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 25),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
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
                                  controller: categoryEdit,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'اسم القسم',
                                      hintStyle: TextStyle(
                                          color: inputText, fontSize: 15),
                                      icon: Icon(
                                        Icons.edit,
                                        color: inputText,
                                      )),
                                ),
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    await db
                                        .collection('category')
                                        .doc(id)
                                        .set({
                                      'name': categoryEdit.text,
                                      'id': id,
                                      'state': false
                                    }).then((value) {
                                      category.removeWhere(
                                          (element) => element['id'] == id);
                                      getdata();
                                      Navigator.of(context).pop();
                                    });
                                  },
                                  child: const Text("حفظ"))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  addCategory() {
    showDialog(
        // shape: const RoundedRectangleBorder(
        //   borderRadius: BorderRadius.only(
        //       topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        // ),
        context: context,
        builder: (BuildContext context) {
          TextEditingController categoryAdd = TextEditingController();
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              titlePadding: EdgeInsets.zero,
              title: Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                padding: EdgeInsets.symmetric(vertical: 5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: appColor.withOpacity(0.5),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                ),
                child: Text(
                  " أضافة القسم",
                  style: TextStyle(color: textColorDark, fontSize: 20),
                ),
              ),
              content: Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                width: MediaQuery.of(context).size.width,
                // height: 100,
                child: SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 25),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
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
                                  controller: categoryAdd,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'اسم القسم',
                                      hintStyle: TextStyle(
                                          color: inputText, fontSize: 15),
                                      icon: Icon(
                                        Icons.add_business,
                                        color: inputText,
                                      )),
                                ),
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    final id = Localstore.instance
                                        .collection('category')
                                        .doc()
                                        .id;
                                    await db
                                        .collection('category')
                                        .doc(id)
                                        .set({
                                      'id': id,
                                      'name': categoryAdd.text,
                                      'state': false
                                    }).then((value) {
                                      getdata();
                                      Navigator.pop(context);
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
              ),
            ),
          );
        });
  }
}
