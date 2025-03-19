import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leave_mib/auth/authController.dart';
import 'package:leave_mib/auth/login.dart';

class Resetpage extends StatelessWidget {
  Resetpage({super.key});
  TextEditingController email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Enter your email to reset password",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 15),
          TextField(
            controller: email,
            decoration: InputDecoration(
              hintText: "Email",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: GetBuilder<Auth>(
              builder: (auth) => ElevatedButton(
                onPressed: () {
                  auth.resetPassword(email.text);
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 31, 30, 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  "Send",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
