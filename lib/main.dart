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
  return number.toString().padLeft(2, "0");
}

class LovingKindnessMain extends StatefulWidget {
  @override
  LovingKindnessMainState createState() {
    return new LovingKindnessMainState();
  }
}

class LovingKindnessMainState extends State<LovingKindnessMain> {
  double angle = 0;
  Duration meditationTime = Duration(minutes: 15);
  StreamSubscription<CountdownTimer> timer;
  Stopwatch stopwatch;
  LovingKindnessMainState() {
    setupTimer();
  }

  void setupTimer() {
    stopwatch = Stopwatch();
    this.timer = CountdownTimer(meditationTime, Duration(milliseconds: 100),
            stopwatch: stopwatch)
        .listen((CountdownTimer event) {
      final total = event.elapsed + event.remaining;
      setState(() {
        angle = (event.elapsed.inSeconds / total.inSeconds) * ((2 * pi) * 0.75);
        elapsed = event.elapsed;
      });
    });
    stopwatch.stop();
    stopwatch.reset();
  }

  Duration elapsed = Duration(minutes: 0);

  get elapsedFormatted {
    final minutes = padTime(elapsed.inMinutes % 60);
    final seconds = padTime(elapsed.inSeconds % 60);
    return "Elapsed time $minutes:$seconds";
  }

  get totalFormatted {
    final minutes = padTime(meditationTime.inMinutes % 60);
    final seconds = padTime(meditationTime.inSeconds % 60);
    return "Total time $minutes:$seconds";
  }

  setMeditationTime(int duration) {
    meditationTime = Duration(minutes: duration);
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
      bottomNavigationBar: BottomAppBar(
        notchMargin: 4.0,
        shape: CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: <Widget>[
              IconButton(
                iconSize: 50,
                icon: Icon(Icons.menu),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return new TimeSelectionModal(
                            timer: timer,
                            setTime: setMeditationTime,
                            setupTimer: setupTimer);
                      });
                },
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(stopwatch.isRunning ? Icons.pause : Icons.play_arrow),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    elapsedFormatted,
                    style: TextStyle(fontSize: 25),
                  ),
                  Text(
                    totalFormatted,
                    style: TextStyle(fontSize: 15),
                  )
                ],
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                  BoxShadow(
                      color: Colors.grey,
                      blurRadius: 2.0,
                      spreadRadius: 1,
                      offset: Offset(0, 1))
                ]),
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
            ),
          ),
          Expanded(
            child: Container(),
          )
        ],
      )),
    );
  }
}

class TimeSelectionModal extends StatelessWidget {
  const TimeSelectionModal({
    Key key,
    @required this.timer,
    @required this.setTime,
    @required this.setupTimer,
  }) : super(key: key);

  final StreamSubscription<CountdownTimer> timer;
  final Function setTime;
  final Function setupTimer;

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      enableDrag: false,
      builder: (BuildContext context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            FlatButton(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text("Set 15 minutes", style: TextStyle(fontSize: 24.0)),
              onPressed: () {
                setTime(15);
                timer.cancel();
                setupTimer();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text("Set 30 minutes", style: TextStyle(fontSize: 24.0)),
              onPressed: () {
                setTime(30);
                timer.cancel();
                setupTimer();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
      onClosing: () {},
    );
  }
}
