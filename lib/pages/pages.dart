import "package:flutter/material.dart";

class HomeScreen extends StatefulWidget {
  String label;
   HomeScreen(this.label,{ Key key } ) : super(key: key);

  @override
  HomeScreenState createState() => new HomeScreenState(label);

}

class HomeScreenState extends State<HomeScreen>{
  String label;
  HomeScreenState(this.label);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(body:new Center(child: new Text(label,style: TextStyle(fontWeight: FontWeight.normal,fontSize: 25.0)),));
  }
}