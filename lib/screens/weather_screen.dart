import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final String apiKey = '23c58c68d34d415983a85602251106';
  final List<String> defaultCities = [
    'Gurgaon',
    'Mumbai',
    'Delhi',
    'Bengaluru',
    'Chennai',
    'Kolkata',
    'Hyderabad',
  ];

  // Jedi planets and their custom messages
  final Map<String, String> jediPlanets = {
    'ahch-to': "Ahch-To: The birthplace of the Jedi Order. 'The Force will be with you. Always.'",
    'coruscant': "Coruscant: Home of the Jedi Temple and the Jedi Council for millennia.",
    'tython': "Tython: Where the Jedi began their journey to bring balance to the Force.",
    'jedha': "Jedha: Sacred moon with ancient Jedi temples and a major site for Force pilgrims.",
    'ossus': "Ossus: Ancient Jedi library world, home to the largest collection of Jedi texts.",
    'bandomeer': "Bandomeer: Many Jedi served in the AgriCorps here, using the Force to help crops flourish.",
    'lothal': "Lothal: Known for its farming communities and Jedi history.",
    'ukio': "Ukio: Famous agriworld, associated with the Jedi AgriCorps and galactic food production.",
    'salliche': "Salliche: A core world with strong agricultural ties and Jedi history.",
    'taanab': "Taanab: A peaceful agriworld, sometimes visited by Jedi for diplomatic missions.",
    'sorgan': "Sorgan: A remote farming world, a place of refuge for some Force users.",
  };

  String city = 'Gurgaon';
  String searchCity = '';
  Map<String, dynamic>? currentWeather;
  List<Map<String, dynamic>> forecast = [];
  bool loading = false;
  String? error;
  String? jediMessage;

  @override
  void initState() {
    super.initState();
    fetchWeatherData(city);
  }

  Future<void> fetchWeatherData(String location) async {
    setState(() {
      loading = true;
      error = null;
      currentWeather = null;
      forecast = [];
      jediMessage = null;
    });

    // Check for Jedi planet easter egg
    final normalized = location.trim().toLowerCase();
    if (jediPlanets.containsKey(normalized)) {
      setState(() {
        jediMessage = jediPlanets[normalized];
        loading = false;
      });
      return;
    }

    if (apiKey.isEmpty) {
      setState(() {
        error =
            "WeatherAPI.com API Key is not set or invalid. Please check your key.";
        loading = false;
      });
      return;
    }

    try {
      final url = Uri.parse(
        'https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$location&days=6&aqi=no&alerts=no',
      );
      final response = await http.get(url);
      final data = json.decode(response.body);

      if (data['error'] != null) {
        setState(() {
          error =
              data['error']['message'] ??
              'Could not fetch weather data. Please check city name.';
          loading = false;
        });
        return;
      }

      setState(() {
        currentWeather = data;
        forecast = (data['forecast']['forecastday'] as List)
            .map<Map<String, dynamic>>(
              (day) => {
                'date': day['date'],
                'day': getWeekday(day['date']),
                'maxTemp': day['day']['maxtemp_c'].toStringAsFixed(0),
                'minTemp': day['day']['mintemp_c'].toStringAsFixed(0),
                'weather': day['day']['condition']['text'],
                'icon': day['day']['condition']['icon'],
              },
            )
            .toList();

        // Remove today's forecast from the list
        final today = DateTime.now();
        forecast = forecast
            .where((day) {
              return DateTime.parse(day['date']).day != today.day;
            })
            .take(5)
            .toList();

        city = data['location']['name'];
        loading = false;
      });
    } catch (e) {
      setState(() {
        error =
            'Failed to fetch weather data. Please check city name or network connection.';
        loading = false;
      });
    }
  }

  String getWeekday(String date) {
    final d = DateTime.parse(date);
    return ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][d.weekday % 7];
  }

  String getWindDirectionText(num degree) {
    if (degree >= 337.5 || degree < 22.5) return 'N';
    if (degree >= 22.5 && degree < 67.5) return 'NE';
    if (degree >= 67.5 && degree < 112.5) return 'E';
    if (degree >= 112.5 && degree < 157.5) return 'SE';
    if (degree >= 157.5 && degree < 202.5) return 'S';
    if (degree >= 202.5 && degree < 247.5) return 'SW';
    if (degree >= 247.5 && degree < 292.5) return 'W';
    if (degree >= 292.5 && degree < 337.5) return 'NW';
    return '';
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
                  // Header & Search
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 20, bottom: 20),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade300,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withAlpha(102),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Weather Forecast",
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
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: TextField(
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Enter city name',
                                    hintStyle: const TextStyle(
                                      color: Colors.black,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white.withAlpha(26),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 0,
                                    ),
                                  ),
                                  onChanged: (v) =>
                                      setState(() => searchCity = v),
                                  onSubmitted: (_) => _handleSearch(),
                                  textInputAction: TextInputAction.search,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              child: InkWell(
                                onTap: _handleSearch,
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(38),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    '🔎',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Popular Cities
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Popular Cities',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Color(0x1A000000),
                                offset: Offset(1, 1),
                                blurRadius: 1,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 40,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: defaultCities.map((c) {
                              final isActive = c == city;
                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: InkWell(
                                  onTap: () {
                                    setState(() => city = c);
                                    fetchWeatherData(c);
                                  },
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 15,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isActive
                                          ? Colors.white.withAlpha(76)
                                          : Colors.white.withAlpha(26),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isActive
                                            ? Colors.white.withAlpha(128)
                                            : Colors.white.withAlpha(51),
                                      ),
                                    ),
                                    child: Text(
                                      c,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: isActive
                                            ? FontWeight.bold
                                            : FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Jedi Easter Egg Message
                  if (jediMessage != null)
                    Container(
                      margin: EdgeInsets.only(top: height * 0.15),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade900.withAlpha(220),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.white.withAlpha(120)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            offset: const Offset(0, 3),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "🌌 Jedi Lore Unlocked!",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            jediMessage!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  // Loading
                  if (loading)
                    Padding(
                      padding: EdgeInsets.only(top: height * 0.2),
                      child: Column(
                        children: const [
                          CircularProgressIndicator(color: Colors.white),
                          SizedBox(height: 10),
                          Text(
                            'Fetching weather data...',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  // Error
                  if (error != null)
                    Container(
                      margin: EdgeInsets.only(top: height * 0.2),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xE6F44336),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Text(
                            error!,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () => fetchWeatherData(city),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  // Current Weather
                  if (!loading && error == null && currentWeather != null && jediMessage == null)
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 30),
                          padding: const EdgeInsets.all(25),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(76),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withAlpha(102),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "${currentWeather!['location']['name']}, ${currentWeather!['location']['country']}",
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                "${currentWeather!['current']['temp_c'].round()}°C",
                                style: const TextStyle(
                                  fontSize: 72,
                                  fontWeight: FontWeight.w200,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                currentWeather!['current']['condition']['text'],
                                style: const TextStyle(
                                  fontSize: 22,
                                  color: Colors.black87,
                                ),
                              ),
                              Image.network(
                                'https:${currentWeather!['current']['condition']['icon']}',
                                width: 100,
                                height: 100,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "Min: ${currentWeather!['forecast']['forecastday'][0]['day']['mintemp_c'].round()}°C",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "Max: ${currentWeather!['forecast']['forecastday'][0]['day']['maxtemp_c'].round()}°C",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Details grid
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: _buildFixedCard(
                                  emoji: '💧',
                                  value:
                                      "${currentWeather!['current']['humidity']}%",
                                  label: "Humidity",
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: _buildFixedCard(
                                  emoji: '🌬️',
                                  value:
                                      "${currentWeather!['current']['wind_kph'].toStringAsFixed(1)} km/h",
                                  label: "Wind Speed",
                                  extra: getWindDirectionText(
                                    currentWeather!['current']['wind_degree'],
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: _buildFixedCard(
                                  emoji: '📊',
                                  value:
                                      "${currentWeather!['current']['pressure_mb']} hPa",
                                  label: "Pressure",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  // 5-day Forecast
                  if (!loading && error == null && forecast.isNotEmpty && jediMessage == null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          "5-Day Forecast",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 180,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: forecast.map((day) {
                              return Container(
                                width: 120,
                                margin: const EdgeInsets.only(right: 15),
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(76),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.white.withAlpha(76),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      day['day'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Image.network(
                                      'https:${day['icon']}',
                                      width: 60,
                                      height: 60,
                                    ),
                                    Text(
                                      "${day['maxTemp']}° / ${day['minTemp']}°C",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      day['weather'],
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black87,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
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

  void _handleSearch() {
    if (searchCity.trim().isNotEmpty) {
      fetchWeatherData(searchCity.trim());
      setState(() => searchCity = '');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a city name.")),
      );
    }
  }

  Widget _buildFixedCard({
    required String emoji,
    required String value,
    required String label,
    String? extra,
  }) {
    return Container(
      height: 146,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: TextStyle(fontSize: 28)),
          SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          if (extra != null) ...[
            SizedBox(height: 4),
            Text(
              extra,
              style: TextStyle(fontSize: 11, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
          ],
          SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
