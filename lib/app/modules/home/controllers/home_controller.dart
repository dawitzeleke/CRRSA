import 'dart:async';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final count = 0.obs;
  var selectedRequestType = 'Pending'.obs;
  var pendingFilter = 'All'.obs;
  var pendingRequests = <Request>[].obs;
  var inProgressRequests = <Request>[].obs;
  var closedRequests = <Request>[].obs;
  var nonConstitutionalRequests = <Request>[].obs;
  final PageController announcementsPageController = PageController();
  final PageController newsPageController = PageController();
  var currentPage = 0.obs;
  var currentPagenews = 0.obs;
  late Timer autoScrollTimer;
  var isLoading = false.obs;
  var isFabExpanded = false.obs;
  var selectedIndex = 0.obs;


  List<String> announcements = [
    'Public Hearing Scheduled',
    'Citizen Feedback Initiative',
    'New Case Procedures',
    'Legal Training Session',
    'Case Updates',
  ];

  @override
  void onInit() {
    super.onInit();
    loadStaticRequests();
    startAutoScroll();
  }

  @override
  void onClose() {
    autoScrollTimer.cancel();
    announcementsPageController.dispose();
    newsPageController.dispose();
    super.onClose();
  }

  void increment() => count.value++;

  void updateRequestType(String requestType) {
    selectedRequestType.value = requestType;
    if (requestType != 'Pending') {
      pendingFilter.value = 'All';
    }
  }

  void startAutoScroll() {
    autoScrollTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (announcementsPageController.hasClients) {
        int nextPage = (currentPage.value + 1) % announcements.length;
        announcementsPageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        currentPage.value = nextPage;
      }

      if (newsPageController.hasClients) {
        int nextPage = (currentPagenews.value + 1) % 3;
        newsPageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
        );
        currentPagenews.value = nextPage;
      }
    });
  }

  void loadStaticRequests() {
    isLoading.value = true;

    // Static request data
    final List<Map<String, dynamic>> staticRequests = [
      {
        'request_id': '123e4567-e89b-12d3-a456-426614174000',
        'constitutional_complaint_summary': 'Constitutional Violation Case 1',
        'affair_discrption': 'Violation of rights under article 25',
        'status': 'Pending',
        'request_date': '2025-07-01',
        'representative_name': 'Kaleab Fekadu',
        'phone': '0912345678',
        'phone_additional': '0923456789',
        'gender': 'Male',
        'court_case_result_reference': 'CCR-001',
        'violated_constitution_article': 'Article 25',
        'caseType': {'name': 'Constitutional'},
        'applicants': [
          {
            'applicant_name': 'Kaleab Fekadu',
            'phone_number': '0912345678',
            'address': 'Addis Ababa',
            'region': {'name': 'Oromia'},
            'zone': {'name': 'Zone 1'},
            'woreda': {'name': 'Woreda 1'},
          },
        ],
        'respondents': [
          {
            'respondent_name': 'Government Office',
            'phone_number': '0934567890',
            'address': 'Addis Ababa',
            'region': {'name': 'Oromia'},
            'zone': {'name': 'Zone 2'},
            'woreda': {'name': 'Woreda 2'},
          },
        ],
        'archives': [
          {
            'archiveNumber': 'ARCH-001',
            'caseId': 'CASE-001',
            'caseStatus': 'Active',
            'caseCustomerStatus': 'Pending',
          },
        ],
      },
      {
        'request_id': '223e4567-e89b-12d3-a456-426614174001',
        'constitutional_complaint_summary': 'Constitutional Violation Case 2',
        'affair_discrption': 'Violation of rights under article 30',
        'status': 'Under Review',
        'request_date': '2025-07-05',
        'representative_name': 'Fatima Ali',
        'phone': '0945678901',
        'phone_additional': '0956789012',
        'gender': 'Female',
        'court_case_result_reference': 'CCR-002',
        'violated_constitution_article': 'Article 30',
        'caseType': {'name': 'Constitutional'},
        'applicants': [
          {
            'applicant_name': 'Fatima Ali',
            'phone_number': '0945678901',
            'address': 'Jimma',
            'region': {'name': 'Oromia'},
            'zone': {'name': 'Zone 3'},
            'woreda': {'name': 'Woreda 3'},
          },
        ],
        'respondents': [
          {
            'respondent_name': 'Local Authority',
            'phone_number': '0967890123',
            'address': 'Jimma',
            'region': {'name': 'Oromia'},
            'zone': {'name': 'Zone 3'},
            'woreda': {'name': 'Woreda 3'},
          },
        ],
        'archives': [],
      },
      {
        'request_id': '323e4567-e89b-12d3-a456-426614174002',
        'constitutional_complaint_summary': 'Constitutional Violation Case 3',
        'affair_discrption': 'Violation of rights under article 15',
        'status': 'Approved',
        'request_date': '2025-06-20',
        'representative_name': 'Mohammed Said',
        'phone': '0978901234',
        'phone_additional': '0989012345',
        'gender': 'Male',
        'court_case_result_reference': 'CCR-003',
        'violated_constitution_article': 'Article 15',
        'caseType': {'name': 'Constitutional'},
        'applicants': [
          {
            'applicant_name': 'Mohammed Said',
            'phone_number': '0978901234',
            'address': 'Adama',
            'region': {'name': 'Oromia'},
            'zone': {'name': 'Zone 4'},
            'woreda': {'name': 'Woreda 4'},
          },
        ],
        'respondents': [
          {
            'respondent_name': 'Regional Office',
            'phone_number': '0990123456',
            'address': 'Adama',
            'region': {'name': 'Oromia'},
            'zone': {'name': 'Zone 4'},
            'woreda': {'name': 'Woreda 4'},
          },
        ],
        'archives': [],
      },
      {
        'request_id': '423e4567-e89b-12d3-a456-426614174003',
        'constitutional_complaint_summary': 'Constitutional Violation Case 4',
        'affair_discrption': 'Violation of rights under article 40',
        'status': 'Decided',
        'request_date': '2025-06-15',
        'representative_name': 'Tigist Lemma',
        'phone': '0911123456',
        'phone_additional': '0922234567',
        'gender': 'Female',
        'court_case_result_reference': 'CCR-004',
        'violated_constitution_article': 'Article 40',
        'caseType': {'name': 'Constitutional'},
        'applicants': [
          {
            'applicant_name': 'Tigist Lemma',
            'phone_number': '0911123456',
            'address': 'Finfinne',
            'region': {'name': 'Oromia'},
            'zone': {'name': 'Zone 5'},
            'woreda': {'name': 'Woreda 5'},
          },
        ],
        'respondents': [
          {
            'respondent_name': 'Federal Office',
            'phone_number': '0933345678',
            'address': 'Finfinne',
            'region': {'name': 'Oromia'},
            'zone': {'name': 'Zone 5'},
            'woreda': {'name': 'Woreda 5'},
          },
        ],
        'archives': [],
      },
      {
        'request_id': '523e4567-e89b-12d3-a456-426614174004',
        'constitutional_complaint_summary': 'Constitutional Violation Case 5',
        'affair_discrption': 'Violation of rights under article 18',
        'status': 'Rejected',
        'request_date': '2025-07-10',
        'representative_name': 'Yohannes Bekele',
        'phone': '0944456789',
        'phone_additional': '0955567890',
        'gender': 'Male',
        'court_case_result_reference': 'CCR-005',
        'violated_constitution_article': 'Article 18',
        'caseType': {'name': 'Constitutional'},
        'applicants': [
          {
            'applicant_name': 'Yohannes Bekele',
            'phone_number': '0944456789',
            'address': 'Bishoftu',
            'region': {'name': 'Oromia'},
            'zone': {'name': 'Zone 6'},
            'woreda': {'name': 'Woreda 6'},
          },
        ],
        'respondents': [
          {
            'respondent_name': 'Municipal Office',
            'phone_number': '0966678901',
            'address': 'Bishoftu',
            'region': {'name': 'Oromia'},
            'zone': {'name': 'Zone 6'},
            'woreda': {'name': 'Woreda 6'},
          },
        ],
        'archives': [],
      },
    ];

    _categorizeRequests(staticRequests);
    isLoading.value = false;
  }

  void _categorizeRequests(List<Map<String, dynamic>> data) {
    pendingRequests.clear();
    inProgressRequests.clear();
    closedRequests.clear();
    nonConstitutionalRequests.clear();

    for (var item in data) {
      List<Applicant> applicants = [];
      List<Respondent> respondents = [];
      List<RequestDocument> requestDocuments = [];
      List<Archive> archives = [];

      if (item['applicants'] != null) {
        for (var applicantItem in item['applicants']) {
          applicants.add(Applicant(
            applicantName: applicantItem['applicant_name'] ?? 'Unknown',
            phoneNumber: applicantItem['phone_number'] ?? 'Unknown',
            address: applicantItem['address'] ?? 'Unknown',
            region: applicantItem['region']?['name'],
            zone: applicantItem['zone']?['name'],
            woreda: applicantItem['woreda']?['name'],
          ));
        }
      }

      if (item['respondents'] != null) {
        for (var respondentItem in item['respondents']) {
          respondents.add(Respondent(
            respondentName: respondentItem['respondent_name'] ?? 'Unknown',
            phoneNumber: respondentItem['phone_number'] ?? 'Unknown',
            address: respondentItem['address'] ?? 'Unknown',
            region: respondentItem['region']?['name'],
            zone: respondentItem['zone']?['name'],
            woreda: respondentItem['woreda']?['name'],
          ));
        }
      }

      if (item['archives'] != null && item['archives'] is List) {
        for (var archiveItem in item['archives']) {
          archives.add(Archive(
            archiveNumber: archiveItem['archiveNumber'] ?? '0',
            caseId: archiveItem['caseId'] ?? 'Unknown',
            caseStatus: archiveItem['caseStatus'] ?? 'Unknown',
            caseCustomerStatus: archiveItem['caseCustomerStatus'] ?? 'Unknown',
          ));
        }
      }

      final request = Request(
        requestId: item['request_id'] ?? 'Unknown ID',
        title: item['constitutional_complaint_summary'] ?? 'No Title',
        description: item['affair_discrption'] ?? 'No Description',
        status: item['status'] ?? 'Unknown',
        requestDate: item['request_date'] ?? 'Unknown Date',
        representativeName: item['representative_name'] ?? 'Unknown',
        phone: item['phone'] ?? 'Unknown',
        phoneAdditional: item['phone_additional'] ?? 'Unknown',
        gender: item['gender'] ?? 'Unknown',
        courtCaseResultReference: item['court_case_result_reference'] ?? 'Unknown',
        violatedConstitutionArticle: item['violated_constitution_article'] ?? 'Unknown',
        otherApplicableLaws: item['other_applicable_laws'],
        constitutionalComplaintSummary: item['constitutional_complaint_summary'],
        caseType: item['caseType']?['name'],
        applicants: applicants,
        respondents: respondents,
        requestDocuments: requestDocuments,
        archives: archives,
        caseTypeName: item['caseTypeName'] ?? 'Unknown',
        applicantNames: item['applicantNames'] ?? 'Unknown',
        applicantPhoneNumber: item['applicantPhoneNumber'] ?? 'Unknown',
        applicantRegions: item['applicantRegions'],
        applicantZones: item['applicantZones'],
        applicantWoredas: item['applicantWoredas'],
        applicantCity: item['applicantCity'],
        applicantSubCity: item['applicantSubCity'],
        respondentNames: item['respondentNames'] ?? 'Unknown',
        respondentPhoneNumber: item['respondentPhoneNumber'] ?? 'Unknown',
        respondentAddress: item['respondentAddress'] ?? 'Unknown',
        respondentRegions: item['respondentRegions'],
        respondentZones: item['respondentZones'],
        respondentWoredas: item['respondentWoredas'],
        respondentCities: item['respondentCities'],
        respondentSubCities: item['respondentSubCities'],
      );

      switch (request.status.toLowerCase()) {
        case 'pending':
        case 'under review':
          pendingRequests.add(request);
          break;
        case 'approved':
          closedRequests.add(request);
          break;
        case 'decided':
          nonConstitutionalRequests.add(request);
          break;
        case 'rejected':
          inProgressRequests.add(request);
          break;
        default:
          break;
      }
    }

    pendingRequests.refresh();
    inProgressRequests.refresh();
    closedRequests.refresh();
    nonConstitutionalRequests.refresh();
  }

  List<Request> getRequestsByType(String type) {
    switch (type.toLowerCase()) {
      case 'pending':
        if (pendingFilter.value == 'All') {
          return pendingRequests.toList();
        } else {
          return pendingRequests
              .where((r) => r.status.toLowerCase() == pendingFilter.value.toLowerCase())
              .toList();
        }
      case 'approved':
        return closedRequests.toList();
      case 'decided':
        return nonConstitutionalRequests.toList();
      case 'rejected':
        return inProgressRequests.toList();
      default:
        return [];
    }
  }

  Future<void> fetchDataFromDatabase() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 1)); // Simulate delay
    loadStaticRequests();
    isLoading.value = false;
  }
}

class Request {
  final String requestId;
  final String title;
  final String description;
  final String status;
  final String requestDate;
  final String representativeName;
  final String phone;
  final String phoneAdditional;
  final String gender;
  final String courtCaseResultReference;
  final String violatedConstitutionArticle;
  final String? otherApplicableLaws;
  final String? constitutionalComplaintSummary;
  final String? caseType;
  final List<Applicant> applicants;
  final List<Respondent> respondents;
  final List<RequestDocument> requestDocuments;
  final List<Archive> archives;
  final String caseTypeName;
  final String applicantNames;
  final String applicantPhoneNumber;
  final dynamic applicantRegions;
  final dynamic applicantZones;
  final dynamic applicantWoredas;
  final dynamic applicantCity;
  final dynamic applicantSubCity;
  final String respondentNames;
  final String respondentPhoneNumber;
  final String respondentAddress;
  final dynamic respondentRegions;
  final dynamic respondentZones;
  final dynamic respondentWoredas;
  final dynamic respondentCities;
  final dynamic respondentSubCities;

  Request({
    required this.requestId,
    required this.title,
    required this.description,
    required this.status,
    required this.requestDate,
    required this.representativeName,
    required this.phone,
    required this.phoneAdditional,
    required this.gender,
    required this.courtCaseResultReference,
    required this.violatedConstitutionArticle,
    this.otherApplicableLaws,
    this.constitutionalComplaintSummary,
    this.caseType,
    required this.applicants,
    required this.respondents,
    required this.requestDocuments,
    required this.archives,
    required this.caseTypeName,
    required this.applicantNames,
    required this.applicantPhoneNumber,
    this.applicantRegions,
    this.applicantZones,
    this.applicantWoredas,
    this.applicantCity,
    this.applicantSubCity,
    required this.respondentNames,
    required this.respondentPhoneNumber,
    required this.respondentAddress,
    this.respondentRegions,
    this.respondentZones,
    this.respondentWoredas,
    this.respondentCities,
    this.respondentSubCities,
  });
}

class Applicant {
  final String applicantName;
  final String phoneNumber;
  final String address;
  final String? region;
  final String? zone;
  final String? woreda;

  Applicant({
    required this.applicantName,
    required this.phoneNumber,
    required this.address,
    this.region,
    this.zone,
    this.woreda,
  });
}

class Respondent {
  final String respondentName;
  final String phoneNumber;
  final String address;
  final String? region;
  final String? zone;
  final String? woreda;

  Respondent({
    required this.respondentName,
    required this.phoneNumber,
    required this.address,
    this.region,
    this.zone,
    this.woreda,
  });
}

class RequestDocument {
  final String documentName;

  RequestDocument({required this.documentName});
}

class Archive {
  final String archiveNumber;
  final String caseId;
  final String caseStatus;
  final String caseCustomerStatus;

  Archive({
    required this.archiveNumber,
    required this.caseId,
    required this.caseStatus,
    required this.caseCustomerStatus,
  });
}