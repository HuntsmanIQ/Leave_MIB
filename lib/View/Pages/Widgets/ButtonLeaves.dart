import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  MyButton(
      {super.key,
      required this.txt,
      required this.press,
      required this.bgColor,
      required this.textColor});
  final dynamic press;
  final String txt;
  final Color bgColor, textColor;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: press,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: Text(txt,
            style: TextStyle(
                color: textColor, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

Widget buildInfoRow(String title, String value) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.teal.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.teal.shade900)),
        ),
        Text(value, style: TextStyle(color: Colors.black87)),
      ],
    ),
  );
}
