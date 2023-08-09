import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../includes/env.api.dart';
import 'package:taskmanagement/src/pages/task/wrapper.dart';

import 'package:get/get.dart';
import 'package:taskmanagement/src/providers/ListController.dart';

class TaskList extends StatefulWidget {
  final Function(int) onTabBarTapped;
  const TaskList({super.key, required this.onTabBarTapped});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final ListController listController = Get.put(ListController());
  List<dynamic> items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listController.clearData();
    getListData();
  }

  @override
  Widget build(BuildContext context) {
    //final dataHolder = TabDataHolder.of(context);

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index] as Map;
          final id = item['id'];
          return ListTile(
            leading: CircleAvatar(
              child: Text('${index + 1}'),
            ),
            title: Text(item['title']),
            subtitle: Text(item['task_name']),
            trailing: PopupMenuButton(
              onSelected: (value) {
                if (value == 'Edit') {
                  // dataHolder.setState(() {
                  //   dataHolder.data = item;
                  // });

                  listController.editData(item);
                  widget.onTabBarTapped(1);
                } else if (value == 'Delete') {

                  showAlertDialog(context, id);
                }
              },
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(
                    value: 'Edit',
                    child: Text('Edit'),
                  ),
                  const PopupMenuItem(
                    value: 'Delete',
                    child: Text('Delete'),
                  ),
                ];
              },
            ),
          );
        },
      ),
    );
  }

  showAlertDialog(BuildContext context, id) {
    // set up the buttons
    Widget cancelButton = TextButton (
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );
    Widget continueButton = TextButton (
      child: Text("Continue"),
      onPressed:  () {
        deleteById(id);
        Navigator.of(context).pop(); // dismiss dialog
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete Task"),
      content: Text("Are you want to delete this task?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> _onRefresh() async {
    //await Future.delayed(const Duration(seconds: 2));
    getListData();
    setState(() {});
  }

  Future<void> navigateToEdit(Map item) async {
    /*Navigator.pushReplacement(context,  MaterialPageRoute(
      builder: (context) => TaskPage(editTask:item, initialPage:1),
    )
    );*/

    /*Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
      return TaskPage(editTask:item, initialPage: 1);
    }));*/
  }

  Future<void> getListData() async {
    var response = await http.get(Uri.parse(await apiCall('GET', 'task.php')));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map;
      final result = jsonData['task_list']['data'];
      setState(() {
        items = result;
      });
    } else {
      print('Api Failed');
    }
  }

  Future<void> deleteById(id) async {
    final uri = Uri.parse(await apiCall('DELETE', 'task.php', id: id));
    final response = await http.post(headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      'Accept': '*/*'
    }, uri);

    if (response.statusCode == 200) {
      final filtered = items.where((element) => element['id'] != id).toList();
      setState(() {
        items = filtered;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Task Delete Successfully.')),
      );

    } else {
      print('Api Failed');
    }
  }
}