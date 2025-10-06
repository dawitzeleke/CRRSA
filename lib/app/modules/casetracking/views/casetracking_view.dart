import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../utils/constants/colors.dart';
import '../controllers/casetracking_controller.dart';

class CasetrackingView extends StatelessWidget {
  const CasetrackingView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CasetrackingController(), permanent: true);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Case Tracking'.tr,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2, color: Colors.black87),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),

      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/logos/491355264_1071021608377276_4708450262223603550_n.jpg',
                        height: 140,
                        width: 140, // Important for a perfect circle
                        fit: BoxFit.cover, // Ensures it fills the circle
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Enter Case Number'.tr,
                      style: TextStyle(fontSize: 20, color: TColors.primary, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ).animate().fadeIn(delay: 100.ms),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => TextField(
                          controller: controller.inputController,
                          enabled: controller.isTextFieldEnabled.value,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'Enter Your Case Number Here'.tr,
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.blue[700]!, width: 1),
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            prefixIcon: Icon(Iconsax.search_normal, color: Colors.grey[600], size: 20),
                          ),
                          style: const TextStyle(fontSize: 14),
                        )),
                        const SizedBox(height: 16),
                        Obx(() => controller.isLoading.value
                            ? Center(
                          child: CircularProgressIndicator(
                            color: Colors.blue[700],
                            strokeWidth: 3,
                          ),
                        )
                            : controller.showResult.value
                            ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Case Details'.tr,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey),
                            ),
                            const SizedBox(height: 12),
                            if (controller.results.isEmpty)
                              _buildNoResults(screenWidth)
                            else
                              ...controller.results.asMap().entries.map((entry) {
                                final index = entry.key;
                                final result = entry.value;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Case ${index + 1} Information',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[900],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    _buildBasicInfo(result, screenWidth),
                                    _buildApplicantsSection(result['applicants'] ?? [], screenWidth),
                                    _buildRespondentsSection(result['respondents'] ?? [], screenWidth),
                                    _buildDocumentsSection(result['requestDocuments'] ?? [], screenWidth),
                                    //_buildArchivesSection(result['archives'] ?? [], screenWidth),
                                    const SizedBox(height: 12),
                                    const Divider(),
                                  ],
                                );
                              }),
                          ],
                        ).animate().fadeIn(delay: 200.ms)
                            : const SizedBox.shrink()),
                        const SizedBox(height: 16),
                        Obx(() => ElevatedButton(
                          onPressed: controller.onSearch,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TColors.primary,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text(
                            controller.buttonText.value == 'Search' ? 'Search'.tr : 'Clear'.tr,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        )),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: 300.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoResults(double screenWidth) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          children: [
            Image.asset(
              'assets/loading.gif',
              height: 100,
              width: 200,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 12),
            Text(
              'No Results Found'.tr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'No Results Message'.tr,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
          ],

        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, double screenWidth, {bool isNested = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: isNested ? 12 : 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${label.tr}:',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey[700]),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value.isEmpty ? 'N/A' : value,
              style: TextStyle(fontSize: 13, color: Colors.grey[900]),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo(Map<String, dynamic> result, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildResultRow('status', result['status'] ?? '', screenWidth),
        _buildResultRow('get_status', result['get_status'] ?? '', screenWidth),
        _buildResultRow('request_date', result['request_date'] ?? '', screenWidth),
        //_buildResultRow('violated_constitution_article', result['violated_constitution_article'] ?? '', screenWidth),
        //_buildResultRow('court_case_result_reference', result['court_case_result_reference'] ?? '', screenWidth),
        //_buildResultRow('other_applicable_laws', result['other_applicable_laws'] ?? '', screenWidth),
        //_buildResultRow('constitutional_complaint_summary', result['constitutional_complaint_summary'] ?? '', screenWidth),
        _buildResultRow('representative_name', result['representative_name'] ?? '', screenWidth),
        //_buildResultRow('gender', result['gender'] ?? '', screenWidth),
        //_buildResultRow('phone', result['phone'] ?? '', screenWidth),
        //_buildResultRow('additional_phone', result['phone_additional'] ?? '', screenWidth),
      ],
    );
  }

  Widget _buildApplicantsSection(List<dynamic> applicants, double screenWidth) {
    return Theme(
      data: Theme.of(Get.context!).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          // Ensure count is replaced correctly
          'applicants'.trParams({'count': applicants.length.toString()}),
          // Fallback approach if .trParams fails:
          // '${'applicants'.tr} (${applicants.length})',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[900]),
        ),
        iconColor: Colors.blue[700],
        collapsedIconColor: Colors.grey[600],
        childrenPadding: const EdgeInsets.only(bottom: 8),
        children: applicants.isEmpty
            ? [_buildResultRow('no_applicants', 'N/A', screenWidth, isNested: true)]
            : applicants.asMap().entries.map((entry) {
          final index = entry.key;
          final applicant = entry.value as Map<String, dynamic>;
          return Padding(
            padding: const EdgeInsets.only(left: 12, top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Applicant ${index + 1}',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[900]),
                ),
                _buildResultRow('applicant_name', applicant['applicant_name'] ?? '', screenWidth, isNested: true),
                _buildResultRow('phone_number', applicant['phone_number'] ?? '', screenWidth, isNested: true),
                _buildResultRow('address', applicant['address'] ?? '', screenWidth, isNested: true),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRespondentsSection(List<dynamic> respondents, double screenWidth) {
    return Theme(
      data: Theme.of(Get.context!).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          'respondents'.trParams({'count': respondents.length.toString()}),
          // Fallback: '${'respondents'.tr} (${respondents.length})',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[900]),
        ),
        iconColor: Colors.blue[700],
        collapsedIconColor: Colors.grey[600],
        childrenPadding: const EdgeInsets.only(bottom: 8),
        children: respondents.isEmpty
            ? [_buildResultRow('no_respondents', 'N/A', screenWidth, isNested: true)]
            : respondents.asMap().entries.map((entry) {
          final index = entry.key;
          final respondent = entry.value as Map<String, dynamic>;
          return Padding(
            padding: const EdgeInsets.only(left: 12, top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Respondent ${index + 1}',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[900]),
                ),
                _buildResultRow('applicant_name', respondent['respondent_name'] ?? '', screenWidth, isNested: true),
                // _buildResultRow('phone_number', respondent['phone_number'] ?? '', screenWidth, isNested: true),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDocumentsSection(List<dynamic> documents, double screenWidth) {
    return Theme(
      data: Theme.of(Get.context!).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          'documents'.trParams({'count': documents.length.toString()}),
          // Fallback: '${'documents'.tr} (${documents.length})',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[900]),
        ),
        iconColor: Colors.blue[700],
        collapsedIconColor: Colors.grey[600],
        childrenPadding: const EdgeInsets.only(bottom: 8),
        children: documents.isEmpty
            ? [_buildResultRow('no_documents', 'N/A', screenWidth, isNested: true)]
            : documents.asMap().entries.map((entry) {
          final index = entry.key;
          final document = entry.value as Map<String, dynamic>;
          return Padding(
            padding: const EdgeInsets.only(left: 12, top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Document ${index + 1}',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[900]),
                ),
                _buildResultRow('document_type', document['document_type'] ?? '', screenWidth, isNested: true),
                _buildResultRow('document_status', document['status'] ?? '', screenWidth, isNested: true),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildArchivesSection(List<dynamic> archives, double screenWidth) {
    return Theme(
      data: Theme.of(Get.context!).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          'archives'.trParams({'count': archives.length.toString()}),
          // Fallback: '${'archives'.tr} (${archives.length})',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[900]),
        ),
        iconColor: Colors.blue[700],
        collapsedIconColor: Colors.grey[600],
        childrenPadding: const EdgeInsets.only(bottom: 8),
        children: archives.isEmpty
            ? [_buildResultRow('no_archives', 'N/A', screenWidth, isNested: true)]
            : archives.asMap().entries.map((entry) {
          final index = entry.key;
          final archive = entry.value as Map<String, dynamic>;
          return Padding(
            padding: const EdgeInsets.only(left: 12, top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Archive ${index + 1}',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[900]),
                ),
                _buildResultRow('archive_number', archive['archiveNumber'].toString(), screenWidth, isNested: true),
                _buildResultRow('case_status', archive['caseStatus'] ?? '', screenWidth, isNested: true),
                _buildResultRow('customer_status', archive['caseCustomerStatus'] ?? '', screenWidth, isNested: true),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}