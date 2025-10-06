import 'package:get/get.dart';

import '../controllers/complaint_form_controller.dart';

class ComplaintFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ComplaintFormController>(
      () => ComplaintFormController(),
    );
  }
}
