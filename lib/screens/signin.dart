

import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:ninja_test/screens/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ninja_test/user%20model/user_model.dart';







class SignIn extends StatefulWidget {
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> with TickerProviderStateMixin {
  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  late TabController tabController;
  bool _passwordMatching = false;
  var box ;
  List users=[];




void intialize() async{
final prefs = await SharedPreferences.getInstance();
final bool? isLoggedIn = prefs.getBool('isLoggedIn');
final bool? isGoogleLoggedIn = prefs.getBool('isGoogleLoggedIn');
if(isLoggedIn == true ||isGoogleLoggedIn == true){
 Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => HomePage()),(Route<dynamic> route) => false,);
 }
 else{
 box =  await Hive.openBox('myBox');
 users= box.values.toList();
 }
   }

@override
  void initState() {
  super.initState();
  tabController = new TabController(length: 2, vsync: this);
  intialize();
  tabController = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
  tabController.dispose();
  super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   
    return  Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.5),
      child: Column(
        children: [
        
          Flexible(
            flex: 7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: namecontroller,
                  decoration: InputDecoration(
                    labelText: "Name",
                    hintText: "Enter your name",
                    border:  OutlineInputBorder(
                              borderSide: BorderSide(),
                    ),
                  ),
                ),
               const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: TextField(
                      controller: passwordcontroller,
                      decoration:  const InputDecoration(
                          hintText: "Password",
                          border:  OutlineInputBorder(
                              borderSide: BorderSide()))),
                ),
                const SizedBox(
                  height: 5,
                ),
                 FlutterPwValidator(
                  controller: passwordcontroller,
                  minLength: 8,
                  uppercaseCharCount: 2,
                  numericCharCount: 3,
                  specialCharCount: 1,
                  normalCharCount: 3,
                  width: 400,
                  height: 150,
                  onSuccess: () {
                    setState(() {
                      _passwordMatching = true;
                    });
                   
                  },
                  onFail: () {
                    setState(() {
                      _passwordMatching = false;
                    });
                 
                  
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: ()async{
                    if(_passwordMatching){
                 var box = await Hive.openBox('myBox');
                 if(passwordcontroller.text !="" && namecontroller.text !=""){
                 User user = await User(name: namecontroller.text, password:passwordcontroller.text,);
                 if(users.toString().contains(user.toMap().toString())){
                 SharedPreferences prefs = await SharedPreferences.getInstance();
                 await prefs.setBool('isLoggedIn', true);
                 Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => HomePage()),(Route<dynamic> route) => false,);
            
                }else{  
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('NO USER FOUND'),
                ));
                }
                }

               else{
               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Please Check All Fields '),
              ));
}
                  }else{
                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Password is not matching with the criteria'),
              ));
                  }

                }, child: Text("Sign In")),
              ],
            ),
          ),
         
        ],
      ),
    );
  
    }
}
