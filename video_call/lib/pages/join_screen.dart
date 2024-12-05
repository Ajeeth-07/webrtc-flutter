import 'package:flutter/material.dart';
import 'package:video_call/models/meeting_details.dart';
import 'package:http/http.dart' as http;
import 'package:video_call/api/meeting_api.dart';
// ignore: depend_on_referenced_packages
import 'package:snippet_coder_utils/FormHelper.dart';


class JoinScreen extends StatefulWidget {
  final String? meetingId;
  final MeetingDetails? meetingDetails;

  const JoinScreen({super.key, this.meetingId, this.meetingDetails});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  String username = "";
  @override
 Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Join Meeting'),
          backgroundColor: Colors.blueAccent,
        ),
        body: Form(key: globalKey, child: formUI()));
  }

  formUI() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            FormHelper.inputFieldWidget(
              context,
              "userId",
              "Enter your name",
              (val) {
                if (val.isEmpty) {
                  return "name cant be empty";
                }
                return null;
              },
              (onSaved) {
                username = onSaved;
              },
              borderRadius: 20,
              borderColor: Colors.blueAccent,
              borderFocusColor: Colors.blueAccent,
              hintColor: Colors.grey,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                    child: FormHelper.submitButton(
                  "Join",
                  () {
                    if (validateAndSave()) {
                      //TODO: validate meeting
                    }
                  },
                )),
              ],
            )
          ],
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateMeeting(String meetingId) async {
    try {
      http.Response response = await joinMeeting(meetingId);
      // Handle response if needed
    } catch (err) {
      print('Error joining meeting: $err');
    }
  }
}