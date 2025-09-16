import 'package:http/http.dart' as http;

class ApiService {
  // Mock 데이터로 API 통신을 흉내 냅니다.
  // 이 코드는 백엔드가 준비되면 실제 통신 코드로 교체해야 합니다.

  Future<http.Response> registerUser(String email, String password) async {
    if (email.contains('@') && password.length >= 6) {
      await Future.delayed(const Duration(seconds: 2));
      return http.Response('{"message": "회원가입 성공"}', 200);
    } else {
      await Future.delayed(const Duration(seconds: 2));
      return http.Response('{"detail": "잘못된 이메일 또는 비밀번호 형식"}', 400);
    }
  }

  Future<http.Response> loginUser(String email, String password) async {
    if (email == 'test@example.com' && password == '123456') {
      await Future.delayed(const Duration(seconds: 2));
      return http.Response('{"access_token": "mock_token_12345", "token_type": "bearer"}', 200);
    } else {
      await Future.delayed(const Duration(seconds: 2));
      return http.Response('{"detail": "잘못된 이메일 또는 비밀번호"}', 401);
    }
  }
}