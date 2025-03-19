import 'package:get/get.dart';
import 'package:leave_mib/Controller/vacationController.dart';
import 'package:leave_mib/Model/global.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "صفحة تقديم الإجازة",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal.shade700,
      ),
      backgroundColor: Colors.teal.shade50,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GetBuilder<VacationController>(
          init: VacationController(),
          builder: (controller) => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                            filled:
                                true, // Whether the input is filled with a color
                            fillColor:
                                Colors.blue[50], // Fill color for the input
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
                                color: Colors
                                    .blueAccent, // Border color when focused
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
                                color: Colors
                                    .red, // Border color when there's an error
                                width: 2.0,
                              ),
                            ),
                            contentPadding: EdgeInsets.all(16.0),
                          ),
                          onSelected: (value) {
                            if (value == 'temp') {
                              controller.isTemp = true;
                              controller.vacationtype = 'زمـنـية';
                            } else {
                              controller.isTemp = false;
                              controller.vacationtype = 'يـومـيـة';
                            }
                          },
                          dropdownMenuEntries: const <DropdownMenuEntry<
                              String>>[
                            DropdownMenuEntry(
                                value: 'temp', label: 'اجـازة زمـنـيـة '),
                            DropdownMenuEntry(
                                value: 'day', label: 'اجـازة يـومـيـة '),
                          ],
                        ),
                      ),
                    ]),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.isTemp
                          ? controller.showModalBottom(context)
                          : controller.pickDate(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade300,
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 30),
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
                      child: Text(
                          controller.isTemp
                              ? '${controller.dateTime.day}/${controller.dateTime.month}/${controller.dateTime.year} - ${controller.period}'
                              : controller.selectedDate != null
                                  ? '${controller.selectedDate!.start.toLocal().toString().split(' ')[0]} to ${controller.selectedDate!.end.toLocal().toString().split(' ')[0]}'
                                  : "",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: controller.reason,
                  decoration: InputDecoration(
                    hintText: "أسباب الإجازة",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: controller.alternative,
                  decoration: InputDecoration(
                    hintText: "اسم البديل",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (controller.reason.text.isEmpty ||
                          controller.alternative.text.isEmpty) {
                        Get.snackbar(
                          'تـحذيـر',
                          'يـرجـى ملئ الـبيانات!',
                          backgroundColor: Colors.red,
                        );
                      } else if (Global.leaveBalance < controller.dayDuration ||
                          Global.leaveBalance < Global.leaveDuration) {
                        {
                          Get.snackbar(
                              'تـحـذير', 'انت لا تمتلك رصيد اجـازات كـافي!',
                              backgroundColor: Colors.red);
                        }
                      } else {
                        try {
                          controller.addLeave(
                              managerID,
                              name,
                              controller.vacationtype,
                              department,
                              controller.isTemp
                                  ? controller.dateTime
                                      .toString()
                                      .substring(0, 10)
                                  : controller.selectedDate!.start
                                      .toLocal()
                                      .toString()
                                      .split(' ')[0],
                              controller.period,
                              Global.leaveDuration == 0
                                  ? 1
                                  : Global.leaveDuration,
                              controller.reason.text,
                              controller.alternative.text);
                          controller.reason.clear();
                          controller.alternative.clear();

                          Get.snackbar(
                              'Notification', 'تـم تـقديم الطلب بنـجاح',
                              backgroundColor: Colors.green);
                        } catch (e) {
                          Get.snackbar('فشلت العملية', e.toString());
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade300,
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text("تقديم الطلب",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LeaveRequestForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("صفحة تقديم الإجازة"),
        backgroundColor: Colors.teal.shade700,
      ),
      backgroundColor: Colors.teal.shade50,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("اختر نوع الاجازة:",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700)),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black54),
                  ),
                  child: DropdownButton(
                    value: "إجازة يومية",
                    underline: SizedBox(),
                    items: ["إجازة يومية", "إجازة سنوية"].map((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {},
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade300,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text("اختيار مدة الاجازة",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.green.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text("2025-02-21 to 2025-02-21",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: "أسباب الإجازة",
                filled: true,
                fillColor: Colors.white,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: "اسم البديل",
                filled: true,
                fillColor: Colors.white,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade300,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text("تقديم الطلب",
                    style:
                        TextStyle(fontSize: 18, color: Colors.blue.shade900)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
