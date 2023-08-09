import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:taskmanagement/src/providers/commonfun.dart';

import '../client_code/client_code.dart';
import 'package:taskmanagement/src/collection/userdata.dart';

//SIDEBAR
import 'package:taskmanagement/src/menu/menu_drawer.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _formKey = GlobalKey<FormState>();
  final _userOtp = TextEditingController();
  var userName = '';
  bool hasLoggedIn = false;

  @override
  void initState() {
    super.initState();
    asyncload();
  }

  asyncload() async {
    //print('dashboard called asyncload');
    dynamic userdata = await UserData();
    bool hasLoggedIn = await userdata.hasLoggedIn();
    //print('hasLoggedIn' + hasLoggedIn.toString());

    userName = await userdata.getByKey('username');
    print(userName);
    if (!hasLoggedIn) {
      await logout();
      return;
    }
  }

  logout() async {
    //print('Login logout call');
    dynamic userdata = await UserData();
    await userdata.logout();
    //print('login page call');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => ClientCode()),
      (Route<dynamic> route) =>
          false, //this is remove all prev. navi.back not working
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("Dashboard"),
          actions: [
            ElevatedButton(
              onPressed: () async {
                // Validate returns true if the form is valid, or false otherwise.

                if (_formKey.currentState!.validate()) {
                  //print(await getUUID());
                  await logout();
                }
              },
              child: Text('Log Out'),
            ),
          ],
        ),
        drawer: MenuDrawer(),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Container(
                            height: 200,
                            width: 200,
                            color: Colors.black,
                            margin: EdgeInsets.only(right: 11),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.white,
                                  size: 50,
                                ),
                                Text(
                                  'Star',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 200,
                            width: 200,
                            color: Colors.blue,
                            margin: EdgeInsets.only(right: 11),
                          ),
                          Container(
                            height: 200,
                            width: 200,
                            color: Colors.amber,
                            margin: EdgeInsets.only(right: 11),
                          ),
                          Container(
                            height: 200,
                            width: 200,
                            color: Colors.black,
                            margin: EdgeInsets.only(right: 11),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 200,
                    color: Colors.deepOrange,
                    margin: EdgeInsets.only(bottom: 11),
                  ),
                  Container(
                    height: 200,
                    color: Colors.blue,
                    margin: EdgeInsets.only(bottom: 11),
                  ),
                  Container(
                    height: 200,
                    color: Colors.teal,
                    margin: EdgeInsets.only(bottom: 11),
                  ),
                  Container(
                    height: 200,
                    color: Colors.deepOrange,
                    margin: EdgeInsets.only(bottom: 11),
                  ),
                  Container(
                    height: 200,
                    color: Colors.blue,
                    margin: EdgeInsets.only(bottom: 11),
                  ),
                  Container(
                    height: 200,
                    color: Colors.teal,
                    margin: EdgeInsets.only(bottom: 11),
                  ),
                  Container(
                    height: 200,
                    color: Colors.deepOrange,
                    margin: EdgeInsets.only(bottom: 11),
                  ),
                  Container(
                    height: 200,
                    color: Colors.blue,
                    margin: EdgeInsets.only(bottom: 11),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
