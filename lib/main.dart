import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),  // 수정: 홈 페이지로 이동
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter App'),
      ),
      body: Center(
        child: Container(
          width: 409,
          height: 725,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // ImageView (Image)
              Image.asset('assets/paycheck_main_logo.png', height: 208),

              // EditText (TextField)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '연봉을 입력하세요 (만원)',
                    hintStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),

              // Button
              ElevatedButton(
                onPressed: () {
                  // 버튼 클릭 시 동작
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // 버튼 배경색
                  foregroundColor: Colors.white, // 버튼 텍스트 색상
                ),
                child: Text('출근 시간 설정'),
              ),

              // TextView (Text)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  '시급: ',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              
              // TextView (Text)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  '오늘 번 돈: ',
                  style: TextStyle(color: Colors.black),
                ),
              ),

              // TextView (Text)
              Padding(
                padding: const EdgeInsets.only(top: 44),
                child: Container(
                  width: 310,
                  height: 215,
                  alignment: Alignment.center,
                  child: Text(
                    '돈에 관한 명언',
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              // Made by Kiju (Text)
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 6, right: 16),
                  child: Text(
                    'Made by Kiju',
                    style: TextStyle(fontSize: 11, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
