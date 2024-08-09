import 'dart:convert';

import 'package:http/http.dart ' as http;

import 'package:flutter/material.dart';
import 'package:flutter_form_user_input/data/categories.dart';
import 'package:flutter_form_user_input/models/category.dart';
import 'package:flutter_form_user_input/models/grocery_item.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});
  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formkey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredQuantity = 1;
  var _selectedCatagory = categories[Categories.vegetables]!;

  void saveitem() async{
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      final url=Uri.https('flutter-prep-c0a48-default-rtdb.firebaseio.com','shoping-app.json');


   final respose= await http.post(url,headers: {
        'Content-Type':'application/json',
      },body:json.encode({
        ' name': _enteredName,
          'quantity': _enteredQuantity,
          'category': _selectedCatagory.title,

      })  );

      print(respose.body);
      print(respose.statusCode);
      

      Navigator.of(context).pop();
        
        /* GroceryItem(
          id: DateTime.now().toString(),
          name: _enteredName,
          quantity: _enteredQuantity,
          category: _selectedCatagory)); */
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new Item to The List"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(label: Text('Name')),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length == 1) {
                    return 'Must be between 1 and 50 char';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) => {_enteredName = value!},
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      initialValue: _enteredQuantity.toString(),
                      decoration: const InputDecoration(
                        label: Text('Quantity'),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return 'Error Input ';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) =>
                          {_enteredQuantity = int.parse(value!)},
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                        hint: const Text('cataagories'),
                        value: _selectedCatagory,
                        items: [
                          for (final catagory in categories.entries)
                            DropdownMenuItem(
                                value: catagory.value,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      color: catagory.value.color,
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Text(catagory.value.title),
                                  ],
                                ))
                        ],
                        onChanged: (value) {
                          _selectedCatagory = value!;
                        }),
                  )
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _formkey.currentState!.reset();
                    },
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: saveitem,
                    child: const Text('Add Item'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
