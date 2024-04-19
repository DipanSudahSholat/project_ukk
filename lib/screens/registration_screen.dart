import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:library_dhifan/screens/home_screen.dart';
import 'package:library_dhifan/screens/login_screen.dart';

import '../model/user_model.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key:key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegistrationScreen> {

  final _auth = FirebaseAuth.instance;

  //form key
  final _formKey = GlobalKey<FormState>();
  //editing controller
  final nameEditingControlle = new TextEditingController();
  final emailEditingControlle = new TextEditingController();
  final passwordEditingControlle = new TextEditingController();
  final confirmPasswordEditingControlle = new TextEditingController();


  @override
  Widget build(BuildContext context) {


    //name field
    final nameField = TextFormField(
      autofocus: false,
      controller: nameEditingControlle,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Username is Required");
        }
        if (!regex.hasMatch(value)) {
          return ("Please Enter a Valid Username(Min 3 Character)");
        }
        return null;
      },
      onSaved: (value)
      {
        nameEditingControlle.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.account_circle),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Enter Your Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
        ),
      ),
    );


    //email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailEditingControlle,
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
      onSaved: (value)
      {
        emailEditingControlle.text = value!;
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
      controller: passwordEditingControlle,
      keyboardType: TextInputType.name,
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
      onSaved: (value)
      {
        passwordEditingControlle.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.vpn_key),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Enter Your Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
        ),
      ),
    );


    //confirm password field
    final confirmPasswordField = TextFormField(
      autofocus: false,
      controller: confirmPasswordEditingControlle,
      keyboardType: TextInputType.name,
      validator: (value) {
        if(confirmPasswordEditingControlle.text != passwordEditingControlle.text){
          return "Password Don't Match";
        }
        return null;
      },
      onSaved: (value)
      {
        confirmPasswordEditingControlle.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.vpn_key),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Confirm Your Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
        ),
      ),
    );


    //signup button
    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.black54,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
        minWidth: MediaQuery.of(context).size.width,

        onPressed: () {
          signUp(emailEditingControlle.text, passwordEditingControlle.text);
        },
        child: Text(
          "R E G I S T E R",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 22, color: const Color(0xFFFDEAD7), fontWeight: FontWeight.bold),
        ),),
    );

    return Scaffold(
        backgroundColor: const Color(0xFFFDEAD7),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: Center (
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
                        SizedBox(height: 70),
                        nameField,
                        SizedBox(height: 20),
                        emailField,
                        SizedBox(height: 20),
                        passwordField,
                        SizedBox(height: 20),
                        confirmPasswordField,
                        SizedBox(height: 35),
                        signUpButton,
                        SizedBox(height: 20)
                      ],
                    ),
                  ),
                ),
              ),
            )
        )
    );
  }

void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => { postDetailsToFirestore()})
          .catchError((e) {
       Fluttertoast.showToast(msg: e!.message);

      });
    }
}

postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sending these values
  
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  User? user = _auth.currentUser;

  UserModel userModel = UserModel();

  // writting all the values
  userModel.email = user!.email;
  userModel.uid = user!.uid;
  userModel.username = nameEditingControlle.text;

  await firebaseFirestore
       .collection("users")
       .doc(user.uid)
       .set(userModel.toMap());
  Fluttertoast.showToast(msg: "Account Create Successfully!");

  Navigator.pushAndRemoveUntil(
      (context),
      MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false);




}

}
