import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pws/models/chat_message.dart';
import 'package:pws/models/forum_post.dart';
import 'dart:io';

// Mock chat messages
final List<ChatMessage> mockChatMessages = [
  ChatMessage(
    id: 'm1',
    sender: 'Farmer John',
    text: 'Hey, everyone! Just joined this group.',
    timestamp: '10:00 AM',
  ),
  ChatMessage(
    id: 'm2',
    sender: 'Me',
    text: 'Welcome John! What are you growing this season?',
    timestamp: '10:05 AM',
  ),
  ChatMessage(
    id: 'm3',
    sender: 'Farmer John',
    text: 'Mostly corn and some soybeans.',
    timestamp: '10:10 AM',
  ),
  ChatMessage(
    id: 'm4',
    sender: 'AgriExpert Sarah',
    text:
        'If you have corn, consider organic fertilizers like compost tea. It really boosts soil health.',
    timestamp: '10:15 AM',
  ),
  ChatMessage(
    id: 'm5',
    sender: 'Me',
    text: 'That sounds interesting! Any specific recipes for compost tea?',
    timestamp: '10:20 AM',
  ),
  ChatMessage(
    id: 'm6',
    sender: 'Farmer John',
    voiceUrl: 'voice_message_1.aac',
    timestamp: '10:25 AM',
  ),
  ChatMessage(
    id: 'm7',
    sender: 'AgriExpert Sarah',
    text:
        'I can share a basic one. Mix well-rotted compost with water, let it steep, and aerate it. I\'ll send a link to a detailed guide.',
    timestamp: '10:30 AM',
  ),
  ChatMessage(
    id: 'm8',
    sender: 'Me',
    text: 'Awesome, thanks!',
    timestamp: '10:35 AM',
  ),
];

class CommunityChatScreen extends StatefulWidget {
  final ForumPost postData;
  final VoidCallback? onBack;

  const CommunityChatScreen({Key? key, required this.postData, this.onBack})
      : super(key: key);

  @override
  State<CommunityChatScreen> createState() => _CommunityChatScreenState();
}

class _CommunityChatScreenState extends State<CommunityChatScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<ChatMessage> _chatMessages = List.from(mockChatMessages);

  late AnimationController _recordingAnimController;
  late Animation<double> _recordingAnim;
  bool _isRecording = false;
  bool _isSendingAudio = false;

  final FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();
  String? _recordedFilePath;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _recordingAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      lowerBound: 1.0,
      upperBound: 1.2,
    );
    _recordingAnim = _recordingAnimController.drive(
      Tween(begin: 1.0, end: 1.2),
    );
    _initRecorder();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  Future<void> _initRecorder() async {
    await _audioRecorder.openRecorder();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _recordingAnimController.dispose();
    _audioRecorder.closeRecorder();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    }
  }

  void _handleSendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      final newMessage = ChatMessage(
        id: 'm${_chatMessages.length + 1}',
        sender: 'Me',
        text: text,
        timestamp: _formatTime(DateTime.now()),
      );
      setState(() {
        _chatMessages.add(newMessage);
        _messageController.clear();
      });
      Future.delayed(const Duration(milliseconds: 150), _scrollToBottom);
    }
  }

  Future<void> _startRecording() async {
    final dir = await getTemporaryDirectory();
    final filePath =
        '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.aac';

    await _audioRecorder.startRecorder(
      toFile: filePath,
      codec: Codec.aacADTS,
      bitRate: 128000,
      sampleRate: 44100,
    );
    setState(() {
      _isRecording = true;
      _recordedFilePath = filePath;
    });
  }

  Future<void> _stopRecordingAndSend() async {
    final path = await _audioRecorder.stopRecorder();
    setState(() {
      _isRecording = false;
      _isSendingAudio = true;
    });

    if (path != null && File(path).existsSync()) {
      final newVoiceMessage = ChatMessage(
        id: 'm${_chatMessages.length + 1}',
        sender: 'Me',
        voiceUrl: path,
        timestamp: _formatTime(DateTime.now()),
      );
      setState(() {
        _chatMessages.add(newVoiceMessage);
        _isSendingAudio = false;
      });
      Future.delayed(const Duration(milliseconds: 150), _scrollToBottom);
    }
  }

  void _handlePlayVoiceMessage(String path) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(DeviceFileSource(path));
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $ampm';
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    final isMe = msg.sender == 'Me';
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue.shade100 : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isMe ? 20 : 5),
            bottomRight: Radius.circular(isMe ? 5 : 20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              offset: const Offset(0, 1),
              blurRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Text(
                msg.sender,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF075E54),
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (msg.text != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  msg.text!,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            if (msg.voiceUrl != null)
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: GestureDetector(
                  onTap: () => _handlePlayVoiceMessage(msg.voiceUrl!),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          '▶️',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Voice Message',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Align(
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  msg.timestamp,
                  style: const TextStyle(fontSize: 10, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            // Gradient background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF2196F3),
                    Color.fromARGB(255, 173, 217, 253),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0, 0.6],
                ),
              ),
            ),
            Column(
              children: [
                // Header
                Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 15),
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ),
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade300,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.4)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(0, 5),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap:
                            widget.onBack ?? () => Navigator.of(context).pop(),
                        child: const Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Text(
                            '←',
                            style: TextStyle(fontSize: 28, color: Colors.white),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              widget.postData.topic,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Color(0x4D000000),
                                    offset: Offset(1, 1),
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "By ${widget.postData.user}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xE6FFFFFF),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Chat area
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: _chatMessages.length,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          itemBuilder: (context, idx) =>
                              _buildMessageBubble(_chatMessages[idx]),
                        ),
                      ),
                      // Message input area
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 10,
                          left: 10,
                          right: 10,
                          top: 10,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxHeight: 100,
                                ),
                                child: TextField(
                                  controller: _messageController,
                                  minLines: 1,
                                  maxLines: 5,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF333333),
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Type your message...",
                                    hintStyle: const TextStyle(
                                      color: Color(0x99000000),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.95),
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 15,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(
                                        color: Colors.black.withOpacity(0.1),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(
                                        color: Colors.black.withOpacity(0.1),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        color: Colors.blue,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            _messageController.text.trim().isNotEmpty
                                ? GestureDetector(
                                    onTap: _handleSendMessage,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 15,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(25),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.2,
                                            ),
                                            offset: const Offset(0, 2),
                                            blurRadius: 3,
                                          ),
                                        ],
                                      ),
                                      child: const Text(
                                        "Send",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                                : ScaleTransition(
                                    scale: _recordingAnim,
                                    child: GestureDetector(
                                      onLongPressStart: (_) async {
                                        await _startRecording();
                                        _recordingAnimController
                                            .repeat(reverse: true);
                                      },
                                      onLongPressEnd: (_) async {
                                        _recordingAnimController.stop();
                                        _recordingAnimController.value = 1.0;
                                        await _stopRecordingAndSend();
                                      },
                                      child: Container(
                                        width: 45,
                                        height: 45,
                                        decoration: BoxDecoration(
                                          color: _isRecording
                                              ? Colors.redAccent
                                              : const Color(0xFFFFEB3B),
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.2,
                                              ),
                                              offset: const Offset(0, 2),
                                              blurRadius: 3,
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            _isRecording ? "⏺️" : "🎤",
                                            style: const TextStyle(
                                              fontSize: 22,
                                              color: Color(0xFF333333),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      if (_isSendingAudio)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
