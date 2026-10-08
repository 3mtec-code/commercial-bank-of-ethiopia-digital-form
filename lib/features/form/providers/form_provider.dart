import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:encrypt/encrypt.dart' as enc;
import '../models/transaction_model.dart';
import '../../../core/constants/app_constants.dart';
import '../../utils/number_to_words.dart';

class FormProvider extends ChangeNotifier {
  // ── Language ──────────────────────────────────────────────────────────────
  Locale _locale = const Locale('en');
  Locale get locale => _locale;
  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

  // ── Form Type ─────────────────────────────────────────────────────────────
  String _formType = AppConstants.formTypeDeposit;
  String get formType => _formType;
  void setFormType(String type) {
    _formType = type;
    notifyListeners();
  }

  // ── Step 1 Fields ─────────────────────────────────────────────────────────
  String _branch = '';
  String _date = '';
  String _accountHolderName = '';
  String _accountNumber = '';
  String _accountType = AppConstants.accountTypes[0];

  String get branch => _branch;
  String get date => _date;
  String get accountHolderName => _accountHolderName;
  String get accountNumber => _accountNumber;
  String get accountType => _accountType;

  void setBranch(String v) { _branch = v; notifyListeners(); }
  void setDate(String v) { _date = v; notifyListeners(); }
  void setAccountHolderName(String v) { _accountHolderName = v; notifyListeners(); }
  void setAccountNumber(String v) { _accountNumber = v; notifyListeners(); }
  void setAccountType(String v) { _accountType = v; notifyListeners(); }

  // ── Step 2: Denominations ─────────────────────────────────────────────────
  Map<double, int> _denominationQty = {
    200: 0, 100: 0, 50: 0, 10: 0, 5: 0,
    1: 0, 0.50: 0, 0.25: 0, 0.10: 0, 0.05: 0,
  };
  Map<double, int> get denominationQty => _denominationQty;

  void updateDenomination(double denom, int qty) {
    _denominationQty[denom] = qty < 0 ? 0 : qty;
    _recalcTotal();
    notifyListeners();
  }

  double _totalAmount = 0.0;
  double get totalAmount => _totalAmount;

  void _recalcTotal() {
    _totalAmount = _denominationQty.entries
        .fold(0.0, (sum, e) => sum + e.key * e.value);
    _amountInWords = NumberToWords.convert(_totalAmount, _locale.languageCode);
    _binInFigure = _totalAmount.toStringAsFixed(2);
  }

  // ── Step 3 Fields ─────────────────────────────────────────────────────────
  String _amountInWords = '';
  String _sourceOfProceeds = '';
  String _phoneNumber = '';
  String _depositedBy = '';
  Uint8List? _signatureBytes;
  String _binInFigure = '';
  String _binInWords = '';

  String get amountInWords => _amountInWords;
  String get sourceOfProceeds => _sourceOfProceeds;
  String get phoneNumber => _phoneNumber;
  String get depositedBy => _depositedBy;
  Uint8List? get signatureBytes => _signatureBytes;
  String get binInFigure => _binInFigure;
  String get binInWords => _binInWords;

  void setAmountInWords(String v) { _amountInWords = v; notifyListeners(); }
  void setSourceOfProceeds(String v) { _sourceOfProceeds = v; notifyListeners(); }
  void setPhoneNumber(String v) { _phoneNumber = v; notifyListeners(); }
  void setDepositedBy(String v) { _depositedBy = v; notifyListeners(); }
  void setSignatureBytes(Uint8List? bytes) { _signatureBytes = bytes; notifyListeners(); }
  void setSignature(Uint8List bytes) => setSignatureBytes(bytes);
  void clearSignature() => setSignatureBytes(null);
  Future<TransactionModel> submitForm() => generateTransaction();
  void setBinInFigure(String v) { _binInFigure = v; notifyListeners(); }
  void setBinInWords(String v) { _binInWords = v; notifyListeners(); }

  // ── Current Transaction ───────────────────────────────────────────────────
  TransactionModel? _currentTransaction;
  TransactionModel? get currentTransaction => _currentTransaction;

  String _generatedQrData = '';
  String get generatedQrData => _generatedQrData;

  /// Build and encrypt transaction for QR
  Future<TransactionModel> generateTransaction() async {
    final now = DateTime.now();
    final refNum = _generateReferenceNumber(now);
    final expires = now.add(
      const Duration(minutes: AppConstants.qrExpiryMinutes),
    );

    // Build denomination map for storage
    final denomMap = <String, int>{};
    _denominationQty.forEach((k, v) {
      if (v > 0) denomMap[k.toString()] = v;
    });

    final tx = TransactionModel(
      id: const Uuid().v4(),
      formType: _formType,
      branch: _branch,
      date: _date,
      accountHolderName: _accountHolderName,
      accountNumber: _accountNumber,
      accountType: _accountType,
      denominations: denomMap,
      totalAmount: _totalAmount,
      amountInWords: _amountInWords,
      sourceOfProceeds: _sourceOfProceeds,
      phoneNumber: _phoneNumber,
      depositedBy: _depositedBy,
      signatureData: _signatureBytes != null
          ? base64Encode(_signatureBytes!)
          : null,
      referenceNumber: refNum,
      status: 'pending',
      createdAt: now,
      expiresAt: expires,
      binInFigure: _binInFigure,
      binInWords: _binInWords,
    );

    // Encrypt payload
    final encrypted = _encryptPayload(jsonEncode(tx.toJson()));
    tx.encryptedPayload = encrypted;
    _generatedQrData = encrypted;
    _currentTransaction = tx;

    // Save to Hive
    await _saveTransaction(tx);

    notifyListeners();
    return tx;
  }

  String _generateReferenceNumber(DateTime now) {
    final datePart =
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    final seq = (now.millisecondsSinceEpoch % 1000000)
        .toString()
        .padLeft(6, '0');
    return 'TXN-$datePart-$seq';
  }

  String _encryptPayload(String plainText) {
    try {
      final key = enc.Key.fromUtf8(AppConstants.encryptionKey);
      final iv = enc.IV.fromUtf8(AppConstants.encryptionIV);
      final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
      final encrypted = encrypter.encrypt(plainText, iv: iv);
      return encrypted.base64;
    } catch (e) {
      return base64Encode(utf8.encode(plainText));
    }
  }

  static Map<String, dynamic>? decryptPayload(String encryptedBase64) {
    try {
      final key = enc.Key.fromUtf8(AppConstants.encryptionKey);
      final iv = enc.IV.fromUtf8(AppConstants.encryptionIV);
      final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
      final decrypted = encrypter.decrypt64(encryptedBase64, iv: iv);
      return jsonDecode(decrypted) as Map<String, dynamic>;
    } catch (e) {
      try {
        final decoded = utf8.decode(base64Decode(encryptedBase64));
        return jsonDecode(decoded) as Map<String, dynamic>;
      } catch (_) {
        return null;
      }
    }
  }

  // ── Local Storage ─────────────────────────────────────────────────────────
  List<TransactionModel> _transactions = [];
  List<TransactionModel> get transactions => _transactions;

  Future<void> loadTransactions() async {
    final box = await Hive.openBox<TransactionModel>(AppConstants.transactionBox);
    _transactions = box.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners();
  }

  Future<void> _saveTransaction(TransactionModel tx) async {
    final box = await Hive.openBox<TransactionModel>(AppConstants.transactionBox);
    await box.put(tx.id, tx);
    await loadTransactions();
  }

  Future<void> updateTransactionStatus(String id, String status) async {
    final box = await Hive.openBox<TransactionModel>(AppConstants.transactionBox);
    final tx = box.get(id);
    if (tx != null) {
      tx.status = status;
      await tx.save();
      await loadTransactions();
    }
  }

  // ── Reset ─────────────────────────────────────────────────────────────────
  void resetForm() {
    _branch = '';
    _date = '';
    _accountHolderName = '';
    _accountNumber = '';
    _accountType = AppConstants.accountTypes[0];
    _denominationQty = {
      200: 0, 100: 0, 50: 0, 10: 0, 5: 0,
      1: 0, 0.50: 0, 0.25: 0, 0.10: 0, 0.05: 0,
    };
    _totalAmount = 0.0;
    _amountInWords = '';
    _sourceOfProceeds = '';
    _phoneNumber = '';
    _depositedBy = '';
    _signatureBytes = null;
    _binInFigure = '';
    _binInWords = '';
    _currentTransaction = null;
    _generatedQrData = '';
    notifyListeners();
  }
}
