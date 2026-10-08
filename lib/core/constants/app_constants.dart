class AppConstants {
  // App Info
  static const String appName = 'CBE Digital Form';
  static const String bankName = 'Commercial Bank of Ethiopia';
  static const String bankNameAm = 'የኢትዮጵያ ንግድ ባንክ';
  static const String serviceName = 'Digital Banking Form Service';
  static const String serviceNameAm = 'ዲጂታል ባንኪንግ ፎርም አገልግሎት';

  // QR
  static const int qrExpiryMinutes = 5;
  static const String encryptionKey = 'CBE2026SecureKey32BytesLongXXXXX'; // 32 bytes for AES-256
  static const String encryptionIV = 'CBE2026IV16ByteX'; // 16 bytes

  // Validation
  static const int accountNumberLength = 13;
  static const int minPhoneLength = 10;

  // Branches
  static const List<String> branches = [
    'Addis Ababa Main Branch',
    'Bole Branch',
    'Merkato Branch',
    'Piazza Branch',
    'Kazanchis Branch',
    'Megenagna Branch',
    'CMC Branch',
    'Sarbet Branch',
    'Gerji Branch',
    'Gofa Branch',
    'Saris Branch',
    'Akaki Branch',
    'Dire Dawa Branch',
    'Hawassa Branch',
    'Mekelle Branch',
    'Bahir Dar Branch',
    'Gondar Branch',
    'Jimma Branch',
    'Adama Branch',
    'Dessie Branch',
  ];

  // Account Types
  static const List<String> accountTypes = [
    'Saving Account',
    'Current Account',
    'Special Demand Deposit Account',
  ];

  // Denominations
  static const List<double> denominations = [
    200, 100, 50, 10, 5, 1, 0.50, 0.25, 0.10, 0.05
  ];

  // Source of Proceeds options
  static const List<String> sourceOfProceeds = [
    'Business',
    'Salary',
    'Investment',
    'Savings',
    'Remittance',
    'Agriculture',
    'Trade',
    'Other',
  ];

  // Form Types
  static const String formTypeDeposit = 'Cash Deposit';
  static const String formTypeWithdrawal = 'Cash Withdrawal';

  // Hive Box Names
  static const String transactionBox = 'transactions';
  static const String settingsBox = 'settings';
}
