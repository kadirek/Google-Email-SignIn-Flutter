import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_email_sign_in_flutter/provider/google_sign_in.dart';
import 'package:google_email_sign_in_flutter/widget/background/background_painter.dart';
import 'package:google_email_sign_in_flutter/widget/google_signup_widget.dart';
import 'package:google_email_sign_in_flutter/widget/profile_page_widget.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            final provider = Provider.of<GoogleSignInProvider>(context);

            if (provider.isSigningIn) {
              return buildLoading(); //when signing in
            } else if (snapshot.hasData) {
              return ProfilePageWidget(); //when signed in
            } else {
              return SignUpWidget(); //not signed in yet
            }
          },
        ),
      ),
    );
  }

  Widget buildLoading() => Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(painter: BackgroundPainter()),
          Center(child: CircularProgressIndicator()),
        ],
      );
}
