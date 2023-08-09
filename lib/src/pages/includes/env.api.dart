import 'package:package_info_plus/package_info_plus.dart';
import 'package:taskmanagement/src/collection/userdata.dart';

dynamic apiCall(dynamic method, dynamic apiPage, {dynamic id = 0}) async {
  final userdata =  UserData();
  final baseurl = await userdata.getByKey('clienturl');
  final mobileUuid = await userdata.getByKey('mobile_uuid');
  final mobileInfo = await userdata.getByKey('mobile_info');
  final mobilePlatform = await userdata.getByKey('mobile_platform');
  final userID = await userdata.getByKey('user_id');
  const fcmToken = "mobile_uuid_flutter_1";
  const userType = 'admin';
  final packageInfo = await PackageInfo.fromPlatform();
  final appName = packageInfo!.packageName;
  final appVercode = packageInfo!.buildNumber;

  final apiUrl = baseurl + "taskmanagement/api.php"+"?api_page=$apiPage&_method=$method&id=$id&mobile_uuid=$mobileUuid&app_vercode=$appVercode&user_type=$userType&user_id=$userID&app_name=$appName&encode=1&app_token=1234";
  return apiUrl;
}

