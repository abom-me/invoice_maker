import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:invoice_maker/settings.dart';
import 'package:localstore/localstore.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  TextEditingController name = TextEditingController();

  StreamSubscription<Map<String, dynamic>>? _subscription;

  @override
  void initState() {
    _subscription = db.collection('category').stream.listen((event) {
      print(event);
    });
    // if (kIsWeb) db.collection('todos').stream.asBroadcastStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('test'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                db.collection('category').delete();
              });
            },
            icon: const Icon(Icons.delete_outlined),
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            TextField(
              controller: name,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final id = Localstore.instance.collection('category').doc().id;
          await db
              .collection('category')
              .doc(id)
              .set({'id': id, 'name': name.text, 'state': false});
        },
        tooltip: 'add',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  @override
  void dispose() {
    if (_subscription != null) _subscription?.cancel();
    super.dispose();
  }
}

/// Data Model
class categoryMap {
  final String id;
  String title;

  categoryMap({
    required this.id,
    required this.title,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }

  factory categoryMap.fromMap(Map<String, dynamic> map) {
    return categoryMap(
      id: map['id'],
      title: map['title'],
    );
  }
}

extension ExtTodo on categoryMap {
  Future save() async {
    final db = Localstore.instance;
    return db.collection('todos').doc(id).set(toMap());
  }

  Future delete() async {
    final db = Localstore.instance;
    return db.collection('todos').doc(id).delete();
  }
}
