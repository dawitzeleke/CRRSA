import 'package:get/get.dart';

import '../controllers/casetracking_controller.dart';

class CasetrackingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CasetrackingController>(
      () => CasetrackingController(),
    );
  }
}
