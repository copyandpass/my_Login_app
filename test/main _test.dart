import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:my_login_app/main.dart';
import 'package:my_login_app/providers/auth_provider.dart';
import 'package:my_login_app/screens/login_screen.dart';
import 'package:my_login_app/screens/home_screen.dart';

// AuthProvider를 모의(Mock)로 구현하여 테스트에 사용합니다.
class MockAuthProvider extends ChangeNotifier implements AuthProvider {
  bool _isLoggedIn;

  MockAuthProvider({bool isLoggedIn = false}) : _isLoggedIn = isLoggedIn;

  @override
  bool get isLoggedIn => _isLoggedIn;
  
  // 나머지 메서드들도 Mock으로 구현해야 합니다.
  @override
  void loadToken() {}
  
  @override
  void login() {}
  
  @override
  void logout() {}
  
  @override
  void register() {}
}

class AuthProvider {
}

void main() {
  group('MyApp 라우팅 테스트', () {
    testWidgets('로그인 상태가 아닐 때 LoginScreen이 표시되어야 함', (WidgetTester tester) async {
      // 로그인 상태가 아님을 나타내는 MockAuthProvider를 생성합니다.
      final mockAuthProvider = MockAuthProvider(isLoggedIn: false);

      // MyApp 위젯을 테스트 환경에 띄웁니다.
      await tester.pumpWidget(
        ChangeNotifierProvider<MockAuthProvider>.value(
          value: mockAuthProvider,
          child: const MyApp(),
        ),
      );

      // LoginScreen 위젯이 화면에 존재하는지 확인합니다.
      expect(find.byType(LoginScreen), findsOneWidget);
      // HomeScreen은 존재하지 않는지 확인합니다.
      expect(find.byType(HomeScreen), findsNothing);
    });

    testWidgets('로그인 상태일 때 HomeScreen이 표시되어야 함', (WidgetTester tester) async {
      // 로그인 상태임을 나타내는 MockAuthProvider를 생성합니다.
      final mockAuthProvider = MockAuthProvider(isLoggedIn: true);

      // MyApp 위젯을 테스트 환경에 띄웁니다.
      await tester.pumpWidget(
        ChangeNotifierProvider<MockAuthProvider>.value(
          value: mockAuthProvider,
          child: const MyApp(),
        ),
      );

      // HomeScreen 위젯이 화면에 존재하는지 확인합니다.
      expect(find.byType(HomeScreen), findsOneWidget);
      // LoginScreen은 존재하지 않는지 확인합니다.
      expect(find.byType(LoginScreen), findsNothing);
    });
  });
}