import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:async';

void main() {
  runApp(SensorApp());
}

class SensorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensor Data Visualization',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SensorChartPage(),
    );
  }
}

class SensorData {
  final DateTime time;
  final double value;

  SensorData(this.time, this.value);
}

class SensorChartPage extends StatefulWidget {
  @override
  _SensorChartPageState createState() => _SensorChartPageState();
}

class _SensorChartPageState extends State<SensorChartPage> {
  List<SensorData> _temperatureData = [];
  List<SensorData> _humidityData = [];
  List<SensorData> _smokeData = [];
  Timer _timer;

  @override
  void initState() {
    super.initState();
    // Start fetching data every 5 seconds
    _timer = Timer.periodic(Duration(seconds: 5), (Timer t) => _updateData());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateData() {
    // Simulate fetching new sensor data
    DateTime now = DateTime.now();
    setState(() {
      _temperatureData.add(SensorData(now, _generateRandomValue(20, 30)));
      _humidityData.add(SensorData(now, _generateRandomValue(40, 60)));
      _smokeData.add(SensorData(now, _generateRandomValue(10, 100)));
    });
  }

  double _generateRandomValue(double min, double max) {
    return min + (max - min) * (new DateTime.now().millisecond / 1000);
  }

  List<charts.Series<SensorData, DateTime>> _getSensorSeries() {
    return [
      charts.Series<SensorData, DateTime>(
        id: 'Temperature',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (SensorData sensor, _) => sensor.time,
        measureFn: (SensorData sensor, _) => sensor.value,
        data: _temperatureData,
      ),
      charts.Series<SensorData, DateTime>(
        id: 'Humidity',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (SensorData sensor, _) => sensor.time,
        measureFn: (SensorData sensor, _) => sensor.value,
        data: _humidityData,
      ),
      charts.Series<SensorData, DateTime>(
        id: 'Smoke',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (SensorData sensor, _) => sensor.time,
        measureFn: (SensorData sensor, _) => sensor.value,
        data: _smokeData,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sensor Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: charts.TimeSeriesChart(
          _getSensorSeries(),
          animate: true,
          dateTimeFactory: const charts.LocalDateTimeFactory(),
        ),
      ),
    );
  }
}
