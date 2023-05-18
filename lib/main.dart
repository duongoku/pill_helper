import 'add_reminder_screen.dart';
import 'notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:localstorage/localstorage.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:timezone/data/latest.dart' as tz;
import 'view_reminder.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  NotificationService().initNotification();
  runApp(MedicationReminderApp());
}

class MedicationReminderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medication Reminder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MedicationReminderScreen(),
    );
  }
}

class MedicationReminderScreen extends StatelessWidget {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final LocalStorage storage = new LocalStorage('reminder.json');
  final FlutterTts tts = FlutterTts();
  stt.SpeechToText speech = stt.SpeechToText();
  var pressed_1 = false;
  var pressed_2 = false;
  var isListening = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medication Reminder'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (isListening) {
            speech.stop();
            isListening = false;
            return;
          }
          bool available = await speech.initialize();
          if (available) {
            isListening = true;
            speech.listen(onResult: (result) {
              print('Result: ${result.recognizedWords}');
            });
          } else {
            print('The user has denied the use of speech recognition.');
          }
        },
        child: Icon(Icons.mic),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              color: Colors.green,
              child: TextButton(
                onPressed: () async {
                  pressed_2 = false;
                  if (!pressed_1) {
                    pressed_1 = true;
                    tts.setLanguage('en');
                    tts.setSpeechRate(0.4);
                    await tts.awaitSpeakCompletion(true);
                    await tts.speak('Add New Reminder');
                  } else {
                    pressed_1 = false;
                    Map<String, dynamic> currentReminder = {
                      'medicineName': '',
                      'Time': ''
                    };
                    storage.setItem('currentReminder', currentReminder);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddReminderScreen(),
                      ),
                    );
                  }
                },
                child: Text(
                  'Add New Reminder',
                  style: TextStyle(
                    fontSize: 36,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.red,
              child: TextButton(
                onPressed: () async {
                  pressed_1 = false;
                  if (!pressed_2) {
                    pressed_2 = true;
                    tts.setLanguage('en');
                    tts.setSpeechRate(0.4);
                    await tts.awaitSpeakCompletion(true);
                    await tts.speak('View Existing Reminders');
                  } else {
                    pressed_2 = false;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewRemindersScreen(),
                      ),
                    );
                  }
                },
                child: Text(
                  'View Existing Reminders',
                  style: TextStyle(
                    fontSize: 36,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showNotification() async {
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'medication_reminder_channel',
      'Medication Reminder',
      subText: 'Reminds you to take your medication',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      icon: '@mipmap/ic_launcher',
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await notificationsPlugin.show(
      0,
      'Medication Reminder',
      'Time to take your medication!',
      platformChannelSpecifics,
      payload: 'medication',
    );
  }
}
