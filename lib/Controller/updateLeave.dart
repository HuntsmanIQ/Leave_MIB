import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> updateLeaveApprovalSupervisor(dynamic leaveID,
    {bool? CEOApproval}) async {
  Map<String, dynamic> updateData2 = {};

  if (CEOApproval != null) {
    updateData2['CEOApproval'] = CEOApproval;
  }

  if (updateData2.isEmpty) {
    print("⚠️ لم يتم تحديد أي تحديث.");
    return;
  }

  await FirebaseFirestore.instance
      .collection('leaves')
      .doc(leaveID)
      .update(updateData2);
  print("✅ تم تحديث حالة الإجازة بنجاح!");
}

Future<void> updateLeaveApprovalCEO(dynamic leaveID,
    {bool? CEOApproval}) async {
  Map<String, dynamic> updateData2 = {};

  if (CEOApproval != null) {
    updateData2['CEOApproval'] = CEOApproval;
  }

  if (updateData2.isEmpty) {
    print("⚠️ لم يتم تحديد أي تحديث.");
    return;
  }

  await FirebaseFirestore.instance
      .collection('ceo')
      .doc(leaveID)
      .update(updateData2);
  print("✅ تم تحديث حالة الإجازة بنجاح!");
}

Future<void> updateLeaveApprovalMaster(dynamic leaveID,
    {bool? CEOApproval}) async {
  Map<String, dynamic> updateData3 = {};

  if (CEOApproval != null) {
    updateData3['CEOApproval'] = CEOApproval;
  }

  if (updateData3.isEmpty) {
    print("⚠️ لم يتم تحديد أي تحديث.");
    return;
  }

  await FirebaseFirestore.instance
      .collection('Master_CEO')
      .doc(leaveID)
      .update(updateData3);
  print("✅ تم تحديث حالة الإجازة بنجاح!");
}

Future<void> updateLeaveApproval(dynamic leaveID,
    {bool? managerApproval}) async {
  Map<String, dynamic> updateData = {};

  if (managerApproval != null) {
    updateData['managerApproval'] = managerApproval;
  }

  if (updateData.isEmpty) {
    print("⚠️ لم يتم تحديد أي تحديث.");
    return;
  }

  await FirebaseFirestore.instance
      .collection('leaves')
      .doc(leaveID)
      .update(updateData);
  print("✅ تم تحديث حالة الإجازة بنجاح!");
}

bool isUpdating = false;
Future<void> updateLeaveBalance(dynamic leaveID, dynamic decrement) async {
  if (isUpdating) return;
  debugPrint("Executing updateLeaveBalance with decrement: $decrement");
  isUpdating = true;
  try {
    await FirebaseFirestore.instance
        .collection('employees')
        .doc(leaveID)
        .update({
      'leave': FieldValue.increment(decrement),
    });
    print("✅ تم تحديث حالة الإجازة بنجاح!");
  } catch (e) {
    print('Error : $e');
  } finally {
    isUpdating = false; // إيقاف القفل بعد الانتهاء
  }
}

void testprint(String txt) {
  print(txt);
}

Future<void> deleteLeavebyManager(dynamic leaveDoc) async {
  try {
    await FirebaseFirestore.instance
        .collection('leaves')
        .doc(leaveDoc)
        .delete();
    print('تم الحذف بنجاح ');
  } catch (e) {
    print(e);
  }
}

Future<void> deleteLeavebyCeo(dynamic leaveDoc) async {
  try {
    await FirebaseFirestore.instance.collection('ceo').doc(leaveDoc).delete();
    print('تم الحذف بنجاح ');
  } catch (e) {
    print(e);
  }
}

Future<void> deleteLeavebyMaster(dynamic leaveDoc) async {
  try {
    await FirebaseFirestore.instance
        .collection('Master_CEO')
        .doc(leaveDoc)
        .delete();
    print('تم الحذف بنجاح ');
  } catch (e) {
    print(e);
  }
}

Future<void> deleteLeavebySupervisor(dynamic leaveDoc) async {
  try {
    await FirebaseFirestore.instance
        .collection('leaves')
        .doc(leaveDoc)
        .delete();
    print('تم الحذف بنجاح ');
  } catch (e) {
    print(e);
  }
}
