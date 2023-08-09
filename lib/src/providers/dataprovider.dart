import 'package:http/http.dart' as http;
import 'package:taskmanagement/src/collection/userdata.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:taskmanagement/src/providers/useragentclient.dart';

class DataProvider {
  late dynamic userdata;
  String? baseurl  ;
  String? mobile_uuid ;

  String? fcm_token  ;
  String? mobile_info  ;
  String? mobile_platform  ;
  String? user_id  ;

  String? app_name  ;
  String? app_vercode ;

  //user_type
  //company_id
  //site_id
  //app_token

  DataProvider() {
    initcall();
  }
  Future<void> initcall() async {
    this.userdata = await UserData();

    if (this.baseurl == null)
      this.baseurl = await userdata.getByKey('clienturl');
    //"http://192.168.1.246/nway_erp/mobile/";
    if (this.mobile_uuid == null)
      this.mobile_uuid = await userdata.getByKey('mobile_uuid');
    if (this.fcm_token == null) this.fcm_token = "mobile_uuid_flutter_1";
    if (this.mobile_info == null)
      this.mobile_info = await userdata.getByKey('mobile_info');
    if (this.mobile_platform == null)
      this.mobile_platform = await userdata.getByKey('mobile_platform');
    if (this.user_id == null)
      this.user_id = await userdata.getByKey('user_id');

    var packageInfo = await PackageInfo.fromPlatform();
    if (this.app_name == null) this.app_name = packageInfo!.packageName;
    if (this.app_vercode == null) this.app_vercode = packageInfo!.buildNumber;
    //appName = packageInfo!.appName;
    //version = packageInfo!.version;
  }

  Future<dynamic> getLogin(String _userName, String _userpassword) async {
    await initcall();

    String para = "";
    para = para + "txtUserName=" + Uri.encodeComponent(_userName);
    para = para + "&txtuserpass=" + Uri.encodeComponent(_userpassword);
    para = para + "&mobile_uuid=" + Uri.encodeComponent(mobile_uuid!);
    para = para + "&app_name=" + app_name!;

    String url = baseurl! + "/get_logon.php?" + para;
print(url);
    final client = UserAgentClient(http.Client());
    final response = await client.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      // body: jsonEncode(<String, String>{
      //   'txtclient_code': clientCode,
      // }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return response.body;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to login.');
    }
  }

  Future<dynamic> getOtp(String _userOtp) async {
    await initcall();

    String para = "";
    para = para + "txtOtp=" + _userOtp;
    para = para + "&user_id=" + user_id!;
    para = para + "&fcm_token=" + Uri.encodeComponent(fcm_token!);
    para = para + "&mobile_uuid=" + Uri.encodeComponent(mobile_uuid!);
    para = para + "&mobile_platform=" + Uri.encodeComponent(mobile_platform!);
    para = para + "&mobile_info=" + Uri.encodeComponent(mobile_info!);
    para = para + "&app_name=" + app_name!;

    String url = baseurl! + "/get_logon_otp_verify.php?" + para;

    final client = UserAgentClient(http.Client());
    final response = await client.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      // body: jsonEncode(<String, String>{
      //   'txtclient_code': clientCode,
      // }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return response.body;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to login.');
    }
  }

  Future<dynamic> createCode(String clientCode) async {
    await initcall();

    String url =
        'http://192.168.1.246/nway_erp/mobile/client_post.php?txtclient_code=$clientCode';

    //url = "https://nwayapp.nwayerp.in/client_post.php?txtclient_code=$clientCode'";
    final client = UserAgentClient(http.Client());

    final response = await client.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      // body: jsonEncode(<String, String>{
      //   'txtclient_code': clientCode,
      // }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return response.body;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create Client Code.');
    }
  }
}
