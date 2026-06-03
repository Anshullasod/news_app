import 'package:get/get.dart';
class BottomController extends GetxController {
  var currentIdx = 0.obs;
  void change(int idx){
    currentIdx.value=idx;
  }
}