import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rive/rive.dart';

import 'BottomNavigatorBars.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoaderVisible = false;

  String validEmail = "abc";
  String validPassword = "123";

  bool passenable = true;

  ///input controller
  FocusNode emailFocusNode = FocusNode();
  TextEditingController emailController = TextEditingController();

  FocusNode passwordFocusNode = FocusNode();
  TextEditingController passwordController = TextEditingController();

  ///Rive controller and input
  StateMachineController? controller;
  SMIInput<bool>? isChecking;
  SMIInput<bool>? isHandsUp;
  SMIInput<bool>? trigSuccess;
  SMIInput<bool>? trigFail;
  SMIInput<double>? numLook;

  @override
  void initState() {
    emailFocusNode.addListener(emailFocus);
    passwordFocusNode.addListener(passwordFocus);

    super.initState();
  }

  @override
  void dispose() {
    emailFocusNode.removeListener(emailFocus);
    passwordFocusNode.removeListener(passwordFocus);

    super.dispose();
  }

  void emailFocus() {
    isChecking?.change(emailFocusNode.hasFocus);
  }

  void passwordFocus() {
    isHandsUp?.change(passwordFocusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return LoaderOverlay(
      child: Scaffold(
        backgroundColor: const Color(0xFFD6E2EA),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(
                  height: 150,
                ),
                SizedBox(
                  width: size.width,
                  height: 220,
                  child: RiveAnimation.asset(
                    "assets/login-teddy.riv",
                    stateMachines: ["Login Machine"],
                    fit: BoxFit.fitHeight,
                    onInit: (artboard) {
                      controller = StateMachineController.fromArtboard(
                          artboard, "Login Machine");
                      if (controller == null) return;
                      artboard.addController(controller!);
                      isChecking = controller?.findInput('isChecking');
                      isHandsUp = controller?.findInput('isHandsUp');
                      numLook = controller?.findInput('numLook');
                      trigSuccess = controller?.findInput('trigSuccess');
                      trigFail = controller?.findInput('trigFail');
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),

                        ///EMAİL
                        child: TextFormField(
                          focusNode: emailFocusNode,
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: "Email"),
                          style: Theme.of(context).textTheme.bodyMedium,
                          onChanged: (value) {
                            numLook?.change(value.length.toDouble());
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 0,
                        ),

                        ///PASSWORD
                        child: TextFormField(
                          focusNode: passwordFocusNode,
                          controller: passwordController,
                          obscureText: passenable,
                          style: Theme.of(context).textTheme.bodyMedium,
                          onChanged: (value) {},
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Password",
                            suffix: IconButton(
                              onPressed: () {
                                //add Icon button at end of TextField
                                setState(() {
                                  //refresh UI
                                  if (passenable) {
                                    //if passenable == true, make it false
                                    passenable = false;
                                  } else {
                                    passenable =
                                        true; //if passenable == false, make it true
                                  }
                                });
                              },
                              icon: Icon(passenable == true
                                  ? Icons.remove_red_eye
                                  : Icons.password),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: size.width,
                        child: const Text(
                          "Forgot your password?",
                          textAlign: TextAlign.right,
                          style:
                              TextStyle(decoration: TextDecoration.underline),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: size.width,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              _isLoaderVisible = context.loaderOverlay.visible;
                            });
                            emailFocusNode.unfocus();
                            passwordFocusNode.unfocus();
                            final email = emailController.text;
                            final password = passwordController.text;
                            if (email == validEmail &&
                                password == validPassword) {
                              trigSuccess?.change(true);

                              context.loaderOverlay.show();
                              _isLoaderVisible = context.loaderOverlay.visible;

                              await Future.delayed(Duration(seconds: 2));
                              if (_isLoaderVisible) {
                                context.loaderOverlay.hide();
                              }
                              _isLoaderVisible = context.loaderOverlay.visible;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BottomNavigators(),
                                ),
                              );
                            } else {
                              trigFail?.change(true);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              backgroundColor: Colors.indigo),
                          child: const Text(
                            "Login",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't you have an account?"),
                            TextButton(
                              onPressed: () {
                                //todo register
                              },
                              child: Text(
                                "Register",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
