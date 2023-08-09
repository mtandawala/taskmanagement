import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:taskmanagement/src/collection/userdata.dart';
import 'package:taskmanagement/src/pages/login/otppage.dart';
import 'package:taskmanagement/src/providers/dataprovider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _userName = TextEditingController();
  final _userpassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Form(
      key: _formKey,
      child: Padding(
          padding: const EdgeInsets.all(11.8),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextFormField(
              controller: _userName,
              //obscureText: true,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'User Name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter User Name';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _userpassword,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter password';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            ElevatedButton(
                onPressed: () async {
                  // Validate returns true if the form is valid, or false otherwise.

                  if (_formKey.currentState!.validate()) {
                    dynamic resp = await DataProvider()
                        .getLogin(_userName.text, _userpassword.text);
                    print(resp);
                    try {
                      resp = json.decode(resp);
                    } catch (e, s) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("Json Error:" + resp.toString())),
                      );
                      return;
                    }
                    if (resp['status']?.isEmpty ?? true) {
                      //check empty or null
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error:" + resp.toString())),
                      );
                      return;
                    }
                    if (resp['status'] != "success") {
                      if (resp['msg'] != "") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text("Error:" + resp['msg'].toString())),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error:" + resp.toString())),
                        );
                      }
                      return;
                    }

                    //after success
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(resp['status'].toString())),
                    );

                    dynamic userdata = await UserData();
                    await userdata.setUser(
                        _userName.text, jsonEncode(resp['data']));
                    print(await userdata.getByKey('clienturl'));

                    //this.userData.setUser(this.login.username, this.xx.data );

                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => OtpPage()));
                  }
                },
                child: Text("Submit"))
          ])),
    ));
  }
}
