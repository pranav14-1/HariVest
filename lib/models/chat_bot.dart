import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatBot extends StatefulWidget {
  final VoidCallback? onClose;
  const ChatBot({Key? key, this.onClose}) : super(key: key);

  @override
  State<ChatBot> createState() => _ChatBot();
}

class _ChatBot extends State<ChatBot> with SingleTickerProviderStateMixin {
  final String _geminiApiKey = 'AIzaSyA2Ar6RM4JmRc_cJOT_GqF5laWOtm8j1lU';
  late GenerativeModel _geminiModel;
  final List<Map<String, String>> _messages = [
    {
      'id': '1',
      'text': 'Hello! I am Surender, your farming assistant 🌾. Ask me about soil, weather, crops, or just say "help"!',
      'sender': 'bot'
    }
  ];
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  late AnimationController _modalAnimController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _geminiModel = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: _geminiApiKey,
    );

    _modalAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(_modalAnimController);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(_modalAnimController);

    _modalAnimController.forward();
  }

  @override
  void dispose() {
    _modalAnimController.dispose();
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final input = _inputController.text.trim();
    if (input.isEmpty || _isTyping) return;
    setState(() {
      _messages.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'text': input,
        'sender': 'user'
      });
      _isTyping = true;
      _inputController.clear();
    });
    _scrollToBottom();

    try {
      final response = await _geminiModel.generateContent([
        Content.text("You are Surender, a friendly Indian farmer and agriculture expert. Help users with farming, soil, weather, crops, and give practical, friendly advice."),
        Content.text(input)
      ]);
      setState(() {
        _messages.add({
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'text': response.text ?? "Sorry, I couldn't answer that.",
          'sender': 'bot'
        });
        _isTyping = false;
      });
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add({
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'text': "Error: ${e.toString()}",
          'sender': 'bot'
        });
        _isTyping = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildMessage(Map<String, String> msg) {
    final isUser = msg['sender'] == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFFDFF8C6) : const Color(0xFFE0F7FA),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft: Radius.circular(isUser ? 15 : 5),
            bottomRight: Radius.circular(isUser ? 5 : 15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Text(
          msg['text'] ?? '',
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: Material(
          color: Colors.black.withOpacity(0.5),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: height * 0.7,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    // Close button and header
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          decoration: const BoxDecoration(
                            color: Color(0xFF4CAF50),
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.white,
                                child: Image.asset(
                                  'assets/images/farmer.png',
                                  width: 32,
                                  height: 32,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                "Surender Farmer",
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 10,
                          top: 10,
                          child: IconButton(
                            icon: Image.asset(
                              'assets/images/remove.png',
                              width: 24,
                              height: 24,
                            ),
                            onPressed: widget.onClose ?? () => Navigator.of(context).pop(),
                          ),
                        ),
                      ],
                    ),
                    // Messages
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: _messages.length,
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        itemBuilder: (context, idx) => _buildMessage(_messages[idx]),
                      ),
                    ),
                    if (_isTyping)
                      Padding(
                        padding: const EdgeInsets.only(left: 20, bottom: 6),
                        child: Row(
                          children: const [
                            Text(
                              "Surender is typing...",
                              style: TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                            SizedBox(width: 8),
                            SizedBox(
                              width: 16, height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF76B947)),
                            ),
                          ],
                        ),
                      ),
                    // Input
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 8, 15, 18),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _inputController,
                              decoration: InputDecoration(
                                hintText: "Ask Surender something...",
                                hintStyle: TextStyle(color: Colors.grey[600]),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide(color: Colors.grey[300]!),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide(color: Colors.grey[300]!),
                                ),
                              ),
                              textInputAction: TextInputAction.send,
                              onSubmitted: (_) => _sendMessage(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Material(
                            color: const Color(0xFF4CAF50),
                            shape: const CircleBorder(),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(25),
                              onTap: _sendMessage,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(
                                  'assets/images/send.png',
                                  width: 18,
                                  height: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
