import 'package:flutter/material.dart';
import 'package:ninja_test/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async{
              
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', false);
              await prefs.setBool('isGoogleLoggedIn', false);
             Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => MyApp()),(Route<dynamic> route) => false,);
            
            },
          ),
        ],
        
      ),
      body: Container(
        child: Center(
          child: Text('HomePage'),
        ),
      ),
    );
  }
}