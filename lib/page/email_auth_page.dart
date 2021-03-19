import 'package:flutter/material.dart';
import 'package:google_email_sign_in_flutter/provider/email_sign_in.dart';
import 'package:google_email_sign_in_flutter/widget/background/background_painter.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(painter: BackgroundPainter()),
            buildAuthForm(), //forms and fields
          ],
        ),
      );

  Widget buildAuthForm() {
    final provider = Provider.of<EmailSignInProvider>(context);

    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          //when keyboard open it can be scrolable
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  buildEmailField(),
                  if (!provider.isLogin) buildUsernameField(),
                  if (!provider.isLogin) buildDatePicker(),
                  buildPasswordField(),
                  SizedBox(height: 12),
                  buildButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDatePicker() {
    final provider = Provider.of<EmailSignInProvider>(context);
    final dateOfBirth = provider.dateOfBirth;

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 12),
          Text(
            'Date of Birth',
            style: TextStyle(color: Colors.grey[700]),
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text(
                '${dateOfBirth.year} - ${dateOfBirth.month}- ${dateOfBirth.day}'),
            trailing: Icon(Icons.keyboard_arrow_down),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                firstDate: DateTime(DateTime.now().year - 80),
                lastDate: DateTime(DateTime.now().year + 1),
                initialDate: dateOfBirth,
              );

              if (date != null) {
                provider.dateOfBirth = date;
              }
            },
          ),
          Divider(color: Colors.grey[700])
        ],
      ),
    );
  }

  Widget buildUsernameField() {
    final provider = Provider.of<EmailSignInProvider>(context);

    return TextFormField(
      key: ValueKey('username'),
      autocorrect: true,
      textCapitalization: TextCapitalization.words,
      enableSuggestions: false,
      validator: (value) {
        if (value.isEmpty || value.length < 4 || value.contains(' ')) {
          return 'Please enter at least 4 characters without space';
        } else {
          return null;
        }
      },
      decoration: InputDecoration(labelText: 'Username'),
      onSaved: (username) => provider.userName = username,
    );
  }

  Widget buildButton(BuildContext context) {
    final provider = Provider.of<EmailSignInProvider>(context);

    if (provider.isLoading) {
      return CircularProgressIndicator();
    } else {
      return Column(
        children: [
          buildLoginButton(),
          buildSignupButton(context),
        ],
      );
    }
  }

  Widget buildLoginButton() {
    //Login button
    final provider = Provider.of<EmailSignInProvider>(context);

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          primary: Colors.black, //highlightedBorderColor
          side: BorderSide(color: Colors.black, width: 1),
          textStyle: TextStyle(color: Colors.purple)),
      child: Text(provider.isLogin ? 'Login' : 'Signup'),
      onPressed: () => submit(),
    );
  }

  Widget buildSignupButton(BuildContext context) {
    final provider = Provider.of<EmailSignInProvider>(context);

    return TextButton(
      style: flatButtonStyle,
      child: Text(
        provider.isLogin ? 'Create new account' : 'I already have an account',
      ),
      onPressed: () => provider.isLogin = !provider.isLogin,
    );
  }

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    primary: Colors.deepOrange,
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
  );

  Widget buildEmailField() {
    final provider = Provider.of<EmailSignInProvider>(context);

    return TextFormField(
      key: ValueKey('email'),
      autocorrect: false,
      textCapitalization: TextCapitalization.none,
      enableSuggestions: false,
      validator: (value) {
        final pattern = r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
        final regExp = RegExp(pattern);

        if (!regExp.hasMatch(value)) {
          return 'Enter a valid mail';
        } else {
          return null;
        }
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(labelText: 'Email address'),
      onSaved: (email) => provider.userEmail =
          email, //this is where we sent our email to model or provider class
    );
  }

  Widget buildPasswordField() {
    final provider = Provider.of<EmailSignInProvider>(context);

    return TextFormField(
      key: ValueKey('password'),
      validator: (value) {
        if (value.isEmpty || value.length < 7) {
          return 'Password must be at least 7 characters long.';
        } else {
          return null;
        }
      },
      decoration: InputDecoration(labelText: 'Password'),
      obscureText: true,
      onSaved: (password) => provider.userPassword = password,
    );
  }

  Future submit() async {
    final provider = Provider.of<EmailSignInProvider>(context, listen: false);

    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();

      final isSuccess = await provider.login();

      if (isSuccess) {
        Navigator.of(context).pop();
      } else {
        showSnackBar();
      }
    }
  }

  void showSnackBar() {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 150.0,
      content: Text(
        'Wrong email or password',
        textAlign: TextAlign.center,
      ),
      backgroundColor: Theme.of(context).errorColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
