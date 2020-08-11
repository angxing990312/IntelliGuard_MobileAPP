import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:intelliguard/screens/guest_register.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import '../models/user.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  static const routeName = '/take_picture';

  const CameraScreen({
    Key key,
    @required this.cameras,
  }) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with TickerProviderStateMixin {
  AnimationController controller;
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  List<CameraDescription> cameras;
  CameraDescription firstCamera;

  @override
  void initState() {
    super.initState();
    cameras = widget.cameras;
    firstCamera = cameras[1];
    _controller = CameraController(firstCamera, ResolutionPreset.ultraHigh);
    _initializeControllerFuture = _controller.initialize();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 15),
    );
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registering Face"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF4f74c2),
                  Color(0xFF6883BC),
                  Color(0xFF79A7D3)
                ]),
          ),
        ),
      ),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Stack(
              children: <Widget>[
                Positioned(
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.all(1.0),
                      child: Center(
                        child: FutureBuilder<void>(
                          future: _initializeControllerFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              // If the Future is complete, display the preview.
                              return CameraPreview(_controller);
                            } else {
                              // Otherwise, display a loading indicator.
                              return Center(child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Align(
                          alignment: FractionalOffset.center,
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: Stack(
                              children: <Widget>[
                                Positioned.fill(
                                  child: CustomPaint(
                                      painter: CustomTimerPainter(
                                    animation: controller,
                                    backgroundColor:
                                        Colors.white.withOpacity(0),
                                    color: Colors.grey.withOpacity(0.7),
                                  )),
                                ),
                                Align(
                                  alignment: FractionalOffset.center,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Ensure that your entire face is visible\n and lighting is sufficient\n\n\nDuring photo-taking,\n Tilt your face following the circle",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          }),

      floatingActionButton: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return FloatingActionButton(
              child: Icon(Icons.camera_alt),
              backgroundColor: Color(0xFF4f74c2),
              onPressed: () async {
                if (controller.isAnimating)
                  controller.stop();
                else {
                  controller.reverse(
                      from: controller.value == 0.0 ? 1.0 : controller.value);
                }
                // Take the Picture in a try / catch block. If anything goes wrong,
                // catch the error.
                try {
                  // Ensure that the camera is initialized.
                  await _initializeControllerFuture;

                  List<String> paths = new List<String>();

                  while (controller.isAnimating) {
                  // Construct the path where the image should be saved using the
                  // pattern package.
                  final path = join(
                    // Store the picture in the temp directory.
                    // Find the temp directory using the `path_provider` plugin.
                    (await getTemporaryDirectory()).path,
                    //'${DateTime.now()}.png',
                    '${DateTime.now()}',
                  );
                  print(path);

                  // Attempt to take a picture and log where it's been saved.
                  await _controller.takePicture(path);

                  paths.add(path);
                  }

                  final users = Provider.of<CreateUser>(context, listen: false);
                  bool addComplete = users.addPaths(paths);
                  // If the picture was taken, display it on a new screen.
                  if (addComplete) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DisplayScreen(),
                      ),
                    );
                  }
                } catch (e) {
                  // If an error occurs, log the error to the console.
                  print(e);
                }
              },
            );
          }),
    );
  }
}

class DisplayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.lightBlue,
        child: Column(
          children: <Widget>[
            SizedBox(height: 400),
            Center(
              child: Text(
                'Face Scanning Complete!',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 32.0,
                    color: Colors.grey[700]),
              ),
            ),
            SizedBox(height: 50),
            FlatButton(
              child: Text(
                'Click to proceed!',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18.0,
                    color: Colors.grey[700]),
              ),
              onPressed: (() {
                Navigator.popUntil(
                    context, ModalRoute.withName('/guest_signup'));
              }),
            )
          ],
        ),
      ),
    );
  }
}

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
