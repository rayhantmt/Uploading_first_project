import 'package:flutter/material.dart';
import 'package:groceries/data/categories.dart';

import 'package:groceries/models/category.dart';
import 'package:groceries/models/grocery_item.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formkey = GlobalKey<FormState>();
  var _enteredname = '';
  var _enteredquantity = 1;
  var _selectedcatagory = categories[Categories.vegetables]!;
  void _saveitem() {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      Navigator.of(context).pop(GroceryItem(
          id: DateTime.now().toString(),
          name: _enteredname,
          quantity: _enteredquantity,
          category: _selectedcatagory));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Items'),
      ),
      // backgroundColor: Colors.red,
      body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
              key: _formkey,
              child: Column(
                children: [
                  TextFormField(
                    onSaved: (newValue) {
                      _enteredname = newValue!;
                    },
                    maxLength: 50,
                    decoration: InputDecoration(
                      label: Text('Name'),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().length == 1 ||
                          value.trim().length > 50) {
                        return 'Must be between 1 and 50 characters.';
                      }
                      return null;
                    },
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(label: Text('Quantity')),
                          initialValue: _enteredquantity.toString(),
                          onSaved: (newValue) {
                            _enteredquantity = int.parse(newValue!);
                          },
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                int.tryParse(value) == null ||
                                int.tryParse(value)! <= 0) {
                              return 'Must be a valid, positive number.';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: DropdownButtonFormField(
                          value: _selectedcatagory,
                         
                          items: [
                            for (final category in categories.entries)
                              DropdownMenuItem(
                                value: category.value,
                                  child: Row(
                                children: [
                                  Container(
                                    height: 16,
                                    width: 16,
                                    color: category.value.color,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(category.value.title)
                                ],
                              ))
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedcatagory = value!;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            _formkey.currentState!.reset();
                          },
                          child: Text('Reset')),
                      ElevatedButton(
                          onPressed: _saveitem, child: Text('Add Item'))
                    ],
                  )
                ],
              ))),
    );
  }
}
