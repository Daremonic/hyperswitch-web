let localeStrings: LocaleStringTypes.localeStrings = {
  locale: "en-GB",
  localeDirection: "ltr",
  cardNumberLabel: "Card Number",
  inValidCardErrorText: "Card number is invalid.",
  inValidExpiryErrorText: "Card expiry is invalid.",
  inCompleteCVCErrorText: "Your card's security code is incomplete.",
  inCompleteExpiryErrorText: "Your card's expiration date is incomplete.",
  enterValidCardNumberErrorText: "Please enter a valid card number.",
  pastExpiryErrorText: "Your card's expiration year is in the past.",
  poweredBy: "Powered By Hyperswitch",
  validThruText: "Expiry",
  sortCodeText: "Sort Code",
  cvcTextLabel: "CVC",
  emailLabel: "Email",
  ibanEmptyText: "IBAN cannot be empty",
  emailEmptyText: "Email cannot be empty",
  emailInvalidText: "Invalid email address",
  line1Label: "Address line 1",
  line1Placeholder: "Street address",
  line1EmptyText: "Address line 1 cannot be empty",
  line2Label: "Address line 2",
  line2Placeholder: "Apt., unit number, etc",
  line2EmptyText: "Address line 2 cannot be empty",
  cityLabel: "City",
  cityEmptyText: "City cannot be empty",
  postalCodeLabel: "Postal Code",
  postalCodeEmptyText: "Postal code cannot be empty",
  postalCodeInvalidText: "Invalid postal code",
  stateLabel: "State",
  stateEmptyText: "State cannot be empty",
  accountNumberText: "Account Number",
  fullNameLabel: "Full name",
  fullNamePlaceholder: "First and last name",
  countryLabel: "Country",
  currencyLabel: "Currency",
  bankLabel: "Select Bank",
  redirectText: "After submitting your order, you will be redirected to securely complete your purchase.",
  bankDetailsText: "After submitting these details, you will get bank account information to make payment. Please make sure to take a note of it.",
  orPayUsing: "Or pay using",
  addNewCard: "Add credit/debit card",
  useExisitingSavedCards: "Use saved debit/credit cards",
  saveCardDetails: "Save card details",
  addBankAccount: "Add bank account",
  achBankDebitTerms: _ =>
    `Your ACH Debit Authorization will be set up now, but we'll confirm the amount and let you know before future payments are taken.`,
  sepaDebitTerms: str =>
    `By providing your payment information and confirming to this mandate form, you authorise (A) ${str}, the Creditor and/or our payment service provider(s) to send instructions to your bank to debit your account and (B) your bank to debit your account in accordance with the instructions from ${str}. As part of your rights, you are entitled to a refund from your bank under the terms and conditions of your agreement with your bank. A refund must be claimed within 8 weeks starting from the date on which your account was debited. Your rights are explained in a statement that you can obtain from your bank.`,
  becsDebitTerms: `By providing your bank account details and confirming this payment, you agree to this Direct Debit Request and the Direct Debit Request service agreement and authorise Hyperswitch Payments Australia Pty Ltd ACN 160 180 343 Direct Debit User ID number 507156 (“Hyperswitch”) to debit your account through the Bulk Electronic Clearing System (BECS) on behalf of Hyperswitch Payment Widget (the "Merchant") for any amounts separately communicated to you by the Merchant. You certify that you are either an account holder or an authorised signatory on the account listed above.`,
  cardTerms: str =>
    `By providing your card information, you allow ${str} to charge your card for future payments in accordance with their terms.`,
  payNowButton: "Pay Now",
  cardNumberEmptyText: "Card Number cannot be empty",
  cardExpiryDateEmptyText: "Card expiry date cannot be empty",
  cvcNumberEmptyText: "CVC Number cannot be empty",
  enterFieldsText: "Please enter all fields",
  enterValidDetailsText: "Please enter valid details",
  selectPaymentMethodText: `Please select a payment method and try again`,
  card: "Card",
  surchargeMsgAmount: (currency, str) => <>
    {React.string(`A surcharge amount of${Utils.nbsp}`)}
    <strong> {React.string(`${currency} ${str}`)} </strong>
    {React.string(`${Utils.nbsp}will be applied for this transaction`)}
  </>,
  shortSurchargeMessage: (currency, amount) => <>
    {React.string(`Fee :${Utils.nbsp}`)}
    <strong> {React.string(`${currency} ${amount}`)} </strong>
  </>,
  surchargeMsgAmountForCard: (currency, str) => <>
    {React.string(`A surcharge amount of upto${Utils.nbsp}`)}
    <strong> {React.string(`${currency} ${str}`)} </strong>
    {React.string(`${Utils.nbsp}will be applied for this transaction`)}
  </>,
  surchargeMsgAmountForOneClickWallets: "Additional fee applicable",
  billingNameLabel: "Billing name",
  billingNamePlaceholder: "First and last name",
  cardHolderName: "Card Holder Name",
  on: "on",
  \"and": "and",
  nameEmptyText: str => `Please provide your ${str}`,
  completeNameEmptyText: str => `Please provide your complete ${str}`,
  billingDetailsText: "Billing Details",
  socialSecurityNumberLabel: "Social Security Number",
  saveWalletDetails: "Wallets details will be saved upon selection",
  morePaymentMethods: "More payment methods",
  useExistingPaymentMethods: "Use saved payment methods",
  cardNickname: "Card Nickname",
  nicknamePlaceholder: "Card Nickname (Optional)",
  cardExpiredText: `This card has expired`,
  cardHeader: `Card information`,
  cardBrandConfiguredErrorText: str => `${str} is not supported at the moment.`,
  currencyNetwork: `Currency Networks`,
  expiryPlaceholder: `MM / YY`,
  dateOfBirth: `Date of Birth`,
  vpaIdLabel: `Vpa Id`,
  vpaIdEmptyText: `Vpa Id cannot be empty`,
  vpaIdInvalidText: `Invalid Vpa Id address`,
  dateofBirthRequiredText: `Date of birth is required`,
  dateOfBirthInvalidText: `Age should be greater than or equal to 18 years`,
  dateOfBirthPlaceholderText: `Enter Date of Birth`,
  formFundsInfoText: `Funds will be credited to this account`,
  formFundsCreditInfoText: pmLabel => `Your funds will be credited in the selected ${pmLabel}.`,
  formEditText: `Edit`,
  formSaveText: `Save`,
  formSubmitText: `Submit`,
  formSubmittingText: `Submitting`,
  formSubheaderBillingDetailsText: `Enter your billing address`,
  formSubheaderCardText: `Your card details`,
  formSubheaderAccountText: pmLabel => `Your ${pmLabel}`,
  formHeaderReviewText: `Review`,
  formHeaderReviewTabLayoutText: pmLabel => `Review your ${pmLabel} details`,
  formHeaderBankText: bankTransferType => `Enter ${bankTransferType} bank details`,
  formHeaderWalletText: walletTransferType => `Enter ${walletTransferType} wallet details`,
  formHeaderEnterCardText: `Enter card details`,
  formHeaderSelectBankText: `Select a bank method`,
  formHeaderSelectWalletText: `Select a wallet`,
  formHeaderSelectAccountText: `Select an account for payouts`,
  formFieldACHRoutingNumberLabel: `Routing Number`,
  formFieldSepaIbanLabel: `International Bank Account Number (IBAN)`,
  formFieldSepaBicLabel: `Bank Identifier Code (Optional)`,
  formFieldPixIdLabel: `Pix ID`,
  formFieldBankAccountNumberLabel: `Bank Account Number`,
  formFieldPhoneNumberLabel: `Phone Number`,
  formFieldCountryCodeLabel: `Country Code (Optional)`,
  formFieldBankNameLabel: `Bank Name (Optional)`,
  formFieldBankCityLabel: `Bank City (Optional)`,
  formFieldCardHoldernamePlaceholder: `Your Name`,
  formFieldBankNamePlaceholder: `Bank Name`,
  formFieldBankCityPlaceholder: `Bank City`,
  formFieldEmailPlaceholder: `Your Email`,
  formFieldPhoneNumberPlaceholder: `Your Phone`,
  formFieldInvalidRoutingNumber: `Routing number is invalid.`,
  infoCardRefId: `Ref Id`,
  infoCardErrCode: `Error Code`,
  infoCardErrMsg: `Error Message`,
  infoCardErrReason: `Reason`,
  linkRedirectionText: seconds => `Redirecting in ${seconds->Int.toString} seconds ...`,
  linkExpiryInfo: expiry => `Link expires on: ${expiry}`,
  payoutFromText: merchant => `Payout from ${merchant}`,
  payoutStatusFailedMessage: `Failed to process your payout. Please check with your provider for more details.`,
  payoutStatusPendingMessage: `Your payout should be processed within 2-3 business days.`,
  payoutStatusSuccessMessage: `Your payout was successful. Funds were deposited in your selected payment mode.`,
  payoutStatusFailedText: `Payout Failed`,
  payoutStatusPendingText: `Payout Processing`,
  payoutStatusSuccessText: `Payout Successful`,
  pixCNPJInvalidText: `Invalid Pix CNPJ`,
  pixCNPJEmptyText: `Pix CNPJ cannot be empty`,
  pixCNPJLabel: `Pix CNPJ`,
  pixCNPJPlaceholder: `Enter Pix CNPJ`,
  pixCPFInvalidText: `Invalid Pix CPF`,
  pixCPFEmptyText: `Pix CPF cannot be empty`,
  pixCPFLabel: `Pix CPF`,
  pixCPFPlaceholder: `Enter Pix CPF`,
  pixKeyEmptyText: `Pix key cannot be empty`,
  pixKeyPlaceholder: `Enter Pix key`,
  pixKeyLabel: `Pix key`,
  destinationBankAccountIdEmptyText: `Destination Bank Account ID cannot be empty`,
  sourceBankAccountIdEmptyText: `Source Bank Account ID cannot be empty`,
  invalidCardHolderNameError: `Cardholder's name cannot contain digits`,
  invalidNickNameError: `Nickname cannot have more than 2 digits`,
  expiry: `expiry`,
}
