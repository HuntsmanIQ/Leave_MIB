import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class LeaveStatusController extends GetxController {
  var leaveData = {}.obs; // نخزن كل بيانات الإجازة هنا
  var isLoading = false.obs;

  Future<void> fetchLeaveStatus(String leaveId) async {
    isLoading.value = true;
    try {
      var firestore = FirebaseFirestore.instance;

      // استعلامات جلب الإجازة من جميع الـ Collections
      List<String> collections = ['leaves', 'ceo', 'hr'];
      String status = 'Unknown';

      for (var collection in collections) {
        var doc = await firestore.collection(collection).doc(leaveId).get();
        if (doc.exists) {
          leaveData.value = doc.data() ?? {}; // تخزين جميع بيانات الإجازة
          leaveData['status'] = collection == 'leaves'
              ? 'Pending...🕒'
              : (collection == 'ceo' ? 'Under Review...🕒' : 'Approved ✅');
          status = leaveData['status'];
          break; // إذا وجدنا الإجازة، نخرج من اللوب
        }
      }

      if (status == 'Unknown') {
        leaveData.value = {'status': 'Not Found'};
      }
    } catch (e) {
      leaveData.value = {'status': 'Error', 'message': e.toString()};
    }
    isLoading.value = false;
  }
}

class LeaveRequestsPage extends StatelessWidget {
  final String leaveId;
  LeaveRequestsPage({required this.leaveId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LeaveStatusController>(
      init: LeaveStatusController(),
      builder: (controller) {
        controller.fetchLeaveStatus(leaveId);

        return Scaffold(
          appBar: AppBar(title: Text('حـالـة الأجـازة')),
          body: Center(
            child: Obx(() {
              if (controller.isLoading.value) {
                return CircularProgressIndicator();
              } else if (controller.leaveData.isEmpty) {
                return Text('No leave data found.');
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Status: ${controller.leaveData['status']}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'نـوع الأجـازة: ${controller.leaveData['leaveType'] ?? 'N/A'}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'التـاريـخ: ${controller.leaveData['date'] ?? 'N/A'}',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      ' ${controller.leaveData['Period'] ?? 'N/A'}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                );
              }
            }),
          ),
        );
      },
    );
  }
}
