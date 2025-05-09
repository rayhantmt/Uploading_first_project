import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:groceries/data/categories.dart';
import 'package:groceries/models/grocery_item.dart';
import 'package:groceries/widgets/new_item.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loaditems();
  }

   List<GroceryItem> _groceryitems = [];
  void _loaditems() async {
    final url = Uri.https(
        'flutterdemo-2ff5e-default-rtdb.firebaseio.com', 'Shopping-list.json');
    final response = await http.get(url);
    final Map<String, dynamic> listdata = json.decode(response.body);
    final List<GroceryItem> _loadeditems = [];
    for (var item in listdata.entries) {
      final category = categories.entries
          .firstWhere(
              (element) => element.value.title == item.value['category'])
          .value;
      _loadeditems.add(GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category));
    }
    setState(() {
      _groceryitems=_loadeditems;
    });
  }

  void additem() async {
    await Navigator.push<GroceryItem>(
        context,
        MaterialPageRoute(
          builder: (context) => NewItem(),
        ));
    _loaditems();
  }

  void removeitem(GroceryItem item) {
    setState(() {
      _groceryitems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget x = Center(
      child: Text('No grocery selected yet'),
    );
    if (_groceryitems.isNotEmpty) {
      x = ListView.builder(
          itemCount: _groceryitems.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: ValueKey(_groceryitems[index].id),
              onDismissed: (direction) {
                removeitem(_groceryitems[index]);
              },
              child: ListTile(
                title: Text(_groceryitems[index].name),
                leading: Container(
                  height: 24,
                  width: 24,
                  color: _groceryitems[index].category.color,
                ),
                trailing: Text(_groceryitems[index].quantity.toString()),
              ),
            );
          });
    }

    return Scaffold(
      backgroundColor: ThemeData.dark().scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Your Groceries'),
        actions: [IconButton(onPressed: additem, icon: Icon(Icons.add))],
      ),
      body: x,
    );
  }
}
