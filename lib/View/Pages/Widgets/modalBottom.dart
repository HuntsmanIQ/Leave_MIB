import 'package:flutter/material.dart';
import 'package:leave_mib/Controller/vacationController.dart';
import 'package:get/get.dart';

class ModalBottomSheetContent extends StatelessWidget {
  final controller = Get.find<VacationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "اختيار مدة الإجازة",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal.shade700,
      ),
      backgroundColor: Colors.teal.shade50,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("اختر مدة الإجازة",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700)),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownMenu(
                    inputDecorationTheme: InputDecorationTheme(
                      filled: true,
                      fillColor: Colors.blue[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2.0,
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
                          color:
                              Colors.red, // Border color when there's an error
                          width: 2.0,
                        ),
                      ),
                      contentPadding: EdgeInsets.all(16.0),
                    ),
                    onSelected: (value) {
                      switch (value) {
                        case 0.25:
                          controller.timePeriod = 0.25;
                          controller.period =
                              '${controller.start.format(context)} - 15 min';
                          controller.changeTime();

                          break;

                        case 0.5:
                          controller.timePeriod = 0.5;
                          controller.period =
                              '${controller.start.format(context)} - 30 min';
                          controller.changeTime();

                          break;
                        case 1:
                          controller.timePeriod = 1;
                          controller.period =
                              '${controller.start.format(context)} - 1 Hour';
                          controller.changeTime();
                          break;

                        case 1.25:
                          controller.timePeriod = 1.25;
                          controller.period =
                              '${controller.start.format(context)} - 1 : 15 Hour';
                          controller.changeTime();
                          break;
                        case 1.5:
                          controller.timePeriod = 1.5;
                          controller.period =
                              '${controller.start.format(context)} - 1 : 30 Hour';
                          controller.changeTime();
                          break;
                        case 2:
                          controller.timePeriod = 2;
                          controller.period =
                              '${controller.start.format(context)} - 2 Hour';
                          controller.changeTime();
                          break;
                        case 2.25:
                          controller.timePeriod = 2.25;
                          controller.period =
                              '${controller.start.format(context)} - 2 : 15 Hour';
                          controller.changeTime();
                          break;
                        case 2.5:
                          controller.timePeriod = 2.5;
                          controller.period =
                              '${controller.start.format(context)} - 2 : 30 Hour';
                          controller.changeTime();
                          break;
                        case 3:
                          controller.timePeriod = 3;
                          controller.period =
                              '${controller.start.format(context)} - 3 Hour';
                          controller.changeTime();
                          break;
                      }

                      controller.update();
                    },
                    dropdownMenuEntries: const <DropdownMenuEntry<double>>[
                      DropdownMenuEntry(value: 0.25, label: '15 دقيقة'),
                      DropdownMenuEntry(value: 0.5, label: '30 دقيقة'),
                      DropdownMenuEntry(value: 1, label: '1'),
                      DropdownMenuEntry(value: 1.25, label: '1:15'),
                      DropdownMenuEntry(value: 1.5, label: '1:30'),
                      DropdownMenuEntry(value: 2, label: '2'),
                      DropdownMenuEntry(value: 2.25, label: '2:15'),
                      DropdownMenuEntry(value: 2.5, label: '2:30'),
                      DropdownMenuEntry(value: 3, label: '3')
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade500,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: Text("Confirm",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
