import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_grocery_app/data/categories.dart';
import 'package:shop_grocery_app/models/category.dart';
import 'package:shop_grocery_app/models/grocery_item.dart';
import 'package:http/http.dart' as http;

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredQuantity = 1;
  var _selectedCategory = categories[Categories.vegetables]!;

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final url = Uri.https('flutter-prep-shopping-default-rtdb.firebaseio.com',
          'shopping-list.json');
      // firebase uses https--> so use Uri.https
      // shopping-list.json is the endpoint...basically this will create the subcollection(sub folder) in the realtime database Firebase

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'name': _enteredName,
            'quantity': _enteredQuantity.toString(),
            'category': _selectedCategory.title,
          },
        ),
      );
      // headers is used to tell the server that what type of data we are sending
      // application/json is used to tell the server that we are sending json data
      // Content-Type is the key and application/json is the value
      // body is used to send the data to the server
      // json.encode is used to convert the data into json format
      // we did not send id as firebase will automatically generate the id for us
      // async and await is used to wait for the response from the server
      // await is used for Future object

      // passing data back to GroceryList....using Navigator.pop(data)
      // Navigator.of(context).pop(
      //   GroceryItem(
      //       id: DateTime.now().toString(),
      //       name: _enteredName,
      //       quantity: _enteredQuantity,
      //       category: _selectedCategory),
      // ); // now getting access of data that u pass.... use async and await

      if (!context.mounted) {
        return;
      }
      // mounted because if the user navigates back before the response is received then we do not want to update the ui
      // mounted is a property of the state class which returns true if the widget is mounted on the screen
      // if the widget is not mounted then we do not want to update the ui
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text("Name"),
                ),

                // validator parameter is used to validate the input field and it takes a function as a parameter which returns a string as an error message
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 1 to 50 characters';
                  }
                  return null;
                },
                onSaved:
                    (value /*this will be the value at the time save is executed*/) {
                  _enteredName = value!;
                  // not need to wrap with setState method as i do not need any ui update...just wanna store the value and execute it after calling save
                },
              ), // instead of TextField
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text("Quantity"),
                      ),
                      initialValue: '1',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return 'Must be a valid positive number';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredQuantity = int.parse(value!);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                      items: [
                        // .entries returns a list of map entries
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: category.value.color,
                                ),
                                const SizedBox(width: 6),
                                Text(category.value.title),
                              ],
                            ),
                          )
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                    },
                    child: const Text("Reset"),
                  ),
                  // const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _saveItem,
                    child: const Text("Add item"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
