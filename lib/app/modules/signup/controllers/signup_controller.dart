import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class SignupController extends GetxController {
  // Controllers for input fields
  var emailController = TextEditingController();
  var fullNameController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  // Reactive error variables
  var emailError = ''.obs;
  var fullNameError = ''.obs;
  var phoneError = ''.obs;
  var passwordError = ''.obs;
  var confirmPasswordError = ''.obs;

  // Loading state
  var isLoading = false.obs;

  // Password visibility toggles
  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;

  // Dio instance
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://196.189.247.250:8600/api/',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {'Content-Type': 'application/json'},
  ));

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    emailController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  // Validate inputs
  bool _validateInputs() {
    bool isValid = true;

    // Email
    if (emailController.text.trim().isEmpty) {
      emailError.value = 'Email is required';
      isValid = false;
    } else if (!GetUtils.isEmail(emailController.text.trim())) {
      emailError.value = 'Please enter a valid email';
      isValid = false;
    } else {
      emailError.value = '';
    }

    // Full Name
    if (fullNameController.text.trim().isEmpty) {
      fullNameError.value = 'Full name is required';
      isValid = false;
    } else if (fullNameController.text.trim().length < 2) {
      fullNameError.value = 'Full name must be at least 2 characters';
      isValid = false;
    } else {
      fullNameError.value = '';
    }

    // Phone Number
    if (phoneController.text.trim().isEmpty) {
      phoneError.value = 'Phone number is required';
      isValid = false;
    } else if (!RegExp(r'^\*?\+\d{9,15}$').hasMatch(phoneController.text.trim())) {
      phoneError.value = 'Please enter a valid phone number (e.g., *+251917175757)';
      isValid = false;
    } else {
      phoneError.value = '';
    }

    // Password
    if (passwordController.text.isEmpty) {
      passwordError.value = 'Password is required';
      isValid = false;
    } else if (passwordController.text.length < 8) {
      passwordError.value = 'Password must be at least 8 characters';
      isValid = false;
    } else {
      passwordError.value = '';
    }

    // Confirm Password
    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordError.value = 'Please confirm your password';
      isValid = false;
    } else if (confirmPasswordController.text != passwordController.text) {
      confirmPasswordError.value = 'Passwords do not match';
      isValid = false;
    } else {
      confirmPasswordError.value = '';
    }

    return isValid;
  }

  // API call to sign up
  // API call to sign up
  Future<void> signUp() async {
    if (!_validateInputs()) {
      _showSnackBar(
        'Error',
        'Please fix the errors before submitting.',
        Colors.red,
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await _dio.post(
        'account/auth/register/',
        data: {
          'email': emailController.text.trim(),
          'full_name': fullNameController.text.trim(),
          'password': passwordController.text,
          'phone_number': phoneController.text.trim(),
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSnackBar(
          'Success',
          'User registered successfully! Redirecting to login...',
          Colors.green,
        );
        // Delay navigation to ensure snackbar is visible
        await Future.delayed(const Duration(seconds: 3));
        Get.offAllNamed(Routes.LOGIN); // Redirect to login screen
      } else {
        _showSnackBar(
          'Error',
          'Failed to register. Please try again.',
          Colors.red,
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'An error occurred. Please try again.';
      if (e.response != null) {
        if (e.response!.statusCode == 400) {
          final responseData = e.response!.data;
          if (responseData is Map && responseData.containsKey('email')) {
            if (responseData['email'].contains('custom user with this email already exists.')) {
              errorMessage = 'This email is already registered.';
            } else {
              errorMessage = 'Invalid input. Please check your details.';
            }
          } else {
            errorMessage = 'Bad request. Please check your input.';
          }
        } else if (e.response!.statusCode == 401) {
          errorMessage = 'Unauthorized request. Please try again.';
        } else {
          errorMessage = 'Server error: ${e.response!.statusCode}';
        }
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Connection timed out. Please check your internet.';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Server took too long to respond.';
      }

      _showSnackBar(
        'Error',
        errorMessage,
        Colors.red,
      );
    } catch (e) {
      _showSnackBar(
        'Error',
        'Unexpected error: $e',
        Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _showSnackBar(String title, String message, Color backgroundColor) {
    Get.closeAllSnackbars(); // Close any existing snackbars
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      isDismissible: true,
      animationDuration: const Duration(milliseconds: 300),
      overlayBlur: 0.5,
      overlayColor: Colors.black.withOpacity(0.2),
    );
  }
}