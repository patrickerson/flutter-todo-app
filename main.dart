import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/items.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Still Food',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomePage(),

    );
  }
}

class HomePage extends StatefulWidget {
  var items = new List<Item>(); 

  HomePage(){
    items = [];
    // items.add(Item(title: "Item 1", done: true));
    // items.add(Item(title: "Item 2", done: true));
    // items.add(Item(title: "Item 3", done: false));
  }




  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var newcrtl =  TextEditingController();

  void add(){
    setState(() {
      widget.items.add(Item(
        title: newcrtl.text,
        done: false,
        ),
      );
    });
    newcrtl.text = "";
    save();
  }

  void remove(int index){
    setState(() {
      widget.items.removeAt(index);
    });
    save();
  }

  Future load() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('data');

    if (data != null){
      Iterable decoded = jsonDecode(data);
      List<Item> result = decoded.map((x) => Item.fromJson(x)).toList();
    }
  } 

  void save() async{
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', jsonEncode(widget.items));
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: newcrtl,
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            backgroundColor: Colors.redAccent
          ),
          decoration: InputDecoration(
            labelText: "Pedir comida",
            labelStyle: TextStyle(color: Colors.white)
          ),
        ),
        
        actions: <Widget>[ButtonBar(children: <Widget>[Icon(Icons.ac_unit), Icon(Icons.star)],)],
      ),
      body: ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (BuildContext ctxt, int index){

          final item = widget.items[index];

          return Dismissible(
            child: CheckboxListTile(
              title: Text(item.title),
              
              value: item.done,
              onChanged: (value) {

                setState(() {
                item.done = value;
                save();
              });
            }),
            key: Key(item.title),
            background: Container(
              color: Colors.red.withOpacity(0.2),
              ),
              onDismissed: (direction) {
                remove(index);
              },
          );
        },


      ),
      floatingActionButton: FloatingActionButton(
        onPressed: add,
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,
    )
    );
  }
}



