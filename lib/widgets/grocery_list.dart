import 'package:flutter/material.dart';
import 'package:shop_grocery_app/data/dummy_items.dart';
import 'package:shop_grocery_app/widgets/new_item.dart';

// class GroceryList extends StatelessWidget {
class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  //StatelessWidget class does not have a default context hence we need to accept the context in user defined function
  // void _addItem(BuildContext context){
  //   Navigator.of(context)...
  // }
  // not following this approach instead converting class to StatefulWidget

  void _addItem() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
      body: ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (ctx, index) => ListTile(
          title: Text(groceryItems[index].name),
          leading: Container(
            width: 24,
            height: 24,
            color: groceryItems[index].category.color,
          ),
          trailing: Text(
            groceryItems[index].quantity.toString(),
          ),
        ),
      ),
    );
  }
}
