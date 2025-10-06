import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../utils/constants/colors.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  String _getPartialUUID(String uuid) {
    final parts = uuid.split('-');
    return parts.isNotEmpty ? '#${parts.first}' : '#Unknown';
  }

  void _showQRCodeDialog(BuildContext context, String requestId) {
    final GlobalKey qrKey = GlobalKey();
    String qrData = requestId.split('-').first;

    showGeneralDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOut),
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 10,
          backgroundColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Semantics(
                container: true,
                label: 'QR Code Dialog for sharing or scanning',
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Iconsax.barcode,
                      size: 32,
                      color: TColors.primary, // TColors.primary
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Scan'.tr,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Scan Instruction'.tr +
                          '\n\nYou can also screenshot this QR code to save or share it later.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    RepaintBoundary(
                      key: qrKey,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.white, Colors.grey.shade50],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          width: 240,
                          height: 240,
                          child: Container(), // Placeholder for QrImageView
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Get.snackbar('Sharing',
                                'QR code sharing not implemented in this version.',
                                duration: const Duration(seconds: 2));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TColors.primary, // TColors.primary
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 3,
                          ),
                          icon: const Icon(Iconsax.share,
                              color: Colors.white, size: 20),
                          label: Text(
                            'Share'.tr,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        OutlinedButton.icon(
                          onPressed: () {
                            Get.snackbar(
                                'Copied', 'QR code data copied to clipboard',
                                duration: const Duration(seconds: 2));
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: TColors.primary),
                            // TColors.primary
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Iconsax.copy,
                              color: TColors.primary, size: 20),
                          label: Text(
                            'Copy'.tr,
                            style: const TextStyle(
                              color: TColors.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close'.tr,
                style: TextStyle(
                  color: TColors.primary, // TColors.primary
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPendingFilter() {
    final ScrollController scrollController = ScrollController();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Fade effect for scroll indication
          ShaderMask(
            shaderCallback: (rect) {
              return LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.white.withOpacity(0.0),
                  Colors.white,
                  Colors.white,
                  Colors.white.withOpacity(0.0),
                ],
                stops: const [0.0, 0.1, 0.9, 1.0],
              ).createShader(rect);
            },
            blendMode: BlendMode.dstIn,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              controller: scrollController,
              child: Obx(() {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildFilterChip(
                      labelKey: 'All',
                      isSelected: controller.pendingFilter.value == 'All',
                      onSelected: () {
                        controller.pendingFilter.value = 'All';
                      },
                    ),
                    const SizedBox(width: 16),
                    _buildFilterChip(
                      labelKey: 'Pending',
                      isSelected: controller.pendingFilter.value == 'Pending',
                      onSelected: () {
                        controller.pendingFilter.value = 'Pending';
                      },
                    ),
                    const SizedBox(width: 16),
                    _buildFilterChip(
                      labelKey: 'Under Review',
                      isSelected:
                          controller.pendingFilter.value == 'Under Review',
                      onSelected: () {
                        controller.pendingFilter.value = 'Under Review';
                      },
                    ),
                  ],
                );
              }),
            ),
          ),
          // Left arrow (visible when scrolled to the right)
          Positioned(
            left: 0,
            child: ValueBuilder<bool?>(
              initialValue: false,
              builder: (showLeftArrow, updateFn) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (scrollController.hasClients) {
                    updateFn(scrollController.offset > 0);
                  }
                });
                return AnimatedOpacity(
                  opacity: showLeftArrow == true ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: GestureDetector(
                    onTap: () {
                      if (showLeftArrow == true) {
                        scrollController.animateTo(
                          scrollController.offset - 100,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Iconsax.arrow_left_2,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                );
              },
              onUpdate: (value) {},
            ),
          ),
          // Right arrow (visible when not at the end)
          Positioned(
            right: 0,
            child: ValueBuilder<bool?>(
              initialValue: false,
              builder: (showRightArrow, updateFn) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (scrollController.hasClients &&
                      scrollController.position.hasContentDimensions) {
                    updateFn(scrollController.offset <
                        scrollController.position.maxScrollExtent);
                  }
                });
                return AnimatedOpacity(
                  opacity: showRightArrow == true ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: GestureDetector(
                    onTap: () {
                      if (showRightArrow == true) {
                        scrollController.animateTo(
                          scrollController.offset + 100,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Iconsax.arrow_right_3,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                );
              },
              onUpdate: (value) {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String labelKey,
    required bool isSelected,
    required VoidCallback onSelected,
  }) {
    return GestureDetector(
      onTap: onSelected,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              labelKey.tr,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? TColors.primary : Colors.grey[800],
                letterSpacing: 0.3,
              ),
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 4),
                height: 2,
                width: 24,
                color: TColors.primary,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestSection() {
    return Obx(() {
      final requestType = controller.selectedRequestType.value;
      final displayRequestType = requestType.toLowerCase() == 'approved'
          ? 'accepted'.tr
          : requestType.capitalizeFirst!.tr;

      List<Request> requests = controller.getRequestsByType(requestType);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Text(
              requestType.toLowerCase() == 'pending'
                  ? 'In Progress Complaints'.tr
                  : requestType.toLowerCase() == 'approved'
                      ? 'Accepted Complaints'.tr
                      : requestType.toLowerCase() == 'decided'
                          ? 'Decided Complaints'.tr
                          : 'Rejected Complaints'.tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
                letterSpacing: 0.2,
                //fontFamily: 'Inter, Roboto, sans-serif',
              ),
            ),
          ),
          if (requestType == 'Pending') _buildPendingFilter(),
          requests.isEmpty
              ? _noRequestsWidget(displayRequestType)
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final request = requests[index];
                    return AnimatedOpacity(
                      opacity: 1.0,
                      duration: const Duration(milliseconds: 300),
                      child: GestureDetector(
                        onTap: () {
                          Get.snackbar(
                            'Info',
                            'Request details view not implemented.',
                            duration: const Duration(seconds: 2),
                            backgroundColor: Colors.grey[800],
                            colorText: Colors.white,
                          );
                        },
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          color: Colors.white,
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _getPartialUUID(request.requestId),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: TColors.primary,
                                        letterSpacing: 0.3,
                                        //fontFamily: 'Inter, Roboto, sans-serif',
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => _showQRCodeDialog(
                                          context, request.requestId),
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color:
                                              TColors.primary.withOpacity(0.1),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: TColors.primary
                                                .withOpacity(0.3),
                                            width: 1,
                                          ),
                                        ),
                                        child: Icon(
                                          Iconsax.barcode,
                                          size: 20,
                                          color: TColors.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(request.status)
                                            .withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Iconsax.stickynote,
                                        size: 20,
                                        color: _getStatusColor(request.status),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        request.applicants
                                            .map((a) => a.applicantName)
                                            .join(', '),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF1A1A1A),
                                          //fontFamily: 'Inter, Roboto, sans-serif',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _statusBadge(request.status),
                                    Text(
                                      '${'Date Label'.tr}: ${request.requestDate}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[600],
                                        //fontFamily: 'Inter, Roboto, sans-serif',
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                _buildRepresentativeInfo(request),
                                const SizedBox(height: 12),
                                _buildCourtAndViolations(request),
                                const SizedBox(height: 12),
                                _buildApplicantsAndRespondents(request),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // if (request.status.toLowerCase() !=
                                    //     'pending') ...[
                                    //   _buildActionButton(
                                    //     label: 'Applications'.tr,
                                    //     color: TColors.primary.withOpacity(0.9),
                                    //     onPressed: () {
                                    //       Get.snackbar(
                                    //         'Info',
                                    //         'Applications view not implemented.',
                                    //         duration: const Duration(seconds: 2),
                                    //         backgroundColor: Colors.grey[800],
                                    //         colorText: Colors.white,
                                    //       );
                                    //     },
                                    //   ),
                                    //   const SizedBox(width: 8),
                                    // ],
                                    // Inside the itemBuilder of ListView.builder in _buildRequestSection
                                    _buildActionButton(
                                      label: 'View Details'.tr,
                                      color: TColors.primary,
                                      onPressed: () {
                                        _showComplaintDetailsSheet(
                                            context, request);
                                      },
                                    ),
                                    if (requestType.toLowerCase() ==
                                        'decided') ...[
                                      const SizedBox(width: 8),
                                      _buildActionButton(
                                        label: 'Decision'.tr,
                                        color: Colors.green[600]!,
                                        onPressed: () {
                                          Get.snackbar(
                                            'Info',
                                            'Decision view not implemented.',
                                            duration:
                                                const Duration(seconds: 2),
                                            backgroundColor: Colors.grey[800],
                                            colorText: Colors.white,
                                          );
                                        },
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ],
      );
    });
  }

  Widget _buildActionButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return AnimatedScale(
      scale: 1.0,
      duration: const Duration(milliseconds: 200),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.1),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            //fontFamily: 'Inter, Roboto, sans-serif',
          ),
        ),
        child: Text(label),
      ),
    );
  }

  Widget _statusBadge(String status) {
    String displayStatusKey;
    Color badgeColor;

    switch (status.toLowerCase()) {
      case 'under review':
        displayStatusKey = 'Under Review';
        badgeColor = Colors.orange[600]!;
        break;
      case 'approved':
        displayStatusKey = 'Accepted';
        badgeColor = TColors.primary;
        break;
      case 'decided':
        displayStatusKey = 'Decided';
        badgeColor = Colors.green[600]!;
        break;
      case 'rejected':
        displayStatusKey = 'Rejected';
        badgeColor = Colors.red[600]!;
        break;
      default:
        displayStatusKey = 'Pending';
        badgeColor = Colors.blue[600]!;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: badgeColor.withOpacity(0.3), width: 1),
      ),
      child: Text(
        displayStatusKey.tr,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: badgeColor,
          //fontFamily: 'Inter, Roboto, sans-serif',
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.blue[600]!;
      case 'under review':
        return Colors.orange[600]!;
      case 'approved':
        return TColors.primary;
      case 'decided':
        return Colors.green[600]!;
      case 'rejected':
        return Colors.red[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  Widget _buildRepresentativeInfo(Request request) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Representative Label'.tr + ': ${request.representativeName}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Phone Label'.tr + ': ${request.phone}',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
        Text(
          'Additional Phone Label'.tr + ': ${request.phoneAdditional}',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildCourtAndViolations(Request request) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Court Case Label'.tr +
              ': ${request.courtCaseResultReference ?? 'no_case'.tr}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Violating Article Label'.tr +
              ': ${request.violatedConstitutionArticle ?? 'na'.tr}',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildApplicantsAndRespondents(Request request) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Applicant Name'.tr + ':'),
        const SizedBox(height: 12),
        ...request.applicants.map((applicant) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                const Icon(
                  Iconsax.profile_tick5,
                  size: 20,
                  color: TColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    applicant.applicantName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        _buildSectionTitle('Respondents Label'.tr + ':'),
        const SizedBox(height: 12),
        ...request.respondents.map((respondent) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                const Icon(
                  Iconsax.profile_tick5,
                  size: 20,
                  color: TColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    respondent.respondentName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _noRequestsWidget(String requestType) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      height: 180,
      width: 500,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/logos/docer-animation.gif',
            height: 100,
            width: 100,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 8),
          Text(
            'No Requests'.trParams({'requestType': requestType}),
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildTopNavigationBar() {
    final ScrollController scrollController = ScrollController();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Fade effect for scroll indication
          ShaderMask(
            shaderCallback: (rect) {
              return LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.white.withOpacity(0.0),
                  Colors.white,
                  Colors.white,
                  Colors.white.withOpacity(0.0),
                ],
                stops: const [0.0, 0.1, 0.9, 1.0],
              ).createShader(rect);
            },
            blendMode: BlendMode.dstIn,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              controller: scrollController,
              child: Obx(() {
                final selectedType = controller.selectedRequestType.value;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _navItem(
                      icon: Iconsax.watch,
                      label: 'On Progress'.tr,
                      isActive: selectedType == 'Pending',
                      onTap: () => controller.updateRequestType('Pending'),
                    ),
                    _verticalDivider(),
                    _navItem(
                      icon: Iconsax.check,
                      label: 'Accepted'.tr,
                      isActive: selectedType == 'approved',
                      onTap: () => controller.updateRequestType('approved'),
                    ),
                    _verticalDivider(),
                    _navItem(
                      icon: Iconsax.tick_circle,
                      label: 'Decided'.tr,
                      isActive: selectedType == 'Decided',
                      onTap: () => controller.updateRequestType('Decided'),
                    ),
                    _verticalDivider(),
                    _navItem(
                      icon: Iconsax.close_circle,
                      label: 'Rejected '.tr,
                      isActive: selectedType == 'Rejected',
                      onTap: () => controller.updateRequestType('Rejected'),
                    ),
                  ],
                );
              }),
            ),
          ),
          // Left arrow (visible when scrolled to the right)
          Positioned(
            left: 0,
            child: ValueBuilder<bool?>(
              initialValue: false,
              builder: (showLeftArrow, updateFn) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (scrollController.hasClients) {
                    updateFn(scrollController.offset > 0);
                  }
                });
                return AnimatedOpacity(
                  opacity: showLeftArrow == true ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: GestureDetector(
                    onTap: () {
                      if (showLeftArrow == true) {
                        scrollController.animateTo(
                          scrollController.offset - 100,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Iconsax.arrow_left_2,
                        size: 16,
                        color: TColors.primary,
                      ),
                    ),
                  ),
                );
              },
              onUpdate: (value) {},
            ),
          ),
          // Right arrow (visible when not at the end)
          Positioned(
            right: 0,
            child: ValueBuilder<bool?>(
              initialValue: false,
              builder: (showRightArrow, updateFn) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (scrollController.hasClients &&
                      scrollController.position.hasContentDimensions) {
                    updateFn(scrollController.offset <
                        scrollController.position.maxScrollExtent);
                  }
                });
                return AnimatedOpacity(
                  opacity: showRightArrow == true ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: GestureDetector(
                    onTap: () {
                      if (showRightArrow == true) {
                        scrollController.animateTo(
                          scrollController.offset + 100,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Iconsax.arrow_right_3,
                        size: 16,
                        color: TColors.primary,
                      ),
                    ),
                  ),
                );
              },
              onUpdate: (value) {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _verticalDivider() {
    return Container(
      height: 32,
      width: 3,
      margin: const EdgeInsets.symmetric(horizontal: 18),
      color: Colors.grey[300],
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? TColors.primary : Colors.grey[700],
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isActive ? TColors.primary : Colors.grey[800],
                letterSpacing: 0.3,
              ),
            ),
            if (isActive)
              Container(
                margin: const EdgeInsets.only(top: 4),
                height: 2,
                width: 24,
                color: TColors.primary,
              ),
          ],
        ),
      ),
    );
  }

  Widget _announcementCardWithImage(
      BuildContext context, String title, String description, String imageUrl) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset(
              imageUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                gradient: LinearGradient(
                  colors: [
                    TColors.primary.withOpacity(0.7),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.put(HomeController());
    ValueNotifier<String> selectedLanguage = ValueNotifier('English');

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: controller.fetchDataFromDatabase,
        color: TColors.primary,
        backgroundColor: Colors.white,
        displacement: 50.0,
        edgeOffset: 0.0,
        strokeWidth: 3.0,
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(
                      top: 60, bottom: 26, left: 4, right: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: Image.asset(
                          'assets/logos/491355264_1071021608377276_4708450262223603550_n.jpg',
                          height: 40,
                          width: 40, // Important for a perfect circle
                          fit: BoxFit.cover, // Ensures it fills the circle
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'CRRSA',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 0),
                            Text(
                              'የሲቪል ምዝገባ እና የነዋሪነት አገልግሎት ኤጀንሲ',
                              style: TextStyle(
                                fontFamily: 'NokiaPureheadline',
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(Iconsax.global,
                            color: Colors.black, size: 22),
                        onPressed: () =>
                            _showLanguageBottomSheet(context, selectedLanguage),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Iconsax.note_2,
                                color: TColors.primary,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              'Announcements'.tr,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 260,
                  child: PageView(
                    controller: controller.announcementsPageController,
                    onPageChanged: (index) {
                      controller.currentPage.value = index;
                      controller.autoScrollTimer.cancel();
                      controller.startAutoScroll();
                    },
                    children: [
                      _announcementCardWithImage(
                        context,
                        'ሞባይል መተግበሪያ የተሳሳተ መረጃ በቀላሉ ማስተካከል እንደሚችሉ ያውቃሉ?'.tr,
                        'አፕሊኬሽኑን ከፕሌይ ስቶር ወይም ከአፕ ስቶር ላይ በማውረድ ይጠቀሙ ማስተካከል ይችላሉ። '
                            .tr,
                        'assets/logos/490127539_1071021958377241_3892097132140489834_n.png',
                      ),
                      _announcementCardWithImage(
                        context,
                        'ለኤጀንሲው የቀድሞ የስራ ኃላፊዎች አሸኛኘት ተደረገላቸው'.tr,
                        'የሲቪል ምዝገባ እና የነዋሪነት ኤጀንሲ  ለቀድሞ የተቋሙ አመራሮች እና የስራ ኃላፊዎች የምስጋና የአሸኛኘት ፕሮግራም አካሂዷል፡፡'
                            .tr,
                        'assets/logos/514254142_1153477890131647_2498540104631505697_n.jpg',
                      ),
                      _announcementCardWithImage(
                        context,
                        'የላቀ አፈፃፀም ያስመዘገቡ ክፍለ ከተሞች ተሸለሙ'.tr,
                        'የሲቪል ምዝገባ እና የነዋሪነት አገልግሎት ኤጀንሲ በ2017 በጀት ዓመት የላቀ አፈፃፀም ላስመዘገቡ ክፍለ ከተሞች የእውቅናና የምሰጋና ፕሮግራም አካሂዷል፡፡ '
                            .tr,
                        'assets/logos/527352113_1155062116639891_8053731989620584229_n.jpg',
                      ),
                      _announcementCardWithImage(
                        context,
                        '2ሺ መፃሕፍት ስጦታ ተበረከተለት'.tr,
                        'የሲቪል ምዝገባ እና የነዋሪነት አገልግሎት ኤጀንሲ እያቋቋመ ለሚገኘው ዲጂታል ላይበራሪ የሚያግዙ 2ሺህ የተለያዩ መፃህፍት ከአብርሆት ቤተ መፃሕፍት በስጦታ ተበርክቶለታል፡፡'
                            .tr,
                        'assets/logos/490127539_1071021958377241_3892097132140489834_n.png',
                      ),
                      _announcementCardWithImage(
                        context,
                        'የላቀ አፈፃፀም ያስመዘገቡ ክፍለ ከተሞች ተሸለሙ'.tr,
                        'የሲቪል ምዝገባ እና የነዋሪነት አገልግሎት ኤጀንሲ በ2017 በጀት ዓመት የላቀ አፈፃፀም ላስመዘገቡ ክፍለ ከተሞች የእውቅናና የምሰጋና ፕሮግራም አካሂዷል፡፡ '
                            .tr,
                        'assets/logos/527352113_1155062116639891_8053731989620584229_n.jpg',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        controller.announcements.length,
                        (dotIndex) => GestureDetector(
                          onTap: () => controller.announcementsPageController
                              .jumpToPage(dotIndex),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 4,
                            width: controller.currentPage.value == dotIndex
                                ? 28
                                : 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: controller.currentPage.value == dotIndex
                                  ? TColors.black
                                  : Colors.grey.withOpacity(0.4),
                              boxShadow:
                                  controller.currentPage.value == dotIndex
                                      ? [
                                          // BoxShadow(
                                          //   color: TColors.primary.withOpacity(0.3),
                                          //   blurRadius: 4,
                                          //   offset: const Offset(0, 2),
                                          // ),
                                        ]
                                      : [],
                            ),
                            transform: Matrix4.identity()
                              ..scale(
                                controller.currentPage.value == dotIndex
                                    ? 1.1
                                    : 1.0,
                              ),
                            transformAlignment: Alignment.center,
                          ),
                        ),
                      ),
                    )),
                // Padding(
                //   padding:
                //       const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                //   child: Container(
                //     alignment: Alignment.centerLeft,
                //     decoration: BoxDecoration(
                //       color: Colors.white,
                //       borderRadius: BorderRadius.circular(12),
                //       boxShadow: [
                //         BoxShadow(
                //           color: Colors.grey.withOpacity(0.1),
                //           spreadRadius: 2,
                //           blurRadius: 8,
                //           offset: const Offset(0, 2),
                //         ),
                //       ],
                //     ),
                //     padding: const EdgeInsets.symmetric(
                //         horizontal: 16, vertical: 12),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         Row(
                //           children: [
                //             Container(
                //               padding: const EdgeInsets.all(8),
                //               decoration: BoxDecoration(
                //                 color: Colors.blue.withOpacity(0.1),
                //                 borderRadius: BorderRadius.circular(8),
                //               ),
                //               child: const Icon(
                //                 Iconsax.card,
                //                 color: TColors.primary,
                //                 size: 16,
                //               ),
                //             ),
                //             const SizedBox(width: 6),
                //             Text(
                //               'Digital Certificates'.tr,
                //               style: const TextStyle(
                //                 fontSize: 13,
                //                 fontWeight: FontWeight.w500,
                //                 color: Colors.black87,
                //                 letterSpacing: 0.2,
                //               ),
                //             ),
                //           ],
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                const SizedBox(height: 26),
                InkWell(
                  onTap: () => _showIDCardBottomSheet(context),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(4, 8, 4, 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // round blue icon (storefront)
                        Container(
                          height: 54,
                          width: 54,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                TColors.primary,
                                TColors.primary,
                              ],
                            ),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(Iconsax.card,
                              size: 26, color: Colors.white),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Digital Certificates',
                                style: TextStyle(
                                  fontSize: 16,
                                  height: 1.0,
                                  fontWeight: FontWeight.w800,
                                  color: TColors.primary,
                                  letterSpacing: 0.1,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Explore and manage your Digital Certificates.',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  height: 1.35,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Iconsax.arrow_down_1,
                          size: 26,
                          color: TColors.primary,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Iconsax.code_1,
                            color: TColors.primary,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Complaints'.tr,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildTopNavigationBar(),
                const SizedBox(height: 10),
                _buildRequestSection(),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 100,
                  child: PageView(
                    controller: controller.newsPageController,
                    onPageChanged: (index) {
                      controller.currentPagenews.value = index;
                      controller.autoScrollTimer.cancel();
                      controller.startAutoScroll();
                    },
                    children: [
                      _announcementCardWithImage(
                        context,
                        'Public hearing scheduled title'.tr,
                        'Public hearing scheduled desc'.tr,
                        'assets/logos/two.jpeg',
                      ),
                      _announcementCardWithImage(
                        context,
                        'Citizen feedback initiative title'.tr,
                        'Citizen feedback initiative desc'.tr,
                        'assets/logos/two.jpeg',
                      ),
                      _announcementCardWithImage(
                        context,
                        'New case procedures title'.tr,
                        'New case procedures desc'.tr,
                        'assets/logos/two.jpeg',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (dotIndex) => GestureDetector(
                          onTap: () => controller.newsPageController
                              .jumpToPage(dotIndex),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(right: 6),
                            height: 8,
                            width: controller.currentPagenews.value == dotIndex
                                ? 24
                                : 10,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color:
                                  controller.currentPagenews.value == dotIndex
                                      ? Colors.black
                                      : Colors.grey.withOpacity(0.3),
                            ),
                          ),
                        ),
                      ),
                    )),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Obx(() {
        return controller.selectedIndex.value == 0
            ? AnimatedScale(
                duration: const Duration(milliseconds: 250),
                scale: 1.0,
                child: SizedBox(
                  height: 56,
                  child: FloatingActionButton.extended(
                    heroTag: 'home_fab',
                    onPressed: () {
                      _showComplaintTypeDialog(context);
                    },
                    icon: Icon(
                      Iconsax.chart_success,
                      color: TColors.primary,
                      size: 24,
                    ),
                    label: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        'Complaint',
                        style: TextStyle(
                          color: TColors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    backgroundColor: Colors.white,
                    foregroundColor: TColors.primary,
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: TColors.primary, width: 1.2),
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink();
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _showIDCardBottomSheet(BuildContext context) {
    final bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    ValueNotifier<String> selectedCertificate =
        ValueNotifier('ID'); // Track selected certificate

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.87,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[900] : Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Drag handle
                      Center(
                        child: Container(
                          width: 48,
                          height: 6,
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      Text(
                        'My Digital Certificates',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Certificate selection
                      SizedBox(
                        height: 45,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildCertificateChip(
                              label: 'ID Card',
                              value: 'ID',
                              selectedCertificate: selectedCertificate,
                              isDarkMode: isDarkMode,
                            ),
                            const SizedBox(width: 12),
                            _buildCertificateChip(
                              label: 'Birth Certificate',
                              value: 'Birth',
                              selectedCertificate: selectedCertificate,
                              isDarkMode: isDarkMode,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Certificate display based on selection
                      ValueListenableBuilder<String>(
                          valueListenable: selectedCertificate,
                          builder: (context, value, child) {
                            return AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (child, animation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: ScaleTransition(
                                      scale:
                                          Tween<double>(begin: 0.95, end: 1.0)
                                              .animate(animation),
                                      child: child,
                                    ),
                                  );
                                },
                                child: value == 'ID'
                                    ? Column(
                                        key: const ValueKey('ID'),
                                        children: [
                                          _IDCardFlipper(
                                              isDarkMode: isDarkMode),
                                          const SizedBox(height: 14),
                                          Center(
                                            child: Text(
                                              'Tap the ID card to view front/back',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: isDarkMode
                                                    ? Colors.white70
                                                    : Colors.grey[700],
                                                fontStyle: FontStyle.normal,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 24),
                                          Text(
                                            'ID Details',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          _IDInfoRow(
                                            label: 'Name',
                                            value: 'Kaleab Fekadu',
                                            isDarkMode: isDarkMode,
                                            context: context,
                                          ),
                                          _IDInfoRow(
                                            label: 'ID Number',
                                            value: '1234567890',
                                            isDarkMode: isDarkMode,
                                            context: context,
                                          ),
                                          _IDInfoRow(
                                            label: 'Date of Birth',
                                            value: '01/01/1992',
                                            isDarkMode: isDarkMode,
                                            context: context,
                                          ),
                                          _IDInfoRow(
                                            label: 'Issue Date',
                                            value: '01/01/2023',
                                            isDarkMode: isDarkMode,
                                            context: context,
                                          ),
                                          _IDInfoRow(
                                            label: 'Expiry Date',
                                            value: '01/01/2033',
                                            isDarkMode: isDarkMode,
                                            context: context,
                                          ),
                                          _IDInfoRow(
                                            label: 'Nationality',
                                            value: 'Ethiopian',
                                            isDarkMode: isDarkMode,
                                            context: context,
                                          ),
                                        ],
                                      )
                                    : Column(
                                        key: const ValueKey('Birth'),
                                        children: [
                                          _CertificateCardFlipper(
                                              isDarkMode: isDarkMode),
                                          const SizedBox(height: 14),
                                          Center(
                                            child: Text(
                                              'Tap the Birth Certificate to view front/back',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: isDarkMode
                                                    ? Colors.white70
                                                    : Colors.grey[700],
                                                fontStyle: FontStyle.normal,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 24),
                                          Text(
                                            'Birth Certificate Details',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          _IDInfoRow(
                                            label: 'Name',
                                            value: 'Kaleab Fekadu',
                                            isDarkMode: isDarkMode,
                                            context: context,
                                          ),
                                          _IDInfoRow(
                                            label: 'Certificate Number',
                                            value: 'BC987654321',
                                            isDarkMode: isDarkMode,
                                            context: context,
                                          ),
                                          _IDInfoRow(
                                            label: 'Date of Birth',
                                            value: '01/01/1992',
                                            isDarkMode: isDarkMode,
                                            context: context,
                                          ),
                                          _IDInfoRow(
                                            label: 'Place of Birth',
                                            value: 'Addis Ababa, Ethiopia',
                                            isDarkMode: isDarkMode,
                                            context: context,
                                          ),
                                          _IDInfoRow(
                                            label: 'Father\'s Name',
                                            value: 'Fekadu ',
                                            isDarkMode: isDarkMode,
                                            context: context,
                                          ),
                                          _IDInfoRow(
                                            label: 'Mother\'s Name',
                                            value: 'Kaleab',
                                            isDarkMode: isDarkMode,
                                            context: context,
                                          ),
                                          _IDInfoRow(
                                            label: 'Issue Date',
                                            value: '01/01/2010',
                                            isDarkMode: isDarkMode,
                                            context: context,
                                          )
                                        ],
                                      ));
                          }),
                    ]),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCertificateChip({
    required String label,
    required String value,
    required ValueNotifier<String> selectedCertificate,
    required bool isDarkMode,
  }) {
    return GestureDetector(
      onTap: () {
        selectedCertificate.value = value;
      },
      child: ValueListenableBuilder<String>(
        valueListenable: selectedCertificate,
        builder: (context, selectedValue, child) {
          final isSelected = selectedValue == value;
          return AnimatedScale(
            scale: isSelected ? 1.05 : 1.0, // Slight scale-up when selected
            duration: const Duration(milliseconds: 200),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                  colors: [
                    TColors.primary, // Assuming TColors.primary is a vibrant color like blue or purple
                    TColors.primary.withOpacity(0.7),
                    TColors.primary ?? TColors.primary.withOpacity(0.5), // Add an accent color for depth
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [0.0, 0.5, 1.0],
                )
                    : LinearGradient(
                  colors: [
                    isDarkMode ? Colors.grey[850]! : Colors.grey[100]!,
                    isDarkMode ? Colors.grey[900]! : Colors.grey[200]!,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8), // Softer, modern radius
                border: Border.all(
                  color: isSelected
                      ? TColors.primary.withOpacity(0.9)
                      : Colors.grey.withOpacity(0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  // Neumorphic shadow for unselected state
                  if (!isSelected)
                    BoxShadow(
                      color: isDarkMode
                          ? Colors.black.withOpacity(0.2)
                          : Colors.grey.withOpacity(0.2),
                      offset: const Offset(4, 4),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  if (!isSelected)
                    BoxShadow(
                      color: isDarkMode
                          ? Colors.grey[700]!.withOpacity(0.2)
                          : Colors.white,
                      offset: const Offset(-4, -4),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  // Glow effect for selected state
                  if (isSelected)
                    BoxShadow(
                      color: TColors.primary.withOpacity(0.4),
                      blurRadius: 12,
                      spreadRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Optional subtle background pattern or shimmer
                  if (isSelected)
                    AnimatedOpacity(
                      opacity: isSelected ? 0.2 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withOpacity(0.3),
                              Colors.transparent,
                            ],
                            radius: 0.8,
                          ),
                        ),
                      ),
                    ),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : isDarkMode
                          ? Colors.white70
                          : Colors.black87,
                      letterSpacing: 0.5,
                      shadows: isSelected
                          ? [
                        Shadow(
                          color: TColors.primary.withOpacity(0.5),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ]
                          : [],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showComplaintTypeDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Complaint Type Dialog',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 280),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved =
            CurvedAnimation(parent: animation, curve: Curves.easeOutBack);
        return ScaleTransition(
          scale: Tween<double>(begin: 0.7, end: 1.0).animate(curved),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              elevation: 16,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 28, 28, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Drag handle
                    Container(
                      width: 50,
                      height: 6,
                      margin: const EdgeInsets.only(bottom: 22),
                      decoration: BoxDecoration(
                        color: TColors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),

                    // Title
                    Text(
                      'Choose Complaint Option',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: TColors.black,
                        letterSpacing: 0.3,
                      ),
                    ),

                    const SizedBox(height: 2),

                    // Subtitle
                    Text(
                      'Select one of the options below to continue.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: TColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Create Complaint Button
                    _buildDialogButton(
                      context: context,
                      icon: Iconsax.clipboard_text,
                      label: 'New Complaint',
                      onPressed: () {
                        Navigator.of(context).pop();
                        Get.toNamed('/complaint-form');
                      },
                      gradient: LinearGradient(
                        colors: [
                          TColors.primary,
                          TColors.primary.withOpacity(0.9)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),

                    // Track Complaint Button
                    _buildDialogButton(
                      context: context,
                      icon: Iconsax.search_favorite,
                      label: 'Track Complaint',
                      onPressed: () {
                        Navigator.of(context).pop();
                        Get.toNamed('/casetracking');
                      },
                      gradient: LinearGradient(
                        colors: [
                          TColors.secondary,
                          TColors.secondary.withOpacity(0.9)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Cancel Button
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          foregroundColor: TColors.error,
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showComplaintDetailsSheet(BuildContext context, Request request) {
    // Simulated static PDF files for the complaint
    final List<String> staticPdfFiles = [
      'Complaint_${_getPartialUUID(request.requestId)}_Document1.pdf',
      'Complaint_${_getPartialUUID(request.requestId)}_Document2.pdf',
      'Complaint_${_getPartialUUID(request.requestId)}_Evidence.pdf',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.90,
          // Slightly larger initial size for more content
          minChildSize: 0.3,
          maxChildSize: 0.95,
          snap: true,
          // Enable snapping for smooth transitions
          snapSizes: [0.3, 0.75, 0.95],
          // Snap points for better UX
          builder: (BuildContext context, ScrollController scrollController) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 16,
                    offset: Offset(0, -6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Drag handle
                  Container(
                    width: 60,
                    height: 6,
                    margin: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: TColors.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header with Complaint ID and Status
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  _getPartialUUID(request.requestId),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: TColors.primary,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                              _statusBadge(request.status),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            request.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 16),
                          Divider(color: Colors.grey[200], thickness: 1),
                          SizedBox(height: 16),
                          // Case Type
                          _buildDetailSection(
                            title: 'Case Type'.tr,
                            content: request.caseType ?? 'Unknown'.tr,
                            icon: Iconsax.document,
                          ),
                          SizedBox(height: 16),
                          // Complaint Summary
                          _buildDetailSection(
                            title: 'Complaint Summary'.tr,
                            content: request.constitutionalComplaintSummary ??
                                'No summary available'.tr,
                            icon: Iconsax.note,
                          ),
                          SizedBox(height: 16),
                          // Affair Description
                          _buildDetailSection(
                            title: 'Description'.tr,
                            content: request.description,
                            icon: Iconsax.message_text,
                          ),
                          SizedBox(height: 16),
                          // Other Applicable Laws
                          _buildDetailSection(
                            title: 'Other Applicable Laws'.tr,
                            content: request.otherApplicableLaws ?? 'None'.tr,
                            icon: Iconsax.level,
                          ),
                          SizedBox(height: 16),
                          // Representative Information
                          _buildDetailSection(
                            title: 'Representative Information'.tr,
                            contentWidget: _buildRepresentativeInfo(request),
                            icon: Iconsax.user,
                          ),
                          SizedBox(height: 16),
                          // Court and Violations
                          _buildDetailSection(
                            title: 'Court and Violations'.tr,
                            contentWidget: _buildCourtAndViolations(request),
                            icon: Iconsax.cake,
                          ),
                          SizedBox(height: 16),
                          // Applicants and Respondents
                          _buildDetailSection(
                            title: 'Parties Involved'.tr,
                            contentWidget:
                                _buildApplicantsAndRespondents(request),
                            icon: Iconsax.profile_circle,
                          ),
                          SizedBox(height: 16),
                          // PDF Documents
                          _buildDetailSection(
                            title: 'Documents'.tr,
                            contentWidget: Column(
                              children: staticPdfFiles.isEmpty
                                  ? [
                                      Text(
                                        'No documents available'.tr,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ]
                                  : staticPdfFiles.map((pdf) {
                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 12),
                                        child: GestureDetector(
                                          onTap: () {
                                            Get.snackbar(
                                              'Info',
                                              'Opening PDF: $pdf (PDF viewer not implemented)',
                                              duration: Duration(seconds: 2),
                                              backgroundColor: Colors.grey[800],
                                              colorText: Colors.white,
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[50],
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: TColors.primary
                                                    .withOpacity(0.2),
                                                width: 1,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Iconsax.document_text,
                                                  color: TColors.primary,
                                                  size: 24,
                                                ),
                                                SizedBox(width: 12),
                                                Expanded(
                                                  child: Text(
                                                    pdf,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black87,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Icon(
                                                  Iconsax.arrow_right_3,
                                                  color: TColors.primary
                                                      .withOpacity(0.7),
                                                  size: 20,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                            ),
                            icon: Iconsax.document_upload,
                          ),
                          SizedBox(height: 16),
                          // Archives
                          if (request.archives.isNotEmpty) ...[
                            _buildDetailSection(
                              title: 'Archives'.tr,
                              contentWidget: Column(
                                children: request.archives.map((archive) {
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 12),
                                    child: Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color:
                                              TColors.primary.withOpacity(0.2),
                                          width: 1,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Archive #${archive.archiveNumber}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'Case ID: ${archive.caseId}',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          Text(
                                            'Status: ${archive.caseStatus}'.tr,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          Text(
                                            'Customer Status: ${archive.caseCustomerStatus}'
                                                .tr,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              icon: Iconsax.archive_book,
                            ),
                            SizedBox(height: 16),
                          ],
                          // Close Button
                          Center(
                            child: AnimatedScale(
                              scale: 1.0,
                              duration: Duration(milliseconds: 200),
                              child: ElevatedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: TColors.primary,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 80, vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 4,
                                  shadowColor: TColors.primary.withOpacity(0.3),
                                ),
                                child: Text(
                                  'Close'.tr,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

// Helper method to build a detail section with an icon and content
  Widget _buildDetailSection({
    required String title,
    String? content,
    Widget? contentWidget,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: TColors.primary,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        AnimatedOpacity(
          opacity: 1.0,
          duration: Duration(milliseconds: 300),
          child: contentWidget ??
              Text(
                content ?? 'No data available'.tr,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
        ),
      ],
    );
  }

  void _showLanguageBottomSheet(
      BuildContext context, ValueNotifier<String> selectedLanguage) {
    final bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      builder: (context) {
        return ValueListenableBuilder<String>(
          valueListenable: selectedLanguage,
          builder: (context, value, child) {
            return Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[400]?.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'Select Language',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: isDarkMode ? TColors.secondary : TColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildLanguageTile(
                    context: context,
                    language: 'English',
                    selectedLanguage: selectedLanguage,
                    isSelected: value == 'English',
                    isDarkMode: isDarkMode,
                  ),
                  _buildLanguageTile(
                    context: context,
                    language: 'አማርኛ',
                    selectedLanguage: selectedLanguage,
                    isSelected: value == 'አማርኛ',
                    isDarkMode: isDarkMode,
                  ),
                  _buildLanguageTile(
                    context: context,
                    language: 'ትግርኛ',
                    selectedLanguage: selectedLanguage,
                    isSelected: value == 'ትግርኛ',
                    isDarkMode: isDarkMode,
                  ),
                  _buildLanguageTile(
                    context: context,
                    language: 'Afaan Oromoo',
                    selectedLanguage: selectedLanguage,
                    isSelected: value == 'Afaan Oromoo',
                    isDarkMode: isDarkMode,
                  ),
                  _buildLanguageTile(
                    context: context,
                    language: 'Soomaali',
                    selectedLanguage: selectedLanguage,
                    isSelected: value == 'Soomaali',
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLanguageTile({
    required BuildContext context,
    required String language,
    required ValueNotifier<String> selectedLanguage,
    required bool isSelected,
    required bool isDarkMode,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: GestureDetector(
        onTap: () {
          selectedLanguage.value = language;
          Navigator.pop(context);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: isDarkMode
                ? Colors.grey[800]?.withOpacity(0.6)
                : Colors.grey[100]?.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(
                    color: isDarkMode ? TColors.white : TColors.secondary,
                    width: 0.5,
                  )
                : null,
            boxShadow: [
              BoxShadow(
                color:
                    isDarkMode ? Colors.black26 : Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDarkMode ? Colors.white : Colors.black,
                    width: 0.5,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Icon(
                          Icons.check,
                          size: 16,
                          color: isDarkMode ? TColors.white : TColors.primary,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Text(
                language,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// Helper method to build dialog buttons with icons and gradient
  Widget _buildDialogButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required LinearGradient gradient,
  }) {
    return AnimatedScaleButton(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
        ).copyWith(
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          overlayColor: WidgetStateProperty.all(Colors.white.withOpacity(0.15)),
        ),
        onPressed: onPressed,
        child: Container(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: gradient.colors.last.withOpacity(0.35),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              Icon(
                Iconsax.arrow_right_3,
                color: Colors.white.withOpacity(0.85),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedScaleButton extends StatefulWidget {
  final Widget child;
  const AnimatedScaleButton({super.key, required this.child});

  @override
  _AnimatedScaleButtonState createState() => _AnimatedScaleButtonState();
}

class _AnimatedScaleButtonState extends State<AnimatedScaleButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _scale = 0.95;
        });
      },
      onTapUp: (_) {
        setState(() {
          _scale = 1.0;
        });
      },
      onTapCancel: () {
        setState(() {
          _scale = 1.0;
        });
      },
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: widget.child,
      ),
    );
  }
}

class _IDInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDarkMode;
  final BuildContext context;

  const _IDInfoRow({
    required this.label,
    required this.value,
    required this.isDarkMode,
    required this.context,
  });

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard'),
        duration: const Duration(seconds: 2),
        backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDarkMode ? Colors.white70 : Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.copy,
              size: 20,
              color: isDarkMode ? Colors.white70 : Colors.grey[700],
            ),
            onPressed: _copyToClipboard,
            tooltip: 'Copy $label',
          ),
        ],
      ),
    );
  }
}

class _IDCardFlipper extends StatefulWidget {
  final bool isDarkMode;

  const _IDCardFlipper({required this.isDarkMode});

  @override
  _IDCardFlipperState createState() => _IDCardFlipperState();
}

class _IDCardFlipperState extends State<_IDCardFlipper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_controller.isAnimating) return;
    setState(() {
      _isFront = !_isFront;
    });
    if (_isFront) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flipCard,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final isFrontVisible = _animation.value <= 0.5;
          final angle = _animation.value * pi;
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Add perspective
              ..rotateY(angle),
            alignment: Alignment.center,
            child: Center(
              child: isFrontVisible
                  ? Image.asset(
                      'assets/logos/IMG_2479 (1).JPG',
                      key: const ValueKey(true),
                      height: 220,
                      fit: BoxFit.contain,
                    )
                  : Transform(
                      transform: Matrix4.identity()..rotateY(pi),
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/logos/IMG_2480 (1).JPG', // Fixed asset path
                        key: const ValueKey(false),
                        height: 220,
                        fit: BoxFit.contain,
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}

class _CertificateCardFlipper extends StatefulWidget {
  final bool isDarkMode;

  const _CertificateCardFlipper({required this.isDarkMode});

  @override
  _CertificateCardFlipperState createState() => _CertificateCardFlipperState();
}

class _CertificateCardFlipperState extends State<_CertificateCardFlipper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_controller.isAnimating) return;
    setState(() {
      _isFront = !_isFront;
    });
    if (_isFront) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flipCard,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final isFrontVisible = _animation.value <= 0.5;
          final angle = _animation.value * pi;
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Add perspective
              ..rotateY(angle),
            alignment: Alignment.center,
            child: Center(
              child: isFrontVisible
                  ? Image.asset(
                      'assets/logos/nene.jpeg', // Placeholder path
                      key: const ValueKey(true),
                      height: 300,
                      fit: BoxFit.contain,
                    )
                  : Transform(
                      transform: Matrix4.identity()..rotateY(pi),
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/logos/nene.jpeg', // Placeholder path
                        key: const ValueKey(false),
                        height: 300,
                        fit: BoxFit.contain,
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
