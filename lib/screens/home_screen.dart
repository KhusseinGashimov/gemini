import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gemini/providers/providers.dart';
import 'package:gemini/widgets/messages_list.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final TextEditingController _messageController;
  final apiKey = 'sk-proj-cPwLJgcT20OE19sM2DXWT3BlbkFJyRvLs0XEXKsSkNFJ1p3s';
  // final apiKey = 'AIzaSyCi8Cq4A9GeC6UAGRg11NxYLspmtcXpzAY';
  @override
  void initState() {
    _messageController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          Consumer(builder: (context, ref, child) {
            return IconButton(
              onPressed: () {
                ref.read(authProvider).singout();
              },
              icon: const Icon(
                Icons.logout,
              ),
            );
          }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: Column(
          children: [
            // Message List
            Expanded(
              child: MessagesList(
                userId: FirebaseAuth.instance.currentUser!.uid,
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 3,
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Row(
                children: [
                  // Message Text field
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Ask any question',
                      ),
                    ),
                  ),

                  // Send Button
                  IconButton(
                    onPressed: sendMessage,
                    icon: const Icon(
                      Icons.send,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;
    await ref.read(chatProvider).sendTextMessage(
          textPrompt: _messageController.text,
        );
    _messageController.clear();
  }
}
