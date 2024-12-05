import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:snippet_coder_utils/FormHelper.dart';

class ControlPanel extends StatefulWidget {
  final bool? videoEnabled;
  final bool? audioEnabled;
  final bool? isConnectionFailed;
  final VoidCallback? onVideoToggle;
  final VoidCallback? onAudioToggle;
  final VoidCallback? onReconnect;
  final VoidCallback? onMeetingEnd;

  const ControlPanel(
      {super.key,
      this.videoEnabled,
      this.audioEnabled,
      this.isConnectionFailed,
      this.onVideoToggle,
      this.onAudioToggle,
      this.onReconnect,
      this.onMeetingEnd});

  @override
  State<ControlPanel> createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[900],
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buildControls(),
      ),
      
    );
  }

  List<Widget> buildControls() {
    if (!widget.isConnectionFailed!) {
      return <Widget>[
        IconButton(
          onPressed: widget.onVideoToggle,
          icon:
              Icon(widget.videoEnabled! ? Icons.videocam : Icons.videocam_off),
          color: Colors.white,
          iconSize: 32.0,
        ),
        IconButton(
          onPressed: widget.onAudioToggle,
          icon: Icon(widget.audioEnabled! ? Icons.mic : Icons.mic_off),
          color: Colors.white,
          iconSize: 32.0,
        ),
        const SizedBox(width: 25),
        Container(
            width: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.red,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.call_end,
                color: Colors.white,
              ),
              onPressed: widget.onMeetingEnd!,
            ))
      ];
    } else {
      return <Widget>[
        FormHelper.submitButton("Reconnect", widget.onReconnect!,
            btnColor: Colors.red, borderRadius: 10, width: 200, height: 40)
      ];
    }
  }
}
