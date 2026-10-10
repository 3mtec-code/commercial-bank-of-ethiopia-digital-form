import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cbe_digital_form/main.dart';
import 'package:cbe_digital_form/features/form/providers/form_provider.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => FormProvider(),
        child: const CbeDigitalFormApp(),
      ),
    );
    expect(find.byType(CbeDigitalFormApp), findsOneWidget);
  });
}
