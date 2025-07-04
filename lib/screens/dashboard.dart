import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pws/models/chat_bot.dart';
import 'package:pws/models/generate_treatment_gemini.dart';
import 'package:pws/screens/settings_screen.dart';
import 'package:pws/services/plant_disease_detector.dart';

final List<Map<String, dynamic>> mockMarketPrices = [
  {
    'id': 'rice',
    'name': 'Basmati Rice',
    'pricePerKg': 65,
    'unit': 'Kg',
    'trend': 'up',
    'lastUpdated': '1 hour ago',
    'emoji': '🍚',
    'mandi': 'Karnal',
  },
  {
    'id': 'wheat',
    'name': 'Wheat',
    'pricePerKg': 25,
    'unit': 'Kg',
    'trend': 'stable',
    'lastUpdated': '2 hours ago',
    'emoji': '🌾',
    'mandi': 'Chandigarh',
  },
  {
    'id': 'potato',
    'name': 'Potato',
    'pricePerKg': 20,
    'unit': 'Kg',
    'trend': 'down',
    'lastUpdated': '30 mins ago',
    'emoji': '🥔',
    'mandi': 'Agra',
  },
  {
    'id': 'onion',
    'name': 'Onion',
    'pricePerKg': 30,
    'unit': 'Kg',
    'trend': 'up',
    'lastUpdated': '1 hour ago',
    'emoji': '🧅',
    'mandi': 'Nashik',
  },
  {
    'id': 'tomato',
    'name': 'Tomato',
    'pricePerKg': 28,
    'unit': 'Kg',
    'trend': 'down',
    'lastUpdated': '4 hours ago',
    'emoji': '🍅',
    'mandi': 'Bengaluru',
  },
  {
    'id': 'maize',
    'name': 'Maize',
    'pricePerKg': 22,
    'unit': 'Kg',
    'trend': 'stable',
    'lastUpdated': '5 hours ago',
    'emoji': '🌽',
    'mandi': 'Lucknow',
  },
  {
    'id': 'cotton',
    'name': 'Cotton',
    'pricePerKg': 70,
    'unit': 'Kg',
    'trend': 'up',
    'lastUpdated': '6 hours ago',
    'emoji': '☁️',
    'mandi': 'Ahmedabad',
  },
];

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  final PlantDiseaseDetector detector = PlantDiseaseDetector();
  String? _result;
  File? _selectedImage;
  String? imagePath;
  String moisture = '';
  String temperature = '';
  String ph = '';
  String nitrogen = '';
  String? recommendations;
  bool loadingRecommendations = false;
  String? recommendationError;
  List<Map<String, dynamic>> marketPrices = [];
  bool loadingMarketPrices = false;
  bool showChatBot = false;
  bool showTreatment = false;
  String? treatmentInfo;
  final ScrollController _marketScrollController = ScrollController();
  Timer? _marketScrollTimer;

  late AnimationController fadeController;
  late AnimationController slideController;
  late Animation<double> fadeAnim;
  late Animation<double> slideAnim;
  late Animation<double> scaleAnim;
  bool modelLoaded = false;

  @override
  void initState() {
    super.initState();
    detector.loadModel().then((_) {
      setState(() {
        modelLoaded = true;
      });
    });

    fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    fadeAnim = Tween<double>(begin: 0, end: 1).animate(fadeController);
    slideAnim = Tween<double>(begin: 30, end: 0).animate(slideController);
    scaleAnim = Tween<double>(
      begin: 0.9,
      end: 1,
    ).animate(CurvedAnimation(parent: fadeController, curve: Curves.easeOut));

    fadeController.forward();
    slideController.forward();

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

  Future<void> pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () async {
                  Navigator.of(ctx).pop();
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (image != null) {
                    await _analyzeImage(File(image.path));
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.of(ctx).pop();
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null) {
                    await _analyzeImage(File(image.path));
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _analyzeImage(File imageFile) async {
    setState(() {
      _selectedImage = imageFile;
      _result = 'Analyzing...';
    });
    final prediction = await detector.predict(imageFile);
    setState(() {
      _result = prediction;
    });
  }

  void _startMarketAutoScroll() {
    _marketScrollTimer?.cancel();
    _marketScrollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_marketScrollController.hasClients) {
        final maxScroll = _marketScrollController.position.maxScrollExtent;
        final current = _marketScrollController.offset;
        final screenWidth = MediaQuery.of(context).size.width;
        final horizontalPadding = 20.0; // From SingleChildScrollView
        final listViewPadding = 16.0; // 8 left + 8 right
        final itemMargin = 16.0; // 8 left + 8 right per item
        final availableWidth =
            screenWidth - 2 * horizontalPadding - 2 * listViewPadding;
        final itemWidth = availableWidth * 0.38;
        final cardWidth = itemWidth + itemMargin;
        final next = current + cardWidth;
        if (next >= maxScroll) {
          _marketScrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
        } else {
          _marketScrollController.animateTo(
            next,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
        }
      }
    });
  }

  String getTreatmentForDisease(String? disease) {
    if (disease == null)
      return 'No disease detected. Please analyze a plant first.';
    switch (disease.toLowerCase()) {
      case 'tomato late blight':
        return 'Remove affected leaves, use fungicide, and avoid overhead watering.';
      case 'apple scab':
        return 'Apply appropriate fungicide and remove fallen leaves.';
      // Add more cases as needed
      default:
        return 'No specific treatment found. Consult an expert for advice.';
    }
  }

  String generateSoilRecommendation({
    required String moisture,
    required String temperature,
    required String ph,
    required String nitrogen,
  }) {
    final List<String> recs = [];

    // Moisture
    final double? m = double.tryParse(moisture);
    if (m == null) {
      recs.add("• Please enter a valid soil moisture value.");
    } else if (m < 20) {
      recs.add(
        "• Soil is too dry. Increase irrigation to maintain optimal moisture.",
      );
    } else if (m > 80) {
      recs.add("• Soil is too wet. Improve drainage or reduce watering.");
    } else {
      recs.add("• Soil moisture is optimal.");
    }

    // Temperature
    final double? t = double.tryParse(temperature);
    if (t == null) {
      recs.add("• Please enter a valid soil temperature.");
    } else if (t < 15) {
      recs.add(
        "• Soil temperature is too low. Consider mulching to retain warmth.",
      );
    } else if (t > 35) {
      recs.add(
        "• Soil temperature is too high. Provide shade or irrigate during cooler hours.",
      );
    } else {
      recs.add("• Soil temperature is good for most crops.");
    }

    // pH
    final double? p = double.tryParse(ph);
    if (p == null) {
      recs.add("• Please enter a valid pH value.");
    } else if (p < 6.0) {
      recs.add("• Soil is acidic. Add lime to raise pH.");
    } else if (p > 7.5) {
      recs.add("• Soil is alkaline. Add organic matter or sulfur to lower pH.");
    } else {
      recs.add("• Soil pH is balanced.");
    }

    // Nitrogen
    final double? n = double.tryParse(nitrogen);
    if (n == null) {
      recs.add("• Please enter a valid nitrogen value.");
    } else if (n < 20) {
      recs.add("• Nitrogen is low. Apply nitrogen-rich fertilizer.");
    } else if (n > 40) {
      recs.add("• Nitrogen is high. Avoid further nitrogen fertilization.");
    } else {
      recs.add("• Nitrogen level is good.");
    }

    return recs.join('\n');
  }

  Map<String, dynamic> getParameterStatus(String value, String type) {
    if (value.isEmpty) return {'color': Colors.blue, 'text': 'Enter value'};
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
        return {'color': Colors.blue, 'text': 'Enter value'};
    }
  }

  void _getSoilRecommendations() async {
    setState(() {
      loadingRecommendations = true;
      recommendationError = null;
      recommendations = null;
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      recommendations = generateSoilRecommendation(
        moisture: moisture,
        temperature: temperature,
        ph: ph,
        nitrogen: nitrogen,
      );
      loadingRecommendations = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = 20.0; // From SingleChildScrollView
    final listViewPadding = 16.0; // 8 left + 8 right
    final availableWidth =
        screenWidth - 2 * horizontalPadding - 2 * listViewPadding;
    final itemWidth = availableWidth * 0.38;

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
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 15,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade800,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.4),
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Center(
                              child: Text(
                                'Farm AI Dashboard',
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
                            Positioned(
                              right: 0,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.more_vert,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const SettingsScreen(),
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
                          color: const Color.fromARGB(255, 225, 241, 255),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 5,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    '💰 Market Prices',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            loadingMarketPrices
                                ? const Padding(
                                    padding: EdgeInsets.all(20),
                                    child: CircularProgressIndicator(
                                      color: Color.fromARGB(255, 173, 217, 253),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: SizedBox(
                                      height: 171,
                                      child: ListView.builder(
                                        controller: _marketScrollController,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: marketPrices.length,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
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
                                            width: itemWidth,
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 5,
                                            ),
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      crop['emoji'],
                                                      style: const TextStyle(
                                                        fontSize: 32,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Expanded(
                                                      child: Text(
                                                        crop['name'],
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15,
                                                          color: Colors.black87,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  '₹${crop['pricePerKg']}/${crop['unit']}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17,
                                                    color: Color(0xFF1A3C34),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      trendIcon,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: trendColor,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      crop['trend']
                                                              .toString()
                                                              .substring(0, 1)
                                                              .toUpperCase() +
                                                          crop['trend']
                                                              .toString()
                                                              .substring(1),
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: trendColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  'Mandi: ${crop['mandi']}',
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                                Text(
                                                  'Updated: ${crop['lastUpdated']}',
                                                  style: const TextStyle(
                                                    fontSize: 9,
                                                    color: Colors.black38,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Divider(thickness: 2, height: 40, color: Colors.black38),
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
                            const Text(
                              'Soil Parameters',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A3C34),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Monitor your soil health',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 15),

                            // 2x2 Grid Layout using Column + Row
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildParameterCard(
                                        '💧',
                                        'Soil Moisture',
                                        'Percentage (%)',
                                        moisture,
                                        (v) => setState(() => moisture = v),
                                        getParameterStatus(
                                          moisture,
                                          'moisture',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: _buildParameterCard(
                                        '🌡️',
                                        'Soil Temperature',
                                        'Celsius (°C)',
                                        temperature,
                                        (v) => setState(() => temperature = v),
                                        getParameterStatus(
                                          temperature,
                                          'temperature',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildParameterCard(
                                        '⚗️',
                                        'pH Level',
                                        'Acidity (0–14)',
                                        ph,
                                        (v) => setState(() => ph = v),
                                        getParameterStatus(ph, 'ph'),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: _buildParameterCard(
                                        '🧪',
                                        'Nitrogen Level',
                                        'PPM (mg/kg)',
                                        nitrogen,
                                        (v) => setState(() => nitrogen = v),
                                        getParameterStatus(
                                          nitrogen,
                                          'nitrogen',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
                        backgroundColor: Colors.blue.shade600,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 25,
                        ),
                        elevation: 4,
                      ),
                      onPressed: loadingRecommendations
                          ? null
                          : _getSoilRecommendations,
                      child: loadingRecommendations
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Get Soil Recommendations',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
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
                        style: const TextStyle(
                          color: Color(0xFFD32F2F),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
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
                        border: Border(
                          left: BorderSide(
                            color: const Color(0xFF03A9F4),
                            width: 5,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'AI Soil Recommendations',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF01579B),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            recommendations!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
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
                            color: Colors.blue.shade600,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: InkWell(
                            onTap: modelLoaded
                                ? () => pickImage(context)
                                : null,
                            borderRadius: BorderRadius.circular(16),
                            child: const Column(
                              children: [
                                Icon(
                                  Icons.science,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'AI Analysis',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Advanced crop disease detection',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 7.5, bottom: 20),
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade600,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: InkWell(
                            onTap: () async {
                              setState(() {
                                showTreatment = true;
                                treatmentInfo =
                                    null; // Optionally show a loading state
                              });

                              // Fetch the treatment asynchronously
                              final result = await generateTreatmentWithGemini(
                                _result,
                              );
                              setState(() {
                                treatmentInfo = result;
                              });
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: const Column(
                              children: [
                                Icon(
                                  Icons.healing,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Treatment',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Personalized care recommendations',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (showTreatment && treatmentInfo != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade600,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.healing,
                                color: Colors.white,
                                size: 32,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                _result ?? 'Disease',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            treatmentInfo!,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 50),
                ],
              ),
            ),
            if (showChatBot)
              ChatBot(onClose: () => setState(() => showChatBot = false)),
            if (!showChatBot)
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton(
                  backgroundColor: Colors.blueGrey,
                  onPressed: () => setState(() => showChatBot = true),
                  child: const Icon(Icons.chat, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildParameterCard(
    String emoji,
    String label,
    String unit,
    String value,
    ValueChanged<String> onChanged,
    Map<String, dynamic> status,
  ) {
    final controller = TextEditingController(text: value);
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
    return Container(
      width: 155,
      height: 220,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: status['color'], width: 4)),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Top section: emoji, label, unit
          Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade100,
                radius: 22,
                child: Text(emoji, style: const TextStyle(fontSize: 22)),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.black,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                unit,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
          // Middle section: TextField
          SizedBox(
            width: double.infinity,
            child: TextField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'eg. 50',
                hintStyle: TextStyle(
                  color: status['color'].withValues(alpha: 0.4),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: status['color'].withValues(alpha: 0.3),
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: onChanged,
              controller: controller,
            ),
          ),
          // Bottom section: Status
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: status['color'],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status['text'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
