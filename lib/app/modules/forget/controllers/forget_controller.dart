import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class ForgetController extends GetxController {
  var emailError = ''.obs;
  TextEditingController emailController = TextEditingController();
  var otpCode = ''.obs;
  var newPasswordError = ''.obs;
  TextEditingController newPasswordController = TextEditingController();
  var confirmPasswordError = ''.obs;
  TextEditingController confirmPasswordController = TextEditingController();
  var isLoading = false.obs;
  var isResendEnabled = false.obs;
  var countdown = 300.obs; // 5 minutes in seconds

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
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // Validate email input
  bool _validateEmail() {
    if (emailController.text.isEmpty || !GetUtils.isEmail(emailController.text)) {
      emailError.value = 'Please enter a valid email address';
      return false;
    }
    emailError.value = '';
    return true;
  }

  // Validate OTP and password inputs
  bool _validateOtpAndPassword() {
    bool hasErrors = false;

    if (otpCode.value.length != 6 || !RegExp(r'^\d{6}$').hasMatch(otpCode.value)) {
      _showSnackBar('Error', 'Please enter a valid 6-digit OTP', Colors.red);
      hasErrors = true;
    }

    if (newPasswordController.text.isEmpty) {
      newPasswordError.value = 'New password is required';
      hasErrors = true;
    } else if (newPasswordController.text.length < 8) {
      newPasswordError.value = 'Password must be at least 8 characters';
      hasErrors = true;
    } else {
      newPasswordError.value = '';
    }

    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordError.value = 'Confirm password is required';
      hasErrors = true;
    } else if (confirmPasswordController.text != newPasswordController.text) {
      confirmPasswordError.value = 'Passwords do not match';
      hasErrors = true;
    } else {
      confirmPasswordError.value = '';
    }

    return !hasErrors;
  }

  // API call to send OTP
  Future<void> sendOtp() async {
    if (!_validateEmail()) {
      _showSnackBar(
        'Error',
        'Please fix the email error before submitting.',
        Colors.red,
      );
      return;
    }

    isLoading.value = true;
    try {
      final response = await _dio.post(
        'account/auth/forgot-password/',
        data: {'email': emailController.text.trim()},
      );

      if (response.statusCode == 200) {
        _showSnackBar(
          'Success',
          'OTP sent to ${emailController.text}. Please check your email.',
          Colors.green,
        );
        // Reset countdown for resend OTP
        countdown.value = 300;
        isResendEnabled.value = false;
        startCountdown();
      } else {
        _showSnackBar(
          'Error',
          'Failed to send OTP. Please try again.',
          Colors.red,
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Failed to connect to the server.';
      if (e.response != null) {
        if (e.response!.statusCode == 404) {
          errorMessage = 'Email not found.';
        } else if (e.response!.statusCode == 400) {
          errorMessage = 'Invalid email. Please check your input.';
        } else {
          errorMessage = 'Server error: ${e.response!.statusCode}';
        }
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Connection timed out. Please check your internet.';
      }
      _showSnackBar('Error', errorMessage, Colors.red);
    } catch (e) {
      _showSnackBar('Error', 'Unexpected error: $e', Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  // API call to reset password
  Future<void> resetPassword() async {
    if (!_validateOtpAndPassword()) {
      return;
    }

    isLoading.value = true;
    try {
      final response = await _dio.post(
        'account/auth/reset-password/',
        data: {
          'email': emailController.text.trim(),
          'otp': otpCode.value,
          'new_password': newPasswordController.text,
        },
      );

      if (response.statusCode == 200) {
        _showSnackBar(
          'Success',
          'Password reset successfully! Please log in with your new password.',
          Colors.green,
        );
        await Future.delayed(const Duration(seconds: 2));
        Get.offAllNamed(Routes.LOGIN);
      } else {
        _showSnackBar(
          'Error',
          'Failed to reset password. Please try again.',
          Colors.red,
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Failed to reset password.';
      if (e.response != null) {
        if (e.response!.statusCode == 400) {
          errorMessage = 'Invalid OTP or email. Please try again.';
        } else if (e.response!.statusCode == 404) {
          errorMessage = 'Email not found.';
        } else {
          errorMessage = 'Server error: ${e.response!.statusCode}';
        }
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Connection timed out. Please check your internet.';
      }
      _showSnackBar('Error', errorMessage, Colors.red);
    } catch (e) {
      _showSnackBar('Error', 'Unexpected error: $e', Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  // Start countdown for resend OTP
  void startCountdown() {
    countdown.value = 300;
    isResendEnabled.value = false;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      countdown.value--;
      if (countdown.value <= 0) {
        isResendEnabled.value = true;
        return false;
      }
      return true;
    });
  }

  void _showSnackBar(String title, String message, Color backgroundColor) {
    Get.closeAllSnackbars();
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