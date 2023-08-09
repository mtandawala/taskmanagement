import 'package:flutter/material.dart';
import '../client_code/client_code.dart';
import 'package:taskmanagement/src/collection/userdata.dart';

//SIDEBAR
import 'package:taskmanagement/src/menu/menu_drawer.dart';

//PAGES ROUTES
import 'package:taskmanagement/src/pages/task/task.dart';
import 'package:taskmanagement/src/pages/task/tasklist.dart';
import 'package:taskmanagement/src/pages/task/wrapper.dart';

import 'package:get/get.dart';
import 'package:taskmanagement/src/providers/ListController.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});
  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage>
    with SingleTickerProviderStateMixin {
  final ListController listController = Get.put(ListController());
  late TabController _tabController;

  final _formKey = GlobalKey<FormState>();
  bool hasLoggedIn = false;

  int bottomTabSelectedIndex = 0;
  bool isEdit = false;
  var task_text = "Add Task";

  //final ScrollController _homeController = ScrollController();
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void onTabBarTapped(int index) {
    setState(() {
      if (index != 1) {
        listController.clearData();
      }
      _nextPage(index);
    });
  }

  void onBottomTabBarTapped(int index) {
    /*switch (index) {
      case 0:
      // only scroll to top when current index is selected.
        if (bottomTabSelectedIndex == index) {
          _homeController.animateTo(
            0.0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
        }
    }*/
    setState(() {
      bottomTabSelectedIndex = index;
    });
  }

  late final List<Tab> taskTabs = <Tab>[
    const Tab(text: 'My Tasks'),
    Tab(text: task_text),
    const Tab(
        child: Align(
          alignment: Alignment.center,
          child: Text('Tasks\nAssigned\nby Me', textAlign: TextAlign.center,),
        ),
    ),
    const Tab(text: 'Alerts'),
  ];

  late final List<Widget> taskTabBarView = <Widget>[
    TabBarView(
      controller: _tabController,
      children: [
        TaskList(onTabBarTapped: onTabBarTapped),
        Task(onTabBarTapped: onTabBarTapped),
        const Center(
          child: Text(
            "Task Assigned by Me",
            textAlign: TextAlign.center,
            style: optionStyle,
          ),
        ),
        const Center(
          child: Text(
            "Alerts",
            textAlign: TextAlign.center,
            style: optionStyle,
          ),
        ),
      ],
    ),
    const Center(
      child: Text(
        'Approval',
        style: optionStyle,
      ),
    ),
    const Center(
      child: Text(
        'Reports',
        style: optionStyle,
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    asyncload();
    _tabController =
        TabController(vsync: this, length: taskTabs.length, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  //method to set the page. This method is very important.
  void _nextPage(int tab) {
    final int newTab = _tabController.index = tab;
    if (newTab < 0 || newTab >= _tabController.length) return;
    _tabController.animateTo(newTab);
  }

  asyncload() async {
    //print('dashboard called asyncload');
    dynamic userdata = UserData();
    bool hasLoggedIn = await userdata.hasLoggedIn();
    //print('hasLoggedIn' + hasLoggedIn.toString());

    if (!hasLoggedIn) {
      await logout();
      return;
    }
  }

  logout() async {
    //print('Login logout call');
    dynamic userdata = UserData();
    await userdata.logout();
    //print('login page call');

    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const ClientCode()),
      (Route<dynamic> route) =>
          false, //this is remove all prev. navi.back not working
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          tabs: taskTabs,
        ),
        title: const Text("Task"),
        actions: [
          ElevatedButton(
            onPressed: () async {
              // Validate returns true if the form is valid, or false otherwise.
              if (_formKey.currentState!.validate()) {
                //print(await getUUID());
                await logout();
              }
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
      drawer: MenuDrawer(),
      body: taskTabBarView.elementAt(bottomTabSelectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline_rounded),
            label: 'Approval',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Reports',
          ),
        ],
        currentIndex: bottomTabSelectedIndex,
        selectedItemColor: Colors.blue,
        onTap: onBottomTabBarTapped,
      ),
    );
  }
}
