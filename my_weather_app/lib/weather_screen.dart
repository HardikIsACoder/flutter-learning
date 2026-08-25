import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:my_weather_app/additional_info_item.dart';
import 'package:my_weather_app/hourly_forecast_item.dart';
import 'package:http/http.dart' as http;
import 'package:my_weather_app/secrets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = "Pune";
      final res = await http.get(Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$apiKey"));

      final data = jsonDecode(res.body);

      if (data['cod'] != "200") {
        throw 'An unxpected error occurs';
      }
      return data;
      // data['list'][0]['main']['temp'] - 273;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    weather = getCurrentWeather();
                  });
                },
                icon: const Icon(Icons.refresh))
          ],
          title: const Text('Weather App'),
          centerTitle: true,
          titleTextStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        body: FutureBuilder(
            future: weather,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              }

              if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              final data = snapshot.data!;
              final currWeatherData = data['list'][0];
              final currentTemp =
                  (currWeatherData['main']['temp'] - 273.15).floor();
              final currentSky = currWeatherData['weather'][0]['main'];
              final currentPressure = currWeatherData['main']['pressure'];
              final currentHumidity = currWeatherData['main']['humidity'];
              final currWindSpeed =
                  ((currWeatherData['wind']['speed'] * 18) / 5).floor();

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // main card
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 15,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Text(
                                    '$currentTemp°C',
                                    style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Icon(
                                    (currentSky == 'Clouds' ||
                                            currentSky == 'Rain')
                                        ? Icons.cloud
                                        : Icons.sunny,
                                    size: 70,
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    currentSky,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //Weather forecast cards
                    const Text(
                      "Hourly Forecast",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 12,
                    ),

                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 7,
                          itemBuilder: (context, i) {
                            final hourlyForecast = data['list'][i + 1];
                            final hourlySky =
                                hourlyForecast['weather'][0]['main'];

                            return HourlyForecastItem(
                                icon: (hourlySky == 'Clouds' ||
                                        hourlySky == 'Rain')
                                    ? Icons.cloud
                                    : Icons.sunny,
                                time:
                                    hourlyForecast['dt_txt'].substring(11, 16),
                                temperature:
                                    '${(hourlyForecast['main']['temp'] - 273.15).floor()}°C');
                          }),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // Additional information
                    const Text(
                      "Additional Information",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AdditionalInfoItem(
                            icon: Icons.water_drop,
                            label: "Humidity",
                            value: "$currentHumidity %"),
                        AdditionalInfoItem(
                            icon: Icons.air,
                            label: "Wind Speed",
                            value: "$currWindSpeed KM/H"),
                        AdditionalInfoItem(
                            icon: Icons.beach_access,
                            label: "Pressure",
                            value: "$currentPressure hPa")
                      ],
                    ),
                  ],
                ),
              );
            }));
  }
}
