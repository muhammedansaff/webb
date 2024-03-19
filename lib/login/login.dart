import 'package:admin/controllers/MenuAppController.dart';
import 'package:admin/screens/main/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:admin/refractor/cachedimage.dart';
import 'package:admin/refractor/container.dart';
import 'package:admin/refractor/materialbutton.dart';
import 'package:admin/refractor/textfield/secondtxtfield.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:admin/refractor/textfield/textform.dart';
import 'package:admin/refractor/textformfieldstyle.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:admin/Services/global_methods.dart';
import 'package:admin/Services/global_variables.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  final FocusNode _passFocusNode = FocusNode();
  // ignore: unused_field
  bool _isLoading = false;

  final TextEditingController _emailTextControler =
      TextEditingController(text: '');
  final TextEditingController _passTextController =
      TextEditingController(text: '');
  bool _obscureText = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _loginFormKey = GlobalKey<FormState>();

  get child => null;
  //variables
  @override
  void dispose() {
    _animationController.dispose();
    _emailTextControler.dispose();
    _passTextController.dispose();
    _passFocusNode.dispose();

    super.dispose();
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 20));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((animationStatus) {});
    _animationController.forward();
    _animationController.repeat();
    super.initState();
  } // animation controllers

  void _submitFormOnLogin() async {
    final isValid = _loginFormKey.currentState!.validate();

    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      try {
        final username = _emailTextControler.text.trim().toLowerCase();
        final DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('admins')
            .doc(username)
            .get();

        if (userDoc.exists) {
          final String? storedPassword =
              (userDoc.data() as Map<String, dynamic>?)?['password'];

          final String enteredPassword = _passTextController.text.trim();

          if (storedPassword == enteredPassword) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                      create: (context) => MenuAppController(),
                    ),
                  ],
                  child: MainScreen(
                    username: username,
                  ),
                ),
              ),
            );
          } else {
            // Password incorrect
            // ignore: use_build_context_synchronously
            GlobalMethod.showErrorDialog(
              error: "Incorrect password",
              ctx: context,
            );
          }
        } else {
          // User not found
          // ignore: use_build_context_synchronously
          GlobalMethod.showErrorDialog(
            error: "User not found",
            ctx: context,
          );
        }
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        // Handle other errors
        // ignore: use_build_context_synchronously
        GlobalMethod.showErrorDialog(
          error: "An error occurred: $error",
          ctx: context,
        );
      }
    }
  } // code to check login

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Refimagecached(animation: _animation, imgurl: loginUrlImage),
          const SizedBox(height: 8.0),
          Container(
            color: Colors.black54,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 80, right: 80, top: 10),
                  child: Image.asset(
                    'assets/images/login.png',
                    height: 400,
                    width: 400,
                  ),
                ),
                Form(
                  key: _loginFormKey,
                  child: Column(
                    children: [
                      Refcontt(
                        childd: Reftxtfield(
                            deccc: deco('username', 5),
                            typee: 'email',
                            inpp: TextInputType.emailAddress,
                            fnode: _passFocusNode,
                            txtcontroller: _emailTextControler),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Refcontt(
                        childd: passtxtfield(
                          deccc: passdeco(
                            'Password',
                            12,
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(
                                _obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          typee: 'password',
                          inpp: TextInputType.visiblePassword,
                          obsc: _obscureText,
                          tonode: _passFocusNode,
                          txtcontroller: _passTextController,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Bottun(
                        onPressed: _submitFormOnLogin,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buttontext('Login'),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  } //main ui code
}
