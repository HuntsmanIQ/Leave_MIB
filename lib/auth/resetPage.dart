import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leave_mib/auth/authController.dart';

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
            autofocus: true,
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
                  if (email.text.isEmpty) {
                    Get.back();
                    Get.snackbar('Error', 'الرجـاء تعـبـئة الحـقل !',
                        backgroundColor: Colors.red);
                  } else {
                    auth.resetPassword(email.text);
                    Get.back();
                    Get.snackbar('Notification', 'تـم ارسـال الطـلب بـنـجـاح',
                        backgroundColor: Colors.green);
                  }
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
