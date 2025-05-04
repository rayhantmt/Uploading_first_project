import 'package:flutter/material.dart';
import 'package:groceries/data/dummy_items.dart';
import 'package:groceries/models/grocery_item.dart';
import 'package:groceries/widgets/new_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<GroceryItem> _groceryitems = [];
  void additem() async {
  final newItem= await Navigator.push<GroceryItem>(
        context,
        MaterialPageRoute(
          builder: (context) => NewItem(),
        ));
        if(newItem==null){
          return;
        }
        setState(() {
          _groceryitems.add(newItem);
        });
  }
  void removeitem(GroceryItem item) {
    setState(() {
      _groceryitems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget x=Center(child: Text('No grocery selected yet'),);
if(_groceryitems.isNotEmpty){
  x=ListView.builder(
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
