import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:uuid/uuid.dart';

import '/models/message.dart';

@immutable
class ChatRepository {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  
  //! Send Text Only Prompt
  Future sendTextMessage({
    required String textPrompt,
    required String apiKey,
  }) async {
    try {
      // Define your model
      final textModel = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

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

      // Make a text only request to Gemini API and save the response
      final response =
          await textModel.generateContent([Content.text(textPrompt)]);

      final responseText = response.text;

      // Save the response in Firebase
      final receivedMessageId = const Uuid().v4();

      final responseMessage = Message(
        id: receivedMessageId,
        message: responseText!,
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