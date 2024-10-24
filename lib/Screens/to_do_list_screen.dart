import 'package:flutter/material.dart';
import 'package:todo_list/Models/todo_model.dart';
import 'package:todo_list/Screens/post_to_do_item.dart';
import 'package:todo_list/Utilities/db_helper.dart';

class ToDoListScreen extends StatefulWidget {
  const ToDoListScreen({super.key});

  @override
  State<ToDoListScreen> createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  DataBaseHelper dataBaseHelper = DataBaseHelper();
  List<TodoModel> _todoList = [];
  int count = 0;

  GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    updateListview(); // Call to update the list when the screen is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: const Text(
          "To Do List",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: populatedListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigationToDetailsView(TodoModel("", "", "", ""), "Add new task");
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Future<void> updateListview() async {
    List<TodoModel> todoList = await dataBaseHelper.getModelsFromMapList();
    setState(() {
      _todoList = todoList;
      count = _todoList.length; // Update count after fetching the data
    });
  }

  ListView populatedListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (context, index) {
        return Card(
          color:
              _todoList[index].status == "Pending" ? Colors.red : Colors.green,
          elevation: 5,
          child: ListTile(
            title: Text(_todoList[index].title),
            subtitle: Text(_todoList[index].description),
            leading: _todoList[index].status == "Pending"
                ? const Icon(Icons.remove_done)
                : const Icon(Icons.done_all),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // Pass the actual todoModel instance to deleteItem
                deleteItem(_todoList[index]);
              },
            ),
            onTap: () {
              navigationToDetailsView(_todoList[index], "Update Item");
            },
          ),
        );
      },
    );
  }

  deleteItem(TodoModel todoModel) async {
    int result = await dataBaseHelper.deleteItem(todoModel);
    if (result != 0) {
      // Use ScaffoldMessenger for showing snack bars
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Item deleted successfully")),
      );
      updateListview();
    }
  }

  // Correct method for navigation
  Future<void> navigationToDetailsView(
      TodoModel todoModel, String appBarTitle) async {
    bool? results = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          // Navigating to the PostToDoItem screen
          return PostToDoItem(todoModel, appBarTitle);
        },
      ),
    );
    if (results == true) {
      await updateListview(); // Update the list after returning
    }
  }
}
