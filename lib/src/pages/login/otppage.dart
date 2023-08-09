import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:taskmanagement/src/collection/userdata.dart';
import 'package:taskmanagement/src/providers/dataprovider.dart';

import '../dashboard/dashboard.dart';

class OtpPage extends StatefulWidget{
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();

}


class _OtpPageState extends State<OtpPage> {
  final _formKey = GlobalKey<FormState>();
  final _userOtp = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(
        body:  Form(
          key: _formKey,
          child: Padding(
              padding: const EdgeInsets.all(11.8),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _userOtp,
                      //obscureText: true,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Otp',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Otp';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height:15),
                    ElevatedButton(onPressed: () async{

                      // Validate returns true if the form is valid, or false otherwise.

                      if (_formKey.currentState!.validate()) {
                        dynamic resp = await DataProvider().getOtp(_userOtp.text);

                        try {
                          resp = json.decode(resp);

                        } catch (e, s) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Json Error:"+resp.toString())),
                          );
                          return ;
                        }
                        if( resp['status']?.isEmpty ?? true ){
                          //check empty or null
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error:"+resp.toString())),
                          );
                          return ;
                        }
                        if( resp['status'] != "success" ){
                          if( resp['msg'] != "" ) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error:" + resp['msg'].toString())),
                            );
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error:" + resp.toString())),
                            );
                          }
                          return ;
                        }

                        //after success
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(resp['status'].toString())),
                        );

                        dynamic userdata = await UserData();
                        await userdata.logged( resp['data'].toString() );

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DashboardPage()
                          ),
                              (Route<dynamic> route) => false, //this is remove all prev. navi.back not working
                        );


                      }
                    }, child: Text("Submit"))
                  ]
              )
          ),
        )
    );
  }

}

