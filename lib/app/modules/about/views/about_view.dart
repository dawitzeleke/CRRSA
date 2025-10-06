import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../controllers/about_controller.dart';
import '../../../utils/constants/colors.dart';

class AboutView extends GetView<AboutController> {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    TextStyle sectionTitleStyle = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
      letterSpacing: 0.3,
    );

    TextStyle contentTextStyle = const TextStyle(
      fontSize: 15,
      height: 1.5,
      color: Colors.black87,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        elevation: 0.4,
        title: const Text(
          'About',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo Circle
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: TColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.information,
                size: 48,
                color: TColors.primary,
              ),
            ),
            const SizedBox(height: 20),

            // App Name
            const Text(
              'CRRSA Mobile Application',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),

            // Version
            const Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // About Section
            Align(
              alignment: Alignment.centerLeft,
              child: Text('About the Application', style: sectionTitleStyle),
            ),
            const SizedBox(height: 10),
            Text(
              'The Civil Registration and Residency Service Agency (CRRSA) mobile app is designed to provide '
                  'citizens and residents with easy access to essential civil registration services. The app offers secure, reliable, '
                  'and timely services related to birth registration, residency verification, identity management, and more.',
              style: contentTextStyle,
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 25),

            // Features Section
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Key Features', style: sectionTitleStyle),
            ),
            const SizedBox(height: 12),
            _featureItem(Iconsax.tick_circle, 'Birth and Death Registration'),
            _featureItem(Iconsax.user_tick, 'Residency Status Verification'),
            _featureItem(Iconsax.security, 'Secure Identity Management'),
            _featureItem(Iconsax.message_question, 'Real-Time Notifications and Updates'),
            _featureItem(Iconsax.document_text, 'Digital Document Access and Downloads'),
            const SizedBox(height: 25),

            // Agency Info Section
            Align(
              alignment: Alignment.centerLeft,
              child: Text('About CRRSA', style: sectionTitleStyle),
            ),
            const SizedBox(height: 10),
            Text(
              'The Civil Registration and Residency Service Agency (CRRSA) is a government body committed to ensuring accurate '
                  'and timely registration of vital events and residency information for citizens and residents. The agency focuses on '
                  'providing transparent, secure, and efficient services in line with national laws and regulations.',
              style: contentTextStyle,
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 30),

            // Contact Section
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Contact Us', style: sectionTitleStyle),
            ),
            const SizedBox(height: 12),
            Row(
              children: const [
                Icon(Iconsax.call, size: 20, color: Colors.grey),
                SizedBox(width: 8),
                Text('+251 11 123 4567', style: TextStyle(fontSize: 15)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Iconsax.sms, size: 20, color: Colors.grey),
                SizedBox(width: 8),
                Text('info@crrsa.gov.et', style: TextStyle(fontSize: 15)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Iconsax.location, size: 20, color: Colors.grey),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Addis Ababa, Ethiopia\nNational Civil Registry Building',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Developer credit footer (like Profile screen)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/logos/491355264_1071021608377276_4708450262223603550_n.jpg',
                    height: 28,
                    width: 28,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Developed by Ethiopian Artificial Intelligence Institute',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _featureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: TColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
