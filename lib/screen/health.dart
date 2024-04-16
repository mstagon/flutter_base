import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Health extends StatefulWidget {
  const Health({Key? key}) : super(key: key);

  @override
  State<Health> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<Health> {
  List<Map<String, dynamic>> weightData = [];
  List<Map<String, dynamic>> walkData = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromFlask('weight', (List<Map<String, dynamic>> data) {
      setState(() {
        weightData = data;
      });
    });
    fetchDataFromFlask('walk', (List<Map<String, dynamic>> data) {
      setState(() {
        walkData = data;
      });
    });
  }

  Future<void> fetchDataFromFlask(String dataType, Function(List<Map<String, dynamic>> data) updateState) async {
    final response = await http.get(Uri.parse('https://72ab-203-230-197-70.ngrok-free.app/get_health?type=$dataType'));

    if (response.statusCode == 200) {
      final data = List<Map<String, dynamic>>.from(json.decode(response.body));
      updateState(data);
    } else {
      print('Flask 서버에서 $dataType 데이터를 불러오지 못했습니다.');
    }
  }

  DateTime parseDate(String date) {
    return DateTime.parse(date);
  }

  double parseWeight(String weightString) {
    RegExp regExp = RegExp(r"(\d+(\.\d+)?)");
    Match? match = regExp.firstMatch(weightString);

    if (match != null) {
      return double.parse(match.group(0)!);
    } else {
      return 0.0;
    }
  }

  double parseWalk(String walkString) {
    RegExp regExp = RegExp(r"(\d+(\.\d+)?)분");
    Match? match = regExp.firstMatch(walkString);

    if (match != null) {
      return double.parse(match.group(1)!);
    } else {
      return 0.0;
    }
  }

  double getMaxWeight(List<Map<String, dynamic>> data) {
    if (data.isEmpty) return 0.0;

    return data
        .map<double>((entry) => parseWeight(entry['weight']))
        .reduce((max, value) => value > max ? value : max);
  }

  double getMaxWalk(List<Map<String, dynamic>> data) {
    if (data.isEmpty) return 0.0;

    return data
        .map<double>((entry) => parseWalk(entry['walk']))
        .reduce((max, value) => value > max ? value : max);
  }

  LineChartData mainWeightData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.orange,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.green,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 150,
            interval: 1,
            getTitlesWidget: (value, meta) => bottomTitleWidgets(value, meta, weightData),
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: (value, meta) => leftTitleWidgets(value, meta, weightData, true),
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: weightData.length.toDouble() - 1,
      minY: 0,
      maxY: getMaxWeight(weightData),
      lineBarsData: [
        LineChartBarData(
          spots: weightData.asMap().entries.map((entry) {
            final index = entry.key;
            final data = entry.value;
            return FlSpot(index.toDouble(), parseWeight(data['weight']));
          }).toList(),
          isCurved: false,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
          ),
        ),
      ],
    );
  }

  LineChartData mainWalkData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 10,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.orange,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.green,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) => bottomTitleWidgets(value, meta, walkData),
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 30,
            getTitlesWidget: (value, meta) => leftTitleWidgets(value, meta, walkData, false),
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: walkData.length.toDouble() - 1,
      minY: 0,
      maxY: getMaxWalk(walkData),
      lineBarsData: [
        LineChartBarData(
          spots: walkData.asMap().entries.map((entry) {
            final index = entry.key;
            final data = entry.value;
            return FlSpot(index.toDouble(), parseWalk(data['walk']));
          }).toList(),
          isCurved: false,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta, List<Map<String, dynamic>> data) {
    if (value < 0 || value >= data.length) {
      return const SizedBox.shrink();
    }

    final entry = data[value.toInt()];
    final month = DateFormat('MM-dd').format(parseDate(entry['date']));

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(month, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta, List<Map<String, dynamic>> data, bool isWeightChart) {
    if (data.isEmpty) {
      return Container();
    }

    final min = isWeightChart
        ? data.map<double>((entry) => parseWeight(entry['weight'])).reduce((min, value) => value < min ? value : min)
        : data.map<double>((entry) => parseWalk(entry['walk'])).reduce((min, value) => value < min ? value : min);

    final max = isWeightChart ? getMaxWeight(data) : getMaxWalk(data);

    if (value < min || value > max) {
      return Container();
    }

    final unit = isWeightChart ? 'kg' : '분';

    return Text('$value$unit', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15), textAlign: TextAlign.left);
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.5, // 가로 크기 조절
            height: MediaQuery.of(context).size.height / 2,
            child: LineChart(
              mainWeightData(),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.5, // 가로 크기 조절
            height: MediaQuery.of(context).size.height / 2,
            child: LineChart(
              mainWalkData(),
            ),
          ),
        ],
      ),
    );
  }
}
