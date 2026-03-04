import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// A builder widget that provides the current device orientation based on accelerometer data.
class CustomOrientationBuilder extends StatefulWidget {
  /// Constructor for [CustomOrientationBuilder].
  const CustomOrientationBuilder({required this.builder, required this.isVideosRecording, super.key});
  
  /// A builder function which provides a context and a [CustomOrientation].
  final Widget Function(BuildContext, CustomOrientation) builder;
  
  /// A flag indicating if video recording is active.
  /// If true, orientation changes will not be recognized.
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
      accelerometerSubscription = accelerometerEventStream().listen((AccelerometerEvent event) {
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
    } on PlatformException catch (_) {
    }
  }
  @override
  void dispose() {
    super.dispose();
    /// do not forget to dispose or cancel or even remove any listeners or controllers or streams.
    accelerometerSubscription.cancel();
  }
}

/// Represents the possible orientations for the camera interface.
enum CustomOrientation {
  /// Vertical orientation.
  portrait, 
  
  /// Landscape orientation with the top of the device to the left.
  leftLandScape, 
  
  /// Landscape orientation with the top of the device to the right.
  rightLandScape
}