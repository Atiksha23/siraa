import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_signup/pages/signup.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_login_signup/services/bezierContainer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_signup/Service/AuthenticationService.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);



  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _key = GlobalKey<FormState>();
  String _email, _password;

  String _error;

  bool validate() {
    final form = _key.currentState;
    form.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  final AuthenticationService _auth = AuthenticationService();
  final auth = FirebaseAuth.instance;

  TextEditingController _emailContoller = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            // color: Colors.deepPurple,
            height: height,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/pic.jpg"),
                  fit: BoxFit.cover
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.shade500,
                    offset: Offset(2, 4),
                    blurRadius: 5,
                    spreadRadius: 2)
              ],
            ),
            child: Center(
              child: Form(
                key: _key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.indigo[900],
                        fontSize: 50,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          SizedBox(height: 30),
                          TextFormField(
                            controller: _emailContoller,
                            validator: (value) {
                              if (value.isEmpty || !value.contains("@"))
                              {
                                return 'Email is invalid';
                              }
                              else
                                return null;
                            },
                            decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                    color: Colors.indigo[900],
                                  fontSize: 17,
                                )
                            ),
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(height: 30),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            validator: (value) {
                              if (value.isEmpty || value.length<6) {
                                return 'Password is invalid';
                              } else
                                return null;
                            },
                            decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                    color: Colors.indigo[900],
                                  fontSize: 17,
                                )
                            ),
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 5),
                          FlatButton(
                            child: Text(
                                'Not registerd? Sign up',
                              style: TextStyle(
                                  color: Colors.black,
                                fontSize: 13,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  fullscreenDialog: true,
                                  builder: (context) => SignUpPage(),
                                ),
                              );
                            },
                            textColor: Colors.white,
                          ),
                          SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FlatButton(
                                child: Text(
                                    'Login',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                    ),
                                ),
                                onPressed: () => signInUser(),
                                  // if (_key.currentState.validate()) {
                                  //   signInUser();
                                  // }
                                // },
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }

  void signInUser() async {
    if(validate()) {
      try {
        dynamic authResult = await _auth.loginUser(
            _emailContoller.text, _passwordController.text);
        if (authResult == null) {
          print('Sign in error. could not be able to login');
        } else {
          _emailContoller.clear();
          _passwordController.clear();

          Navigator.pushNamed(context, '/Home');
          print('login successfull');
        }
      }
      catch (e) {
        setState(() {
          _error = e.message;
        });
      }
    }
  }

  // signInUser() async {
  //   try {
  //     //Create Get Firebase Auth User
  //     await auth.signInWithEmailAndPassword(email: _emailContoller.text, password : _passwordController.text);
  //
  //     //Success
  //     Navigator.pushNamed(context, '/Home');
  //
  //   } on FirebaseAuthException catch (error) {
  //     return Fluttertoast.showToast(msg: error.message,gravity: ToastGravity.TOP);
  //   }

  }
