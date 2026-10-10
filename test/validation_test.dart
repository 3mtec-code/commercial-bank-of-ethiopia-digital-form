import 'package:flutter_test/flutter_test.dart';
import 'package:cbe_digital_form/features/utils/number_to_words.dart';

void main() {
  group('CBE Form Validations', () {
    test('CBE Account Number validation (strictly 13 digits)', () {
      final accRegex = RegExp(r'^\d{13}$');

      // Valid cases
      expect(accRegex.hasMatch('1000123456789'), isTrue);
      expect(accRegex.hasMatch('1000000000000'), isTrue);

      // Invalid cases (too short, too long, letters, symbols)
      expect(accRegex.hasMatch('100012345678'), isFalse); // 12 digits
      expect(accRegex.hasMatch('10001234567890'), isFalse); // 14 digits
      expect(accRegex.hasMatch('100012345678A'), isFalse);
      expect(accRegex.hasMatch(''), isFalse);
      expect(accRegex.hasMatch('1000-1234-5678'), isFalse);
    });

    test('Full Name input validation (Amharic and English letters & spaces only)', () {
      final nameRegex = RegExp(r'^[a-zA-Z\s\u1200-\u137F]+$');

      // Valid English
      expect(nameRegex.hasMatch('Abebe Kebede'), isTrue);
      expect(nameRegex.hasMatch('John Doe Smith'), isTrue);

      // Valid Amharic (Ethiopic block)
      expect(nameRegex.hasMatch('አበበ ከበደ'), isTrue);
      expect(nameRegex.hasMatch('ታደሰ ወልደማሪያም'), isTrue);
      expect(nameRegex.hasMatch('ሀሁሂሃሄህሆ'), isTrue);

      // Invalid cases (numbers, special characters)
      expect(nameRegex.hasMatch('Abebe123'), isFalse);
      expect(nameRegex.hasMatch('Abebe @ Kebede'), isFalse);
      expect(nameRegex.hasMatch('አበበ 12'), isFalse);
      expect(nameRegex.hasMatch('Abebe_Kebede'), isFalse);
      expect(nameRegex.hasMatch('Kebede!'), isFalse);
    });

    test('Ethiopian Telephone Number validation', () {
      final ethPhoneRegex = RegExp(r'^(?:\+251[79]\d{8}|251[79]\d{8}|0[79]\d{8})$');

      // Valid 09... and 07... (10 digits)
      expect(ethPhoneRegex.hasMatch('0912345678'), isTrue);
      expect(ethPhoneRegex.hasMatch('0712345678'), isTrue);

      // Valid international +251...
      expect(ethPhoneRegex.hasMatch('+251912345678'), isTrue);
      expect(ethPhoneRegex.hasMatch('+251712345678'), isTrue);

      // Valid 251...
      expect(ethPhoneRegex.hasMatch('251912345678'), isTrue);
      expect(ethPhoneRegex.hasMatch('251712345678'), isTrue);

      // Invalid numbers
      expect(ethPhoneRegex.hasMatch('0812345678'), isFalse); // starting with 08
      expect(ethPhoneRegex.hasMatch('091234567'), isFalse); // 9 digits
      expect(ethPhoneRegex.hasMatch('09123456789'), isFalse); // 11 digits
      expect(ethPhoneRegex.hasMatch('+254712345678'), isFalse); // Kenya code
      expect(ethPhoneRegex.hasMatch('09abcdefgh'), isFalse);
    });

    test('Number to Words in English and Amharic', () {
      expect(NumberToWords.convert(5000, 'en'), 'Five Thousand Birr Only');
      expect(NumberToWords.convert(5000, 'am'), 'አምስት ሺህ ብር ብቻ');
      expect(NumberToWords.convert(100, 'en'), 'One Hundred Birr Only');
      expect(NumberToWords.convert(100, 'am'), 'አንድ መቶ ብር ብቻ');
    });
  });
}
