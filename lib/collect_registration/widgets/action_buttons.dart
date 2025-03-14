import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sample_assist/utils/consts.dart';

class ActionButtons extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Map<String, dynamic> body;
  final String path;
  const ActionButtons({
    required this.formKey,
    required this.body,
    required this.path,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF01B4D2),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          onPressed: () {},
          child: const Text(
            'Save and Close',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A1448),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          onPressed: () {
            if (formKey.currentState!.validate()) {
              storeDriverLicense(context, path, body);
            }
          },
          child: const Text(
            'Confirm',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> storeDriverLicense(
      BuildContext context, String path, Map<String, dynamic> body) async {
    String url = '$baseUri$path';
    const Map<String, String> headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            title: Text("Success!"),
            content: Text("Your data has been saved successfully!"),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            title: Text("Fail!"),
            content: Text("Your data has been saved fail!"),
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Fail!"),
          content: Text("Your data has been saved fail!"),
        ),
      );
    }
  }
}
