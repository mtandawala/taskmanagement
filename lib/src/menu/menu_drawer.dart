import 'package:flutter/material.dart';
import 'package:taskmanagement/src/collection/userdata.dart';
//ROUTES
import 'package:taskmanagement/src/pages/dashboard/dashboard.dart';
import 'package:taskmanagement/src/pages/task/taskpage.dart';

userName() async {
  dynamic userdata = UserData();
  return await userdata.getByKey('username');
}

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: userName(),
        builder: (context, snapshot) {
          return Drawer(
            child: ListView(
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text((snapshot.hasData) ? snapshot.data : ''),
                  accountEmail: const Text('john.doe@example.com'),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  onTap: () {
                    // handle navigation to home
                    Navigator.pop(context); // Close the drawer
                    //Navigator.pushNamed(context, '/'); // Navigate to dashboard
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const DashboardPage()),
                      (Route<dynamic> route) => true,
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.task),
                  title: const Text('Task'),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    //Navigator.pushNamed(context, '/taskpage'); // Navigate to taskpage
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const TaskPage()),
                      (Route<dynamic> route) => true,
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    // handle navigation to settings
                  },
                ),
                Divider(),
                ListTile(
                  leading: const Icon(Icons.help),
                  title: const Text('Help'),
                  onTap: () {
                    // handle navigation to help
                  },
                ),
              ],
            ),
          );
        });
  }

}
