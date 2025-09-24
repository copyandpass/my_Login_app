// test/main_test.dart

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
  bool _isLoading = true; // isLoading 속성 추가

  MockAuthProvider({bool isLoggedIn = false}) : _isLoggedIn = isLoggedIn;

  @override
  bool get isLoggedIn => _isLoggedIn;

  @override
  bool get isLoading => _isLoading; // isLoading 게터 오버라이드

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
    // 테스트에서는 실제 로직 대신 비동기 완료를 모의
    await Future.delayed(Duration.zero);
    if (_isLoggedIn) {
      _token = 'mock_token';
    }
    _isLoading = false; // 로딩 완료
    notifyListeners();
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
      final mockAuthProvider = MockAuthProvider(isLoggedIn: false);

      await tester.pumpWidget(
        ChangeNotifierProvider<AuthProvider>.value(
          value: mockAuthProvider,
          child: const MyApp(),
        ),
      );
      
      // 비동기 작업(loadToken)이 완료되기를 기다립니다.
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.byType(HomeScreen), findsNothing);
    });

    testWidgets('로그인 상태일 때 HomeScreen이 표시되어야 함', (WidgetTester tester) async {
      final mockAuthProvider = MockAuthProvider(isLoggedIn: true);

      await tester.pumpWidget(
        ChangeNotifierProvider<AuthProvider>.value(
          value: mockAuthProvider,
          child: const MyApp(),
        ),
      );
      
      // 비동기 작업(loadToken)이 완료되기를 기다립니다.
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(LoginScreen), findsNothing);
    });
  });
}