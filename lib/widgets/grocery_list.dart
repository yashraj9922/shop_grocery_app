import 'package:flutter/material.dart';
// import 'package:shop_grocery_app/data/dummy_items.dart';
import 'package:shop_grocery_app/models/grocery_item.dart';
import 'package:shop_grocery_app/widgets/new_item.dart';

// class GroceryList extends StatelessWidget {
class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryItems = [];

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

  // Using async and await to access the returned data from newItem screen
  void _addItem() async {
    final newItem =
        await Navigator.of(context).push< /*return data type*/ GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );

    if (newItem == null) {
      return;
    }

    setState(() {
      _groceryItems.add(newItem);
      // wrapped in setState because it after addition ui needs to be changed
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
