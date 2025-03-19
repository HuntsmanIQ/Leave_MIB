import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:leave_mib/auth/resetPage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:leave_mib/Model/global.dart';
import 'package:leave_mib/View/Pages/homepagebody.dart';
import 'package:leave_mib/auth/login.dart';

class Auth extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final LocalAuthentication localAuth = LocalAuthentication();

  bool isLoading = false;

  /// ✅ تسجيل الدخول يدويًا + حفظ البريد وكلمة المرور
  Future<void> signIn(String email, String password) async {
    try {
      isLoading = true;
      update(); // Notify GetBuilder to show loading indicator

      await auth.signInWithEmailAndPassword(email: email, password: password);

      // 🔹 حفظ البريد وكلمة المرور في التخزين الآمن
      await storage.write(key: 'email', value: email);
      await storage.write(key: 'password', value: password);

      String? token = await FirebaseMessaging.instance.getToken();

      DocumentSnapshot employeeData = await _firestore
          .collection('employees')
          .where('email', isEqualTo: email)
          .limit(1)
          .get()
          .then((snapshot) => snapshot.docs.first);

      String employeeID = employeeData['employeeID'];
      String department = employeeData['department'];
      String name = employeeData['name'];
      String managerID = employeeData['ManagerID'];
      Global.leaveBalance = employeeData['leave'];
      bool isManager = employeeData['isManager'];
      String position = employeeData['position'];

      await FirebaseFirestore.instance
          .collection('employees')
          .doc(employeeID)
          .update({'token': token});

      navigateToHomePage(name, managerID, department, position, isManager);

      // When done, stop loading
      isLoading = false;
      update();
    } catch (e) {
      isLoading = false;
      update();
      Get.snackbar('خطأ', e.toString(), backgroundColor: Colors.red);
      print("Error: $e");
    }
  }

  /// ✅ التحقق من البصمة/الوجه وتسجيل الدخول تلقائيًا
  Future<void> biometricLogin() async {
    try {
      print("🚀 Checking biometric authentication...");

      bool canCheckBiometrics = await localAuth.canCheckBiometrics;
      bool isDeviceSupported = await localAuth.isDeviceSupported();

      if (canCheckBiometrics && isDeviceSupported) {
        print("✅ Device supports biometrics!");

        bool isAuthenticated = await localAuth.authenticate(
          localizedReason: 'login using Biometrics',
          options: AuthenticationOptions(biometricOnly: true),
        );

        if (isAuthenticated) {
          print("🎉 Biometric authentication successful!");

          String? email = await storage.read(key: 'email');
          String? password = await storage.read(key: 'password');

          if (email != null && password != null) {
            print("🔹 Logging in with saved credentials...");
            await signIn(email, password);
          } else {
            print("❌ No saved credentials to use for login.");
          }
        } else {
          print("❌ Biometric authentication failed.");
        }
      } else {
        print("❌ Biometrics not supported on this device.");
      }
    } catch (e) {
      print("🚨 Error in biometric authentication: $e");
    }
  }

  /// ✅ استدعاء تسجيل الدخول بالبصمة عند تشغيل التطبيق
  Future<void> autoLogin() async {
    print("🚀 Checking for saved credentials...");

    String? email = await storage.read(key: 'email');
    String? password = await storage.read(key: 'password');

    if (email != null && password != null) {
      print("🔹 Found saved credentials: Email = $email");
      await biometricLogin();
    } else {
      print("❌ No saved credentials found.");
    }
  }

  /// ✅ توجيه المستخدم إلى الصفحة المناسبة
  void navigateToHomePage(String name, String managerID, String department,
      String position, bool isManager) {
    if (department == 'ceo' && position == 'duty') {
      Get.off(CEOHomePage(
        name: name,
        managerID: managerID,
        department: department,
        position: position,
      ));
    } else if (department == 'ceo' && position == 'Master') {
      Get.off(MasterHomePage(
        name: name,
        managerID: managerID,
        department: department,
        position: position,
      ));
    } else if (isManager) {
      Get.off(ManagerHomePage(
        name: name,
        isManager: isManager,
        managerID: managerID,
        department: department,
      ));
    } else {
      Get.off(EmployeHomePage(
        name: name,
        managerID: managerID,
        department: department,
      ));
    }
  }

  /// ✅ تسجيل الخروج ومسح البيانات المحفوظة
  Future<void> signOut() async {
    await auth.signOut();
    await storage.deleteAll();
    Get.offAll(LoginPage());
    print("تم تسجيل الخروج!");
  }

  Future<void> resetPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  void startLoading() async {
    isLoading = true;
    update();
    await Future.delayed(Duration(seconds: 15));
    isLoading = false;
    update();
  }

  void showResetPage(BuildContext context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        backgroundColor: Colors.white,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Resetpage();
        });
  }
}
