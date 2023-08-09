import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:taskmanagement/src/providers/commonfun.dart';

class UserData {
   SharedPreferences? prefs;
   String HAS_LOGGED_IN = 'hasLoggedIn';
   String HAS_SEEN_TUTORIAL = 'hasSeenTutorial';


  _open() async {
    if(this.prefs == null) {
      this.prefs = await SharedPreferences.getInstance();
    }
  }
  Future<void> setClientUrl(String clientcode,String clienturl) async {
    await this._open();
    await this.prefs!.setString('clientcode', clientcode);
    await this.prefs!.setString('clienturl', clienturl);
  }

   void setUser(String username,dynamic userdata) async {
    //before otp varified
     await this._open();
     await this.prefs!.setString("userdata", userdata.toString());
     await this.prefs!.setString("username", username);

     String jsonsDataString = userdata.toString();
     final jsonData = jsonDecode(jsonsDataString);

     await this.prefs!.setString("user_id", jsonData['user_id'].toString());
   }


   void logged(dynamic logindata ) async {
     //after opt varified
     await this._open();
     await this.prefs!.setString("logindata", logindata);
     await this.prefs!.setBool(HAS_LOGGED_IN, true);
     //this.events.publish('user:login');
   }


   Future<bool?> hasLoggedIn()  async {
     await this._open();

     if( (await this.prefs!.getBool(HAS_LOGGED_IN) ?? false) != true){
       await this.prefs!.setBool(HAS_LOGGED_IN, false);
     }
     return this.prefs!.getBool(HAS_LOGGED_IN);
   }


   void setByKeyString(String key,String value) async  {
     await this._open();
     await this.prefs!.setString(key, value);
   }

   dynamic getByKey(String key) async  {
     await this._open();
     return await this.prefs!.get(key);
   }
   void logout() async {
     await this._open();
     await this.prefs!.clear();
     //this.events.publish('user:logout');

  }
   void fn_other_mobile_data_before_login() async {
      if( await this.getByKey('mobile_uuid') == null){
        //serial: this.device.serial,
        //isVirtual: this.device.isVirtual,
        Map<String, dynamic> device = await getMobileInfo();


        dynamic mobile_info = {
          "uuid": await getUUID() ,
          "serial": device['serial'],
          "isVirtual": device['isVirtual'],
          "platform": getPlatform(),
          //"navigator_platform": getPlatform(),
          "browser": device['browser'],
          "version": device['version'],
          "model": device['model'],
          "manufacturer": device['manufacturer'],
          //local_ip: local_ip,
          //public_ip: public_ip,
          //sim_info: this.sim_info,
        };

        setByKeyString('mobile_info', mobile_info.toString() );
        setByKeyString('mobile_uuid', await getUUID() ?? '' );
        setByKeyString('mobile_platform', getPlatform());

      }
   }
}