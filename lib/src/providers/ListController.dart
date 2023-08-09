import 'package:get/get.dart';

class ListController extends GetxController {
  RxMap<dynamic, dynamic> mapData = {}.obs;

  void editData(Map<dynamic, dynamic> data) {
    mapData.clear();
    mapData.addAll(data);
  }

  void clearData() {
    mapData.clear();
    mapData.addAll({'id': 0});
  }
}
