import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:leave_mib/View/Pages/Widgets/ButtonLeaves.dart';
import 'package:leave_mib/View/Pages/Widgets/history.dart';

class LeaveStatusController extends GetxController {
  var leaveData = {}.obs; // نخزن كل بيانات الإجازة هنا
  var isLoading = false.obs;
  List<Map<String, dynamic>> history = [];

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

  Future<void> deleteLeave(String leaveID) async {
    await FirebaseFirestore.instance.collection('leaves').doc(leaveID).delete();
    update();
  }

  Future<List<Map<String, dynamic>>> fetchLeaveHistory(String leaveID) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('employees')
          .doc(leaveID)
          .collection('history')
          .orderBy('timestamp', descending: true) // ترتيب حسب الأحدث
          .get();

      List<Map<String, dynamic>> historyList = snapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

      return historyList;
    } catch (e) {
      print("Error fetching history: $e");
      return [];
    }
  }

  void getHistory(String leaveID) async {
    history = await fetchLeaveHistory(leaveID);
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
        controller.getHistory(leaveId);

        return Scaffold(
          appBar: AppBar(title: Text('حـالـة الأجـازة')),
          body: Column(
            children: [
              SizedBox(height: 16),
              Center(
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
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
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
                        SizedBox(height: 10),
                        controller.leaveData['status'] == 'Pending...🕒'
                            ? MyButton(
                                txt: 'Delete',
                                press: () => controller.deleteLeave(leaveId),
                                bgColor: const Color.fromARGB(255, 238, 96, 86),
                                textColor: Colors.white)
                            : SizedBox(),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(),
                        //
                        GestureDetector(
                          onTap: () => showModalBottomSheet<void>(
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext context) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 60),
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListView.builder(
                                          itemCount: controller.history.length,
                                          itemBuilder: (context, index) =>
                                              HistoryCard(
                                                  txt1:
                                                      controller.history[index]
                                                          ['leaveType'],
                                                  txt2: controller
                                                      .history[index]['Period'],
                                                  txt3: controller
                                                      .history[index]['date'],
                                                  duration:
                                                      controller.history[index]
                                                          ['duration'])),
                                    ),
                                  ),
                                );
                              }),
                          child: Text(
                            'Show All',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                        //
                        Container(
                          height: MediaQuery.of(context).size.height - 340,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: controller.history.length,
                                itemBuilder: (context, index) => HistoryCard(
                                    txt1: controller.history[index]
                                        ['leaveType'],
                                    txt2: controller.history[index]['Period'],
                                    txt3: controller.history[index]['date'],
                                    duration: controller.history[index]
                                        ['duration'])),
                          ),
                        )
                      ],
                    );
                  }
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
