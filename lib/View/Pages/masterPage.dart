import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:leave_mib/Controller/hr.dart';
import 'package:leave_mib/Controller/updateLeave.dart';
import 'package:flutter/material.dart';
import 'package:leave_mib/Model/global.dart';
import 'package:leave_mib/Model/notification.dart';
import 'package:leave_mib/View/Pages/Widgets/ButtonLeaves.dart';

class MasterCeoPage extends StatelessWidget {
  MasterCeoPage({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot> getMasterLeaveRequests() {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      return const Stream.empty();
    }

    return _firestore.collection('Master_CEO').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: getMasterLeaveRequests(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            var leaveRequests = snapshot.data!.docs;
            var validDocs = leaveRequests.where((doc) {
              var data = doc.data() as Map<String, dynamic>?;
              return data != null &&
                  data.containsKey('employeeID') &&
                  data['employeeID'] != null;
            }).toList();

            if (leaveRequests.length < 2) {
              return Center(child: Text("لا توجد طلبات إجازة"));
            }

            return ListView.builder(
                itemCount: validDocs.length,
                itemBuilder: (context, index) {
                  var doc = leaveRequests[index];

                  return Center(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: Offset(0, 5),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.teal.shade200,
                            child: Icon(Icons.person,
                                color: Colors.white, size: 30),
                          ),
                          SizedBox(height: 10),
                          Text(
                            doc['employeeID'],
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal.shade800),
                          ),
                          SizedBox(height: 10),
                          buildInfoRow("القسم:", doc['department']),
                          buildInfoRow("نوع الإجازة:", doc['leaveType']),
                          buildInfoRow("التاريخ:", doc['date']),
                          buildInfoRow("المدة:", doc['Period']),
                          buildInfoRow("السبب:", doc['reason']),
                          buildInfoRow("البديل:", doc['substitute']),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              MyButton(
                                bgColor: Colors.teal,
                                textColor: Colors.white,
                                txt: 'Approve',
                                press: () {
                                  updateLeaveApprovalMaster(doc['employeeID'],
                                      CEOApproval: true);

                                  updateLeaveBalance(
                                      doc['employeeID'], -doc['duration']);
                                  sendNotification(doc['employeeID'],
                                      'تمت الموافقة على الاجـازة ✅');
                                  listenForApprovedLeavesMaster();

                                  Get.snackbar('', 'تـمـت المـوافـقة بنـجاح',
                                      backgroundColor: Colors.green);
                                },
                              ),
                              MyButton(
                                bgColor: Colors.red,
                                textColor: Colors.white,
                                txt: 'Decline',
                                press: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                            title: Text('Enter Text'),
                                            content: TextField(
                                              onChanged: (value) {
                                                Global.declineReason = value;
                                              },
                                              decoration: InputDecoration(
                                                  hintText: "Enter something"),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text('Cancel'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  Global.declineReason = '';
                                                },
                                              ),
                                              TextButton(
                                                  child: Text('OK'),
                                                  onPressed: () {
                                                    deleteLeavebyMaster(
                                                        doc['employeeID']);
                                                    Navigator.of(context).pop();

                                                    sendNotification(
                                                        doc['employeeID'],
                                                        '❌ تم رفض الأجـازة بسبب : ${Global.declineReason}');
                                                  }),
                                            ]);
                                      });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
