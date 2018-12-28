import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:quiver/async.dart';
import 'package:flutter/material.dart';
import 'package:loving_kindness_meditation/widgets/clock_background.dart';
import 'package:loving_kindness_meditation/widgets/clock_window.dart';
import 'package:loving_kindness_meditation/widgets/clock_window_frame.dart';

void main() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Loving Kindness Meditation',
        theme: ThemeData(primarySwatch: Colors.blue, fontFamily: "BebasNeue"),
        home: LovingKindnessMain());
  }
}

String padTime(int number) {
 return number.toString().padLeft(2, "0") ;
}

class LovingKindnessMain extends StatefulWidget {
  @override
  LovingKindnessMainState createState() {
    return new LovingKindnessMainState();
  }
}

class LovingKindnessMainState extends State<LovingKindnessMain> {
  double angle = 0;
  StreamSubscription<CountdownTimer> timer;
  Stopwatch stopwatch;
  LovingKindnessMainState() {
    setupTimer(Duration(minutes: 15));
  }

  void setupTimer(Duration duration) {
    stopwatch = Stopwatch();
    this.timer = CountdownTimer(duration, Duration(milliseconds: 100), stopwatch: stopwatch)
        .listen((CountdownTimer event) {
      final total = event.elapsed + event.remaining;
      setState(() {
        angle = (event.elapsed.inSeconds / total.inSeconds) * ((2 * pi) * 0.75);
        elapsed = event.elapsed;
      });
    });
  }

  Duration elapsed = Duration(minutes: 0);

  get elapsedFormatted {
    final minutes = padTime(elapsed.inMinutes % 60);
    final seconds = padTime(elapsed.inSeconds % 60);
    return "Elapsed time $minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Loving Kindness Meditation",
          style: TextStyle(fontSize: 30),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          stopwatch.isRunning ? Icons.pause : Icons.play_arrow
        ),
        onPressed: () {
          setState(() {
            stopwatch.isRunning ? stopwatch.stop() : stopwatch.start();
          });
        },
      ),
      body: Container(
          child: Column(
        children: <Widget>[
          Container(
              width: double.infinity,
              height: 100,
              child: Center(
                child: Text(
                  elapsedFormatted,
                  style: TextStyle(
                    fontSize: 25
                  ),
                  ),
              )),
          Container(
            padding: EdgeInsets.all(8.0),
            width: double.infinity,
            height: 400,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CustomPaint(
                  painter: ClockBackground(),
                ),
                Transform.rotate(
                  angle: angle,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      CustomPaint(
                        painter: ClockWindow(),
                      ),
                      CustomPaint(
                        painter: ClockWindowFrame(),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
            ),
          )
        ],
      )),
    );
  }
}
