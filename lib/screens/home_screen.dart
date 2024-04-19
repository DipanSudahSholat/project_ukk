import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:library_dhifan/model/user_model.dart';
import 'package:library_dhifan/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key:key);

  @override
 _HomeScreenState createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
         .collection("users")
         .doc(user!.uid)
         .get()
         .then((value) {
           this.loggedInUser = UserModel.fromMap(value.data());
           setState(() {});
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ActionChip(label: Icon(Icons.logout, size: 18,), onPressed: () {
                      logOut(context);
                    } ,)
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 5, top: 5),
                    child: Text("Wellcome To Ourlibs", style: TextStyle(fontSize: 23, fontStyle: FontStyle.italic),),

                  )
                ],
              ),
              SizedBox(height: 10,),
              Container(
                height: 180,
                child: Stack(
                  children: [
                    Positioned(
                        top:0,
                        left: -40,
                        right: 0,
                        child: Container(
                          height: 180,
                          child: PageView.builder(
                              controller: PageController(viewportFraction: 0.8),
                              itemCount: 5,
                              itemBuilder: (_, i){
                                return Container(
                                  height: 180,
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        image: AssetImage("img/pic-8.png"),
                                        fit: BoxFit.fill,
                                      )
                                  ),
                                );
                              }),
                        )
                    )
                  ]


                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> logOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
