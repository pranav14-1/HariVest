import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final String apiKey =
      '23c58c68d34d415983a85602251106'; // Your WeatherAPI.com key
  final List<String> defaultCities = [
    'Gurgaon',
    'Mumbai',
    'Delhi',
    'Bengaluru',
    'Chennai',
    'Kolkata',
    'Hyderabad',
  ];

  String city = 'Gurgaon';
  String searchCity = '';
  Map<String, dynamic>? currentWeather;
  List<Map<String, dynamic>> forecast = [];
  bool loading = false;
  String? error;

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
    });

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
    final width = MediaQuery.of(context).size.width;
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
                        color: Colors.white.withValues(alpha: 102),
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
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Enter city name',
                                    hintStyle: const TextStyle(
                                      color: Colors.black,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white.withValues(
                                      alpha: 26,
                                    ),
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
                            // const SizedBox(width: 5),
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
                                    color: Colors.white.withValues(alpha: 38),
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
                                  onTap: () => setState(() => city = c),
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 15,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isActive
                                          ? Colors.white.withValues(alpha: 76)
                                          : Colors.white.withValues(alpha: 26),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isActive
                                            ? Colors.white.withValues(
                                                alpha: 128,
                                              )
                                            : Colors.white.withValues(
                                                alpha: 51,
                                              ),
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
                  if (!loading && error == null && currentWeather != null)
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 30),
                          padding: const EdgeInsets.all(25),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 76),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 102),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _detailCard(
                              '💧',
                              "${currentWeather!['current']['humidity']}%",
                              "Humidity",
                            ),
                            _detailCard(
                              '🌬️',
                              "${currentWeather!['current']['wind_kph'].toStringAsFixed(1)} km/h",
                              "Wind Speed",
                              extra: getWindDirectionText(
                                currentWeather!['current']['wind_degree'],
                              ),
                            ),
                            _detailCard(
                              '📊',
                              "${currentWeather!['current']['pressure_mb']} hPa",
                              "Pressure",
                            ),
                          ],
                        ),
                      ],
                    ),
                  // 5-day Forecast
                  if (!loading && error == null && forecast.isNotEmpty)
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
                          height: 170,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: forecast.map((day) {
                              return Container(
                                width: 120,
                                margin: const EdgeInsets.only(right: 15),
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 76),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 76),
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

  Widget _detailCard(
    String emoji,
    String value,
    String label, {
    String? extra,
  }) {
    return Container(
      width: 100,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 76),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withValues(alpha: 76)),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          if (extra != null)
            Text(
              extra,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
