import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';

class CustomOrientationBuilder extends StatefulWidget {
  const CustomOrientationBuilder({required this.builder, required this.isVideosRecording, super.key});
  /// this is a builder function which will provide a context and as well as a orientation (enum)
  final Widget Function(BuildContext, CustomOrientation) builder;
  /// this is a flag on which the builder widget will able to know if the video recording is going on?
  /// if the recording is running, then the change of orientation won't be recognized. I made this logic from my own. You can make your own
  final bool isVideosRecording;
  @override
  State<CustomOrientationBuilder> createState() => _CustomOrientationBuilderState();
}

class _CustomOrientationBuilderState extends State<CustomOrientationBuilder> {
  late StreamSubscription<AccelerometerEvent> accelerometerSubscription;
  CustomOrientation cameraOrientation = CustomOrientation.portrait;

  @override
  void initState() {
    super.initState();
    orientation();
  }
  @override
  Widget build(BuildContext context) {
    return widget.builder(context, cameraOrientation);
  }

  orientation(){
    try {
      accelerometerSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
        if(!widget.isVideosRecording){
          setState(() {
            if (event.z < -8.0) {

              cameraOrientation = CustomOrientation.portrait;
            } else if (event.x > 5.0) {

              cameraOrientation = CustomOrientation.rightLandScape;
            } else if (event.x < -5.0) {

              cameraOrientation = CustomOrientation.leftLandScape;
            }
            else{

              cameraOrientation = CustomOrientation.portrait;
            }

          });

        }



      });
    } on PlatformException catch (e) {
      print("Error: $e");
    }
  }
  @override
  void dispose() {
    super.dispose();
    /// do not forget to dispose or cancel or even remove any listeners or controllers or streams.
    accelerometerSubscription.cancel();
  }
}

/// orientation enums
enum CustomOrientation {portrait, leftLandScape, rightLandScape}