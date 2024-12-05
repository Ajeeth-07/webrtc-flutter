// ignore: depend_on_referenced_packages
import 'package:flutter_webrtc/flutter_webrtc.dart';

class CustomPeerConnection {
  final RTCPeerConnection connection;
  final String name;
  final bool audioEnabled;

  CustomPeerConnection({
    required this.connection,
    required this.name,
    required this.audioEnabled,
  });
} 