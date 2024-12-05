import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../models/custom_peer_connection.dart';


class RemoteConnection extends StatefulWidget {
  final RTCVideoRenderer renderer;
  final CustomPeerConnection connection;
  final bool videoEnabled;

  const RemoteConnection({
    super.key,
    required this.renderer,
    required this.connection,
    required this.videoEnabled,
  });

  @override
  State<RemoteConnection> createState() => _RemoteConnectionState();
}

class _RemoteConnectionState extends State<RemoteConnection> {
  @override
  void initState() {
    super.initState();
    _initializeRenderer();
  }

  Future<void> _initializeRenderer() async {
    widget.renderer.srcObject = widget.connection.connection.getRemoteStreams()[0];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          child: RTCVideoView(
            widget.renderer,
            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            mirror: false,
          ),
        ),
        Container(
          color: widget.videoEnabled ? Colors.transparent : Colors.blueGrey[900],
          child: Text(widget.videoEnabled ? '' : widget.connection.name, style: const TextStyle(color: Colors.white, fontSize: 30,)),
        ),
        Positioned(
          child: Container(
            padding: const EdgeInsets.all(5),
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(widget.connection.name, style: const TextStyle(fontSize: 15, color: Colors.white)),
                Icon(widget.connection.audioEnabled! ? Icons.mic : Icons.mic_off, color: Colors.white, size: 15)
              ]
            )
          )
          
        )
      ],
    );
  }
}