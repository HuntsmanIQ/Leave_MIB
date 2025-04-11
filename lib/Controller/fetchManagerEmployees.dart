import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:leave_mib/Model/global.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// used to fetch employees IDs to manager to use for EmployeeInformation
Future<void> fetchManagerEmployees() async {
  User? currentUser = _auth.currentUser;
  if (currentUser == null) {
    print("No user logged in.");
    return;
  }

  print("Fetching manager's employees...");

  try {
    // Get manager info
    var managerSnapshot = await _firestore
        .collection('employees')
        .where('email', isEqualTo: currentUser.email)
        .limit(1)
        .get();

    if (managerSnapshot.docs.isEmpty) {
      print("No manager found for email: ${currentUser.email}");
      return;
    }

    String managerID = managerSnapshot.docs.first.id;
    print("Manager ID: $managerID");

    // Get employees under this manager
    var employeesSnapshot = await _firestore
        .collection('employees')
        .where('ManagerID', isEqualTo: managerID)
        .get();

    List<String> employeeIDs =
        employeesSnapshot.docs.map((doc) => doc.id).toList();

    // ✅ Update Global.employeeIDs
    Global.employeeIDs = employeeIDs;
    print("Global.employeeIDs updated: ${Global.employeeIDs}");
  } catch (e) {
    print("Error fetching employees: $e");
  }
}
