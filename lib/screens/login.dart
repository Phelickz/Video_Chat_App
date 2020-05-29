import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_chat/screens/forgotPassword.dart';
import 'package:video_chat/screens/home.dart';
import 'package:video_chat/screens/register.dart';
import 'package:video_chat/services/snackBar.dart';
import 'package:video_chat/services/validators.dart';
import 'package:video_chat/state/authState.dart';
import 'package:video_chat/state/onStateChanged.dart';
import 'package:video_chat/utils/colors.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final FocusNode myFocusNodePassword = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: GlobalColors.blackColor,
      body: Stack(
        children: <Widget>[
          _login(width, height),
          _button(width, height),
          _text(width, height, true),
          _text(width, height, false),
          _header(width, height),
        ],
      ),
    );
  }

  Widget _header(double width, double height) {
    return Positioned(
      top: height * 0.26,
      left: width * 0.39,
      child: Text(
        'Sign In',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 30, color: Colors.red[800]),
      ),
    );
  }

  Widget _text(double width, double height, bool text1) {
    return Positioned(
      top: text1 ? height * 0.6 : height * 0.82,
      left: text1 ? width * 0.6 : width * 0.32,
      child: InkWell(
        onTap: () {
          text1
              ? Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => ForgotPassword()))
              : Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => Register()));
        },
        child: Text(
          text1 ? 'Forgot Password ?' : "No Account? Create",
          style: TextStyle(fontSize: text1 ? 15 : 18, color: Colors.white54),
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
                    Provider.of<AuthenticationState>(context, listen: false)
                        .login(_emailController.text, _passwordController.text)
                        .then((signInUser) => gotoHomeScreen(context));
                  } catch (e) {
                    print(e);
                  }
                }
              },
              label: Text('Login'),
            ),
          ),
        );
      },
    );
  }

  Widget _login(double width, double height) {
    return Positioned(
      top: height * 0.35,
      child: Container(
        width: width,
        height: height * 0.26,
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
                      obscureText: _obscureText,
                      controller: _passwordController,
                      validator: PasswordValidator.validate,
                      focusNode: myFocusNodePassword,
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
