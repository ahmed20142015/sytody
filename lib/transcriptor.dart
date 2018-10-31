import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttr_protorecorder/languages.dart';
import 'package:fluttr_protorecorder/pages/pages.dart';
import 'package:fluttr_protorecorder/recognizer.dart';

class TranscriptorWidget extends StatefulWidget {
  final Language lang;

  TranscriptorWidget({this.lang});

  @override
  _TranscriptorAppState createState() => new _TranscriptorAppState();
}

class _TranscriptorAppState extends State<TranscriptorWidget> {
  String transcription = '';
  String label = '';
  bool authorized = false;

  bool isListening = false;

  bool get isNotEmpty => transcription != '';

  @override
  void initState() {
    super.initState();
    SpeechRecognizer.setMethodCallHandler(_platformCallHandler);
    _activateRecognition();
  }

  @override
  void dispose() {
    super.dispose();
    if (isListening) _cancelRecognitionHandler();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    List<Widget> blocks = [
      new Expanded(
        flex: 2,
        child: new Center(
            child: new Padding(
                padding: new EdgeInsets.all(10.0),
                child: new InkWell(onTap: goToPage,child: new Text(label,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),),)
            )),
      ),
      _buildButtonBar(),
    ];
    if (isListening || transcription != '')
      blocks.insert(
          1,
          _buildTranscriptionBox(
              text: transcription,
              onCancel: _cancelRecognitionHandler,
              width: size.width - 20.0));
    return new Center(
        child: new Column(mainAxisSize: MainAxisSize.min, children: blocks));
  }

   goToPage(){
    switch(label){
      case "home":
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new HomeScreen("Home screen")));
   break;
      case "courses":
      case "course":
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new HomeScreen("Courses screen")));
        break;
      case "to do":
      case "to do list":
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new HomeScreen("To do list  screen")));
        break;

      case "profile":
      case "email":
      case "info":
      case "information":
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new HomeScreen("Assessment screen")));
        break;

      case "schedule":
      case "my schedule":
      case "course":
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new HomeScreen("Schadule screen")));
        break;

      case "request":
      case "add new request":
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new HomeScreen("Add request screen")));
        break;

      case "study":
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new HomeScreen("Study screen")));
        break;
        //chat list /chat
      case "chat":
      case "chat with":
      case "chat list":
      case "chat history":
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new HomeScreen("Chat screen")));
        break;

    }
   }

  void _saveTranscription() {
    setState(() {
      label = transcription;

    });
    _cancelRecognitionHandler();
  }

  Future _startRecognition() async {
    final res = await SpeechRecognizer.start(widget.lang.code);
    print(widget.lang.code);
    if (!res)
      showDialog(
          context: context,
          child: new SimpleDialog(title: new Text("Error"), children: [
            new Padding(
                padding: new EdgeInsets.all(12.0),
                child: const Text('Recognition not started'))
          ]));
  }

  Future _cancelRecognitionHandler() async {
    final res = await SpeechRecognizer.cancel();

    setState(() {
      transcription = '';
      isListening = res;
    });
  }

  Future _activateRecognition() async {
    final res = await SpeechRecognizer.activate();
    setState(() => authorized = res);
  }

  Future _platformCallHandler(MethodCall call) async {
    switch (call.method) {
      case "onSpeechAvailability":
        setState(() => isListening = call.arguments);
        break;
      case "onSpeech":
        if (isNotEmpty) return;
        setState(() => transcription = call.arguments);
        break;
      case "onRecognitionStarted":
        setState(() => isListening = true);
        break;
      case "onRecognitionComplete":
        setState(() {
          transcription = call.arguments;

        });
        break;
      default:
        print('Unknowm method ${call.method} ');
    }
  }


  Widget _buildButtonBar() {
    List<Widget> buttons = [
      !isListening
          ? _buildIconButton(authorized ? Icons.mic : Icons.mic_off,
              authorized ? _startRecognition : null,
              color: Colors.white, fab: true)
          : _buildIconButton(Icons.add, isListening ? _saveTranscription : null,
              color: Colors.white,
              backgroundColor: Colors.greenAccent,
              fab: true),
    ];
    Row buttonBar = new Row(mainAxisSize: MainAxisSize.min, children: buttons);
    return buttonBar;
  }

  Widget _buildTranscriptionBox(
          {String text, VoidCallback onCancel, double width}) =>
      new Container(
          width: width,
          color: Colors.grey.shade200,
          child: new Row(children: [
            new Expanded(
                child: new Padding(
                    padding: new EdgeInsets.all(8.0), child: new Text(text))),
            new IconButton(
                icon: new Icon(Icons.close, color: Colors.grey.shade600),
                onPressed: onCancel),
          ]));

  Widget _buildIconButton(IconData icon, VoidCallback onPress,
      {Color color: Colors.grey,
      Color backgroundColor: Colors.pinkAccent,
      bool fab = false}) {
    return new Padding(
      padding: new EdgeInsets.all(12.0),
      child: fab
          ? new FloatingActionButton(
              child: new Icon(icon),
              onPressed: onPress,
              backgroundColor: backgroundColor)
          : new IconButton(
              icon: new Icon(icon, size: 32.0),
              color: color,
              onPressed: onPress),
    );
  }



}
