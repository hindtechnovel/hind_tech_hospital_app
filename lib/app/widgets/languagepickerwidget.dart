import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helperClasses/AppStorage.dart';

class LanguagePickerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Locale>(
      icon: Icon(Icons.language), // 🌐 Language Icon
      onSelected: (Locale locale) async {



        print('land is:  ${locale.languageCode.toString()}');

        await AppStorage.saveValue('locale', locale.languageCode.toString());



        Get.updateLocale(locale);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
        PopupMenuItem(
          value: Locale('en', 'US'),
          child: Row(
            children: [
              Icon(Icons.flag, color: Colors.blue),
              SizedBox(width: 8),
              Text('English'),
            ],
          ),
        ),
        PopupMenuItem(
          value: Locale('hi', 'IN'),
          child: Row(
            children: [
              Icon(Icons.flag, color: Colors.orange),
              SizedBox(width: 8),
              Text('हिन्दी (Hindi)'),
            ],
          ),
        ),
        PopupMenuItem(
          value: Locale('ur', 'PK'),
          child: Row(
            children: [
              Icon(Icons.flag, color: Colors.green),
              SizedBox(width: 8),
              Text('اردو (Urdu)'),
            ],
          ),
        ),
        PopupMenuItem(
          value: Locale('pa', 'IN'),
          child: Row(
            children: [
              Icon(Icons.flag, color: Colors.deepPurple),
              SizedBox(width: 8),
              Text('ਪੰਜਾਬੀ (Punjabi)'),
            ],
          ),
        ),
      ],
    );
  }
}
