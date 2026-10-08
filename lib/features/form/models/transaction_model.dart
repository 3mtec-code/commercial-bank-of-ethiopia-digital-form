import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 0)
class TransactionModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String formType; // 'Cash Deposit' or 'Cash Withdrawal'

  @HiveField(2)
  String branch;

  @HiveField(3)
  String date;

  @HiveField(4)
  String accountHolderName;

  @HiveField(5)
  String accountNumber;

  @HiveField(6)
  String accountType;

  @HiveField(7)
  Map<String, int> denominations; // denomination -> quantity

  @HiveField(8)
  double totalAmount;

  @HiveField(9)
  String amountInWords;

  @HiveField(10)
  String sourceOfProceeds;

  @HiveField(11)
  String phoneNumber;

  @HiveField(12)
  String depositedBy;

  @HiveField(13)
  String? signatureData; // base64 encoded

  @HiveField(14)
  String referenceNumber;

  @HiveField(15)
  String status; // 'pending', 'completed', 'expired'

  @HiveField(16)
  DateTime createdAt;

  @HiveField(17)
  DateTime expiresAt;

  @HiveField(18)
  String? encryptedPayload;

  @HiveField(19)
  String? binInFigure;

  @HiveField(20)
  String? binInWords;

  TransactionModel({
    required this.id,
    required this.formType,
    required this.branch,
    required this.date,
    required this.accountHolderName,
    required this.accountNumber,
    required this.accountType,
    required this.denominations,
    required this.totalAmount,
    required this.amountInWords,
    required this.sourceOfProceeds,
    required this.phoneNumber,
    required this.depositedBy,
    this.signatureData,
    required this.referenceNumber,
    required this.status,
    required this.createdAt,
    required this.expiresAt,
    this.encryptedPayload,
    this.binInFigure,
    this.binInWords,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'formType': formType,
      'branch': branch,
      'date': date,
      'accountHolderName': accountHolderName,
      'accountNumber': accountNumber,
      'accountType': accountType,
      'denominations': denominations,
      'totalAmount': totalAmount,
      'amountInWords': amountInWords,
      'sourceOfProceeds': sourceOfProceeds,
      'phoneNumber': phoneNumber,
      'depositedBy': depositedBy,
      'referenceNumber': referenceNumber,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
      'binInFigure': binInFigure,
      'binInWords': binInWords,
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      formType: json['formType'],
      branch: json['branch'],
      date: json['date'],
      accountHolderName: json['accountHolderName'],
      accountNumber: json['accountNumber'],
      accountType: json['accountType'],
      denominations: Map<String, int>.from(json['denominations'] ?? {}),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      amountInWords: json['amountInWords'],
      sourceOfProceeds: json['sourceOfProceeds'],
      phoneNumber: json['phoneNumber'],
      depositedBy: json['depositedBy'],
      referenceNumber: json['referenceNumber'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      expiresAt: DateTime.parse(json['expiresAt']),
      binInFigure: json['binInFigure'],
      binInWords: json['binInWords'],
    );
  }

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
