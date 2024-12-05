import 'package:flutter/material.dart';
import 'package:video_call/models/meeting_details.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:video_call/utils/webrtc_meeting_helper.dart';
import '../utils/user_utils.dart';

class MeetingPage extends StatefulWidget {
  const MeetingPage(
      {super.key,
      required this.meetingId,
      required this.name,
      required this.meetingDetails});

  final String? meetingId;
  final String? name;
  final MeetingDetails meetingDetails;

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  final _localRenderer = RTCVideoRenderer();
  final Map<String, dynamic> mediaConstraints = {'audio': true, 'video': true};
  bool isConnectionFailed = false;
  WebRTCMeetingHelper? meetingHelper;
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black87,
      body: _buildMeetingRoom(),
    );
  }

  void startMeeting() async {
    final String userId = await loadUserId();
    meetingHelper = WebRTCMeetingHelper(
      url: "https://192.168.1.12:4000",
      meetingId: widget.meetingId,
      userId: userId,
      name: widget.name,
    );

    MediaStream? _localStream =
        await navigator.mediaDevices.getUserMedia(mediaConstraints);

    _localRenderer.srcObject = _localStream;
    meetingHelper!.stream = _localStream;

    meetingHelper!.on("open", context, (ev, context) {
      setState(() {
        isConnectionFailed = false;
      });
    });
    meetingHelper!.on("connection", context, (ev, context) {
      setState(() {
        isConnectionFailed = false;
      });
    });
    meetingHelper!.on("user-left", context, (ev, context) {
      setState(() {
        isConnectionFailed = false;
      });
    });
    meetingHelper!.on("video-toggle", context, (ev, context) {
      setState(() {
        // isConnectionFailed = false;
      });
    });
    meetingHelper!.on("audio-toggle", context, (ev, context) {
      setState(() {
        // isConnectionFailed = false;
      });
    });
    meetingHelper!.on("meeting-ended", context, (ev, context) {
      setState(() {
        onMeetingEnd();
      });
    });
    meetingHelper!.on("connection-settings-changed", context, (ev, context) {
      setState(() {
        isConnectionFailed = false;
      });
    });
    meetingHelper!.on("stream-changed", context, (ev, context) {
      setState(() {
        isConnectionFailed = false;
      });
    });

    setState(() {
      
    });
  }

  initRenderers() async{
    await _localRenderer.initialize();
  }

  @override
  void initState() {
    super.initState();
    initRenderers();
    startMeeting();
  }

  @override
  void deactivate() {
    super.deactivate();
    _localRenderer.dispose();
    if (meetingHelper != null) {
      meetingHelper!.destroy();
      meetingHelper = null;
    }
  }

  void onMeetingEnd() {}
}

class _buildMeetingRoom {
  const _buildMeetingRoom();
}


