import 'package:flutter/material.dart';
import 'background/background_painter.dart';
import 'buttons/google_signup_button_widget.dart';
import 'buttons/outlined_button.dart';

class SignUpWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(painter: BackgroundPainter()),
          buildSignUp(context),
        ],
      );

  Widget buildSignUp(BuildContext context) => Column(
        children: [
          Spacer(),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: 175,
            ),
          ),
          Spacer(),
          SizedBox(height: 12),
          OutlinedButtonWidget(), //login button
          SizedBox(height: 12),
          GoogleSignupButtonWidget(), //google login button
          Spacer()
        ],
      );
}
