import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:taskmanagement/src/collection/userdata.dart';
import 'package:taskmanagement/src/pages/login/login.dart';
import 'package:taskmanagement/src/providers/dataprovider.dart';
class ClientCode extends StatefulWidget {
  const ClientCode({super.key});

  @override
  State<ClientCode> createState() => _ClientCodeState();
}

class _ClientCodeState extends State<ClientCode> {
  final _formKey = GlobalKey<FormState>();
  final _clinetOtp = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(11.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _clinetOtp,
                //obscureText: true,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Client Code',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Client Code';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    // Validate returns true if the form is valid, or false otherwise.
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   const SnackBar(content: Text('Processing Data')),
                    // );
                    if (_formKey.currentState!.validate()) {

                      dynamic resp = await DataProvider().createCode(_clinetOtp.text);

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

                            // String x = resp['data'].toString();
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   SnackBar(content: Text(x)),
                            // );

                      dynamic userdata = await UserData();
                      await userdata.setClientUrl( _clinetOtp.text , resp['data'].toString() );
                      await userdata.fn_other_mobile_data_before_login();

                      print(await userdata.getByKey('clienturl'));
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));


                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//
// class Code {
//   final String status;
//   final String msg;
//   final String data;
//
//   const Code({required this.status, required this.msg, required this.data});
//
//   factory Code.fromJson(Map<String, dynamic> json) {
//     return Code(
//       status: json['status'],
//       msg: json['msg'],
//       data: json['data'],
//     );
//   }
// }
//
//
//

