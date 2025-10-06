import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/constants/colors.dart';
import '../../OtpVerification/views/otp_verification_view.dart';
import '../controllers/forget_controller.dart';

class ForgetView extends GetView<ForgetController> {
  const ForgetView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ForgetController());
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: TColors.primary,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 280,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/logos/Head.png'),
                        fit: BoxFit.cover,
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          TColors.primary.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedScale(
                            scale: 1.0,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            child: Image.asset(
                              'assets/logos/ccilogomain.png',
                              height: 280,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Form
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedOpacity(
                      opacity: 1.0,
                      duration: const Duration(milliseconds: 600),
                      child: const Text(
                        'Reset Password',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    AnimatedOpacity(
                      opacity: 1.0,
                      duration: const Duration(milliseconds: 600),
                      child: const Text(
                        'Enter your email to receive a 6-digit OTP.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    AnimatedSlide(
                      offset: const Offset(0, 0),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                      child: Obx(() => TextField(
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          prefixIcon: Icon(Iconsax.sms, color: Colors.grey.shade600),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: TColors.primary, width: 1.5),
                          ),
                          errorText: controller.emailError.value.isNotEmpty
                              ? controller.emailError.value
                              : null,
                        ),
                      )),
                    ),
                    const SizedBox(height: 28),
                    AnimatedScale(
                      scale: 1.0,
                      duration: const Duration(milliseconds: 600),
                      child: SizedBox(
                        width: double.infinity,
                        child: Obx(() => ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : () async {
                            await controller.sendOtp();
                            if (!controller.isLoading.value && controller.emailError.value.isEmpty) {
                              await showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) => const OtpVerificationView(),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 3,
                            shadowColor: TColors.primary.withOpacity(0.4),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: controller.isLoading.value
                              ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                              : const Text(
                            'Send OTP',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        )),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        onPressed: () => Get.offAllNamed(Routes.LOGIN),
                        child: Text(
                          'Back to Login',
                          style: TextStyle(
                            color: TColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}