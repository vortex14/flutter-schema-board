import 'dart:convert';

class MyLinkData {
  String startLabel;
  String endLabel;

  MyLinkData({
    this.startLabel = '',
    this.endLabel = '',
  });

  MyLinkData.copy(MyLinkData customData)
      : this(
          startLabel: customData.startLabel,
          endLabel: customData.endLabel,
        );

  Map<String, dynamic> toJson() {
    return {
      'startLabel': startLabel,
      'endLabel': endLabel,
    };
  }

  factory MyLinkData.fromJson(Map<String, dynamic> map) {
    return MyLinkData(
      startLabel: map['startLabel'] ?? '',
      endLabel: map['endLabel'] ?? '',
    );
  }
}
