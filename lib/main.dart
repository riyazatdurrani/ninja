import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ninja_test/screens/signin.dart';
import 'package:ninja_test/screens/signup.dart';
import 'user model/user_model.dart';

void main()  async{
  await Hive.initFlutter("hive_boxes");
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Scaffold(
           resizeToAvoidBottomInset : false,
            appBar:  AppBar(
              title: Text("NINJA STUDY"),
            ),
            body:  DefaultTabController(
        length: 2,
        child: SafeArea(
          child: Scaffold(
             resizeToAvoidBottomInset : false,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: Container(
                height: 50.0,
                child: const TabBar(
                  indicatorColor: Colors.greenAccent,
                  unselectedLabelColor: Colors.grey,
                  labelColor: Colors.blue,
                  tabs: [
                    
                 
                    Tab(
                      text: "SignIn",
                    ),
                       Tab(
                      text: "SignUp",
                    ),
                    
                  ],
                ),
              ),
            ),
            body: TabBarView(
              children: [
                SignIn(),
                SignUp(),
                 
             
              
              ],
            ),
          ),
        ),
      ),));
  }
}

