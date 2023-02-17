import 'package:canvaskit/models.dart';
import 'package:canvaskit/shiftplan_calendar_view_widget.dart';
import 'package:canvaskit/shiftplan_data.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ShiftplanData shiftplanData;
  final Shiftplan shiftplan = Shiftplan(
    from: DateTime(2023, 3, 1),
    to: DateTime(2023, 4, 1),
  );

  @override
  void initState() {
    super.initState();
    shiftplan.selfRef = "ref";
    shiftplanData = ShiftplanData.withShiftplanRef(shiftplan);
  }

  @override
  void didUpdateWidget(covariant MyHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    shiftplanData = ShiftplanData.withShiftplanRef(shiftplan);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ShiftplanCalendarViewWidget(
        shiftplanData: shiftplanData,
      ),
    );
  }
}
