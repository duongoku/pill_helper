import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_tts/flutter_tts.dart';

class MedicineNameScreen extends StatelessWidget {
  final LocalStorage storage = new LocalStorage('reminders.json');
  final textController = TextEditingController();
  final FlutterTts tts = FlutterTts();
  var pressed_1 = false;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> currentReminder =
        storage.getItem('currentReminder') ?? {'medicineName': '', 'Time': ''};

    @override
    void dispose() {
      textController.dispose();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Medicine Name'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: textController,
                decoration: InputDecoration(
                  labelText: 'Enter Medicine Name',
                  contentPadding: EdgeInsets.symmetric(vertical: 24.0),
                ),
                onTap: () {
                  pressed_1 = false;
                  tts.setLanguage('en');
                  tts.setSpeechRate(0.4);
                  tts.speak('Editing Medicine Name');
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.green,
              child: TextButton(
                onPressed: () {
                  if (!pressed_1) {
                    pressed_1 = true;
                    tts.setLanguage('en');
                    tts.setSpeechRate(0.4);
                    tts.speak('Confirm');
                  } else {
                    pressed_1 = false;
                    currentReminder['medicineName'] = textController.text;
                    storage.setItem('currentReminder', currentReminder);
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  'Confirm',
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
