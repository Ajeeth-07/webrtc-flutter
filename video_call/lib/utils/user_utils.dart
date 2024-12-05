import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

var uuid = const Uuid();

Future<String> generateUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  var userId;

  if (prefs.containsKey('userIs')) {
    userId = prefs.getString('userId');
  } else {
    userId = uuid.v4();
    prefs.setString('userId', userId);
  }

  return userId;
}
