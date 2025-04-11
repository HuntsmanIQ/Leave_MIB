import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:leave_mib/Model/global.dart';
import 'package:leave_mib/View/Pages/Widgets/modalBottom.dart';

class VacationController extends GetxController {
  bool isTemp = false;
  int dayDuration = 1;
  DateTimeRange? selectedDate = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );
  String vacationtype = 'يـومـيـة';
  String name = '';
  TextEditingController reason = TextEditingController();
  TextEditingController alternative = TextEditingController();
// Select time and date for temp vacation
  DateTime dateTime = DateTime(2025, 01, 01, 12, 00);
  TimeOfDay start = TimeOfDay(hour: 08, minute: 00);
  //period to post in firebase to work only
  double timePeriod = 0;
  //period to post in Firebase to show only
  String period = '1 يـوم';

  // date for private leaves only
  String datePrivate = '';
  String leaveTypePrivate = '';

  Future<void> pickDateAndTimeRange(BuildContext context) async {
    // Step 1: Pick a date
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date == null) return; // User canceled date picker
    dateTime = date;

    // Step 2: Pick the start time
    final TimeOfDay? startTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 08, minute: 00),
    );

    if (startTime == null) return;
    start = startTime; // User canceled time picker
    Global.leaveDuration = timePeriod * 0.14;

    update();
  }

  void showModalBottom(BuildContext context) async {
    await pickDateAndTimeRange(context);
    showModalBottomSheet(
        // ignore: use_build_context_synchronously
        context: context,
        isScrollControlled: false,
        builder: (BuildContext context) {
          return SizedBox(
              height: MediaQuery.of(context).size.height - 350,
              child: ModalBottomSheetContent());
        });
    update();
  }

// this function for update duration in database (only in Temp leaves)
  void changeTime() {
    Global.leaveDuration = timePeriod * 0.14;
  }

// Select date range for daily vacation
  Future<void> pickDate(BuildContext context) async {
    final DateTimeRange? pickedDate = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        initialDateRange: selectedDate);

    if (pickedDate != null && pickedDate != selectedDate) {
      selectedDate = pickedDate;
      dayDuration = 0;
      dayDuration = pickedDate.duration.inDays + 1;
      Global.leaveDuration = dayDuration.toDouble();

      period = '$dayDuration يـوم';
      update();
    }
  }

  // for private leaves only
  Future<void> pickDatePrivate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      String formattedDate =
          "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";

      datePrivate = formattedDate;
    }
    update();
  }

////
  Future<void> addLeave(
    String managerID,
    String employeeID,
    String leaveType,
    String department,
    String date,
    String period,
    double duration,
    String reason,
    String substitute, {
    bool managerApproval = false,
    bool CEOApproval = false,
  }) async {
    if (isTemp) {
      await FirebaseFirestore.instance
          .collection('leaves')
          .doc(employeeID)
          .set({
        'ManagerID': managerID,
        'employeeID': employeeID,
        'department': department,
        'leaveType': leaveType,
        'Period': period,
        'duration': duration,
        'date': date,
        'reason': reason,
        'substitute': substitute,
        'managerApproval': managerApproval,
        'CEOApproval': CEOApproval,
      });

      Global.leaveID = employeeID;
      print("تمت إضافة الموظف بمعرف: $employeeID");
    } else {
      await FirebaseFirestore.instance
          .collection('leaves')
          .doc(employeeID)
          .set({
        'ManagerID': managerID,
        'employeeID': employeeID,
        'department': department,
        'leaveType': leaveType,
        'date': date,
        'Period': period,
        'duration': duration,
        'reason': reason,
        'substitute': substitute,
        'managerApproval': managerApproval,
        'CEOApproval': CEOApproval,
      });
      Global.leaveID = employeeID;
      print("تمت إضافة الموظف بمعرف: $employeeID");
    }
  }
}
