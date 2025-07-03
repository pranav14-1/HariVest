import 'package:flutter/material.dart';
import 'package:pws/models/forum_post.dart';
import 'package:pws/screens/communityChatScreen.dart';

class CommunityForumScreen extends StatelessWidget {
  CommunityForumScreen({Key? key}) : super(key: key);

  final List<ForumPost> mockForumPosts = [
    ForumPost(
      id: '1',
      user: 'Farmer John',
      timestamp: '2 hours ago',
      topic: 'Best organic fertilizers for corn',
      lastMessage: 'I found a great recipe using compost and fish emulsion!',
      messagesCount: 34,
    ),
    ForumPost(
      id: '2',
      user: 'AgriExpert Sarah',
      timestamp: 'Yesterday',
      topic: 'Managing pest outbreaks in paddy fields',
      lastMessage: 'Neem oil sprays are effective if applied consistently.',
      messagesCount: 88,
    ),
    ForumPost(
      id: '3',
      user: 'Grower Geeta',
      timestamp: '3 days ago',
      topic: 'Sharing tips for rainwater harvesting',
      lastMessage: 'My new pond system saved me a lot this season. Anyone else?',
      messagesCount: 56,
      voiceSupport: true,
    ),
    ForumPost(
      id: '4',
      user: 'Local Farmer',
      timestamp: '1 week ago',
      topic: 'Subsidies for new farming equipment',
      lastMessage: 'Does anyone know about the latest government schemes?',
      messagesCount: 112,
    ),
    ForumPost(
      id: '5',
      user: 'Harvester Mike',
      timestamp: '2 weeks ago',
      topic: 'Discussion: Future of smart irrigation systems',
      lastMessage: 'Looking into drip irrigation with sensor automation.',
      messagesCount: 41,
      voiceSupport: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  width: double.infinity,
                  margin: const EdgeInsets.only(
                    top: 20,
                    bottom: 25,
                    left: 20,
                    right: 20,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
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
                  child: Column(
                    children: const [
                      Text(
                        'Community Forum',
                        style: TextStyle(
                          fontSize: 28,
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
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Connect with other farmers',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xE6FFFFFF),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Forum List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: mockForumPosts.length,
                    itemBuilder: (context, idx) {
                      final item = mockForumPosts[idx];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CommunityChatScreen(postData: item),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(15),
                            border: Border(
                              left: BorderSide(color: Colors.blue, width: 5),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                offset: const Offset(0, 3),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item.user,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF1A3C34),
                                      ),
                                    ),
                                    Text(
                                      item.timestamp,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF777777),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  item.topic,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Last: "${item.lastMessage}"',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF555555),
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${item.messagesCount} messages',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF666666),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    if (item.voiceSupport)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFEB3B),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: const Text(
                                          '🎙️ Live Chat',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF333333),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
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
