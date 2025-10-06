import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../utils/constants/colors.dart';
import '../controllers/notification_controller.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  List<Map<String, dynamic>> notifications = [
    {
      'title': 'ID Renewal Reminder',
      'message':
      'Your National ID card will expire in 30 days. Please visit your nearest CRRSA office for renewal.',
      'time': '2m ago',
      'icon': Iconsax.card
    },
    {
      'title': 'Birth Registration Approved',
      'message':
      'Your application for birth registration of your child has been approved.',
      'time': '1h ago',
      'icon': Iconsax.document_text
    },
    {
      'title': 'Address Change Confirmation',
      'message':
      'Your address has been successfully updated in the CRRSA system.',
      'time': '3h ago',
      'icon': Iconsax.location
    },
    {
      'title': 'Marriage Registration',
      'message':
      'Your marriage registration certificate is now ready for pickup.',
      'time': 'Yesterday',
      'icon': Iconsax.heart
    },
    {
      'title': 'Death Registration Submitted',
      'message':
      'Your death registration application has been submitted successfully and is under review.',
      'time': '2 days ago',
      'icon': Iconsax.activity
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.4,
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: notifications.isEmpty
          ? const Center(
        child: Text(
          'No notifications',
          style: TextStyle(color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final item = notifications[index];
          return Dismissible(
            key: Key(item['title'] + index.toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.centerRight,
              child: const Icon(
                Iconsax.trash,
                color: Colors.white,
              ),
            ),
            onDismissed: (direction) {
              setState(() {
                notifications.removeAt(index);
              });
              Get.snackbar(
                'Deleted',
                '${item['title']} removed',
                snackPosition: SnackPosition.BOTTOM,
                margin: const EdgeInsets.all(12),
                borderRadius: 8,
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: TColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: TColors.primary,
                    size: 22,
                  ),
                ),
                title: Text(
                  item['title'] as String,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      item['message'] as String,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item['time'] as String,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
