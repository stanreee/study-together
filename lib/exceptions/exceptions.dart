class AppException implements Exception {
  String cause;
  AppException({required this.cause});

  @override
  String toString() {
    return cause;
  }
}

class UserAuthException extends AppException {
  UserAuthException({required String cause}) : super(cause: cause);
}

class UserException extends AppException {
  UserException({required String cause}) : super(cause: cause);
}