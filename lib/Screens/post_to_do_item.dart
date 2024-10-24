import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/Models/todo_model.dart';
import 'package:todo_list/Utilities/db_helper.dart';

class PostToDoItem extends StatefulWidget {
  TodoModel todoModel;
  String appBarTitle;
  PostToDoItem(this.todoModel, this.appBarTitle, {super.key});

  @override
  State<PostToDoItem> createState() =>
      _PostToDoItemState(this.todoModel, this.appBarTitle);
}

class _PostToDoItemState extends State<PostToDoItem> {
  TodoModel todoModel;
  String appBarTitle;

  var _statusesList = ["Pending", "Completed"];
  var selectedStatus = "Pending";

  TextEditingController _titleEditingController = TextEditingController();
  TextEditingController _descriptionEditingController = TextEditingController();

  _PostToDoItemState(this.todoModel, this.appBarTitle);
  @override
  void initState() {
    selectedStatus = todoModel.status.length == 0 ? "Pending" : todoModel.status;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    _titleEditingController.text = todoModel.title;
    _descriptionEditingController.text = todoModel.description;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarTitle,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            DropdownButton(
                value: selectedStatus,
                items: _statusesList.map((item) {
                  return DropdownMenuItem(child: Text(item), value: item);
                }).toList(),
                onChanged: (item) {
                  setState(() {
                    selectedStatus = item!;
                  });
                }),
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: 20.0,
                      left: 10.0,
                      right: 10.0), // Top margin for the first TextField
                  child: TextField(
                    controller: _titleEditingController,
                    decoration: InputDecoration(
                        hintText: "Enter title",
                        labelText: "Title",
                        border: OutlineInputBorder()),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: 20.0,
                      left: 10.0,
                      right: 10.0), // Top margin for the second TextField
                  child: TextField(
                    controller: _descriptionEditingController,
                    decoration: InputDecoration(
                        hintText: "Enter description",
                        labelText: "Description",
                        border: OutlineInputBorder()),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
                  child: ElevatedButton(
                      onPressed: () {
                        validate();
                      },
                      child: Text(
                        appBarTitle,
                        style: TextStyle(color: Colors.black),
                      )),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  validate() {
    todoModel.title = _titleEditingController.text;
    todoModel.description = _descriptionEditingController.text;
    todoModel.status = selectedStatus;
    todoModel.date = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Correct way to access the singleton instance of DataBaseHelper
    DataBaseHelper dataBaseHelper = DataBaseHelper();
      // Insert the todoModel into the database
      if(todoModel.id == null) {
        dataBaseHelper.insert(todoModel);
      } else {
      // Handle error if title or description is empty
      print("Title or Description cannot be empty!");
      dataBaseHelper.updateItem(todoModel);
    }
    Navigator.pop(context, true);
    // You can now use the instance of dataBaseHelper to perform DB operations.
  }
}
