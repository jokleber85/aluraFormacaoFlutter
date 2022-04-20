import 'package:flutter/src/widgets/framework.dart';
import 'package:nested_nuvigators/flows/second_flow/screens/display_screen.dart';
import 'package:nested_nuvigators/flows/second_flow/screens/input_screen.dart';
import 'package:nuvigator/next.dart';

class _SecondFlowRouter extends NuRouter {
  @override
  String get initialRoute => 'second-flow/input';

  @override
  List<NuRoute<NuRouter, Object, Object>> get registerRoutes => [
    NuRouteBuilder(
      path: 'second-flow/input', 
      screenType: materialScreenType,
      builder: (_, __, ___) => InputScreen(
        onNext: (text) => nuvigator.open(
          'second-flow/display',
          parameters: {'text': text}
        ),
      ),
    ),

    NuRouteBuilder(
      path: 'second-flow/display', 
      screenType: materialScreenType,
      builder: (_, __, settings) => DisplayScreen(
        text: settings.rawParameters['text'],
        onClose: () => nuvigator.closeFlow(),
      ),
    ),

  ];
}

class SecondFlowRoute extends NuRoute {
  @override
  String get path => 'second-flow';

  @override
  ScreenType get screenType => materialScreenType;
 
  @override
  Widget build(BuildContext context, NuRouteSettings<Object> settings) {
    return Nuvigator(router: _SecondFlowRouter());
  }

}