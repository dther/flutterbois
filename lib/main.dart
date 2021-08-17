import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as math;
import 'boids.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutterbois',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: BoidPage(title: 'oh man look at em go'),
    );
  }
}

class BoidPage extends StatefulWidget {
  BoidPage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _BoidPageState createState() => _BoidPageState();
}

class _BoidPageState extends State<BoidPage> {
  BoidBox boidBox = BoidBox(150, math.Vector2(300, 300));
  void nextFrame(Timer t) async {
    setState(() {
      boidBox.moveBoids();
    });
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 20), nextFrame);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: CustomPaint(
          size: Size.infinite,
          painter: BoidPainter(boidBox),
        )
      ),
    );
  }
}

class BoidPainter extends CustomPainter {
  late BoidBox boidBox;
  BoidPainter(this.boidBox);
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    for (Boid boid in boidBox.boids) {
      Offset currentLocation = Offset(boid.position.x,
                                      boid.position.y) * 2;
      Offset nextLocation = currentLocation +
          Offset(boid.velocity.x, boid.velocity.y);
      canvas.drawLine(currentLocation, nextLocation,
        Paint()
          ..strokeCap = StrokeCap.round
          ..isAntiAlias = true
          ..color = Colors.blue
          ..strokeWidth = 5
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
    throw UnimplementedError();
  }
}
