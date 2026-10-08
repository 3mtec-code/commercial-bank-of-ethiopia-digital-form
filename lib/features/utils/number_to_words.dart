class NumberToWords {
  static String convert(double amount, String lang) {
    if (lang == 'am') {
      return _convertAmharic(amount);
    }
    return _convertEnglish(amount);
  }

  // ── English ───────────────────────────────────────────────────────────────
  static String _convertEnglish(double amount) {
    if (amount == 0) return 'Zero Birr Only';

    final intPart = amount.truncate();
    final cents = ((amount - intPart) * 100).round();

    String result = _intToWordsEn(intPart);
    if (cents > 0) {
      result += ' and ${_intToWordsEn(cents)} Cents';
    }
    return '$result Birr Only';
  }

  static String _intToWordsEn(int n) {
    if (n == 0) return 'Zero';
    if (n < 0) return 'Negative ${_intToWordsEn(-n)}';

    const ones = [
      '', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight',
      'Nine', 'Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen',
      'Sixteen', 'Seventeen', 'Eighteen', 'Nineteen'
    ];
    const tens = [
      '', '', 'Twenty', 'Thirty', 'Forty', 'Fifty',
      'Sixty', 'Seventy', 'Eighty', 'Ninety'
    ];

    if (n < 20) return ones[n];
    if (n < 100) {
      return tens[n ~/ 10] + (n % 10 != 0 ? ' ${ones[n % 10]}' : '');
    }
    if (n < 1000) {
      return '${ones[n ~/ 100]} Hundred${n % 100 != 0 ? ' ${_intToWordsEn(n % 100)}' : ''}';
    }
    if (n < 1000000) {
      return '${_intToWordsEn(n ~/ 1000)} Thousand${n % 1000 != 0 ? ' ${_intToWordsEn(n % 1000)}' : ''}';
    }
    if (n < 1000000000) {
      return '${_intToWordsEn(n ~/ 1000000)} Million${n % 1000000 != 0 ? ' ${_intToWordsEn(n % 1000000)}' : ''}';
    }
    return '${_intToWordsEn(n ~/ 1000000000)} Billion${n % 1000000000 != 0 ? ' ${_intToWordsEn(n % 1000000000)}' : ''}';
  }

  // ── Amharic ───────────────────────────────────────────────────────────────
  static String _convertAmharic(double amount) {
    if (amount == 0) return 'ዜሮ ብር ብቻ';

    final intPart = amount.truncate();
    final cents = ((amount - intPart) * 100).round();

    String result = _intToWordsAm(intPart);
    if (cents > 0) {
      result += ' እና ${_intToWordsAm(cents)} ሳንቲም';
    }
    return '$result ብር ብቻ';
  }

  static String _intToWordsAm(int n) {
    if (n == 0) return 'ዜሮ';
    if (n < 0) return 'አሉታዊ ${_intToWordsAm(-n)}';

    const ones = [
      '', 'አንድ', 'ሁለት', 'ሶስት', 'አራት', 'አምስት', 'ስድስት', 'ሰባት', 'ስምንት',
      'ዘጠኝ', 'አስር', 'አስራ አንድ', 'አስራ ሁለት', 'አስራ ሶስት', 'አስራ አራት', 'አስራ አምስት',
      'አስራ ስድስት', 'አስራ ሰባት', 'አስራ ስምንት', 'አስራ ዘጠኝ'
    ];
    const tens = [
      '', '', 'ሃያ', 'ሰላሳ', 'አርባ', 'ሃምሳ',
      'ስልሳ', 'ሰባ', 'ሰማኒያ', 'ዘጠና'
    ];

    if (n < 20) return ones[n];
    if (n < 100) {
      return tens[n ~/ 10] + (n % 10 != 0 ? ' ${ones[n % 10]}' : '');
    }
    if (n < 1000) {
      return '${ones[n ~/ 100]} መቶ${n % 100 != 0 ? ' ${_intToWordsAm(n % 100)}' : ''}';
    }
    if (n < 1000000) {
      return '${_intToWordsAm(n ~/ 1000)} ሺህ${n % 1000 != 0 ? ' ${_intToWordsAm(n % 1000)}' : ''}';
    }
    if (n < 1000000000) {
      return '${_intToWordsAm(n ~/ 1000000)} ሚሊዮን${n % 1000000 != 0 ? ' ${_intToWordsAm(n % 1000000)}' : ''}';
    }
    return '${_intToWordsAm(n ~/ 1000000000)} ቢሊዮን${n % 1000000000 != 0 ? ' ${_intToWordsAm(n % 1000000000)}' : ''}';
  }
}
