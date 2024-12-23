import 'package:flutter/material.dart';
import 'package:video_call/models/meeting_details.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:video_call/utils/webrtc_meeting_helper.dart';
import 'package:video_call/widgets/control_panel.dart';
import 'package:video_call/widgets/remote_connection.dart';
import '../utils/user_utils.dart';
import '../pages/home_screen.dart';

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
    return Scaffold(
      backgroundColor: Colors.black87,
      body: _buildMeetingRoom(),
      bottomNavigationBar: ControlPanel(
        onAudioToggle: onAudioToggle,
        onVideoToggle: onVideoToggle,
        videoEnabled: isVideoEnabled(),
        audioEnabled: isAudioEnabled(),
        isConnectionFailed: isConnectionFailed,
        onReconnect: onReconnect,
        onMeetingEnd: onMeetingEnd,
      ),
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

    setState(() {});
  }

  initRenderers() async {
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

  void onMeetingEnd() {
    if (meetingHelper != null) {
      meetingHelper!.endMeeting();
      meetingHelper = null;
      goToHomePage();
    }
  }

  void onAudioToggle() {
    if (meetingHelper != null) {
      setState(() {
        meetingHelper!.toggleAudio();
      });
    }
  }

  void onVideoToggle() {
    if (meetingHelper != null) {
      setState(() {
        meetingHelper!.toggleVideo();
      });
    }
  }

  void onReconnect() {
    if (meetingHelper != null) {
      meetingHelper!.reconnect();
    }
  }

  bool isVideoEnabled() {
    return meetingHelper != null ? meetingHelper!.isVideoEnabled() : false;
  }

  bool isAudioEnabled() {
    return meetingHelper != null ? meetingHelper!.isAudioEnabled() : false;
  }

  void goToHomePage() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  Widget _buildMeetingRoom() {
    return Stack(
      children: [
        meetingHelper != null && meetingHelper!.connections.isNotEmpty
            ? GridView.count(
                crossAxisCount: meetingHelper!.connections.length < 3 ? 1 : 2,
                children: List.generate(meetingHelper!.connections.length, (index) {
                  var connection = meetingHelper!.connections.values.toList()[index];
                  return Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: RemoteConnection(
                      renderer: connection.renderer,
                      connection: connection,
                      videoEnabled: connection.stream?.getVideoTracks().isNotEmpty ?? false 
                          ? connection.stream!.getVideoTracks().first.enabled 
                          : false,
                    ),
                  );
                }),
              )
            : const Center(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "Waiting for other participants to join",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 24.0),
                  ),
                ),
              ),
        Positioned( bottom : 10, right: 0, child: SizedBox(
          width: 150,
            height: 200,
            child: RTCVideoView(_localRenderer),
          ),
        )
      ],
    );
  }
}
