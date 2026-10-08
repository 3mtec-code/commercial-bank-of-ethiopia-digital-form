import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_am.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('am'),
    Locale('en')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'CBE Digital Form'**
  String get appName;

  /// No description provided for @bankName.
  ///
  /// In en, this message translates to:
  /// **'Commercial Bank of Ethiopia'**
  String get bankName;

  /// No description provided for @serviceName.
  ///
  /// In en, this message translates to:
  /// **'Digital Banking Form Service'**
  String get serviceName;

  /// No description provided for @serviceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Easy • Secure • Fast'**
  String get serviceSubtitle;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @amharic.
  ///
  /// In en, this message translates to:
  /// **'አማርኛ'**
  String get amharic;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How can we help you today?'**
  String get welcomeSubtitle;

  /// No description provided for @cashDeposit.
  ///
  /// In en, this message translates to:
  /// **'Cash Deposit'**
  String get cashDeposit;

  /// No description provided for @cashWithdrawal.
  ///
  /// In en, this message translates to:
  /// **'Cash Withdrawal'**
  String get cashWithdrawal;

  /// No description provided for @fillDepositForm.
  ///
  /// In en, this message translates to:
  /// **'Fill digital deposit form'**
  String get fillDepositForm;

  /// No description provided for @fillWithdrawalForm.
  ///
  /// In en, this message translates to:
  /// **'Fill digital withdrawal form'**
  String get fillWithdrawalForm;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @myForms.
  ///
  /// In en, this message translates to:
  /// **'My Forms'**
  String get myForms;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @selectFormType.
  ///
  /// In en, this message translates to:
  /// **'Select Form Type'**
  String get selectFormType;

  /// No description provided for @chooseForm.
  ///
  /// In en, this message translates to:
  /// **'Choose the form you want to fill'**
  String get chooseForm;

  /// No description provided for @fillForm.
  ///
  /// In en, this message translates to:
  /// **'Fill Form'**
  String get fillForm;

  /// No description provided for @stepOf.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String stepOf(Object current, Object total);

  /// No description provided for @branch.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get branch;

  /// No description provided for @selectBranch.
  ///
  /// In en, this message translates to:
  /// **'Select Branch'**
  String get selectBranch;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @accountHolder.
  ///
  /// In en, this message translates to:
  /// **'Account Holder Name'**
  String get accountHolder;

  /// No description provided for @accountNumber.
  ///
  /// In en, this message translates to:
  /// **'Account Number'**
  String get accountNumber;

  /// No description provided for @accountType.
  ///
  /// In en, this message translates to:
  /// **'Account Type'**
  String get accountType;

  /// No description provided for @savingAccount.
  ///
  /// In en, this message translates to:
  /// **'Saving Account'**
  String get savingAccount;

  /// No description provided for @currentAccount.
  ///
  /// In en, this message translates to:
  /// **'Current Account'**
  String get currentAccount;

  /// No description provided for @specialDemand.
  ///
  /// In en, this message translates to:
  /// **'Special Demand Deposit Account'**
  String get specialDemand;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @denominations.
  ///
  /// In en, this message translates to:
  /// **'Denominations'**
  String get denominations;

  /// No description provided for @denomination.
  ///
  /// In en, this message translates to:
  /// **'Denomination (ETB)'**
  String get denomination;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @grandTotal.
  ///
  /// In en, this message translates to:
  /// **'Grand Total'**
  String get grandTotal;

  /// No description provided for @otherDetails.
  ///
  /// In en, this message translates to:
  /// **'Other Details'**
  String get otherDetails;

  /// No description provided for @amountInWords.
  ///
  /// In en, this message translates to:
  /// **'Amount in Words'**
  String get amountInWords;

  /// No description provided for @sourceOfProceeds.
  ///
  /// In en, this message translates to:
  /// **'Source of Proceeds'**
  String get sourceOfProceeds;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Telephone Number'**
  String get phoneNumber;

  /// No description provided for @depositedBy.
  ///
  /// In en, this message translates to:
  /// **'Deposited By'**
  String get depositedBy;

  /// No description provided for @withdrawnBy.
  ///
  /// In en, this message translates to:
  /// **'Withdrawn By'**
  String get withdrawnBy;

  /// No description provided for @signature.
  ///
  /// In en, this message translates to:
  /// **'Account Holder Signature'**
  String get signature;

  /// No description provided for @signHere.
  ///
  /// In en, this message translates to:
  /// **'Sign Here'**
  String get signHere;

  /// No description provided for @clearSignature.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearSignature;

  /// No description provided for @passBookNote.
  ///
  /// In en, this message translates to:
  /// **'Pass book must accompany this form'**
  String get passBookNote;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Review Your Form'**
  String get review;

  /// No description provided for @reviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please verify all details before confirming'**
  String get reviewSubtitle;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Generate QR'**
  String get confirm;

  /// No description provided for @formSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Form Submitted Successfully!'**
  String get formSubmitted;

  /// No description provided for @referenceNumber.
  ///
  /// In en, this message translates to:
  /// **'Reference Number'**
  String get referenceNumber;

  /// No description provided for @scanQrAtBank.
  ///
  /// In en, this message translates to:
  /// **'Scan this QR code at the bank'**
  String get scanQrAtBank;

  /// No description provided for @expiresIn.
  ///
  /// In en, this message translates to:
  /// **'Expires in'**
  String get expiresIn;

  /// No description provided for @downloadPDF.
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get downloadPDF;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @scanQrCode.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scanQrCode;

  /// No description provided for @alignQr.
  ///
  /// In en, this message translates to:
  /// **'Align the QR code within the frame'**
  String get alignQr;

  /// No description provided for @scanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning...'**
  String get scanning;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @formDetails.
  ///
  /// In en, this message translates to:
  /// **'Form Details'**
  String get formDetails;

  /// No description provided for @cashDepositVoucher.
  ///
  /// In en, this message translates to:
  /// **'Cash Deposit Voucher'**
  String get cashDepositVoucher;

  /// No description provided for @cashWithdrawalForm.
  ///
  /// In en, this message translates to:
  /// **'Cash Withdrawal Form'**
  String get cashWithdrawalForm;

  /// No description provided for @proceed.
  ///
  /// In en, this message translates to:
  /// **'Proceed'**
  String get proceed;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @transactionHistory.
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get transactionHistory;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get noHistory;

  /// No description provided for @accountNumberValidation.
  ///
  /// In en, this message translates to:
  /// **'Account number must be 13 digits'**
  String get accountNumberValidation;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredField;

  /// No description provided for @invalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number'**
  String get invalidPhone;

  /// No description provided for @signatureRequired.
  ///
  /// In en, this message translates to:
  /// **'Please provide your signature'**
  String get signatureRequired;

  /// No description provided for @qrExpired.
  ///
  /// In en, this message translates to:
  /// **'QR Code Expired'**
  String get qrExpired;

  /// No description provided for @qrExpiredMessage.
  ///
  /// In en, this message translates to:
  /// **'This QR code has expired. Please generate a new one.'**
  String get qrExpiredMessage;

  /// No description provided for @generateNew.
  ///
  /// In en, this message translates to:
  /// **'Generate New QR'**
  String get generateNew;

  /// No description provided for @secureTransaction.
  ///
  /// In en, this message translates to:
  /// **'Your transaction is safe with us'**
  String get secureTransaction;

  /// No description provided for @binInFigure.
  ///
  /// In en, this message translates to:
  /// **'Bin in Figure'**
  String get binInFigure;

  /// No description provided for @binInWords.
  ///
  /// In en, this message translates to:
  /// **'Bin in Words'**
  String get binInWords;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['am', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'am':
      return AppLocalizationsAm();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
