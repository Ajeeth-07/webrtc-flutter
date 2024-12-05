import 'dart:convert';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:video_call/api/meeting_api.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:video_call/models/meeting_details.dart';
import 'package:video_call/pages/join_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  String? meetingId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Meeting'),
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
            const Text(
              "Webrtc Meeting App",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            FormHelper.inputFieldWidget(
              context,
              "meetingId",
              "Enter Meeting Id",
              (val) {
                if (val.isEmpty) {
                  return "Meeting Id is required";
                }
                return null;
              },
              (onSaved) {
                meetingId = onSaved;
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
                  "Join Meeting",
                  () {
                    if (validateAndSave()) {
                      validateMeeting(meetingId!);
                    }
                  },
                )),
                Flexible(
                    child: FormHelper.submitButton(
                  "Start Meeting",
                  () async {
                    try {
                      print('Attempting to create meeting...');
                      var response = await createMeeting();
                      print('Server Response: ${response.body}');

                      final body = json.decode(response.body);
                      print('Decoded response: $body');

                      final meetId = body['data'];
                      print('Meeting ID created: $meetId');

                      validateMeeting(meetId);
                    } catch (err) {
                      print('Error creating meeting: $err');
                      // Show error to user
                      FormHelper.showSimpleAlertDialog(
                          context,
                          "Meeting App",
                          "Failed to create meeting: $err",
                          "Ok",
                          () => Navigator.of(context).pop());
                    }
                  },
                ))
              ],
            )
          ],
        ),
      ),
    );
  }

  void validateMeeting(String meetingId) async {
    try {
      http.Response response = await joinMeeting(meetingId);
      var data = json.decode(response.body);
      final meetingDetails = MeetingDetails.fromJson(data['data']);
      //go to Join screen
    } catch (err) {
      FormHelper.showSimpleAlertDialog(
          context, "Meeting App", "Invalid Meeting Id", "Ok", () {
        Navigator.of(context).pop();
      });
    }
  }

  goToJoinScreen(MeetingDetails meetingDetails) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => JoinScreen(
                  meetingDetails: meetingDetails,
                )));
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
