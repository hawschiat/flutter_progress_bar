import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_progress_bar/flutter_progress_bar.dart';

void main() {
  testWidgets('testing progress indicator widget', (WidgetTester tester) async {
    var value = 30.0;
    AnimatedProgressIndicator widget = new AnimatedProgressIndicator(value: value);
    await tester.pumpWidget(MaterialApp(home: widget));
    value = 75.0;
    await Future.delayed(Duration(seconds: 1));
    expect(widget.value, 75.0);
  });
}
