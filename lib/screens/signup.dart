import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ninja_test/screens/homepage.dart';
import 'package:ninja_test/user%20model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
   ],
);

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp>with SingleTickerProviderStateMixin {
  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  late TabController tabController;
  GoogleSignInAccount? _currentUser;
  bool _passwordMatching = false;
  

  @override
    void initState() {
    super.initState();
    _googleSignIn.disconnect();
    tabController = new TabController(length: 2, vsync: this);
    _googleSignIn.onCurrentUserChanged.listen((account) {
    setState(() {
      _currentUser = account;
    });
    });
    _googleSignIn.signInSilently();
    }



  @override
  void dispose() {
  tabController.dispose();
  super.dispose();
  }
 

 
  @override
  Widget build(BuildContext context) {
     GoogleSignInAccount? user= _currentUser;
     
    
    return  Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.5),
      child: Column(
        children: [
        
          Flexible(
            flex: 7,
            child: Column(
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
                    print("MATCHED");
                  
                  },
                  onFail: () {
                    setState(() {
                      _passwordMatching = false;
                    });
                    print("Please Check Password");
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(onPressed: ()async{
                 var box = await Hive.openBox('myBox');
                 if(_passwordMatching){
                 if(passwordcontroller !="" && namecontroller !=""){
                 User user = User(name: namecontroller.text, password:passwordcontroller.text,);
               box.add(user.toMap());
              if(user != null){
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', true);
             Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => HomePage()),(Route<dynamic> route) => false,);
            }
            print("added");
           
       
          
          }
                 }
                 else{
                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Password is not matching with the criteria'),
              ));
                 }



                },
                 child: Text("Sign Up")),
               SizedBox(
            height: 10,
          ),

          ElevatedButton(onPressed:()async{
            try{
           await _googleSignIn.signIn();
           SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isGoogleLoggedIn', true);
              Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => HomePage()),(Route<dynamic> route) => false,);
            
            }catch(e){
              print(e);
            }
          }
          
          , child: Text("Google Sign In")),
              
              ],
            ),
          )
        ],
      ),
    );
    
  }
}
