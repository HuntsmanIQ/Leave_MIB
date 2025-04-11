import 'package:flutter/material.dart';

class HistoryCard extends StatelessWidget {
  const HistoryCard({
    super.key,
    required this.txt1,
    required this.txt2,
    required this.txt3,
    required this.duration,
  });

  final String txt1, txt2, txt3;
  final num duration;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Container(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade400, width: 0.8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Title(txt: 'نوع الاجـازة'),
                      Title(txt: 'الـمـدة'),
                      Title(txt: 'الـتـاريـخ')
                    ],
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.white,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(txt: txt1),
                      CustomText(txt: '              $txt2'),
                      CustomText(txt: txt3),
                    ],
                  ),
                  Divider(),
                  Center(
                    child: Text(
                      duration >= 0
                          ? duration == 0
                              ? '0'
                              : '- ${duration.toStringAsFixed(0)}'
                          : '- ${duration.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}

//
class HistoryCardManager extends StatelessWidget {
  const HistoryCardManager({
    super.key,
    required this.txt1,
    required this.txt2,
    required this.txt3,
  });

  final String txt1, txt2, txt3;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 6,
        ),
        Container(
            width: MediaQuery.of(context).size.width - 6,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade400, width: 0.8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Title(txt: 'نوع الاجـازة'),
                      Title(txt: 'الـمـدة'),
                      Title(txt: 'الـتـاريـخ')
                    ],
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.white,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(txt: txt1),
                      CustomText(txt: '              $txt2'),
                      CustomText(txt: txt3),
                    ],
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
//

class Title extends StatelessWidget {
  Title({super.key, required this.txt});
  final String txt;
  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black45,
      ),
    );
  }
}

class CustomText extends StatelessWidget {
  CustomText({super.key, required this.txt});
  final String txt;
  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black45,
      ),
    );
  }
}
