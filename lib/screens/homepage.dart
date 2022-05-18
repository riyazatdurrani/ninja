import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ninja_test/api/getconversation.dart';
import 'package:ninja_test/main.dart';
import 'package:ninja_test/screens/chat.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isConversationStarted = false;
  bool _isLoading=false;
  var box ;
  List chatStuff=[];


void loaddata() async{
   final prefs = await SharedPreferences.getInstance();
    final String? bucket = prefs.getString('bucket');
     box = await Hive.openBox(bucket!);
      // box =  await Hive.openBox('mytub');
       setState(() {
         chatStuff= box.values.toList();
       });
 print("kkk");
 print(chatStuff.length);
}

@override
  void initState() {
  loaddata();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
   // loaddata();
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
            itemCount: chatStuff.length,
            itemBuilder: (BuildContext context, int index){
             
              return Container(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child:BubbleSpecialThree(
                     text: chatStuff[index]['bot'],
                     color: Color(0xFFE8E8EE),
                     tail: true,
                     isSender: false,
                      )
                       
                       ),
                    Align(
                        alignment: Alignment.topLeft,
                        child:BubbleSpecialThree(
                        text: chatStuff[index]['human'],
                        color: Color(0xFF1B97F3),
                        tail: true,
                        textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                           ),
                           ),
                         
                         )
                    
                  ],
                ),
              );
            },
                  ),
          ),
          _isConversationStarted?
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(child:
            _isLoading?CircularProgressIndicator(color: Colors.white,) : Text("Restaurant"),
               onPressed: ()async {
                   setState(() {
                      _isLoading=true;
                    
                   });
                   GetApiData getapidata = GetApiData();
                  List conversation = await getapidata.getData();
                  
                    Navigator.push(context,MaterialPageRoute(builder: (context) => Chat(conversation: conversation,))).then((value) => loaddata());
                      setState(() {
                      _isLoading=false;
                    
                   });
 }
               ),
                ),
                SizedBox(height: 10,),
               Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  height: 50,
                  width: double.infinity,
                 child: ElevatedButton(child:
              Text("Interview"),
                 onPressed: () async{
                   
                    GetApiData getapidata = GetApiData();
                  List conversation = await getapidata.getData();
                  
                    Navigator.push(context,MaterialPageRoute(builder: (context) => Chat(conversation: conversation,))).then((value) => loaddata());
                    
                 }),
               )
              ],
            ),
          ):
          Center(
            child: Container(
              child:ElevatedButton(child:
              Text("Start a Conversation"),
               onPressed: (){
                 setState(() {
                    _isConversationStarted = true;
                  
                 });
               })
            ),
          ),
        ],
      ),
    );
  }
}