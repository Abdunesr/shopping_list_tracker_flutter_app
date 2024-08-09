import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_form_user_input/models/grocery_item.dart';
import 'package:flutter_form_user_input/screen/form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<GroceryItem> _groceryItems = [];

  @override
  void initState() {
    
    super.initState();
    _loadItem();
  }





  void _loadItem() async{
    final url=Uri.https('flutter-prep-c0a48-default-rtdb.firebaseio.com','shoping-app.json');
    final respose= await http.get(url);
    print(respose.body);
   

  }
  void _addItem() async {
     await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(builder: (ctx) => const FormScreen()),
    );

   _loadItem();

   /*  if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(newItem);
    }); */
  }

  void _removeItem(GroceryItem item){
setState(() {
   _groceryItems.remove(item);
  
});
   
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
              title: const Text('Groceries List'),
              actions: [
                IconButton(
                  onPressed: _addItem,
                  icon: const Icon(Icons.add),
                )
              ],
            ),
            body:_groceryItems.isEmpty
            ? const Center(
            child: Text('uh there is nothig here'),
          ): ListView.builder(
              itemCount: _groceryItems.length,
              itemBuilder: (ctx, index) => Dismissible(
                background: Container(color:Colors.red),
                key: ValueKey(_groceryItems[index].id),
                onDismissed: (direction){
                  _removeItem(_groceryItems[index]);
                  

                },
                child: ListTile(
                  title: Text(_groceryItems[index].name),
                  leading: Container(
                    width: 50,
                    height: 50,
                    color: _groceryItems[index].category.color,
                  ),
                ),
              ),
            ),
          );
  }
}
