import 'package:crrsa/app/modules/bottom_nav_home/views/bottom_nav_home_view.dart';
import 'package:crrsa/app/modules/home/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ComplaintFormController extends GetxController {
  // Dropdown items
  final serviceTypes = [
    'Birth Registration',
    'Marriage Registration',
    'Death Registration',
    'Residency Permit',
    'ID Issuance',
    'Other'
  ].obs;

  final branches = [
    'Addis Ababa Main Office',
    'Woreda 1 Branch',
    'Woreda 7 Branch',
    'Woreda 9 Branch',
    'Woreda 13 Branch'
  ].obs;

  // Selected values
  final selectedServiceType = ''.obs;
  final selectedBranch = ''.obs;
  final complaintDescription = ''.obs;
  final attachedFiles = <XFile>[].obs;

  // Text controller for description
  final TextEditingController descriptionController = TextEditingController();

  // Image picker instance
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    // Set default values for dropdowns
    if (serviceTypes.isNotEmpty) selectedServiceType.value = serviceTypes.first;
    if (branches.isNotEmpty) selectedBranch.value = branches.first;

    // Bind description controller to Rx variable
    descriptionController.addListener(() {
      complaintDescription.value = descriptionController.text;
    });
  }

  @override
  void onClose() {
    descriptionController.dispose();
    super.onClose();
  }

  // Pick multiple files (images or videos)
  Future<void> pickFiles() async {
    try {
      final List<XFile>? files = await _picker.pickMultiImage();
      if (files != null && files.isNotEmpty) {
        attachedFiles.addAll(files);
        Get.snackbar('Success', '${files.length} file(s) attached',
            backgroundColor: Colors.grey[800], colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick files: $e',
          backgroundColor: Colors.red[600], colorText: Colors.white);
    }
  }

  // Remove a file from the attached files list
  void removeFile(int index) {
    attachedFiles.removeAt(index);
    Get.snackbar('Removed', 'File removed successfully',
        backgroundColor: Colors.grey[800], colorText: Colors.white);
  }

  // Submit the complaint
  void submitComplaint() {
    if (selectedServiceType.isEmpty) {
      Get.snackbar('Error', 'Please select a service type',
          backgroundColor: Colors.red[600], colorText: Colors.white);
      return;
    }
    if (selectedBranch.isEmpty) {
      Get.snackbar('Error', 'Please select a branch',
          backgroundColor: Colors.red[600], colorText: Colors.white);
      return;
    }
    if (complaintDescription.isEmpty) {
      Get.snackbar('Error', 'Please enter a complaint description',
          backgroundColor: Colors.red[600], colorText: Colors.white);
      return;
    }

    // Simulate submitting the complaint (replace with actual API call)
    Get.to(BottomNavHomeView());
    Get.snackbar('Success', 'Complaint submitted successfully',
        backgroundColor: Colors.green[600], colorText: Colors.white);

    // Reset form
    selectedServiceType.value = serviceTypes.first;
    selectedBranch.value = branches.first;
    descriptionController.clear();
    attachedFiles.clear();
  }
}