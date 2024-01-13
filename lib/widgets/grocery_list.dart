import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_grocery_app/data/categories.dart';
// import 'package:shop_grocery_app/data/dummy_items.dart';
import 'package:shop_grocery_app/models/grocery_item.dart';
import 'package:shop_grocery_app/widgets/new_item.dart';
import 'package:http/http.dart' as http;

// class GroceryList extends StatelessWidget {
class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  // final List<GroceryItem> _groceryItems = [];
  List<GroceryItem> _groceryItems = [];

  //StatelessWidget class does not have a default context hence we need to accept the context in user defined function
  // void _addItem(BuildContext context){
  //   Navigator.of(context)...
  // }
  // not following this approach instead converting class to StatefulWidget

  // void _addItem() {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (ctx) => const NewItem(),
  //     ),
  //   );
  // }

  @override
  void initState() {
    super.initState();
    _loadItem();
  }
  // initState is created because we need to load the data from the server when the app starts and not when the user navigates back from the newItem screen

  // Using async and await to access the returned data from newItem screen
  void _addItem() async {
    // final newItem =
    //     await Navigator.of(context).push< /*return data type*/ GroceryItem>(
    //   MaterialPageRoute(
    //     builder: (ctx) => const NewItem(),
    //   ),
    // );

    // if (newItem == null) {
    //   return;
    // }

    // setState(() {
    //   _groceryItems.add(newItem);
    //   // wrapped in setState because it after addition ui needs to be changed
    // });

    // WAITING FOR THE User come back from the newItem screen
    await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );

    // NOW WE ARE BACK FROM THE newItem screen
    // NOW WE NEED TO FETCH THE DATA FROM THE SERVER
    // WE WILL USE GET REQUEST TO FETCH THE DATA FROM THE SERVER
    // final url = Uri.https('flutter-prep-shopping-default-rtdb.firebaseio.com',
    //     'shopping-list.json');
    // final response = await http.get(url);
    // print(response.body);

    _loadItem();
  }

  // I need to load the data from the server when the app starts and not when the user navigates back from the newItem screen
  void _loadItem() async {
    final url = Uri.https('flutter-prep-shopping-default-rtdb.firebaseio.com',
        'shopping-list.json');
    final response = await http.get(url);
    // print(response.body);

    // now we need to convert the json data into dart object
    final Map<String, dynamic> listData = json.decode(response.body);
    final List<GroceryItem> loadedItems = [];
    for (final item in listData.entries) {
      final category = categories.entries
          .firstWhere(
              (element) => element.value.title == item.value['category'])
          .value;
      // categories.entries is a list of map entries, so we are using firstWhere to find the first element that matches the condition and then we are storing the value of that element in category variable
      loadedItems.add(
        GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: int.parse(item.value['quantity']),
          category: category,
        ),
      );
    }
    setState(() {
      _groceryItems = loadedItems;
    });
  }

  void removeItem(GroceryItem item) {
    setState(() {
      _groceryItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text("No Items added yet..."),
    );

    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        // itemCount: groceryItems.length,//dummy data
        itemBuilder: (ctx, index) => Dismissible(
          onDismissed: (direction) {
            removeItem(_groceryItems[index]);
          },
          key: ValueKey(_groceryItems[index].id),
          child: ListTile(
            title: Text(_groceryItems[index].name),
            leading: Container(
              width: 24,
              height: 24,
              color: _groceryItems[index].category.color,
            ),
            trailing: Text(
              _groceryItems[index].quantity.toString(),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Groceries"),

        //adding a button that will help me navigate to newItemScreen
        actions: [
          IconButton(
            // onPressed: (){
            //   _addItem(context);
            // },

            onPressed: _addItem,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      // body: ListView.builder(
      //   itemCount: _groceryItems.length,
      //   // itemCount: groceryItems.length,//dummy data
      //   itemBuilder: (ctx, index) => ListTile(
      //     title: Text(_groceryItems[index].name),
      //     leading: Container(
      //       width: 24,
      //       height: 24,
      //       color: _groceryItems[index].category.color,
      //     ),
      //     trailing: Text(
      //       _groceryItems[index].quantity.toString(),
      //     ),
      //   ),
      // ),
      body: content,
    );
  }
}
