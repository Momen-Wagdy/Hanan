import 'package:flutter/material.dart';  // Import Flutter material design library
import 'package:charts_flutter/flutter.dart' as charts;  // Import the charts_flutter package for charting
import 'dart:async';  // Import dart:async for Timer functionality

void main() {
  runApp(SensorApp());  // Run the SensorApp widget
}

class SensorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Build the MaterialApp
    return MaterialApp(
      title: 'Sensor Data Visualization',  // Title of the app
      theme: ThemeData(
        primarySwatch: Colors.blue,  // Set the primary color theme
      ),
      home: SensorChartPage(),  // Set the home page to SensorChartPage
    );
  }
}

// Class to represent individual sensor data points
class SensorData {
  final DateTime time;  // Time of the sensor reading
  final double value;  // Value of the sensor reading

  SensorData(this.time, this.value);  // Constructor to initialize the properties
}

class SensorChartPage extends StatefulWidget {
  @override
  _SensorChartPageState createState() => _SensorChartPageState();  // Create state for the widget
}

class _SensorChartPageState extends State<SensorChartPage> {
  // Lists to hold sensor data points
  List<SensorData> _temperatureData = [];
  List<SensorData> _humidityData = [];
  List<SensorData> _smokeData = [];
  Timer _timer;  // Timer for periodic data fetching

  @override
  void initState() {
    super.initState();
    // Start fetching data every 5 seconds
    _timer = Timer.periodic(Duration(seconds: 5), (Timer t) => _updateData());
  }

  @override
  void dispose() {
    _timer?.cancel();  // Cancel the timer when disposing the widget
    super.dispose();
  }

  void _updateData() {
    // Simulate fetching new sensor data
    DateTime now = DateTime.now();  // Get the current time
    setState(() {
      // Add new sensor data points to the lists
      _temperatureData.add(SensorData(now, _generateRandomValue(20, 30)));  // Simulated temperature
      _humidityData.add(SensorData(now, _generateRandomValue(40, 60)));  // Simulated humidity
      _smokeData.add(SensorData(now, _generateRandomValue(10, 100)));  // Simulated smoke level
    });
  }

  double _generateRandomValue(double min, double max) {
    // Generate a random value between min and max
    return min + (max - min) * (new DateTime.now().millisecond / 1000);
  }

  // Prepare data series for the charts
  List<charts.Series<SensorData, DateTime>> _getSensorSeries() {
    return [
      charts.Series<SensorData, DateTime>(
        id: 'Temperature',  // Identifier for the series
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,  // Color for the series
        domainFn: (SensorData sensor, _) => sensor.time,  // X-axis (time)
        measureFn: (SensorData sensor, _) => sensor.value,  // Y-axis (sensor value)
        data: _temperatureData,  // Data for this series
      ),
      charts.Series<SensorData, DateTime>(
        id: 'Humidity',  // Identifier for the series
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,  // Color for the series
        domainFn: (SensorData sensor, _) => sensor.time,  // X-axis (time)
        measureFn: (SensorData sensor, _) => sensor.value,  // Y-axis (sensor value)
        data: _humidityData,  // Data for this series
      ),
      charts.Series<SensorData, DateTime>(
        id: 'Smoke',  // Identifier for the series
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,  // Color for the series
        domainFn: (SensorData sensor, _) => sensor.time,  // X-axis (time)
        measureFn: (SensorData sensor, _) => sensor.value,  // Y-axis (sensor value)
        data: _smokeData,  // Data for this series
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sensor Data'),  // Title of the app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),  // Padding around the chart
        child: charts.TimeSeriesChart(
          _getSensorSeries(),  // Get the series for the chart
          animate: true,  // Enable animations for the chart
          dateTimeFactory: const charts.LocalDateTimeFactory(),  // Use local date time for x-axis
        ),
      ),
    );
  }
}
