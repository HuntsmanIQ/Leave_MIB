import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:leave_mib/Model/global.dart';
import 'package:leave_mib/View/Pages/Widgets/homePageWidgets.dart';
import 'package:leave_mib/View/Pages/ceoPage.dart';
import 'package:leave_mib/View/Pages/employeeInformation.dart';
import 'package:leave_mib/View/Pages/masterPage.dart';
import 'package:leave_mib/View/Pages/supervisor_master.dart';
import 'package:leave_mib/auth/authController.dart';
import 'package:leave_mib/View/Pages/supervisor.dart';
import 'package:leave_mib/View/Pages/fetchEmployeeLeave.dart';
import 'package:leave_mib/View/Pages/vacation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MasterHomePage extends StatelessWidget {
  MasterHomePage({
    super.key,
    required this.name,
    required this.managerID,
    required this.department,
    required this.position,
  });
  final managerID;
  final name, department, position;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool exitApp = await Get.defaultDialog(
          title: "تأكيد",
          middleText: "هل أنت متأكد أنك تريد الخروج؟",
          textConfirm: "نعم",
          textCancel: "لا",
          onConfirm: () => Get.back(result: true),
          onCancel: () => Get.back(result: false),
        );

        return exitApp ?? false;
      },
      child: Scaffold(
        backgroundColor: Colors.teal[100],
        body: Column(
          children: [
            GetBuilder<Auth>(
                init: Auth(),
                builder: (auth) => ModernAppBar2(
                    name: name,
                    position: position,
                    press: () => auth.signOut())),
            Expanded(
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.teal[100]!, Colors.teal[200]!],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      LeaveWidget(name: name),
                      SizedBox(height: 16),
                      HomePageButton(
                          txt: 'حـالة الأجـازة',
                          press: () =>
                              Get.to(LeaveRequestsPage(leaveId: name))),
                      SizedBox(height: 8),
                      HomePageButton(
                        txt: 'تـقـديم طـلـب اجـازة',
                        press: () => Get.to(
                          VacationPage(
                              name: name,
                              managerID: managerID,
                              department: department),
                        ),
                      ),
                      const SizedBox(height: 8),
                      HomePageButton(
                          txt: 'طلـبـات الأجـازة',
                          press: () => Get.to(SupervisorMaster())),
                      SizedBox(height: 8),
                      HomePageButton(
                        txt: 'الأجازات الخـاصـة',
                        press: () => department == 'ceo'
                            ? Get.to(MasterCeoPage())
                            : Get.snackbar('!تـحـذيـر', 'لـيـسـت لديـك صلاحـية',
                                backgroundColor: Colors.red),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CEOHomePage extends StatelessWidget {
  CEOHomePage({
    super.key,
    required this.name,
    required this.managerID,
    required this.department,
    required this.position,
  });
  final managerID;
  final name, department, position;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool exitApp = await Get.defaultDialog(
          title: "تأكيد",
          middleText: "هل أنت متأكد أنك تريد الخروج؟",
          textConfirm: "نعم",
          textCancel: "لا",
          onConfirm: () => Get.back(result: true),
          onCancel: () => Get.back(result: false),
        );

        return exitApp ?? false;
      },
      child: Scaffold(
        backgroundColor: Colors.teal[100],
        body: Column(
          children: [
            GetBuilder<Auth>(
                init: Auth(),
                builder: (auth) => ModernAppBar2(
                    name: name,
                    position: position,
                    press: () => auth.signOut())),
            Expanded(
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.teal[100]!, Colors.teal[200]!],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      LeaveWidget(name: name),
                      SizedBox(height: 16),
                      HomePageButton(
                          txt: 'حـالة الأجـازة',
                          press: () =>
                              Get.to(LeaveRequestsPage(leaveId: name))),
                      SizedBox(height: 8),
                      HomePageButton(
                        txt: 'تـقـديم طـلـب اجـازة',
                        press: () => Get.to(
                          VacationPage(
                              name: name,
                              managerID: managerID,
                              department: department),
                        ),
                      ),
                      SizedBox(height: 8),
                      HomePageButton(
                          txt: 'طلـبات الأجازة',
                          press: () => department == 'ceo'
                              ? Get.to(CEOPage())
                              : Get.snackbar(
                                  '!تـحـذيـر', 'لـيـسـت لديـك صلاحـية',
                                  backgroundColor: Colors.red)),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ManagerHomePage extends StatelessWidget {
  ManagerHomePage({
    super.key,
    required this.name,
    required this.isManager,
    required this.managerID,
    required this.department,
    required this.position,
  });
  final managerID;
  final name, isManager, department, position;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool exitApp = await Get.defaultDialog(
          title: "تأكيد",
          middleText: "هل أنت متأكد أنك تريد الخروج؟",
          textConfirm: "نعم",
          textCancel: "لا",
          onConfirm: () => Get.back(result: true),
          onCancel: () => Get.back(result: false),
        );

        return exitApp ?? false;
      },
      child: Scaffold(
        backgroundColor: Colors.teal[100],
        body: Column(
          children: [
            GetBuilder<Auth>(
                init: Auth(),
                builder: (auth) => ModernAppBar(
                    name: name,
                    position: position,
                    press: () => auth.signOut())),
            Expanded(
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.teal[100]!, Colors.teal[200]!],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      LeaveWidget(name: name),
                      SizedBox(height: 16),
                      HomePageButton(
                          txt: 'حـالة الأجـازة',
                          press: () =>
                              Get.to(LeaveRequestsPage(leaveId: name))),
                      SizedBox(height: 8),
                      HomePageButton(
                        txt: 'تـقـديم طلـب اجـازة',
                        press: () => Get.to(
                          VacationPage(
                              name: name,
                              managerID: managerID,
                              department: department),
                        ),
                      ),
                      SizedBox(height: 8),
                      HomePageButton(
                          txt: 'طلـبـات الأجــازة',
                          press: () => isManager
                              ? Get.to(SuperVisorPage())
                              : Get.snackbar(
                                  '!تـحـذيـر', 'لـيـسـت لديـك صلاحـية',
                                  backgroundColor: Colors.red)),
                      SizedBox(height: 8),
                      HomePageButton(
                          txt: 'مـعـلـومـات المـوظـف',
                          press: () => Get.to(EmployeeInformationPage())),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class EmployeHomePage extends StatelessWidget {
  const EmployeHomePage({
    super.key,
    required this.name,
    required this.managerID,
    required this.department,
    required this.position,
  });

  final name, managerID, department, position;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool exitApp = await Get.defaultDialog(
          title: "تأكيد",
          middleText: "هل أنت متأكد أنك تريد الخروج؟",
          textConfirm: "نعم",
          textCancel: "لا",
          onConfirm: () => Get.back(result: true),
          onCancel: () => Get.back(result: false),
        );

        return exitApp ?? false;
      },
      child: Scaffold(
        backgroundColor: Colors.teal[100],
        body: Column(
          children: [
            GetBuilder<Auth>(
                init: Auth(),
                builder: (auth) => ModernAppBar(
                    name: name,
                    position: position,
                    press: () => auth.signOut())),
            Expanded(
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.teal[100]!, Colors.teal[200]!],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      LeaveWidget(name: name),
                      SizedBox(height: 40),
                      HomePageButton(
                          txt: 'حـالة الأجـازة',
                          press: () =>
                              Get.to(LeaveRequestsPage(leaveId: name))),
                      SizedBox(height: 16),
                      HomePageButton(
                        txt: 'تـقـديم طـلب اجـازة',
                        press: () => Get.to(
                          VacationPage(
                              name: name,
                              managerID: managerID,
                              department: department),
                        ),
                      ),
                      SizedBox(height: 8),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
