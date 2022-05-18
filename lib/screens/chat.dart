import 'dart:async';

import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class Chat extends StatefulWidget {
List conversation;
Chat({required this.conversation});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
int currentIndex =0;
 SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  String humanSentence="";
   var box ;

@override
  void initState() {
    super.initState();
    _initSpeech();
  }

 
  void _initSpeech() async {
    final prefs = await SharedPreferences.getInstance();
    final String? bucket = prefs.getString('bucket');
     box = await Hive.openBox(bucket!);
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
   
  
 
  }


  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }



  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords =  result.recognizedWords;
   });

   if(_speechToText.isListening){
    
   }
   else{
        if(currentIndex<widget.conversation.length-1){
        
       
                      
     if(_lastWords.toLowerCase().toString() == humanSentence.toLowerCase().toString()){
    
                       setState(() {
                        currentIndex++;
                       
                      });
                      
                      box.add(widget.conversation[currentIndex-1]);
     }
     else{
       
     
         showDialog(
     context: context,
     builder: (BuildContext context) {
         return AlertDialog(
                 title: Text("ERROR"),
                 content: Text("Cant recognise text \" $_lastWords \" "),
                  actions: <Widget>[
                   ElevatedButton(
                     child: Text("Close"),
                     onPressed: () {
                      Navigator.of(context).pop();
                      },
                   )
                  ],
                );
               }
             );
     }
   }

else{
                         showDialog(
     context: context,
     builder: (BuildContext context) {
         return AlertDialog(
                 title: Text("DONE"),
                 content: Text("Enough for the day!! you are done!!"),
                  actions: <Widget>[
                   ElevatedButton(
                     child: Text("Restart"),
                     onPressed: () {
                      Navigator.of(context).pop();
                      },
                   )
                  ],
                );
               }
             );
             setState(() {
                        currentIndex=0;
                       
                      });
                      }
     
   }
  }






  @override
  Widget build(BuildContext context) {
       
    List conversation = widget.conversation;
    int conversationLength = conversation.length;
     humanSentence = conversation[currentIndex]['human'];
    
    return SafeArea(
      child: Scaffold(
        body: ListView.builder(
          itemCount: currentIndex+1,
          itemBuilder: (BuildContext context, int index){
           
            return Container(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child:BubbleSpecialThree(
                   text: conversation[index]['bot'],
                   color: Color(0xFFE8E8EE),
                   tail: true,
                   isSender: false,
                    )
                     
                     ),
                  Align(
                      alignment: Alignment.topLeft,
                      child:BubbleSpecialThree(
                      text: conversation[index]['human'],
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
    floatingActionButton: FloatingActionButton(
        onPressed:
            // If not yet listening for speech start, otherwise stop
            _speechToText.isNotListening ? _startListening : _stopListening,
            
        tooltip: 'Listen',
        child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
      ),
      ),
    );
  }
}