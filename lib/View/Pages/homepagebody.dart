import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:leave_mib/Model/global.dart';
import 'package:leave_mib/View/Pages/ceoPage.dart';
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
                builder: (auth) =>
                    ModernAppBar(name: name, press: () => auth.signOut())),
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
                builder: (auth) =>
                    ModernAppBar(name: name, press: () => auth.signOut())),
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
  });
  final managerID;
  final name, isManager, department;
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
                builder: (auth) =>
                    ModernAppBar(name: name, press: () => auth.signOut())),
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
  });

  final name, managerID, department;

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
                builder: (auth) =>
                    ModernAppBar(name: name, press: () => auth.signOut())),
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

class LeaveWidget extends StatelessWidget {
  const LeaveWidget({
    super.key,
    required this.name,
  });

  final dynamic name;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('employees')
          .doc(name)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Text('No data found');
        }

        var leaveValue = snapshot.data!.get('leave');
        Global.leaveBalance = leaveValue;

        return Container(
          alignment: Alignment.center,
          height: 50,
          width: 380,
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 70, 180, 169),
              borderRadius: BorderRadius.circular(8)),
          child: Text(
            'رصـيـد الأجـازات : ${leaveValue.toStringAsFixed(2)}',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        );
      },
    );
  }
}

class ModernAppBar extends StatelessWidget {
  ModernAppBar({
    required this.name,
    required this.press,
    super.key,
  });
  final String name;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        height: 30,
        color: Colors.teal,
      ),
      Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16))),
        child: Row(
          children: [
            SizedBox(width: 15),
            CircleAvatar(
              radius: 25,
              child: Icon(
                Icons.person,
                size: 30,
              ),
            ),
            SizedBox(width: 8),
            Text(name,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white)),
            Spacer(),
            IconButton(
              icon: Icon(Icons.power_settings_new),
              onPressed: press,
            ),
          ],
        ),
      ),
    ]);
  }
}

class LeaveTest extends StatelessWidget {
  const LeaveTest({
    required this.txt,
    super.key,
  });
  final txt;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 70, 180, 169),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'رصيد الأجازات : $txt',
        style: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class HomePageButton extends StatelessWidget {
  HomePageButton({
    required this.txt,
    required this.press,
    super.key,
  });
  final VoidCallback press;
  final String txt;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: press,
      child: Text(
        txt,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.teal[800],
        backgroundColor: Colors.teal[50], // تركواز داكن
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

///=====================
class Button extends StatelessWidget {
  Button({
    super.key,
    required this.txt,
    required this.press,
  });
  final String txt;
  final press;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: press,
          child: Container(
            alignment: Alignment.center,
            height: 70,
            width: 350,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.green[50]),
            child: Text(
              txt,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.blue[900]),
            ),
          ),
        ),
        const SizedBox(height: 20)
      ],
    );
  }
}

class Test2 extends StatelessWidget {
  const Test2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[100],
      body: Column(
        children: [
          ModernAppBar(name: 'name', press: () => print('good')),
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
                    LeaveTest(txt: '10'),
                    SizedBox(height: 16),
                    HomePageButton(txt: 'txt', press: () => null),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
