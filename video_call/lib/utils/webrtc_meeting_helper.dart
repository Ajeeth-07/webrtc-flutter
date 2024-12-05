// ignore: depend_on_referenced_packages
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import 'package:flutter/material.dart';

class WebRTCMeetingHelper {
  final String url;
  final String? meetingId;
  final String? userId;
  final String? name;
  webrtc.RTCPeerConnection? peerConnection;
  webrtc.MediaStream? stream;
  final Map<String, Function(dynamic, BuildContext)> _eventHandlers = {};

  WebRTCMeetingHelper({
    required this.url,
    required this.meetingId,
    required this.userId,
    required this.name,
  });

  void on(String event, BuildContext context, Function(dynamic, BuildContext) handler) {
    _eventHandlers[event] = handler;
  }

  Future<void> createPeerConnection() async {
    Map<String, dynamic> configuration = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ]
    };
    
    peerConnection = await webrtc.createPeerConnection(
      configuration,
      const <String, dynamic>{},
    );
  }

  Future<void> destroy() async {
    stream?.getTracks().forEach((track) => track.stop());
    await stream?.dispose();
    await peerConnection?.close();
    peerConnection?.dispose();
    _eventHandlers.clear();
  }
} 