import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/constants/config.dart';

class CasetrackingController extends GetxController {
  final inputController = TextEditingController();
  final buttonText = 'Search'.obs;
  final showResult = false.obs;
  final results = <Map<String, dynamic>>[].obs;
  final isTextFieldEnabled = true.obs;
  final isLoading = false.obs;
  final Dio _dio = Dio();

  @override
  void onInit() {
    super.onInit();
    inputController.addListener(_onInputChanged);
  }

  void _onInputChanged() {
    // Reset results if input changes
    if (showResult.value && inputController.text.isEmpty) {
      resetSearch();
    }
  }

  // bool isInputValid() {
  //   // UUID format validation (8-4-4-4-12 characters)
  //   final regex = RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$', caseSensitive: false);
  //   return inputController.text.isNotEmpty && regex.hasMatch(inputController.text.trim());
  // }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); // Adjust key if different
    if (token == null || token.isEmpty) {
      Get.snackbar(
        'Authentication Error',
        'No authentication token found. Please log in again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 10.0,
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 4),
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
      return null;
    }
    return token;
  }

  Future<void> fetchCaseDetails() async {
    final caseId = inputController.text.trim();
    final token = await _getToken();
    if (token == null) return;

    isLoading.value = true;
    try {
      final response = await _dio.get(
        '${Config.baseUrl}/api/requests/search?query=$caseId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final requests = response.data['requests'] as List<dynamic>? ?? [];
        if (requests.isNotEmpty) {
          results.value = requests.cast<Map<String, dynamic>>();
        } else {
          results.clear();
          Get.snackbar(
            'No Results',
            'No case found with the provided Case ID.',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            borderRadius: 10.0,
            margin: const EdgeInsets.all(10),
          );
        }
      } else {
        results.clear();
        Get.snackbar(
          'Error',
          'Failed to fetch case details: ${response.data['message'] ?? 'Unknown error'}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on DioException catch (e) {
      results.clear();
      String errorMessage = 'An error occurred while fetching data.';
      if (e.response != null) {
        errorMessage = e.response?.data['message'] ?? 'Server error: ${e.response?.statusCode}';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Connection timed out. Please check your internet connection.';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'Failed to connect to the server. Please try again.';
      } else {
        errorMessage = e.message ?? errorMessage;
      }
      Get.snackbar(
        'Error',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      results.clear();
      Get.snackbar(
        'Unexpected Error',
        'An unexpected error occurred: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void onSearch() async {
    if (buttonText.value == 'Search') {
      if (inputController.text.isEmpty) {
        Get.snackbar(
          'Input Required',
          'Please enter a Case ID to proceed with the search.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          borderRadius: 10.0,
          margin: const EdgeInsets.all(10),
          duration: const Duration(seconds: 3),
          icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
        );
        showResult.value = false;
        return;
      }

      // if (!isInputValid()) {
      //   Get.snackbar(
      //     'Invalid Input',
      //     'Please enter a valid Case ID (e.g., 97b9844b-da0c-4c35-b5b6-48360b8e8bf6)',
      //     backgroundColor: Colors.orange,
      //     colorText: Colors.white,
      //     snackPosition: SnackPosition.BOTTOM,
      //     borderRadius: 10.0,
      //     margin: const EdgeInsets.all(10),
      //     duration: const Duration(seconds: 3),
      //     icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
      //   );
      //   showResult.value = false;
      //   return;
      // }

      await fetchCaseDetails();
      showResult.value = true;
      if (results.isNotEmpty) {
        isTextFieldEnabled.value = false;
        buttonText.value = 'Clear';
      } else {
        isTextFieldEnabled.value = true;
        buttonText.value = 'Search';
      }
    } else {
      resetSearch();
    }
  }

  void resetSearch() {
    inputController.clear();
    showResult.value = false;
    results.clear();
    buttonText.value = 'Search';
    isTextFieldEnabled.value = true;
  }

  @override
  void onClose() {
    inputController.removeListener(_onInputChanged);
    inputController.dispose();
    super.onClose();
  }
}