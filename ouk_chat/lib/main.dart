import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/room_list_controller.dart';
import 'views/room_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: BindingsBuilder(() {
        Get.lazyPut(() => RoomListController());
      }),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // 애니메이션 컨트롤러 초기화 (duration: 1초, 반복)
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    // Tween 애니메이션으로 바운스 효과 생성
    _animation = Tween<double>(begin: 0, end: 40).animate(
        CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut
        )
    );

    // 3초 후 RoomListScreen으로 자동 이동
    Future.delayed(Duration(seconds: 3), () {
      Get.off(() => RoomListScreen());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 배경색 설정
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _animation.value),
              child: Image.asset(
                'assets/image/chat.png',
                width: 200, // 이미지 크기 조절
                height: 200,
              ),
            );
          },
        ),
      ),
    );
  }
}