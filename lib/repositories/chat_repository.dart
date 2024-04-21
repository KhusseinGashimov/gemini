import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gemini/database_service.dart';
import 'package:gemini/models/message.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'package:uuid/uuid.dart';

class ChatRepository {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final String chatGPTApiKey = ''; // Замените на ваш API ключ от ChatGPT

  Future sendPlaceMessage(name, description, location, working_hours,
      ticket_price, contact_info) async {
    DatabaseService databaseService = DatabaseService();
    databaseService.addAttraction(
        name.toString(),
        description.toString(),
        location.toString(),
        working_hours.toString(),
        ticket_price.toString(),
        contact_info.toString());
  }

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

      // Format message for ChatGPT API
      var requestBody = {
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "system", "content": "You: $textPrompt"},
        ],
      };

      var res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          "Authorization": "Bearer $chatGPTApiKey",
          "Content-Type": "application/json",
        },
        body: json.encode(requestBody),
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
