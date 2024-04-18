// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart' show immutable;
// import 'package:google_generative_ai/google_generative_ai.dart';
// import 'package:uuid/uuid.dart';

// import '/models/message.dart';

// @immutable
// class ChatRepository {
//   final _auth = FirebaseAuth.instance;
//   final _firestore = FirebaseFirestore.instance;

  
//   //! Send Text Only Prompt
//   Future sendTextMessage({
//     required String textPrompt,
//     required String apiKey,
//   }) async {
//     try {
//       // Define your model
//       final textModel = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

//       final userId = _auth.currentUser!.uid;
//       final sentMessageId = const Uuid().v4();

//       Message message = Message(
//         id: sentMessageId,
//         message: textPrompt,
//         createdAt: DateTime.now(),
//         isMine: true,
//       );

//       // Save Message to Firebase
//       await _firestore
//           .collection('conversations')
//           .doc(userId)
//           .collection('messages')
//           .doc(sentMessageId)
//           .set(message.toMap());

//       // Make a text only request to Gemini API and save the response
//       final response =
//           await textModel.generateContent([Content.text(textPrompt)]);

//       final responseText = response.text;

//       // Save the response in Firebase
//       final receivedMessageId = const Uuid().v4();

//       final responseMessage = Message(
//         id: receivedMessageId,
//         message: responseText!,
//         createdAt: DateTime.now(),
//         isMine: false,
//       );

//       // Save Message to Firebase
//       await _firestore
//           .collection('conversations')
//           .doc(userId)
//           .collection('messages')
//           .doc(receivedMessageId)
//           .set(responseMessage.toMap());
//     } catch (e) {
//       throw Exception(e.toString());
//     }
//   }
// }



import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gemini/models/message.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';

import 'package:uuid/uuid.dart';

class ChatRepository {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final String chatGPTApiKey = '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'; // Замените на ваш API ключ от ChatGPT

  Future sendTextMessage({
    required String textPrompt,
  }) async {
    try {
      final userId = _auth.currentUser!.uid;
      final sentMessageId = const Uuid().v4();

      Message message = Message(
        id: sentMessageId,
        message: textPrompt,
        createdAt: DateTime.now(),
        isMine: true,
      );

      // Save Message to Firebase
      await _firestore
          .collection('conversations')
          .doc(userId)
          .collection('messages')
          .doc(sentMessageId)
          .set(message.toMap());

      // Make a request to ChatGPT API and save the response
      var res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          "Authorization": "Bearer $chatGPTApiKey",
          "Content-Type": "application/json",
        },
        body: json.encode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {"role": "system", "content": "You: $textPrompt"},
          ],
        }),
      );

      Map jsonResponse = jsonDecode(res.body);
      if (jsonResponse['error'] != null) {
        log("ERROR: ${jsonResponse['error']['message']}");
        throw HttpException(jsonResponse['error']['message']);
      }

      // Extract response text from ChatGPT API response
      String responseText = jsonResponse['choices'][0]['message']['content'];

      // Save the response in Firebase
      final receivedMessageId = const Uuid().v4();

      final responseMessage = Message(
        id: receivedMessageId,
        message: responseText,
        createdAt: DateTime.now(),
        isMine: false,
      );

      // Save Message to Firebase
      await _firestore
          .collection('conversations')
          .doc(userId)
          .collection('messages')
          .doc(receivedMessageId)
          .set(responseMessage.toMap());
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
