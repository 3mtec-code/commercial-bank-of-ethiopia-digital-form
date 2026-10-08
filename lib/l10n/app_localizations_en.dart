// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'CBE Digital Form';

  @override
  String get bankName => 'Commercial Bank of Ethiopia';

  @override
  String get serviceName => 'Digital Banking Form Service';

  @override
  String get serviceSubtitle => 'Easy • Secure • Fast';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get english => 'English';

  @override
  String get amharic => 'አማርኛ';

  @override
  String get welcome => 'Welcome';

  @override
  String get welcomeSubtitle => 'How can we help you today?';

  @override
  String get cashDeposit => 'Cash Deposit';

  @override
  String get cashWithdrawal => 'Cash Withdrawal';

  @override
  String get fillDepositForm => 'Fill digital deposit form';

  @override
  String get fillWithdrawalForm => 'Fill digital withdrawal form';

  @override
  String get home => 'Home';

  @override
  String get myForms => 'My Forms';

  @override
  String get history => 'History';

  @override
  String get notifications => 'Notifications';

  @override
  String get profile => 'Profile';

  @override
  String get selectFormType => 'Select Form Type';

  @override
  String get chooseForm => 'Choose the form you want to fill';

  @override
  String get fillForm => 'Fill Form';

  @override
  String stepOf(Object current, Object total) {
    return 'Step $current of $total';
  }

  @override
  String get branch => 'Branch';

  @override
  String get selectBranch => 'Select Branch';

  @override
  String get date => 'Date';

  @override
  String get accountHolder => 'Account Holder Name';

  @override
  String get accountNumber => 'Account Number';

  @override
  String get accountType => 'Account Type';

  @override
  String get savingAccount => 'Saving Account';

  @override
  String get currentAccount => 'Current Account';

  @override
  String get specialDemand => 'Special Demand Deposit Account';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get denominations => 'Denominations';

  @override
  String get denomination => 'Denomination (ETB)';

  @override
  String get quantity => 'Quantity';

  @override
  String get amount => 'Amount';

  @override
  String get grandTotal => 'Grand Total';

  @override
  String get otherDetails => 'Other Details';

  @override
  String get amountInWords => 'Amount in Words';

  @override
  String get sourceOfProceeds => 'Source of Proceeds';

  @override
  String get phoneNumber => 'Telephone Number';

  @override
  String get depositedBy => 'Deposited By';

  @override
  String get withdrawnBy => 'Withdrawn By';

  @override
  String get signature => 'Account Holder Signature';

  @override
  String get signHere => 'Sign Here';

  @override
  String get clearSignature => 'Clear';

  @override
  String get passBookNote => 'Pass book must accompany this form';

  @override
  String get review => 'Review Your Form';

  @override
  String get reviewSubtitle => 'Please verify all details before confirming';

  @override
  String get edit => 'Edit';

  @override
  String get confirm => 'Confirm & Generate QR';

  @override
  String get formSubmitted => 'Form Submitted Successfully!';

  @override
  String get referenceNumber => 'Reference Number';

  @override
  String get scanQrAtBank => 'Scan this QR code at the bank';

  @override
  String get expiresIn => 'Expires in';

  @override
  String get downloadPDF => 'Download PDF';

  @override
  String get done => 'Done';

  @override
  String get scanQrCode => 'Scan QR Code';

  @override
  String get alignQr => 'Align the QR code within the frame';

  @override
  String get scanning => 'Scanning...';

  @override
  String get verified => 'Verified';

  @override
  String get formDetails => 'Form Details';

  @override
  String get cashDepositVoucher => 'Cash Deposit Voucher';

  @override
  String get cashWithdrawalForm => 'Cash Withdrawal Form';

  @override
  String get proceed => 'Proceed';

  @override
  String get status => 'Status';

  @override
  String get pending => 'Pending';

  @override
  String get completed => 'Completed';

  @override
  String get expired => 'Expired';

  @override
  String get transactionHistory => 'Transaction History';

  @override
  String get noHistory => 'No transactions yet';

  @override
  String get accountNumberValidation => 'Account number must be 13 digits';

  @override
  String get requiredField => 'This field is required';

  @override
  String get invalidPhone => 'Enter a valid phone number';

  @override
  String get signatureRequired => 'Please provide your signature';

  @override
  String get qrExpired => 'QR Code Expired';

  @override
  String get qrExpiredMessage =>
      'This QR code has expired. Please generate a new one.';

  @override
  String get generateNew => 'Generate New QR';

  @override
  String get secureTransaction => 'Your transaction is safe with us';

  @override
  String get binInFigure => 'Bin in Figure';

  @override
  String get binInWords => 'Bin in Words';
}
