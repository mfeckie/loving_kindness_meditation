import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Loving Kindness Meditation',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: "BebasNeue"
        ),
        home: LovingKindnessMain());
  }
}

class LovingKindnessMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Loving Kindness Meditation", style: TextStyle(
          fontSize: 30
        ),),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.red,
              width: double.infinity,
              height: 100,
            ),
            Container(
              color: Colors.amber,
              width: double.infinity,
              height: 400,
            ),
            Expanded(
              child: Container(
                color: Colors.purple,
              ),
            )
          ],
        )
      ),
    );
  }
}
