import 'package:flutter/material.dart';
import 'dart:async';

// --- MOCK DATA FOR DEMONSTRATION ---
const List<String> indianStates = [
  'Andhra Pradesh',
  'Bihar',
  'Gujarat',
  'Haryana',
  'Karnataka',
  'Maharashtra',
  'Madhya Pradesh',
  'Odisha',
  'Punjab',
  'Rajasthan',
  'Tamil Nadu',
  'Telangana',
  'Uttar Pradesh',
  'West Bengal',
];

const Map<String, List<Map<String, String>>> mockCropData = {
  'Andhra Pradesh': [
    {
      'name': 'Paddy',
      'sowing': 'June-July',
      'growing': 'Aug-Oct',
      'harvesting': 'Nov-Dec',
      'icon': '🍚',
    },
    {
      'name': 'Maize',
      'sowing': 'June-July',
      'growing': 'July-Sep',
      'harvesting': 'Oct-Nov',
      'icon': '🌽',
    },
    {
      'name': 'Groundnut',
      'sowing': 'June-July',
      'growing': 'Aug-Oct',
      'harvesting': 'Oct-Nov',
      'icon': '🥜',
    },
    {
      'name': 'Cotton',
      'sowing': 'July-Aug',
      'growing': 'Aug-Oct',
      'harvesting': 'Dec-Feb',
      'icon': '☁️',
    },
  ],
  // ... (add the rest of your mockCropData here, same as in your JS code)
  'Punjab': [
    {
      'name': 'Wheat',
      'sowing': 'Oct-Nov',
      'growing': 'Nov-Feb',
      'harvesting': 'Apr-May',
      'icon': '🌾',
    },
    {
      'name': 'Rice',
      'sowing': 'June-July',
      'growing': 'Aug-Oct',
      'harvesting': 'Oct-Nov',
      'icon': '🍚',
    },
    {
      'name': 'Maize',
      'sowing': 'Feb-Mar',
      'growing': 'Apr-June',
      'harvesting': 'July-Aug',
      'icon': '🌽',
    },
    {
      'name': 'Cotton',
      'sowing': 'May-June',
      'growing': 'July-Sep',
      'harvesting': 'Oct-Dec',
      'icon': '☁️',
    },
  ],
  // ... (add all other states)
};

class CropCalendarScreen extends StatefulWidget {
  const CropCalendarScreen({Key? key}) : super(key: key);

  @override
  State<CropCalendarScreen> createState() => _CropCalendarScreenState();
}

class _CropCalendarScreenState extends State<CropCalendarScreen> {
  String selectedState = 'Punjab';
  List<Map<String, String>> crops = [];
  bool loading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchCrops();
  }

  void _fetchCrops() {
    setState(() {
      loading = true;
      error = null;
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      final data = mockCropData[selectedState];
      setState(() {
        if (data != null) {
          crops = data;
          error = null;
        } else {
          crops = [];
          error =
              'No specific crop data available for $selectedState. Displaying general data if available.';
        }
        loading = false;
      });
    });
  }

  void _onStateChanged(String? state) {
    if (state != null && state != selectedState) {
      setState(() {
        selectedState = state;
      });
      _fetchCrops();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Gradient background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF29CA9F), Color(0xFFFBE2BA)],
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
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 15,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xCC227263),
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
                          '🌾 Crop Calendar',
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
                        SizedBox(height: 8),
                        Text(
                          'Plan your farming activities',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xE6FFFFFF),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // State Dropdown
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, bottom: 12),
                      child: Text(
                        'Select Your State:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A3C34),
                          shadows: [
                            Shadow(
                              color: Colors.white.withOpacity(0.5),
                              offset: const Offset(1, 1),
                              blurRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  CustomDropdown(
                    selectedValue: selectedState,
                    onChanged: _onStateChanged,
                    options: indianStates,
                  ),
                  const SizedBox(height: 25),
                  // Data Display Area
                  if (loading)
                    Padding(
                      padding: EdgeInsets.only(top: height * 0.1),
                      child: Column(
                        children: const [
                          CircularProgressIndicator(color: Color(0xFF4CAF50)),
                          SizedBox(height: 15),
                          Text(
                            'Loading crop data...',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF1A3C34),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (error != null)
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xE6F44336),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(0, 4),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Text(
                        error!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if (!loading && error == null && crops.isNotEmpty)
                    Column(
                      children: crops.map((crop) {
                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 15),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    crop['icon'] ?? '',
                                    style: const TextStyle(fontSize: 32),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Text(
                                      crop['name'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1A3C34),
                                        shadows: [
                                          Shadow(
                                            color: Colors.white,
                                            offset: Offset(1, 1),
                                            blurRadius: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              _buildDetailRow('🌱 Sowing:', crop['sowing']),
                              _buildDetailRow('🌿 Growing:', crop['growing']),
                              _buildDetailRow(
                                '🚜 Harvesting:',
                                crop['harvesting'],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  if (!loading && error == null && crops.isEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      padding: const EdgeInsets.all(25),
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
                      child: const Column(
                        children: [
                          Text(
                            'No crop calendar data available for the selected state yet.',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A3C34),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Select another state or contact support for more information.',
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

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xCC212121), // black87 with 80% opacity
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? '',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A3C34),
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Dropdown Widget
class CustomDropdown extends StatelessWidget {
  final String selectedValue;
  final ValueChanged<String?> onChanged;
  final List<String> options;

  const CustomDropdown({
    Key? key,
    required this.selectedValue,
    required this.onChanged,
    required this.options,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      items: options
          .map(
            (s) => DropdownMenuItem<String>(
              value: s,
              child: Text(
                s,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.25),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.4),
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
      ),
      icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF1A3C34)),
      dropdownColor: Colors.white,
      style: const TextStyle(fontSize: 16, color: Color(0xFF1A3C34)),
    );
  }
}
