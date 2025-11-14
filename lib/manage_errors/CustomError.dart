class CustomError implements Exception {
  final String message;
  final int? statusCode;
  final bool isLogged;

  CustomError({
    required this.message,
    this.statusCode,
    this.isLogged = false,
  });

  @override
  String toString() => 'CustomError: $message (code: $statusCode)';
}
