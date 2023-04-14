import 'dart:convert';

import 'package:flutter/material.dart';

class MyCustomComponentData {
  Color color;
  Color borderColor;
  double borderWidth;

  String text;
  Alignment textAlignment;
  double textSize;

  bool isHighlightVisible;

  MyCustomComponentData({
    this.color = Colors.white,
    this.borderColor = Colors.black,
    this.borderWidth = 0.0,
    this.text = '',
    this.textAlignment = Alignment.center,
    this.textSize = 20,
    this.isHighlightVisible = false,
  });

  MyCustomComponentData.copy(MyCustomComponentData customData)
      : this(
          color: customData.color,
          borderColor: customData.borderColor,
          borderWidth: customData.borderWidth,
          text: customData.text,
          textAlignment: customData.textAlignment,
          textSize: customData.textSize,
        );

  switchHighlight() {
    isHighlightVisible = !isHighlightVisible;
  }

  showHighlight() {
    isHighlightVisible = true;
  }

  hideHighlight() {
    isHighlightVisible = false;
  }

  Map<String, dynamic> toJson() {
    return {
      'color': color.value,
      'borderColor': borderColor.value,
      'borderWidth': borderWidth,
      'text': text,
      'textAlignment': [textAlignment.x, textAlignment.y],
      'textSize': textSize,
      'isHighlightVisible': isHighlightVisible,
    };
  }

  factory MyCustomComponentData.fromJson(Map<String, dynamic> map) {
    return MyCustomComponentData(
      color: Color(map['color']),
      borderColor: Color(map['borderColor']),
      borderWidth: map['borderWidth']?.toDouble() ?? 0.0,
      text: map['text'] ?? '',
      textAlignment: Alignment(map['textAlignment'][0], map['textAlignment'][1]),
      textSize: map['textSize']?.toDouble() ?? 0.0,
      isHighlightVisible: map['isHighlightVisible'] ?? false,
    );
  }

}
