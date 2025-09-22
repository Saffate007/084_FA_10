import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final TextEditingController _controller = TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client;

  List<Map<String, dynamic>> messages = [];
  String? userId;

  @override
  void initState() {
    super.initState();

    final currentUser = supabase.auth.currentUser;
    if (currentUser != null) {
      userId = currentUser.id;
      _fetchMessages();
    }
  }

  Future<void> _fetchMessages() async {
    if (userId == null) return;

    try {
      final response = await supabase
          .from('messages')
          .select()
          .eq('user_id', userId!)
          .order('created_at', ascending: true);

      if (response != null) {
        final data = response as List<dynamic>;
        setState(() {
          messages = data.map((e) => Map<String, dynamic>.from(e)).toList();
        });
      }
    } catch (e) {
      debugPrint('Error fetching messages: $e');
    }
  }

  Future<void> _sendMessage() async {
    if (userId == null) return;

    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add({"text": text, "is_me": true});
      _controller.clear();
    });

    await supabase.from('messages').insert({
      "user_id": userId!,
      "text": text,
      "is_me": true,
    });

    Future.delayed(const Duration(seconds: 1), () async {
      final reply = _getDoctorReply(text);
      setState(() {
        messages.add({"text": reply, "is_me": false});
      });
      await supabase.from('messages').insert({
        "user_id": userId!,
        "text": reply,
        "is_me": false,
      });
    });
  }

  String _getDoctorReply(String userMessage) {
    final msg = userMessage.toLowerCase();
    if (msg.contains("hello") || msg.contains("hi")) {
      return "Hello! 👋 How can I help you today?";
    }
    if (msg.contains("book") || msg.contains("appointment")) {
      return "Sure! Please provide your preferred date and time.";
    }
    if (msg.contains("cancel")) {
      return "Your appointment has been cancelled. ❌ Do you want to reschedule?";
    }
    if (msg.contains("thanks")) {
      return "You're welcome! 😊";
    }
    if (msg.contains("bye")) {
      return "Goodbye! 👋 Take care!";
    }
    return "Message noted. Our team will assist you.";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text("Doctor Chat", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? const Center(
                    child: Text(
                      "No messages yet",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isMe = message["is_me"] as bool;
                      return Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 8,
                          ),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue : Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            message["text"],
                            style: TextStyle(
                              color: isMe ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      filled: true,
                      fillColor: Colors.blue.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
