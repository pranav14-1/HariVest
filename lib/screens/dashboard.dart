import 'dart:async';
import 'package:flutter/material.dart';

final List<Map<String, dynamic>> mockMarketPrices = [
  {'id': 'rice', 'name': 'Basmati Rice', 'pricePerKg': 65, 'unit': 'Kg', 'trend': 'up', 'lastUpdated': '1 hour ago', 'emoji': '🍚', 'mandi': 'Karnal'},
  {'id': 'wheat', 'name': 'Wheat', 'pricePerKg': 25, 'unit': 'Kg', 'trend': 'stable', 'lastUpdated': '2 hours ago', 'emoji': '🌾', 'mandi': 'Chandigarh'},
  {'id': 'potato', 'name': 'Potato', 'pricePerKg': 20, 'unit': 'Kg', 'trend': 'down', 'lastUpdated': '30 mins ago', 'emoji': '🥔', 'mandi': 'Agra'},
  {'id': 'onion', 'name': 'Onion', 'pricePerKg': 30, 'unit': 'Kg', 'trend': 'up', 'lastUpdated': '1 hour ago', 'emoji': '🧅', 'mandi': 'Nashik'},
  {'id': 'tomato', 'name': 'Tomato', 'pricePerKg': 28, 'unit': 'Kg', 'trend': 'down', 'lastUpdated': '4 hours ago', 'emoji': '🍅', 'mandi': 'Bengaluru'},
  {'id': 'maize', 'name': 'Maize', 'pricePerKg': 22, 'unit': 'Kg', 'trend': 'stable', 'lastUpdated': '5 hours ago', 'emoji': '🌽', 'mandi': 'Lucknow'},
  {'id': 'cotton', 'name': 'Cotton', 'pricePerKg': 70, 'unit': 'Kg', 'trend': 'up', 'lastUpdated': '6 hours ago', 'emoji': '☁️', 'mandi': 'Ahmedabad'},
];

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  String? imagePath;
  bool chatVisible = false;
  String moisture = '';
  String temperature = '';
  String ph = '';
  String nitrogen = '';
  String? recommendations;
  bool loadingRecommendations = false;
  String? recommendationError;
  List<Map<String, dynamic>> marketPrices = [];
  bool loadingMarketPrices = false;

  // For auto-scrolling market prices
  final ScrollController _marketScrollController = ScrollController();
  Timer? _marketScrollTimer;

  // Animation controllers
  late AnimationController fadeController;
  late AnimationController slideController;
  late Animation<double> fadeAnim;
  late Animation<double> slideAnim;
  late Animation<double> scaleAnim;

  @override
  void initState() {
    super.initState();

    fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    slideController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    fadeAnim = Tween<double>(begin: 0, end: 1).animate(fadeController);
    slideAnim = Tween<double>(begin: 30, end: 0).animate(slideController);
    scaleAnim = Tween<double>(begin: 0.9, end: 1).animate(CurvedAnimation(parent: fadeController, curve: Curves.easeOut));

    fadeController.forward();
    slideController.forward();

    // Simulate fetching market prices
    setState(() => loadingMarketPrices = true);
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        marketPrices = mockMarketPrices;
        loadingMarketPrices = false;
      });
      _startMarketAutoScroll();
    });
  }

  @override
  void dispose() {
    fadeController.dispose();
    slideController.dispose();
    _marketScrollController.dispose();
    _marketScrollTimer?.cancel();
    super.dispose();
  }

  void _startMarketAutoScroll() {
    _marketScrollTimer?.cancel();
    _marketScrollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_marketScrollController.hasClients) {
        final maxScroll = _marketScrollController.position.maxScrollExtent;
        final current = _marketScrollController.offset;
        final cardWidth = MediaQuery.of(context).size.width * 0.38 + 16; // width + margin
        final next = current + cardWidth;
        if (next >= maxScroll) {
          _marketScrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
        } else {
          _marketScrollController.animateTo(next, duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
        }
      }
    });
  }

  Map<String, dynamic> getParameterStatus(String value, String type) {
    if (value.isEmpty) return {'color': Colors.blueGrey, 'text': 'Enter value'};
    final numValue = double.tryParse(value) ?? 0;
    switch (type) {
      case 'moisture':
        if (numValue < 20) return {'color': Colors.red, 'text': 'Too Dry'};
        if (numValue > 80) return {'color': Colors.orange, 'text': 'Too Wet'};
        return {'color': Colors.green, 'text': 'Optimal'};
      case 'temperature':
        if (numValue < 15) return {'color': Colors.blue, 'text': 'Too Cold'};
        if (numValue > 35) return {'color': Colors.red, 'text': 'Too Hot'};
        return {'color': Colors.green, 'text': 'Good'};
      case 'ph':
        if (numValue < 6.0) return {'color': Colors.orange, 'text': 'Acidic'};
        if (numValue > 7.5) return {'color': Colors.purple, 'text': 'Alkaline'};
        return {'color': Colors.green, 'text': 'Balanced'};
      case 'nitrogen':
        if (numValue < 20) return {'color': Colors.red, 'text': 'Low'};
        if (numValue > 40) return {'color': Colors.orange, 'text': 'High'};
        return {'color': Colors.green, 'text': 'Good'};
      default:
        return {'color': Colors.blueGrey, 'text': 'Enter value'};
    }
  }

  void _getSoilRecommendations() async {
    setState(() {
      loadingRecommendations = true;
      recommendationError = null;
      recommendations = null;
    });
    // Simulate AI call
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      recommendations = "This is a mock recommendation. Adjust irrigation, maintain pH, and monitor nitrogen for optimal crop growth.";
      loadingRecommendations = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Gradient background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF29ca9f), Color(0xFFFBE2BA)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0, 0.6],
                ),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Header
                  FadeTransition(
                    opacity: fadeAnim,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.1),
                        end: Offset.zero,
                      ).animate(slideController),
                      child: Container(
                        margin: const EdgeInsets.only(top: 20, bottom: 25),
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                        decoration: BoxDecoration(
                          color: const Color(0xCC227263),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Colors.white.withOpacity(0.4)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              offset: const Offset(0, 5),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            '🌾 Farm AI Dashboard ⛅',
                            style: TextStyle(
                              fontSize: 25,
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
                        ),
                      ),
                    ),
                  ),
                  // Market Prices
                  FadeTransition(
                    opacity: fadeAnim,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.1),
                        end: Offset.zero,
                      ).animate(slideController),
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 25),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              offset: const Offset(0, 3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text('💰 Market Prices', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A3C34))),
                                ],
                              ),
                            ),
                            loadingMarketPrices
                                ? const Padding(
                                    padding: EdgeInsets.all(20),
                                    child: CircularProgressIndicator(color: Color(0xFF4CAF50)),
                                  )
                                : SizedBox(
                                    height: 140,
                                    child: ListView.builder(
                                      controller: _marketScrollController,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: marketPrices.length,
                                      itemBuilder: (context, idx) {
                                        final crop = marketPrices[idx];
                                        Color trendColor;
                                        String trendIcon;
                                        switch (crop['trend']) {
                                          case 'up':
                                            trendColor = Colors.green;
                                            trendIcon = '▲';
                                            break;
                                          case 'down':
                                            trendColor = Colors.red;
                                            trendIcon = '▼';
                                            break;
                                          default:
                                            trendColor = Colors.amber;
                                            trendIcon = '▬';
                                        }
                                        return Container(
                                          width: width * 0.38,
                                          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(15),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.1),
                                                offset: const Offset(0, 2),
                                                blurRadius: 4,
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(crop['emoji'], style: const TextStyle(fontSize: 32)),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      crop['name'],
                                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text('₹${crop['pricePerKg']}/${crop['unit']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Color(0xFF1A3C34))),
                                              Row(
                                                children: [
                                                  Text(trendIcon, style: TextStyle(fontSize: 16, color: trendColor)),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    crop['trend'].toString().substring(0, 1).toUpperCase() + crop['trend'].toString().substring(1),
                                                    style: TextStyle(fontSize: 12, color: trendColor),
                                                  ),
                                                ],
                                              ),
                                              const Spacer(),
                                              Text('Mandi: ${crop['mandi']}', style: const TextStyle(fontSize: 11, color: Colors.black54)),
                                              Text('Updated: ${crop['lastUpdated']}', style: const TextStyle(fontSize: 9, color: Colors.black38)),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Soil Parameters
                  FadeTransition(
                    opacity: fadeAnim,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.1),
                        end: Offset.zero,
                      ).animate(slideController),
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 25),
                        child: Column(
                          children: [
                            const Text('🌱 Soil Parameters', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A3C34))),
                            const SizedBox(height: 4),
                            const Text('Monitor your soil health', style: TextStyle(fontSize: 14, color: Color(0xFF323432))),
                            const SizedBox(height: 15),
                            Wrap(
                              spacing: 15,
                              runSpacing: 15,
                              children: [
                                _buildParameterCard('💧', 'Soil Moisture', 'Percentage (%)', moisture, (v) => setState(() => moisture = v), getParameterStatus(moisture, 'moisture')),
                                _buildParameterCard('🌡️', 'Soil Temperature', 'Celsius (°C)', temperature, (v) => setState(() => temperature = v), getParameterStatus(temperature, 'temperature')),
                                _buildParameterCard('⚗️', 'pH Level', 'Acidity (0-14)', ph, (v) => setState(() => ph = v), getParameterStatus(ph, 'ph')),
                                _buildParameterCard('🧪', 'Nitrogen Level', 'PPM (mg/kg)', nitrogen, (v) => setState(() => nitrogen = v), getParameterStatus(nitrogen, 'nitrogen')),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Get Recommendations Button
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF388E3C),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                        elevation: 4,
                      ),
                      onPressed: loadingRecommendations ? null : _getSoilRecommendations,
                      child: loadingRecommendations
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Get Soil Recommendations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                  // Recommendations
                  if (recommendationError != null)
                    Container(
                      padding: const EdgeInsets.all(15),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEBEE),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFF44336)),
                      ),
                      child: Text(
                        recommendationError!,
                        style: const TextStyle(color: Color(0xFFD32F2F), fontSize: 14, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if (recommendations != null)
                    Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2F7),
                        borderRadius: BorderRadius.circular(16),
                        border: Border(left: BorderSide(color: const Color(0xFF03A9F4), width: 5)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('AI Soil Recommendations', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF01579B))),
                          const SizedBox(height: 10),
                          Text(recommendations!, style: const TextStyle(fontSize: 16, color: Colors.black87)),
                        ],
                      ),
                    ),
                  // Bottom Cards
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 7.5, bottom: 20),
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: const Color(0xFF43A047),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                offset: const Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: const Column(
                            children: [
                              Icon(Icons.science, color: Colors.white, size: 40),
                              SizedBox(height: 8),
                              Text('AI Analysis', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                              SizedBox(height: 4),
                              Text('Advanced crop disease detection', style: TextStyle(fontSize: 12, color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 7.5, bottom: 20),
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFB8C00),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                offset: const Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: const Column(
                            children: [
                              Icon(Icons.healing, color: Colors.white, size: 40),
                              SizedBox(height: 8),
                              Text('Treatment', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                              SizedBox(height: 4),
                              Text('Personalized care recommendations', style: TextStyle(fontSize: 12, color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
            // Floating Chatbot Button (placeholder)
            if (!chatVisible)
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton(
                  backgroundColor: const Color(0xFF43A047),
                  onPressed: () => setState(() => chatVisible = true),
                  child: const Icon(Icons.chat, color: Colors.white),
                ),
              ),
            // Chatbot overlay (placeholder)
            if (chatVisible)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () => setState(() => chatVisible = false),
                      child: const Text('Close Chatbot (Placeholder)'),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildParameterCard(String emoji, String label, String unit, String value, ValueChanged<String> onChanged, Map<String, dynamic> status) {
    return Container(
      width: (MediaQuery.of(context).size.width - 55) / 2,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: status['color'], width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade100,
                child: Text(emoji, style: const TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xFF1A3C34))),
                    Text(unit, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                  ],
                ),
              ),
            ],
          ),
          TextField(
            decoration: InputDecoration(
              hintText: 'eg. 50',
              hintStyle: TextStyle(color: status['color'].withOpacity(0.4)),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: status['color'].withOpacity(0.3))),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            ),
            keyboardType: TextInputType.number,
            onChanged: onChanged,
            controller: TextEditingController(text: value),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: status['color'],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(status['text'], style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
