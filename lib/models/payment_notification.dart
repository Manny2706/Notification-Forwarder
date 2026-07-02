class PaymentNotification {
  final String packageName;
  final String title;
  final String text;
  final DateTime timestamp;

  const PaymentNotification({
    required this.packageName,
    required this.title,
    required this.text,
    required this.timestamp,
  });

  factory PaymentNotification.fromMap(Map<String, dynamic> map) {
    return PaymentNotification(
      packageName: map["packageName"] ?? "",
      title: map["title"] ?? "",
      text: map["text"] ?? "",
      timestamp: DateTime.fromMillisecondsSinceEpoch(map["postTime"] ?? 0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "packageName": packageName,
      "title": title,
      "text": text,
      "postTime": timestamp.millisecondsSinceEpoch,
    };
  }

  @override
  String toString() {
    return '''
Package : $packageName
Title   : $title
Text    : $text
Time    : $timestamp
''';
  }
}
