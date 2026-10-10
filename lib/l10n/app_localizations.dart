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

  /// No description provided for @secureBank.
  ///
  /// In en, this message translates to:
  /// **'Secure Bank'**
  String get secureBank;

  /// No description provided for @yourTransactionSafe.
  ///
  /// In en, this message translates to:
  /// **'Your transaction is safe with us'**
  String get yourTransactionSafe;

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

  /// No description provided for @whyDigitalForm.
  ///
  /// In en, this message translates to:
  /// **'Why Digital Form?'**
  String get whyDigitalForm;

  /// No description provided for @noMorePaper.
  ///
  /// In en, this message translates to:
  /// **'No more paper'**
  String get noMorePaper;

  /// No description provided for @noMorePaperDesc.
  ///
  /// In en, this message translates to:
  /// **'Save trees and go 100% digital'**
  String get noMorePaperDesc;

  /// No description provided for @fastAndAccurate.
  ///
  /// In en, this message translates to:
  /// **'Fast & accurate'**
  String get fastAndAccurate;

  /// No description provided for @fastAndAccurateDesc.
  ///
  /// In en, this message translates to:
  /// **'Automatic calculation and instant teller scan'**
  String get fastAndAccurateDesc;

  /// No description provided for @secureAndReliable.
  ///
  /// In en, this message translates to:
  /// **'Secure & reliable'**
  String get secureAndReliable;

  /// No description provided for @secureAndReliableDesc.
  ///
  /// In en, this message translates to:
  /// **'End-to-end encrypted single-use QR'**
  String get secureAndReliableDesc;

  /// No description provided for @easyToUse.
  ///
  /// In en, this message translates to:
  /// **'Easy to use'**
  String get easyToUse;

  /// No description provided for @easyToUseDesc.
  ///
  /// In en, this message translates to:
  /// **'Simple 3-step digital form assistance'**
  String get easyToUseDesc;

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

  /// No description provided for @cashDepositVoucher.
  ///
  /// In en, this message translates to:
  /// **'Cash Deposit Voucher'**
  String get cashDepositVoucher;

  /// No description provided for @fillDepositSlip.
  ///
  /// In en, this message translates to:
  /// **'Fill digital deposit slip'**
  String get fillDepositSlip;

  /// No description provided for @cashWithdrawalForm.
  ///
  /// In en, this message translates to:
  /// **'Cash Withdrawal Form'**
  String get cashWithdrawalForm;

  /// No description provided for @fillWithdrawalSlip.
  ///
  /// In en, this message translates to:
  /// **'Fill digital withdrawal slip'**
  String get fillWithdrawalSlip;

  /// No description provided for @stepAccountInfo.
  ///
  /// In en, this message translates to:
  /// **'Account Info'**
  String get stepAccountInfo;

  /// No description provided for @stepDenominations.
  ///
  /// In en, this message translates to:
  /// **'Denominations'**
  String get stepDenominations;

  /// No description provided for @stepDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get stepDetails;

  /// No description provided for @step1Of3.
  ///
  /// In en, this message translates to:
  /// **'Step 1 of 3'**
  String get step1Of3;

  /// No description provided for @step2Of3.
  ///
  /// In en, this message translates to:
  /// **'Step 2 of 3'**
  String get step2Of3;

  /// No description provided for @step3Of3.
  ///
  /// In en, this message translates to:
  /// **'Step 3 of 3'**
  String get step3Of3;

  /// No description provided for @fillDepositVoucher.
  ///
  /// In en, this message translates to:
  /// **'Fill Deposit Voucher'**
  String get fillDepositVoucher;

  /// No description provided for @fillWithdrawalFormHeader.
  ///
  /// In en, this message translates to:
  /// **'Fill Withdrawal Form'**
  String get fillWithdrawalFormHeader;

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

  /// No description provided for @accountHolderWithSurname.
  ///
  /// In en, this message translates to:
  /// **'Account Holder (with surname)'**
  String get accountHolderWithSurname;

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

  /// No description provided for @birrInFigure.
  ///
  /// In en, this message translates to:
  /// **'Birr in Figure'**
  String get birrInFigure;

  /// No description provided for @passBookNote.
  ///
  /// In en, this message translates to:
  /// **'Pass book must accompany this form'**
  String get passBookNote;

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

  /// No description provided for @errorSelectBranch.
  ///
  /// In en, this message translates to:
  /// **'Please select branch'**
  String get errorSelectBranch;

  /// No description provided for @errorSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Please select date'**
  String get errorSelectDate;

  /// No description provided for @errorAccountHolderRequired.
  ///
  /// In en, this message translates to:
  /// **'Account holder name is required'**
  String get errorAccountHolderRequired;

  /// No description provided for @errorLettersOnly.
  ///
  /// In en, this message translates to:
  /// **'Name must contain letters only'**
  String get errorLettersOnly;

  /// No description provided for @errorMin3Chars.
  ///
  /// In en, this message translates to:
  /// **'Must be at least 3 characters'**
  String get errorMin3Chars;

  /// No description provided for @errorAccountNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Account number is required'**
  String get errorAccountNumberRequired;

  /// No description provided for @errorAccountNumber13Digits.
  ///
  /// In en, this message translates to:
  /// **'Account number must be exactly 13 digits'**
  String get errorAccountNumber13Digits;

  /// No description provided for @quickPresetAmounts.
  ///
  /// In en, this message translates to:
  /// **'Quick Preset Amounts'**
  String get quickPresetAmounts;

  /// No description provided for @manualCustomEntry.
  ///
  /// In en, this message translates to:
  /// **'Manual Custom Entry'**
  String get manualCustomEntry;

  /// No description provided for @denominationBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Cash Breakdown'**
  String get denominationBreakdown;

  /// No description provided for @customAmount.
  ///
  /// In en, this message translates to:
  /// **'Custom Amount (ETB)'**
  String get customAmount;

  /// No description provided for @enterAmountHint.
  ///
  /// In en, this message translates to:
  /// **'Enter amount in Birr'**
  String get enterAmountHint;

  /// No description provided for @denominationHeader.
  ///
  /// In en, this message translates to:
  /// **'Denomination (ETB)'**
  String get denominationHeader;

  /// No description provided for @quantityHeader.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantityHeader;

  /// No description provided for @amountHeader.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amountHeader;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @errorEnterDenomination.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount'**
  String get errorEnterDenomination;

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

  /// No description provided for @errorAmountInWordsRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter amount in words'**
  String get errorAmountInWordsRequired;

  /// No description provided for @sourceOfProceeds.
  ///
  /// In en, this message translates to:
  /// **'Source of Proceeds'**
  String get sourceOfProceeds;

  /// No description provided for @selectSource.
  ///
  /// In en, this message translates to:
  /// **'Select source'**
  String get selectSource;

  /// No description provided for @sourceSalary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get sourceSalary;

  /// No description provided for @sourceBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get sourceBusiness;

  /// No description provided for @sourceRemittance.
  ///
  /// In en, this message translates to:
  /// **'Remittance'**
  String get sourceRemittance;

  /// No description provided for @sourceSavings.
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get sourceSavings;

  /// No description provided for @sourceInvestment.
  ///
  /// In en, this message translates to:
  /// **'Investment'**
  String get sourceInvestment;

  /// No description provided for @sourceOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get sourceOther;

  /// No description provided for @telephoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Telephone Number'**
  String get telephoneNumber;

  /// No description provided for @errorPhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Telephone number is required'**
  String get errorPhoneRequired;

  /// No description provided for @errorPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter valid Ethiopian phone (09..., 07..., or +251...)'**
  String get errorPhoneInvalid;

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

  /// No description provided for @errorDepositorRequired.
  ///
  /// In en, this message translates to:
  /// **'Depositor name is required'**
  String get errorDepositorRequired;

  /// No description provided for @signatureLabel.
  ///
  /// In en, this message translates to:
  /// **'Signature'**
  String get signatureLabel;

  /// No description provided for @depositedBySignature.
  ///
  /// In en, this message translates to:
  /// **'Deposited By Signature'**
  String get depositedBySignature;

  /// No description provided for @accountHolderSignature.
  ///
  /// In en, this message translates to:
  /// **'Account Holder Signature'**
  String get accountHolderSignature;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @errorSignatureRequired.
  ///
  /// In en, this message translates to:
  /// **'Please provide your signature'**
  String get errorSignatureRequired;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// No description provided for @reviewYourForm.
  ///
  /// In en, this message translates to:
  /// **'Review Your Form'**
  String get reviewYourForm;

  /// No description provided for @amountFigure.
  ///
  /// In en, this message translates to:
  /// **'Amount (Figure)'**
  String get amountFigure;

  /// No description provided for @amountWords.
  ///
  /// In en, this message translates to:
  /// **'Amount (Words)'**
  String get amountWords;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @formSubmittedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Form Submitted Successfully!'**
  String get formSubmittedSuccess;

  /// No description provided for @referenceNumber.
  ///
  /// In en, this message translates to:
  /// **'Reference Number'**
  String get referenceNumber;

  /// No description provided for @refCopied.
  ///
  /// In en, this message translates to:
  /// **'Reference number copied to clipboard!'**
  String get refCopied;

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

  /// No description provided for @downloadPdf.
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get downloadPdf;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @errorExportPdf.
  ///
  /// In en, this message translates to:
  /// **'Failed to export PDF'**
  String get errorExportPdf;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get noHistory;

  /// No description provided for @noHistorySub.
  ///
  /// In en, this message translates to:
  /// **'Your submitted forms and vouchers will appear here'**
  String get noHistorySub;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @statusExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get statusExpired;

  /// No description provided for @securityAndCompliance.
  ///
  /// In en, this message translates to:
  /// **'Security & Compliance'**
  String get securityAndCompliance;

  /// No description provided for @encryptionStandard.
  ///
  /// In en, this message translates to:
  /// **'Encryption Standard'**
  String get encryptionStandard;

  /// No description provided for @encryptionValue.
  ///
  /// In en, this message translates to:
  /// **'AES-256 CBC'**
  String get encryptionValue;

  /// No description provided for @qrLifespan.
  ///
  /// In en, this message translates to:
  /// **'QR Code Lifespan'**
  String get qrLifespan;

  /// No description provided for @qrLifespanValue.
  ///
  /// In en, this message translates to:
  /// **'5 Minutes'**
  String get qrLifespanValue;

  /// No description provided for @cbeContactCenter.
  ///
  /// In en, this message translates to:
  /// **'CBE Contact Center'**
  String get cbeContactCenter;

  /// No description provided for @cbeContactValue.
  ///
  /// In en, this message translates to:
  /// **'951'**
  String get cbeContactValue;

  /// No description provided for @digitalBanking.
  ///
  /// In en, this message translates to:
  /// **'Digital Banking'**
  String get digitalBanking;

  /// No description provided for @digitalBankingValue.
  ///
  /// In en, this message translates to:
  /// **'Official CBE Form Service'**
  String get digitalBankingValue;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences & Settings'**
  String get preferences;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @languagePreference.
  ///
  /// In en, this message translates to:
  /// **'Language Preference'**
  String get languagePreference;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @clearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache & Storage'**
  String get clearCache;

  /// No description provided for @clearCacheConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get clearCacheConfirmTitle;

  /// No description provided for @clearCacheConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear saved forms and cached data?'**
  String get clearCacheConfirmMessage;

  /// No description provided for @clearCacheSuccess.
  ///
  /// In en, this message translates to:
  /// **'Cache cleared successfully!'**
  String get clearCacheSuccess;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @appVersionValue.
  ///
  /// In en, this message translates to:
  /// **'v1.0.0'**
  String get appVersionValue;

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support / FAQ'**
  String get helpAndSupport;

  /// No description provided for @faqTitle.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get faqTitle;

  /// No description provided for @faqQ1.
  ///
  /// In en, this message translates to:
  /// **'How does the digital form work?'**
  String get faqQ1;

  /// No description provided for @faqA1.
  ///
  /// In en, this message translates to:
  /// **'Fill the required details in 3 easy steps, generate your encrypted QR code, and show it to the teller at any CBE branch.'**
  String get faqA1;

  /// No description provided for @faqQ2.
  ///
  /// In en, this message translates to:
  /// **'Do I need to print or bring paper?'**
  String get faqQ2;

  /// No description provided for @faqA2.
  ///
  /// In en, this message translates to:
  /// **'No. The system is 100% paperless. The teller scans your QR code directly from your phone screen.'**
  String get faqA2;

  /// No description provided for @faqQ3.
  ///
  /// In en, this message translates to:
  /// **'How long is the QR code valid?'**
  String get faqQ3;

  /// No description provided for @faqA3.
  ///
  /// In en, this message translates to:
  /// **'For security reasons, each generated QR code is valid for 5 minutes.'**
  String get faqA3;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;
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
