import 'package:flutter/material.dart';

import '../../../widgets/custom_text.dart';

class AuthButton extends StatelessWidget {
  final String title;
  final String image;
  final Function onTap;

  const AuthButton({Key key, this.title, this.image, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 150,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(.3),
                    offset: Offset(2, 3),
                    blurRadius: 7)
              ]),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 5,
                ),
                Image.asset(
                  "assets/images/$image",
                  width: 25,
                ),
                SizedBox(
                  width: 10,
                ),
                CustomText(
                  text: title,
                  size: 18,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
