import 'package:bytebank/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../matchers/matchers.dart';

void main() {
  testWidgets('Should display the main image when the Dashboard is opended',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Dashboard()));
    final mainImage = find.byType(Image);
    expect(mainImage, findsOneWidget);
  });
  testWidgets(
      'Should display the transfer feature when the Dashboard is opened',
      (tester) async {
    await tester.pumpWidget(MaterialApp(home: Dashboard()));
    final transferFeatureItem = find.byWidgetPredicate((widget) =>
        featureItemMatcher(widget, 'Transfer', Icons.monetization_on));
    expect(transferFeatureItem, findsOneWidget);
  });
  testWidgets('Should display the transaction feed feature when the Dashboard is opened',
      (tester) async {
    await tester.pumpWidget(MaterialApp(home: Dashboard()));
    final transactionFeedFeatureItem = find.byWidgetPredicate((widget) =>
        featureItemMatcher(widget, 'Transaction Feed', Icons.description));
    expect(transactionFeedFeatureItem, findsOneWidget);
  });
}

// void main(){
//   testWidgets('should display the main imagem when the Dashboard is opended', (WidgetTester tester) async{
//     await tester.pumpWidget(MaterialApp(home: Dashboard()));
//     final mainImage = find.byType(Image);
//     expect(mainImage, findsOneWidget);
//   });
//
//   testWidgets('should display the transfer feature when the Dashboard is opened', (tester) async {
//     await tester.pumpWidget(MaterialApp(home: Dashboard()));
//     // final firstFeature = find.byType(FeatureItem);
//     // expect(firstFeature, findsWidgets);
//     final iconTransferFeatureIcon = find.widgetWithIcon(FeatureItem, Icons.monetization_on);
//     expect(iconTransferFeatureIcon, findsOneWidget);
//     final nameTransferFeatureIcon = find.widgetWithText(FeatureItem, 'Transfer');
//     expect(nameTransferFeatureIcon, findsOneWidget);
//   });
//
//   testWidgets('should display the transaction feature when the Dashboard is opened', (tester) async {
//     await tester.pumpWidget(MaterialApp(home: Dashboard()));
//     // final firstFeature = find.byType(FeatureItem);
//     // expect(firstFeature, findsWidgets);
//     final iconTransactionFeedFeatureIcon = find.widgetWithIcon(FeatureItem, Icons.description);
//     expect(iconTransactionFeedFeatureIcon, findsOneWidget);
//     final nameTransactionFeedFeatureIcon = find.widgetWithText(FeatureItem, 'Transaction Feed');
//     expect(nameTransactionFeedFeatureIcon, findsOneWidget);
//   });
// }