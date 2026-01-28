import 'package:uuid/uuid.dart';

class BrainText {
  final String id;
  final String text;

  BrainText({String? id, required this.text}) : id = id ?? const Uuid().v4();

  // Convert BrainText to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'text': text};
  }

  // Create BrainText from JSON
  factory BrainText.fromJson(Map<String, dynamic> json) {
    return BrainText(id: json['id'] as String, text: json['text'] as String);
  }

  BrainText copyWith({String? id, String? text}) {
    return BrainText(id: id ?? this.id, text: text ?? this.text);
  }
}
