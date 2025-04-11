import 'package:flutter/material.dart';
import 'package:leave_mib/View/Pages/normalLeave.dart';
import 'package:leave_mib/View/Pages/privateLeave.dart';

class VacationPage extends StatelessWidget {
  VacationPage({
    super.key,
    required this.name,
    required this.managerID,
    required this.department,
  });
  final name;
  final managerID;
  final department;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.white, // Set the color of the back arrow
              onPressed: () {
                Navigator.pop(context); // Go back to the previous screen
              },
            ),
            title: Text(
              "صفحة تقديم الإجازة",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.teal.shade700,
          ),
          backgroundColor: Colors.teal.shade50,
          body: Column(
            children: [
              Container(
                color: Colors.teal.shade100,
                child: TabBar(
                    indicatorColor:
                        Colors.teal.shade700, // Active tab indicator
                    labelColor: Colors.teal.shade900, // Active tab text color
                    unselectedLabelColor: Colors.black54,
                    tabs: [
                      Tab(
                        icon: Icon(Icons.calendar_month),
                        child: Text("الإجـازات الإعـتـيادية",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Tab(
                        icon: Icon(Icons.stars),
                        child: Text("الإجـازات الخـاصـة",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ]),
              ),
              Expanded(
                child: TabBarView(children: [
                  NormalLeavePage(
                      name: name, managerID: managerID, department: department),
                  PrivateleavePage(
                      name: name, managerID: managerID, department: department)
                ]),
              )
            ],
          )),
    );
  }
}
