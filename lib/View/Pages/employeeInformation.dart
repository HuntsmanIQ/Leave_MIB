import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leave_mib/Model/global.dart';
import 'package:leave_mib/View/Pages/Widgets/employeeAppBar.dart';
import 'package:leave_mib/View/Pages/Widgets/history.dart';

class EmployeeInformationPage extends StatelessWidget {
  EmployeeInformationPage({super.key});
  Future<List<QueryDocumentSnapshot>> fetchEmployees() async {
    final collection = FirebaseFirestore.instance.collection('employees');
    final employeeIDs = Global.employeeIDs;

    List<QueryDocumentSnapshot> allDocs = [];

    // تقسيم القائمة إلى دفعات من 10 عناصر
    for (var i = 0; i < employeeIDs.length; i += 10) {
      final batch = employeeIDs.sublist(
        i,
        i + 10 > employeeIDs.length ? employeeIDs.length : i + 10,
      );

      final query = await collection.where('employeeID', whereIn: batch).get();
      allDocs.addAll(query.docs);
    }

    return allDocs;
  }

  // Future<List<QueryDocumentSnapshot>> fetchEmployees() async {
  //   final collection = FirebaseFirestore.instance.collection('employees');
  //   final query =
  //       await collection.where('employeeID', whereIn: Global.employeeIDs).get();
  //   return query.docs;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[100],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white, // Set the color of the back arrow
          onPressed: () {
            Get.back(); // Go back to the previous screen
          },
        ),
        backgroundColor: Colors.teal,
        title: Text(
          'مـعـلـومـات المـوظـفيـن',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: fetchEmployees(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final employees = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.only(top: 16, left: 10, right: 10),
              child: ListView.builder(
                itemCount: employees.length,
                itemBuilder: (context, index) {
                  final employee =
                      employees[index].data() as Map<String, dynamic>;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => Get.to(
                            EmployeeInformationDetails(name: employee['name'])),
                        child: Text(
                          employee['name'],
                          style: TextStyle(
                            fontSize: 18, // حجم خط أكبر
                            fontWeight: FontWeight.bold, // خط عريض
                            letterSpacing: 1.2, // تباعد بين الحروف
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, // لون النص
                          backgroundColor: const Color.fromARGB(
                              255, 7, 189, 129), // لون الزر
                          shadowColor: Colors.black.withOpacity(0.3), // ظل ناعم
                          elevation: 5, // ارتفاع خفيف
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(20), // زوايا ناعمة أكثر
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 18), // حجم مريح
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          } else {
            return Center(child: Text('No employees found.'));
          }
        },
      ),
    );
  }
}

class EmployeeInformationDetails extends StatelessWidget {
  const EmployeeInformationDetails({super.key, required this.name});

  final String name;
  Future<List<QueryDocumentSnapshot>> fetchHistory() async {
    final collection = FirebaseFirestore.instance
        .collection('employees')
        .doc(name)
        .collection('history')
        .where('name', isNotEqualTo: '');
    final query = await collection.get();
    return query.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[200],
      body: Column(
        children: [
          EmployeeAppBar(name: name),
          SizedBox(height: 4),
          Expanded(
            child: FutureBuilder<List<QueryDocumentSnapshot>>(
              future: fetchHistory(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final historyData = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.all(12),
                    child: ListView.builder(
                      itemCount: historyData.length,
                      itemBuilder: (context, index) {
                        final historyItem =
                            historyData[index].data() as Map<String, dynamic>;
                        return HistoryCardManager(
                          txt1: historyItem['leaveType'],
                          txt2: historyItem['Period'],
                          txt3: historyItem['date'],
                        );
                      },
                    ),
                  );
                } else {
                  return Center(child: Text('No history data found.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
