import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:leave_mib/Model/global.dart';

class ModernAppBar extends StatelessWidget {
  ModernAppBar({
    required this.name,
    required this.position,
    required this.press,
    super.key,
  });
  final String name, position;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 40,
          color: Colors.teal,
        ),
        Container(
          width: double.infinity,
          height: 180,
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.teal.shade700],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 26,
                      color: Colors.teal[400],
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.power_settings_new, color: Colors.white),
                    onPressed: press,
                  ),
                ],
              ),
              Divider(
                height: 30,
                endIndent: 180,
              ),
              Row(
                children: [
                  SizedBox(width: 20),
                  Text(
                    position,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// this AppBar for Ceo and Master only
class ModernAppBar2 extends StatelessWidget {
  ModernAppBar2({
    required this.name,
    required this.position,
    required this.press,
    super.key,
  });
  final String name, position;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 30,
          color: Colors.teal,
        ),
        Container(
          width: double.infinity,
          height: 180,
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.teal.shade700],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 26,
                      color: Colors.teal[400],
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.power_settings_new, color: Colors.white),
                    onPressed: press,
                  ),
                ],
              ),
              Divider(
                height: 30,
                endIndent: 100,
              ),
              Row(
                children: [
                  SizedBox(width: 20),
                  Text(
                    position == 'Master'
                        ? 'المـديـر المـفـوض'
                        : 'مـعـاون المـديـر المـفـوض',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

//

class HomePageButton extends StatelessWidget {
  HomePageButton({
    required this.txt,
    required this.press,
    super.key,
  });
  final VoidCallback press;
  final String txt;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: press,
      child: Text(
        txt,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.teal[800],
        backgroundColor: Colors.teal[50], // تركواز داكن
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class LeaveWidget extends StatelessWidget {
  const LeaveWidget({
    super.key,
    required this.name,
  });

  final dynamic name;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('employees')
          .doc(name)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Text('No data found');
        }

        var leaveValue = snapshot.data!.get('leave');
        Global.leaveBalance = leaveValue;

        return Container(
          alignment: Alignment.center,
          height: 50,
          width: 380,
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 70, 180, 169),
              borderRadius: BorderRadius.circular(8)),
          child: Text(
            'رصـيـد الأجـازات : ${leaveValue.toStringAsFixed(2)}',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        );
      },
    );
  }
}
