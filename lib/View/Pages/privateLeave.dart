import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leave_mib/Controller/vacationController.dart';
import 'package:leave_mib/Model/global.dart';
import 'package:leave_mib/Model/notification.dart';

class PrivateleavePage extends StatelessWidget {
  PrivateleavePage({
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GetBuilder<VacationController>(
        init: VacationController(),
        builder: (controller) => SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text("اختر نوع الاجازة:",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.transparent),
                ),
                child: DropdownMenu(
                  inputDecorationTheme: InputDecorationTheme(
                    filled: true, // Whether the input is filled with a color
                    fillColor: Colors.blue[50], // Fill color for the input
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(8.0), // Rounded corners
                      borderSide: BorderSide(
                        color: Colors.blue, // Border color
                        width: 2.0, // Border width
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Colors.blueAccent, // Border color when focused
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Colors.blue, // Border color when enabled
                        width: 2.0,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Colors.red, // Border color when there's an error
                        width: 2.0,
                      ),
                    ),
                    contentPadding: EdgeInsets.all(16.0),
                  ),
                  onSelected: (value) {
                    controller.leaveTypePrivate = value.toString();
                  },
                  dropdownMenuEntries: const <DropdownMenuEntry<String>>[
                    DropdownMenuEntry(
                        value: 'مـرضـية', label: 'اجـازة مـرضـية '),
                    DropdownMenuEntry(
                        value: 'اجـازة الأمـومة', label: 'اجـازة الأمـومة  '),
                    DropdownMenuEntry(
                        value: 'اجازة الأبـوة', label: 'اجـازة الأبـوة  '),
                    DropdownMenuEntry(value: 'حداد', label: 'اجـازة الحـداد  '),
                    DropdownMenuEntry(value: 'زواج', label: 'اجـازة الزواج  '),
                    DropdownMenuEntry(
                        value: 'اجازة بدون راتب',
                        label: 'اجـازة بـدون راتـب  '),
                    DropdownMenuEntry(
                        value: 'اجازة الدراسـة', label: 'اجـازة الدراسة  '),
                  ],
                ),
              ),
            ]),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  controller.pickDatePrivate(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade300,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text("اختيار مدة الاجازة",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                child: Container(
                  alignment: Alignment.center,
                  height: 60,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(controller.datePrivate,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (controller.leaveTypePrivate == '' ||
                      controller.datePrivate == '') {
                    Get.snackbar('Warning', 'الرجـاء إخـتـيار نـوع الإجـازة',
                        backgroundColor: Colors.red[400]);
                  } else {
                    try {
                      controller.addLeave(
                          managerID,
                          name,
                          controller.leaveTypePrivate,
                          department,
                          controller.datePrivate,
                          '0',
                          0,
                          controller.leaveTypePrivate,
                          'لا يـوجـد');

                      Get.snackbar('Notification', 'تـم تـقديم الطلب بنـجاح',
                          backgroundColor: Colors.green);

                      sendNotification(Global.managerID,
                          'لديـك طلب إجـازة خاص ⭐ ${Global.leaveID}');
                    } catch (e) {
                      Get.snackbar('فشلت العملية', e.toString());
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade300,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  "تقديم الطـلب",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
