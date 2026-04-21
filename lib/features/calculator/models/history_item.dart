import 'dart:convert';

class HistoryItem {
  final String equation;
  final String result;
  final DateTime timestamp;

  HistoryItem({
    required this.equation,
    required this.result,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'equation': equation,
      'result': result,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      equation: json['equation'],
      result: json['result'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  static String encode(List<HistoryItem> items) => json.encode(
        items.map<Map<String, dynamic>>((item) => item.toJson()).toList(),
      );

  static List<HistoryItem> decode(String items) =>
      (json.decode(items) as List<dynamic>)
          .map<HistoryItem>((item) => HistoryItem.fromJson(item))
          .toList();
}
