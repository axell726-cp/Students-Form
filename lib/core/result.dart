class Result<T> {
  final T? data;
  final String? error;
  final bool success;

  Result._({this.data, this.error, required this.success});

  factory Result.success([T? data]) => Result._(data: data, success: true);
  factory Result.failure(String error) =>
      Result._(error: error, success: false);

  bool get isSuccess => success;
}
