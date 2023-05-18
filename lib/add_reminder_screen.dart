import 'medicine_name_screen.dart';
import 'notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:localstorage/localstorage.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'time_screen.dart';

class AddReminderScreen extends StatelessWidget {
  final LocalStorage storage = new LocalStorage('reminders.json');
  final FlutterTts tts = FlutterTts();
  stt.SpeechToText speech = stt.SpeechToText();
  var pressed_1 = false;
  var pressed_2 = false;
  var pressed_3 = false;
  var isListening = false;

  @override
  Widget build(BuildContext context) {
    List<dynamic> reminders = storage.getItem('reminders') ??
        [
          {
            'medicineName': 'Panadol',
            'Time': '6:01',
          },
          {
            'medicineName': 'Paracetamol',
            'Time': '8:12',
          },
          {
            'medicineName': 'Tiffy',
            'Time': '12:31',
          },
          {
            'medicineName': 'Decolgen',
            'Time': '15:11',
          },
          {
            'medicineName': 'Vitamin B1',
            'Time': '21:03',
          }
        ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Reminder'),
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
                onPressed: () {
                  pressed_2 = false;
                  pressed_3 = false;
                  if (!pressed_1) {
                    pressed_1 = true;
                    tts.setLanguage('en');
                    tts.setSpeechRate(0.4);
                    tts.speak('Add Medicine');
                  } else {
                    pressed_1 = false;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MedicineNameScreen(),
                      ),
                    );
                  }
                },
                child: Text(
                  'Add Medicine',
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
              color: Colors.blue,
              child: TextButton(
                onPressed: () {
                  pressed_1 = false;
                  pressed_3 = false;
                  if (!pressed_2) {
                    pressed_2 = true;
                    tts.setLanguage('en');
                    tts.setSpeechRate(0.4);
                    tts.speak('Add Time');
                  } else {
                    pressed_2 = false;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TimeScreen(),
                      ),
                    );
                  }
                },
                child: Text(
                  'Add Time',
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
                onPressed: () {
                  pressed_1 = false;
                  pressed_2 = false;
                  if (!pressed_3) {
                    pressed_3 = true;
                    tts.setLanguage('en');
                    tts.setSpeechRate(0.4);
                    tts.speak('Save Reminder');
                  } else {
                    pressed_3 = false;
                    reminders.add(Map<String, dynamic>.from(
                        storage.getItem('currentReminder')));
                    reminders.sort((a, b) => a['Time'].compareTo(b['Time']));
                    storage.setItem('reminders', reminders);
                    NotificationService().showNotification(
                      1,
                      'Medicine Reminder',
                      "Time to take your medicine: ${storage.getItem('currentReminder')['Medicine']}",
                      storage.getItem('currentReminder')['Time'],
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  'Save Reminder',
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
}
