import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/screens/login.dart';
import 'package:video_chat/services/snackBar.dart';
import 'package:video_chat/services/validators.dart';
import 'package:video_chat/state/authState.dart';
import 'package:video_chat/state/onStateChanged.dart';
import 'package:video_chat/utils/colors.dart';

import 'forgotPassword.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  final FocusNode myFocusNodePassword = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodeUsername = FocusNode();
  final FocusNode myFocusNodePhone = FocusNode();

  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  @override
  void dispose() {
    myFocusNodePassword.dispose();
    myFocusNodeEmail.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: GlobalColors.blackColor,
      body: Stack(
        children: <Widget>[
          _header(width, height),
          _register(width, height),
          _button(width, height),
          _text(width, height)
        ],
      ),
    );
  }

  Widget _header(double width, double height) {
    return Positioned(
      top: height * 0.26,
      left: width * 0.39,
      child: Text(
        'Sign Up',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 30, color: Colors.red[800]),
      ),
    );
  }

  Widget _text(double width, double height) {
    return Positioned(
      top: height * 0.82,
      left: width * 0.27,
      child: InkWell(
        splashColor: GlobalColors.blackColor,
        onTap: () {
          Navigator.push(
              context, CupertinoPageRoute(builder: (context) => Login()));
        },
        child: Text(
          "Have an account? Sign In",
          style: TextStyle(fontSize: 18, color: Colors.white54),
        ),
      ),
    );
  }

  Widget _button(double width, double height) {
    return Builder(
      builder: (BuildContext _context) {
        SnackBarService.instance.buildContext = _context;

        return Positioned(
          top: height * 0.7,
          left: width * 0.36,
          child: Container(
            // color: Colors.blue,
            width: width * 0.3,
            child: FloatingActionButton.extended(
              backgroundColor: Colors.red[800],
              onPressed: () {
                final form = _formKey.currentState;
                form.save();
                if (form.validate()) {
                  try {
                    Provider.of<AuthenticationState>(_context, listen: false)
                        .signup(_emailController.text, _passwordController.text,
                            _usernameController.text)
                        .then((signInUser) => gotoHomeScreen(_context));
                    // gotoHomeScreen(context);
                    // print('signed up');
                    // Navigator.push(context,
                    //   MaterialPageRoute(builder: (context) => Feedss()));
                  } catch (e) {
                    print(e);
                  }
                }
              },
              label: Text('Sign Up'),
            ),
          ),
        );
      },
    );
  }

  Widget _register(double width, double height) {
    return Positioned(
      top: height * 0.35,
      child: Container(
        width: width,
        height: height * 0.29,
        // color: Colors.blue,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: GlobalColors.greyColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _usernameController,
                      focusNode: myFocusNodeUsername,
                      validator: UsernameValidator.validate,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          suffixIcon: Icon(Icons.account_circle),
                          hintText: "Username",
                          hintStyle: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w800)),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: GlobalColors.greyColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      focusNode: myFocusNodeEmail,
                      validator: EmailValidator.validate,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          suffixIcon: Icon(Icons.email),
                          hintText: "Email",
                          hintStyle: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w800)),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: GlobalColors.greyColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _passwordController,
                      focusNode: myFocusNodePassword,
                      validator: PasswordValidator.validate,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            child: _obscureText
                                ? Icon(Icons.enhanced_encryption)
                                : Icon(Icons.remove_red_eye),
                          ),
                          hintText: "Password",
                          hintStyle: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w800)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
