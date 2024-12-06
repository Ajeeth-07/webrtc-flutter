import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import 'package:flutter/material.dart';
import '../models/custom_peer_connection.dart';

class WebRTCMeetingHelper {
  final String url;
  final String? meetingId;
  final String? userId;
  final String? name;
  webrtc.RTCPeerConnection? peerConnection;
  webrtc.MediaStream? stream;
  final Map<String, CustomPeerConnection> connections = {};
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

  void toggleVideo() {
    if (stream != null && stream!.getVideoTracks().isNotEmpty) {
      final videoTrack = stream!.getVideoTracks()[0];
      videoTrack.enabled = !videoTrack.enabled;
      _notifyEvent('video-toggle', null);
    }
  }

  void toggleAudio() {
    if (stream != null && stream!.getAudioTracks().isNotEmpty) {
      final audioTrack = stream!.getAudioTracks()[0];
      audioTrack.enabled = !audioTrack.enabled;
      _notifyEvent('audio-toggle', null);
    }
  }

  void _notifyEvent(String event, dynamic data) {
    final handler = _eventHandlers[event];
    if (handler != null) {
      handler(data, _eventHandlers['context'] as BuildContext);
    }
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

  void endMeeting() {
    _notifyEvent('meeting-ended', null);
    destroy();
  }

  bool isVideoEnabled() {
    return stream?.getVideoTracks().first.enabled ?? false;
  }

  bool isAudioEnabled() {
    return stream?.getAudioTracks().first.enabled ?? false;
  }

  Future<void> reconnect() async {
    await destroy();
    await createPeerConnection();
    _notifyEvent('connection', null);
  }
} 