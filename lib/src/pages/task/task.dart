import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../includes/env.api.dart';

import 'package:taskmanagement/src/collection/userdata.dart';
import 'package:taskmanagement/src/pages/task/wrapper.dart';

import 'package:get/get.dart';
import 'package:taskmanagement/src/providers/ListController.dart';

class Task extends StatefulWidget {
  final Function(int) onTabBarTapped;
  const Task({super.key, required this.onTabBarTapped});

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  final ListController listController = Get.find<ListController>();
  final Map mapData = {}.obs;

  final _formKey = GlobalKey<FormState>();
  bool hasLoggedIn = false;
  bool isLoading = false; // Track loading state
  bool isSubmitted = false; // Track submission state

  // Task Add Controller
  bool isEdit = false;
  Map<String, dynamic> responseData = {};
  TextEditingController taskIDController = TextEditingController();
  TextEditingController taskTypeController = TextEditingController();
  dynamic selectedTaskType = "";
  final List<DropdownMenuEntry<String>> taskTypeEntries =
      <DropdownMenuEntry<String>>[];

  TextEditingController taskPriorityController = TextEditingController();
  dynamic selectedTaskPriority = "";
  final List<DropdownMenuEntry<String>> taskPriorityEntries =
      <DropdownMenuEntry<String>>[];

  TextEditingController taskNameController = TextEditingController();
  TextEditingController taskTitleController = TextEditingController();
  TextEditingController taskDescriptionController = TextEditingController();

  TextEditingController taskStartDateController = TextEditingController();
  DateTime selectedStartDate = DateTime.now();

  TextEditingController taskStartTimeController = TextEditingController();
  TimeOfDay selectedStartTime = TimeOfDay.now();

  var beforeBtn = "Add";
  var afterBtn = "Adding";

  final FocusScopeNode _node = FocusScopeNode();

  @override
  void initState() {
    super.initState();
    taskStartDateController.text = "";
    taskStartTimeController.text = "";

    mapData.addAll(listController.mapData);
    if (mapData['id'] != 0) {
      isEdit = true;
      beforeBtn = "Update";
      afterBtn = "Updating";

      taskIDController.text = mapData['task_id'];
      taskTypeController.text = mapData['task_type'];
      taskPriorityController.text = mapData['task_priority'];
      taskNameController.text = mapData['task_name'];
      taskTitleController.text = mapData['title'];
      taskDescriptionController.text = mapData['task_desc'];

      DateTime tempStartDate =
          DateFormat("yyyy-MM-dd").parse(mapData['start_date']);
      String formattedStartDate =
          DateFormat('yyyy-MM-dd').format(tempStartDate);
      selectedStartDate = tempStartDate;
      taskStartDateController.text = formattedStartDate;

      final inputFormat = DateFormat('HH:mm:ss');
      final outputFormat = DateFormat('hh:mm a');

      final inputStartTime = mapData['start_time'];
      final startTime = inputFormat.parse(inputStartTime);
      final formattedStartTime = outputFormat.format(startTime);

      TimeOfDay startTimeConvert = TimeOfDay(
          hour: int.parse(inputStartTime.split(":")[0]),
          minute: int.parse(inputStartTime.split(":")[1]));
      selectedStartTime = startTimeConvert;
      taskStartTimeController.text = formattedStartTime;
    }

    getTaskTypeData();
    getTaskPriorityData();
  }

  @override
  void dispose() {
    taskIDController.dispose();
    taskNameController.dispose();
    taskTitleController.dispose();
    taskDescriptionController.dispose();
    taskStartDateController.dispose();
    taskStartTimeController.dispose();
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final dataHolder = TabDataHolder.of(context);

    return GestureDetector(
        onTap: () {
          // Hide keyboard when tapped outside of a text field
          _node.unfocus();
        },
        child: FocusScope(
            node: _node,
            child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: taskIDController,
                              //obscureText: true,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Task ID',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Task ID';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            DropdownMenu<String>(
                              //width: double.infinity,
                              width: MediaQuery.of(context).size.width - 24,
                              controller: taskTypeController,
                              label: const Text('Task Type'),
                              dropdownMenuEntries: taskTypeEntries,
                              onSelected: (String? value) {
                                setState(() {
                                  selectedTaskType = value;
                                });
                              },
                            ),
                            const SizedBox(height: 15),
                            DropdownMenu<String>(
                              width: MediaQuery.of(context).size.width - 24,
                              controller: taskPriorityController,
                              label: const Text('Task Priority'),
                              dropdownMenuEntries: taskPriorityEntries,
                              onSelected: (String? value) {
                                setState(() {
                                  selectedTaskPriority = value;
                                });
                              },
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: taskNameController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Task/Project Name',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Task/Project Name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: taskTitleController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Title',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Title';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: taskDescriptionController,
                              maxLines: 3,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Task Description',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Task Description';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Flexible(
                                  child: TextField(
                                      controller:
                                          taskStartDateController, //editing controller of this TextField
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          // icon:
                                          //     Icon(Icons.calendar_today), //icon of text field
                                          labelText:
                                              "Start Date" //label text of field
                                          ),
                                      readOnly:
                                          true, // when true user cannot edit text
                                      onTap: () async {
                                        //when click we have to show the datepicker
                                        DateTime? pickedStartDate =
                                            await showDatePicker(
                                                context: context,
                                                initialDate:
                                                    selectedStartDate, //get today's date
                                                firstDate: DateTime(
                                                    2000), //DateTime.now() - not to allow to choose before today.
                                                lastDate: DateTime(2101));

                                        if (pickedStartDate != null) {
                                          print(
                                              pickedStartDate); //get the picked date in the format => 2022-07-04 00:00:00.000
                                          String formattedStartDate =
                                              DateFormat('yyyy-MM-dd').format(
                                                  pickedStartDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                          print(
                                              formattedStartDate); //formatted date output using intl package =>  2022-07-04
                                          //You can format date as per your need
                                          DateTime tempStartDate =
                                              DateFormat("yyyy-MM-dd")
                                                  .parse(formattedStartDate);

                                          setState(() {
                                            selectedStartDate = tempStartDate;
                                            taskStartDateController.text =
                                                formattedStartDate; //set foratted date to TextField value.
                                          });
                                        }
                                      }),
                                ),
                                const SizedBox(
                                  width: 20.0,
                                ),
                                Flexible(
                                  child: TextField(
                                    controller:
                                        taskStartTimeController, //editing controller of this TextField
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        // icon: Icon(Icons.calendar_today), //icon of text field
                                        labelText:
                                            "Start Time" //label text of field
                                        ),
                                    readOnly:
                                        true, // when true user cannot edit text
                                    onTap: () async {
                                      final TimeOfDay? pickedStartTime =
                                          await showTimePicker(
                                        context: context,
                                        initialTime: selectedStartTime,
                                        builder: (BuildContext context,
                                            Widget? child) {
                                          return Theme(
                                            data: ThemeData.light(),
                                            child: child!,
                                          );
                                        },
                                      );

                                      /*TimeOfDay? pickedStartTime =
                                      await showTimePicker(
                                          context: context,
                                          initialTime: electedStartTime, //get today's date
                                       );*/

                                      if (pickedStartTime != null) {
                                        // ignore: use_build_context_synchronously
                                        String formattedStartTime =
                                            pickedStartTime.format(context);

                                        setState(() {
                                          selectedStartTime = pickedStartTime;
                                          taskStartTimeController.text =
                                              formattedStartTime;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            ElevatedButton(
                              onPressed: () async {
                                /*FilePickerResult? result = await FilePicker.platform.pickFiles(
                                  allowMultiple: true,
                                  type: FileType.custom,
                                  allowedExtensions: ['jpg', 'pdf', 'doc'],
                                );*/
                                /*if (result != null) {
                                  //List<File> files = result.paths.map((path) => File(path)).toList();
                                } else {
                                  // User canceled the picker
                                }*/
                              },
                              child: const Text('File Pick'),
                            ),
                            const SizedBox(height: 15),
                            Center(
                              child: SizedBox(
                                width: 135,
                                height: 45,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Validate returns true if the form is valid, or false otherwise.
                                    if (_formKey.currentState!.validate()) {
                                      // If the form is valid, display a snackbar. In the real world,
                                      // you'd often call a server or save the information in a database.
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text('Processing Data')),
                                      );
                                      if (!isLoading) {
                                        // Disable button while loading
                                        isEdit ? updateData() : submitData();
                                      }
                                    }
                                  },
                                  child: isLoading
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              afterBtn,
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            const SizedBox(width: 15),
                                            const SizedBox(
                                                width: 22,
                                                height: 22,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.white,
                                                )),
                                            //CircularProgressIndicator(color: Colors.white,),
                                          ],
                                        ) // Show loading indicator
                                      : Text(
                                          beforeBtn,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 50),
                          ],
                        ))))));
  }

  /* API CALL */

  /* Task Type DropDown Get API */
  var _tasktype = [];
  Future<void> getTaskTypeData() async {
    final userdata = UserData();
    final baseurl = await userdata.getByKey('clienturl');
    final mobileUuid = await userdata.getByKey('mobile_uuid');
    const fcm_token = "mobile_uuid_flutter_1";
    final mobileInfo = await userdata.getByKey('mobile_info');
    final mobilePlatform = await userdata.getByKey('mobile_platform');
    final userId = await userdata.getByKey('user_id');
    const user_type = 'admin';

    final packageInfo = await PackageInfo.fromPlatform();
    final appName = packageInfo!.packageName;
    final appVercode = packageInfo!.buildNumber;

    final url = baseurl +
        "taskmanagement/task_type_get.php" +
        "?mobile_uuid=" +
        mobileUuid +
        "&app_vercode=" +
        appVercode +
        "&user_type=" +
        user_type +
        "&user_id=" +
        userId +
        "&app_name=" +
        appName +
        "&encode=1" +
        "&app_token=1234";

    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as Map;
      final result = responseData['task_type_list']['data'];
      setState(() {
        _tasktype = result;
        _tasktype.map((type) {
          taskTypeEntries.add(DropdownMenuEntry<String>(
              value: type["task_type_id"], label: type["task_type"]));
        }).toList();
      });
    } else {
      print('Api Failed');
    }
  }

  /* Task Priority DropDown Get API */
  var _taskpriority = [];
  Future<void> getTaskPriorityData() async {
    final userdata = UserData();
    final baseurl = await userdata.getByKey('clienturl');
    final mobileUuid = await userdata.getByKey('mobile_uuid');
    const fcm_token = "mobile_uuid_flutter_1";
    final mobileInfo = await userdata.getByKey('mobile_info');
    final mobilePlatform = await userdata.getByKey('mobile_platform');
    final userId = await userdata.getByKey('user_id');
    const user_type = 'admin';

    final packageInfo = await PackageInfo.fromPlatform();
    final appName = packageInfo!.packageName;
    final appVercode = packageInfo!.buildNumber;

    final url = baseurl +
        "taskmanagement/task_priority_get.php" +
        "?mobile_uuid=" +
        mobileUuid +
        "&app_vercode=" +
        appVercode +
        "&user_type=" +
        user_type +
        "&user_id=" +
        userId +
        "&app_name=" +
        appName +
        "&encode=1" +
        "&app_token=1234";
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as Map;
      final result = responseData['task_priority_list']['data'];
      setState(() {
        _taskpriority = result;
        _taskpriority.map((priority) {
          taskPriorityEntries.add(DropdownMenuEntry<String>(
              value: priority["task_priority_id"],
              label: priority["task_priority"]));
        }).toList();
      });
    } else {
      print('Api Failed');
    }
  }

  /* Task Insert Post API */
  void submitData() async {
    setState(() {
      isLoading = true; // Start loading
    });

    final taskID = taskIDController.text;
    final taskType = taskTypeController.text;
    final taskPriority = taskPriorityController.text;
    final taskName = taskNameController.text;
    final taskTitle = taskTitleController.text;
    final taskDescription = taskDescriptionController.text;
    final taskStartDate = taskStartDateController.text;
    final taskStartTime = taskStartTimeController.text;

    final body = {
      "task_id": taskID,
      "task_type": taskType,
      "task_priority": taskPriority,
      "task_name": taskName,
      "title": taskTitle,
      "task_desc": taskDescription,
      "start_date": taskStartDate,
      "start_time": taskStartTime,
    };

    final uri = Uri.parse(await apiCall('POST', 'task.php'));
    final response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        'Accept': '*/*'
      },
      body: {"data": jsonEncode(body)},
    );

    if (response.statusCode == 200) {
      responseData = jsonDecode(response.body);
      if (responseData['status'] == 'success') {
        showMessenge(responseData['msg']);
        // Simulate API call or data insertion
        Future.delayed(const Duration(seconds: 3), () {
          setState(() {
            isLoading = false; // Stop loading
            isSubmitted = true; // Set submission state

            taskTypeController.text = '';
            taskPriorityController.text = '';
            taskNameController.text = '';
            taskTitleController.text = '';
            taskDescriptionController.text = '';
            taskStartDateController.text = '';
            taskStartTimeController.text = '';
            taskIDController.text = '';
          });
        });
      }
    } else {
      showMessenge('Api Failed');
    }
  }

  void updateData() async {
    setState(() {
      isLoading = true; // Start loading
    });

    if (mapData["id"] == 0) {
      print('You Can not Call Api Without ID fetch');
    }

    final id = mapData["id"];
    final taskID = taskIDController.text;
    final taskType = taskTypeController.text;
    final taskPriority = taskPriorityController.text;
    final taskName = taskNameController.text;
    final taskTitle = taskTitleController.text;
    final taskDescription = taskDescriptionController.text;
    final taskStartDate = taskStartDateController.text;
    final taskStartTime = taskStartTimeController.text;

    final body = {
      "task_id": taskID,
      "task_type": taskType,
      "task_priority": taskPriority,
      "task_name": taskName,
      "title": taskTitle,
      "task_desc": taskDescription,
      "start_date": taskStartDate,
      "start_time": taskStartTime,
    };

    final uri = Uri.parse(await apiCall('PUT', 'task.php', id: id));
    final response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        'Accept': '*/*'
      },
      body: {"data": jsonEncode(body)},
    );

    if (response.statusCode == 200) {
      responseData = jsonDecode(response.body);
      if (responseData['status'] == 'success') {
        showMessenge(responseData['msg']);
        // Simulate API call or data insertion
        // dataHolder.setState(() {
        //   dataHolder.data = null;
        // });
        //listController.clearData();

        Future.delayed(const Duration(seconds: 3), () {
          setState(() {
            isEdit = false;
            isLoading = false; // Stop loading
            isSubmitted = true; // Set submission state
          });
          widget.onTabBarTapped(0);
        });
      }
    } else {
      showMessenge('Api Failed');
    }
  }

  void showMessenge(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
}
