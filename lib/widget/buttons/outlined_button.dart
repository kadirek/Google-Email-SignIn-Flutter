import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_email_sign_in_flutter/page/email_auth_page.dart';

class OutlinedButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(4),
        child: OutlinedButton.icon(
          label: Text(
            'Sign In With Email',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: StadiumBorder(),
            primary: Colors.black, //highlightedBorderColor
            side: BorderSide(color: Colors.black, width: 1),
          ),
          icon: FaIcon(FontAwesomeIcons.mailBulk, color: Colors.blue),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AuthPage()),
          ),
        ),
      );
}
