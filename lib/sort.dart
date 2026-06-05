import 'package:get/get.dart';
class SortController extends GetxController{
  var selecteddate= DateTime.now().obs;
  void updatedate(DateTime data)
  {
    selecteddate.value=data;
    print("Sorting data for date: ${selecteddate.value}");
  }
}