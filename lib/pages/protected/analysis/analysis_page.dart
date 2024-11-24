import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:trashtrack_user/blocs/analysis/get_analysis/get_analysis_bloc.dart';
import 'package:trashtrack_user/models/analysis/analysis.dart';
import 'package:trashtrack_user/widgets/custom_app_bar.dart';
import 'package:intl/intl.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key});

  @override
  State<StatefulWidget> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  String selectedView = 'daily';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Analysis'),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            // Analysis chart and data
            Expanded(
              child: buildGetAnalysisBB(),
            ),
            const SizedBox(height: 20),
            // View type buttons
            //dasd
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _viewButton('Daily', 'daily'),
                  _viewButton('Weekly', 'weekly'),
                  _viewButton('Monthly', 'monthly'),
                  _viewButton('Yearly', 'yearly'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _viewButton(String label, String viewType) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedView = viewType;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: selectedView == viewType ? Colors.blue : Colors.grey,
        ),
        child: AutoSizeText(
          label,
          style: const TextStyle(color: Colors.white),
          maxLines: 1,
          minFontSize: 8,
        ),
      ),
    );
  }

  BlocBuilder buildGetAnalysisBB() {
    return BlocBuilder<GetAnalysisBloc, GetAnalysisState>(
      builder: (context, state) {
        if (state is GetAnalysisSuccessfulState) {
          final List<Analysis> analysis = state.analysis;

          final aggregatedData = _aggregateData(analysis, selectedView);
          final chartOption = _createChartOption(aggregatedData);

          return Echarts(option: chartOption);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Map<String, List<Map<String, double>>> _aggregateData(
    List<Analysis> analysis,
    String period,
  ) {
    Map<String, List<Map<String, double>>> aggregatedData = {};

    DateTime today = DateTime.now();
    DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

    startOfWeek = DateTime(
      startOfWeek.year,
      startOfWeek.month,
      startOfWeek.day,
    );
    endOfWeek = DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day);

    for (var data in analysis) {
      DateTime date = data.date.toDate().toLocal();
      date = DateTime(date.year, date.month, date.day);

      if (period == 'daily') {
        if (date.isBefore(startOfWeek) || date.isAfter(endOfWeek)) {
          continue;
        }
      }

      String key = '';

      switch (period) {
        case 'daily':
          key = DateFormat('MM-dd').format(date);
          break;
        case 'weekly':
          key = DateFormat('yyyy-\'W\'w').format(date);
          break;
        case 'monthly':
          key = DateFormat('yyyy-MM').format(date);
          break;
        case 'yearly':
          key = DateFormat('yyyy').format(date);
          break;
        default:
          key = DateFormat('yyyy-MM-dd').format(date);
      }

      double kg = double.tryParse(data.kiloGram) ?? 0;
      double cm = double.tryParse(data.cubicMeter) ?? 0;

      if (aggregatedData.containsKey(key)) {
        aggregatedData[key]!.add({'kg': kg, 'cm': cm});
      } else {
        aggregatedData[key] = [
          {'kg': kg, 'cm': cm}
        ];
      }
    }

    return aggregatedData;
  }

  String _createChartOption(
    Map<String, List<Map<String, double>>> data,
  ) {
    List<String> categories = [];
    List<double> kgValues = [];
    List<double> cmValues = [];

    data.forEach((date, values) {
      double totalKg = values.map((e) => e['kg'] ?? 0).reduce((a, b) => a + b);
      double totalCm = values.map((e) => e['cm'] ?? 0).reduce((a, b) => a + b);

      categories.add(date);
      kgValues.add(totalKg);
      cmValues.add(totalCm);
    });

    return '''
    {
      "tooltip": {
        "trigger": "axis"
      },
      "legend": {
        "data": ["Kg", "Cm"]
      },
      "xAxis": {
        "type": "category",
        "data": ${categories.map((e) => '"$e"').toList()}
      },
      "yAxis": {
        "type": "value",
        "axisLabel": {
        "formatter": function (value) {
          return value.toString().replace(/B(?=(d{3})+(?!d))/g, ',');
        }
      }
      },
      "series": [
        {
          "name": "Kg",
          "type": "bar",
          "data": ${kgValues.map((e) => e.toString()).toList()}
        },
        {
          "name": "Cm",
          "type": "bar",
          "data": ${cmValues.map((e) => e.toString()).toList()}
        }
      ]
    }
    ''';
  }
}
