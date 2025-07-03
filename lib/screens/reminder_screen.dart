import 'package:flutter/material.dart';

// --- MOCK DATA FOR FARMER SCHEMES ---
class Scheme {
  final String id;
  final String name;
  final String description;
  final String launchDate;
  final String status; // 'previous' | 'upcoming' | 'newly-launched'
  final String? link;
  final List<String> benefits;
  final List<String> eligibility;

  Scheme({
    required this.id,
    required this.name,
    required this.description,
    required this.launchDate,
    required this.status,
    this.link,
    required this.benefits,
    required this.eligibility,
  });
}

final List<Scheme> mockSchemes = [
  Scheme(
    id: 'scheme1',
    name: 'Pradhan Mantri Fasal Bima Yojana (PMFBY)',
    description:
        'A scheme to provide insurance coverage and financial support to farmers in the event of failure of any of the notified crops as a result of natural calamities, pests & diseases.',
    launchDate: 'February 2016',
    status: 'previous',
    link: 'https://pmfby.gov.in/',
    benefits: [
      'Financial support to farmers',
      'Risk coverage against crop failure',
      'Promotes adoption of modern agricultural practices',
    ],
    eligibility: [
      'All farmers including sharecroppers and tenant farmers growing the notified crops in the notified areas.',
    ],
  ),
  Scheme(
    id: 'scheme2',
    name: 'Kisan Credit Card (KCC) Scheme',
    description:
        'A scheme to provide adequate and timely credit support to farmers for their cultivation needs, purchase of agricultural inputs, and post-harvest expenses.',
    launchDate: 'August 1998',
    status: 'previous',
    link: 'https://pmkisan.gov.in/KccApplication.aspx',
    benefits: [
      'Flexible and simplified procedure for credit',
      'Disbursement of crop loans',
      'Covers post-harvest expenses and allied activities',
    ],
    eligibility: [
      'Farmers (individual/joint borrowers) who are engaged in agriculture and allied activities.',
    ],
  ),
  Scheme(
    id: 'scheme3',
    name: 'Soil Health Card Scheme',
    description:
        'A program launched to help farmers improve productivity through judicious use of fertilizers by providing soil nutrient status to farmers.',
    launchDate: 'February 2015',
    status: 'previous',
    link: 'https://www.soilhealth.dac.gov.in/',
    benefits: [
      'Analyzes soil health',
      'Provides recommendations on nutrient management',
      'Reduces fertilizer misuse',
    ],
    eligibility: ['All farmers can get a Soil Health Card.'],
  ),
  Scheme(
    id: 'scheme4',
    name: 'National Agriculture Market (e-NAM)',
    description:
        'An online trading platform for agricultural commodities in India. The platform facilitates farmers, traders, and buyers with online trading in commodities.',
    launchDate: 'April 2016',
    status: 'previous',
    link: 'https://www.enam.gov.in/',
    benefits: [
      'Better price discovery for farmers',
      'Transparency in transactions',
      'Access to a wider market',
    ],
    eligibility: ['Farmers who are members of APMCs connected to e-NAM.'],
  ),
  // Upcoming/Newly Launched Schemes
  Scheme(
    id: 'scheme5',
    name: 'PM-KISAN Samman Nidhi (Latest Installment)',
    description:
        'Direct income support to all landholding farmer families in India. Details on the next installment release and new registration drives.',
    launchDate: 'Expected Q3 2024',
    status: 'upcoming',
    link: 'https://pmkisan.gov.in/',
    benefits: [
      'Direct income support for farmers',
      'Financial assistance for agricultural needs',
    ],
    eligibility: [
      'All landholding farmer families, subject to certain exclusion criteria.',
    ],
  ),
  Scheme(
    id: 'scheme6',
    name: 'New Drone Technology Adoption Program',
    description:
        'A proposed scheme to subsidize the purchase and use of agricultural drones for precision farming, spraying, and monitoring.',
    launchDate: 'Expected Early 2025',
    status: 'upcoming',
    benefits: [
      'Promotes precision agriculture',
      'Reduces labor costs',
      'Efficient application of inputs',
    ],
    eligibility: [
      'Farmer producer organizations (FPOs), individual farmers with certain land holdings.',
    ],
  ),
  Scheme(
    id: 'scheme7',
    name: 'Climate-Resilient Agriculture Initiative',
    description:
        'A newly launched initiative focusing on sustainable farming practices, water conservation, and development of climate-resistant crop varieties.',
    launchDate: 'June 2024',
    status: 'newly-launched',
    link: 'https://example.gov.in/climate-resilience',
    benefits: [
      'Sustainable farming',
      'Improved water efficiency',
      'New crop varieties for extreme weather',
    ],
    eligibility: ['Farmers in identified climate-vulnerable regions.'],
  ),
  Scheme(
    id: 'scheme8',
    name: 'Agri-Tech Startup Incubation Grant',
    description:
        'A new grant program to support agricultural technology startups focusing on innovative solutions for small and marginal farmers.',
    launchDate: 'May 2024',
    status: 'newly-launched',
    link: 'https://example.gov.in/agri-tech-grants',
    benefits: [
      'Funding for innovation',
      'Job creation in rural areas',
      'Development of farmer-centric tech',
    ],
    eligibility: ['Registered Agri-Tech startups with a valid business plan.'],
  ),
];
// --- END MOCK DATA FOR FARMER SCHEMES ---

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({Key? key}) : super(key: key);

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  String selectedSchemeCategory = 'upcoming'; // 'upcoming' or 'previous'
  List<Scheme> schemes = [];
  bool schemeLoading = false;
  String? schemeError;

  @override
  void initState() {
    super.initState();
    _fetchSchemes();
  }

  void _fetchSchemes() {
    setState(() {
      schemeLoading = true;
      schemeError = null;
    });
    Future.delayed(const Duration(milliseconds: 700), () {
      List<Scheme> filteredSchemes;
      if (selectedSchemeCategory == 'previous') {
        filteredSchemes = mockSchemes
            .where((s) => s.status == 'previous')
            .toList();
      } else {
        filteredSchemes = mockSchemes
            .where(
              (s) => s.status == 'upcoming' || s.status == 'newly-launched',
            )
            .toList();
      }
      setState(() {
        if (filteredSchemes.isNotEmpty) {
          schemes = filteredSchemes;
          schemeError = null;
        } else {
          schemes = [];
          schemeError =
              'No ${selectedSchemeCategory == 'upcoming' ? 'upcoming or newly launched' : 'previous'} schemes found at this time.';
        }
        schemeLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
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
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 20, bottom: 25),
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
                          'Farmer Schemes',
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
                          'Government Initiatives for Farmers',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xE6FFFFFF),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Category Tabs
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: const Offset(0, 2),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (selectedSchemeCategory != 'upcoming') {
                                setState(() {
                                  selectedSchemeCategory = 'upcoming';
                                });
                                _fetchSchemes();
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: selectedSchemeCategory == 'upcoming'
                                    ? Colors.blue.shade700
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: selectedSchemeCategory == 'upcoming'
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          offset: const Offset(0, 2),
                                          blurRadius: 4,
                                        ),
                                      ]
                                    : [],
                              ),
                              child: Text(
                                'New Schemes',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: selectedSchemeCategory == 'upcoming'
                                      ? Colors.white
                                      : const Color(0xFF1A3C34),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (selectedSchemeCategory != 'previous') {
                                setState(() {
                                  selectedSchemeCategory = 'previous';
                                });
                                _fetchSchemes();
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: selectedSchemeCategory == 'previous'
                                    ? Colors.blue.shade700
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: selectedSchemeCategory == 'previous'
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          offset: const Offset(0, 2),
                                          blurRadius: 4,
                                        ),
                                      ]
                                    : [],
                              ),
                              child: Text(
                                'Previous Schemes',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: selectedSchemeCategory == 'previous'
                                      ? Colors.white
                                      : const Color(0xFF1A3C34),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Schemes Data Display
                  if (schemeLoading)
                    Padding(
                      padding: EdgeInsets.only(top: height * 0.1),
                      child: Column(
                        children: const [
                          CircularProgressIndicator(color: Colors.white),
                          SizedBox(height: 10),
                          Text(
                            'Loading schemes...',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF1A3C34),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (schemeError != null)
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xE6F44336),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(0, 4),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Text(
                        schemeError!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if (!schemeLoading &&
                      schemeError == null &&
                      schemes.isNotEmpty)
                    Column(
                      children: schemes
                          .map((scheme) => _buildSchemeCard(scheme))
                          .toList(),
                    ),
                  if (!schemeLoading && schemeError == null && schemes.isEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: const Offset(0, 4),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'No ${selectedSchemeCategory == 'upcoming' ? 'upcoming or newly launched' : 'previous'} schemes available at the moment.',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Please check back later for updates.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF333333),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSchemeCard(Scheme scheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(15),
        border: Border(left: BorderSide(color: Colors.blue, width: 5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: const Offset(0, 3),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            scheme.name,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            scheme.description,
            style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: Colors.blue),
              const SizedBox(width: 6),
              Text(
                'Launched: ${scheme.launchDate}',
                style: const TextStyle(fontSize: 13, color: Colors.black),
              ),
              if (scheme.status == 'newly-launched')
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'New',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (scheme.status == 'upcoming')
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Upcoming',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          if (scheme.link != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: GestureDetector(
                onTap: () {
                  // You can use url_launcher package to open the link
                },
                child: Text(
                  scheme.link!,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 8),
          if (scheme.benefits.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Benefits:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                ...scheme.benefits.map(
                  (b) => Row(
                    children: [
                      const Text(
                        '• ',
                        style: TextStyle(color: Color(0xFF4CAF50)),
                      ),
                      Expanded(
                        child: Text(b, style: const TextStyle(fontSize: 13)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          const SizedBox(height: 8),
          if (scheme.eligibility.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Eligibility:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                ...scheme.eligibility.map(
                  (e) => Row(
                    children: [
                      const Text(
                        '• ',
                        style: TextStyle(color: Color(0xFF4CAF50)),
                      ),
                      Expanded(
                        child: Text(e, style: const TextStyle(fontSize: 13)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
