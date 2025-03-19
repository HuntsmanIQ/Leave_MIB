import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:leave_mib/Controller/updateLeave.dart';

void listenForApprovedLeaves() {
  FirebaseFirestore.instance
      .collection('ceo')
      .where('CEOApproval', isEqualTo: true)
      .snapshots()
      .listen((snapshot) {
    for (var doc in snapshot.docs) {
      moveLeaveToHR(doc);
    }
  });
}

void listenForApprovedLeavesSupervisor() {
  FirebaseFirestore.instance
      .collection('leaves')
      .where('CEOApproval', isEqualTo: true)
      .snapshots()
      .listen((snapshot) {
    for (var doc in snapshot.docs) {
      moveLeaveToHR(doc);
    }
  });
}

void listenForApprovedLeavesMaster() {
  FirebaseFirestore.instance
      .collection('Master_CEO')
      .where('CEOApproval', isEqualTo: true)
      .snapshots()
      .listen((snapshot) {
    for (var doc in snapshot.docs) {
      moveLeaveToHR(doc);
    }
  });
}

Future<void> moveLeaveToHR(QueryDocumentSnapshot leaveDoc) async {
  try {
    Map<String, dynamic> leaveData = leaveDoc.data() as Map<String, dynamic>;

    // نسخ الإجازة إلى Collection "hr"
    await FirebaseFirestore.instance
        .collection('hr')
        .doc(leaveDoc.id)
        .set(leaveData);

    // (اختياري) حذف الإجازة من "leaves" بعد نقلها إلى "hr"
    await FirebaseFirestore.instance
        .collection('ceo')
        .doc(leaveDoc.id)
        .delete();
    await FirebaseFirestore.instance
        .collection('Master_CEO')
        .doc(leaveDoc.id)
        .delete();
    await FirebaseFirestore.instance
        .collection('leaves')
        .doc(leaveDoc.id)
        .delete();

    print("✅ تم نقل الإجازة إلى HR: ${leaveDoc.id}");
  } catch (e) {
    print("❌ خطأ أثناء نقل الإجازة: $e");
  }
}

void listenForApprovedLeaves2(dynamic duration) {
  FirebaseFirestore.instance
      .collection('leaves')
      .where('managerApproval', isEqualTo: true)
      .snapshots()
      .listen((snapshot) {
    for (var doc in snapshot.docs) {
      if (doc['duration'] > 3) {
        moveLeaveToMaster(doc);
      } else {
        moveLeaveToCEO(doc);
      }
    }
  });
}

Future<void> moveLeaveToCEO(QueryDocumentSnapshot leaveDoc) async {
  try {
    Map<String, dynamic> leaveData = leaveDoc.data() as Map<String, dynamic>;

    // نسخ الإجازة إلى Collection "hr"
    await FirebaseFirestore.instance
        .collection('ceo')
        .doc(leaveDoc.id)
        .set(leaveData);

    // (اختياري) حذف الإجازة من "leaves" بعد نقلها إلى "ceo"
    await FirebaseFirestore.instance
        .collection('leaves')
        .doc(leaveDoc.id)
        .delete();

    print("✅ تم نقل الإجازة إلى CEO: ${leaveDoc.id}");
  } catch (e) {
    print("❌ خطأ أثناء نقل الإجازة: $e");
  }
}

Future<void> moveLeaveToMaster(QueryDocumentSnapshot leaveDoc) async {
  try {
    Map<String, dynamic> leaveData = leaveDoc.data() as Map<String, dynamic>;

    // نسخ الإجازة إلى Collection "hr"
    await FirebaseFirestore.instance
        .collection('Master_CEO')
        .doc(leaveDoc.id)
        .set(leaveData);

    // (اختياري) حذف الإجازة من "leaves" بعد نقلها إلى "ceo"
    await FirebaseFirestore.instance
        .collection('leaves')
        .doc(leaveDoc.id)
        .delete();

    print("✅ تم نقل الإجازة إلى CEO: ${leaveDoc.id}");
  } catch (e) {
    print("❌ خطأ أثناء نقل الإجازة: $e");
  }
}
