import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

// 이 코드가 누락되지 않았는지 확인하세요.
import 'package:my_login_app/providers/auth_provider.dart';
import 'package:my_login_app/main.dart';
import 'package:my_login_app/screens/login_screen.dart';
import 'package:my_login_app/screens/home_screen.dart';

// AuthProvider를 모의(Mock)로 구현하여 테스트에 사용합니다.
class MockAuthProvider extends ChangeNotifier implements AuthProvider {
  bool _isLoggedIn;
  String? _token;

  MockAuthProvider({bool isLoggedIn = false}) : _isLoggedIn = isLoggedIn;

  @override
  bool get isLoggedIn => _isLoggedIn;

  @override
  String? get token => _token;

  // 원본 AuthProvider의 saveToken 메소드 오버라이드
  @override
  Future<void> saveToken(String token) async {
    _token = token;
    _isLoggedIn = true;
    notifyListeners();
  }

  // 원본 AuthProvider의 loadToken 메소드 오버라이드
  @override
  Future<void> loadToken() async {
    // 테스트에서는 실제 로직 대신 상태만 변경
  }

  // 원본 AuthProvider의 logout 메소드 오버라이드
  @override
  Future<void> logout() async {
    _token = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}

void main() {
  group('MyApp 라우팅 테스트', () {
    testWidgets('로그인 상태가 아닐 때 LoginScreen이 표시되어야 함', (WidgetTester tester) async {
      // 로그인 상태가 아님을 나타내는 MockAuthProvider를 생성합니다.
      final mockAuthProvider = MockAuthProvider(isLoggedIn: false);

      // MyApp 위젯을 테스트 환경에 띄웁니다.
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthProvider>.value( // <MockAuthProvider> -> <AuthProvider>로 수정
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
        ChangeNotifierProvider<AuthProvider>.value( // <MockAuthProvider> -> <AuthProvider>로 수정
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