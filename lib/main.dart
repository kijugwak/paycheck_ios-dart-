import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 날짜 및 시간 포맷팅
import 'dart:async'; // 타이머
import 'package:flutter/services.dart'; // FilteringTextInputFormatter
import 'dart:math'; // 랜덤 함수 사용

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _annualSalaryController = TextEditingController();
  final TextEditingController _hoursPerDayController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  double _annualSalary = 3000.0; // 기본 연봉 (만원 단위)
  double _hoursPerDay = 9.0; // 기본 하루 근무 시간
  TimeOfDay _startTime = TimeOfDay(hour: 9, minute: 0); // 기본 근무 시작 시간
  double _hourlyWage = 0.0; // 시급
  double _dailyWageToday = 0.0; // 오늘 일급
  String _formattedHourlyWage = '';
  String _formattedDailyWageToday = '';
  String _currentQuote = '';
  Timer? _timer;
  Timer? _quoteTimer;

  final List<String> _quotes = [
    "돈을 잃어도 명예를 잃지 마라. 돈은 돌아올 수 있지만 명예는 한 번 손실되면 돌아오지 않는다. - 피그말리온",
    "돈은 맛있는 음식, 따뜻한 옷, 집 같은 것을 주지만 당신에게는 좋은 친구, 훌륭한 연인, 멋진 취미, 행복한 가족 같은 것을 사지 못한다. - 인디라 간디",
    "돈으로 살 수 있는 행복이 있다. 그것은 돈이 없을 때의 불행보다 낫다. - 마셜 맥루한",
    "돈을 사랑하지 말고 꿈을 쫓으라. 그러면 돈도 따라붙게 된다. - 톰스 피터스",
    "돈이 허락하는 선에서 가장 행복한 사람은 돈이 아닌 것이다. - 알버트 클로스",
    // 추가 명언...
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _startUpdatingDailyWage(); // Start updating the daily wage
    _startQuoteTimer(); // Start the quote timer
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    _quoteTimer?.cancel(); // Cancel the quote timer when the widget is disposed
    super.dispose();
  }

  void _initializeControllers() {
    _annualSalaryController.text = (_annualSalary).toString(); // 만원 단위로 표시
    _hoursPerDayController.text = _hoursPerDay.toString();
    _startTimeController.text = _formatTimeOfDay(_startTime);

    _calculateWage(); // Initialize the hourly wage
    _updateDailyWage(); // Initialize the daily wage
  }

  void _calculateWage() {
    setState(() {
      if (_hoursPerDay > 0) {
        double totalAnnualHours = _hoursPerDay * 365;
        _hourlyWage = (_annualSalary * 10000) / totalAnnualHours;
        _formattedHourlyWage = '${NumberFormat("#,##0 원").format(_hourlyWage)}';
      } else {
        _formattedHourlyWage = '하루 근무 시간을 입력해 주세요';
      }
    });
  }

  void _updateDailyWage() {
    final now = DateTime.now();
    final startTime = DateTime(now.year, now.month, now.day, _startTime.hour, _startTime.minute);

    if (now.isAfter(startTime)) {
      final workedSeconds = now.difference(startTime).inSeconds;
      final workedHours = workedSeconds / 3600.0;

      final dailyWage = (_hourlyWage * workedHours);
      setState(() {
        _dailyWageToday = dailyWage;
        _formattedDailyWageToday = '${NumberFormat("#,##0 원").format(_dailyWageToday)}';
      });
    } else {
      setState(() {
        _formattedDailyWageToday = '근무 시작 시간을 확인하세요';
      });
    }
  }

  void _startUpdatingDailyWage() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      _updateDailyWage();
    });
  }

  void _startQuoteTimer() {
    _quoteTimer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      final random = Random();
      setState(() {
        _currentQuote = _quotes[random.nextInt(_quotes.length)];
      });
    });
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('HH:mm').format(dateTime);
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (picked != null && picked != _startTime) {
      setState(() {
        _startTime = picked;
        _startTimeController.text = _formatTimeOfDay(picked);
        _updateDailyWage(); // Update the wage calculation
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''), // 타이틀 제거
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 로고 이미지 추가
          Center(
            child: Image.asset(
              'assets/paycheck_main_logo.png',
              height: 100, // 원하는 높이 설정
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _annualSalaryController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '연봉 (만원 단위)',
                border: OutlineInputBorder(),
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {
                _annualSalary = double.tryParse(value) ?? 0.0;
                _calculateWage();
              },
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _hoursPerDayController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '하루 근무 시간',
                border: OutlineInputBorder(),
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {
                _hoursPerDay = double.tryParse(value) ?? 0.0;
                _calculateWage();
              },
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _startTimeController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: '근무 시작 시간',
                border: OutlineInputBorder(),
              ),
              onTap: () => _selectStartTime(context),
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '시급:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              _formattedHourlyWage,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '오늘의 일급:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              _formattedDailyWageToday,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 16),
          // 명언 표시
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: Text(
                  _currentQuote,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
