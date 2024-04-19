import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:library_dhifan/screens/home_screen.dart';
import 'package:library_dhifan/screens/registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key:key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  //form key
  final _formKey = GlobalKey<FormState>();

  //editing controller
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  //firebase
  final _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    //email field
    final emailfield = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Email is Required");
        }
        //reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
            .hasMatch(value)) {
          return ("Please Enter a Valid Email");
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Enter Your Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
        ),
      ),
    );

    //password field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is Required");
        }
        if (!regex.hasMatch(value)) {
          return ("Please Enter a Valid Password(Min 6 Character)");
        }
        return null;
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.vpn_key),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Enter Your Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
        ),
      ),

    );

    //login button
    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.black54,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
        minWidth: MediaQuery
            .of(context)
            .size
            .width,

        onPressed: () {
          signIn(emailController.text, passwordController.text);
        },
        child: Text(
          "L O G I N",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 22,
              color: const Color(0xFFFDEAD7),
              fontWeight: FontWeight.bold),
        ),),
    );

    return Scaffold(
        backgroundColor: const Color(0xFFFDEAD7),
        body: Center(
            child: SingleChildScrollView(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 170,
                          child: Image.asset("assets/logo.png",
                            fit: BoxFit.fill,),),
                        SizedBox(height: 80),
                        emailfield,
                        SizedBox(height: 20),
                        passwordField,
                        SizedBox(height: 35),
                        loginButton,
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Don't Have Account? "),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RegistrationScreen()));
                              },
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                    color: Colors.brown,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
        )
    );
  }


  //login function
    void signIn (String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
            Fluttertoast.showToast(msg: "Login Successfully"),
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen())),


      }).catchError((e)
      {
        Fluttertoast.showToast(msg: "Account Not Found!");
      });
    }
 }
}