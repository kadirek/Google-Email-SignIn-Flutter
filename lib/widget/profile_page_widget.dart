import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_email_sign_in_flutter/provider/email_sign_in.dart';
import 'package:google_email_sign_in_flutter/provider/google_sign_in.dart';
import 'package:provider/provider.dart';

class ProfilePageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Container(
      alignment: Alignment.center,
      color: Colors.purple,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[300],
          title: Text('Profile'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Logged In',
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 8),
              if (user.photoURL != null)
                CircleAvatar(
                  maxRadius: 25,
                  backgroundImage: NetworkImage(user.photoURL),
                ),
              SizedBox(height: 8),
              if (user.displayName != null)
                Text(
                  'Name: ' + user.displayName,
                  style: TextStyle(color: Colors.black),
                ),
              SizedBox(height: 8),
              Text(
                'Email: ' + user.email,
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  if (user.photoURL != null) {
                    final provider = Provider.of<GoogleSignInProvider>(context,
                        listen: false);
                    provider.logout();
                  } else {
                    final provider = Provider.of<EmailSignInProvider>(context,
                        listen: false);
                    provider.logout();
                  }
                },
                child: Text('Logout'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
