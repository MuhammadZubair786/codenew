//** CHANGE APP LOGO
import 'package:get/get.dart';
import 'package:lms_flutter_app/Controller/site_controller.dart';

final String appLogo = "logo.png";

final String appLogo2 = "darklogo.png";

//** CHANGE SPLASH SCREEN IMAGE
final String splashLogo = "logov.gif";

// ** CHANGE WEBSITE ROOT URL
final String rootUrl = "https://aca.teratarget.com/le";

final bool isDemo = false;

final bool showDownloadsFolder = false;

final String authHeader =
    "Authorization"; // X-Authorization if server doesn't support Authorization header

final String isBearer = authHeader == "X-Authorization" ? "" : "Bearer ";

final String baseUrl = rootUrl + "/api";

//** Change App Title
final String companyName = "Ferbe";

//** Change Currency
final String appCurrency = '\دینار';

//** Enable USD to INR conversion for PayTM and Razorpay
final bool enableCurrencyConvert = true;

//** VdoCipher API KEY
final String vdoCipherApiKey =
    "GfLenTbglazt9TCSgJpqRTDYTQnZJGro4lCPr9wJ43Cyw9pGz9NxiEG3ECXJqmrW";

//** Change currencyconverterapi.com API KEY
final String currencyConvApiKey = "c53aa753fbea191d10a1";

//** Change Razor Pay API Key and API Secret for Razor Pay Payment
final String razorPayKey = 'rzp_test_lQtnyQrR6BUBkf';
final String razorPaySecret = 'Fg3w0gZ7YITgjVoms98fekTf';

//** CHANGE PAYTM host url
const PAYTM_HOST_URL = "http://localhost:3000";

//** Settings Page Links
final String privacyPolicyLink = "https://www.facebook.com/in.ferbe/about";
final String rateAppLinkAndroid =
    "https://www.facebook.com/in.ferbe";
final String rateAppLinkiOS = "https://www.facebook.com/in.ferbe";
final String contactUsLink = "https://www.facebook.com/in.ferbe";

const PAYMENT_URL = "$PAYTM_HOST_URL/payment";
const STATUS_LOADING = "PAYMENT_LOADING";
const STATUS_SUCCESSFUL = "PAYMENT_SUCCESSFUL";
const STATUS_PENDING = "PAYMENT_PENDING";
const STATUS_FAILED = "PAYMENT_FAILED";
const STATUS_CHECKSUM_FAILED = "PAYMENT_CHECKSUM_FAILED";

//** Midtrans Payment
final String midTransServerUrl = 'http://localhost:3000';

//** Paypal Payment

final String paypalDomain =
    "https://api.sandbox.paypal.com"; // "https://api.paypal.com"; // for production mode
final String paypalCurrency = 'USD';
final String paypalClientId =
    'AQgAWV4PlM9g81xZ51TLtVi68KjB89s4mpcchFschs7OvTM-3p4zsQTDqHOkv5Sw44k9goHlE-VAC7zj';
final String paypalClientSecret =
    'ELLoQfnZ4kRbDkul81U_RNRsgHgFPDumlUloCcX6nO6ziXRXKob8gVYaTn6CGCeNVJtBqsfv7VtbsuR2';

//** PayStack Payment
final String payStackPublicKey =
    'pk_test_cb290d59b9ec539d7bc3617d1fee3d8a9cdb78b3';

final String payStackCurrency = 'ZAR';

///
/// InstaMojo
///
final String instaMojoApiUrl = 'https://test.instamojo.com/api/1.1';
final String instaMojoApiKey = 'test_653cb00cbfc37b41dc7fad3bf92';
final String instaMojoAuthToken = 'test_ba9959aa2b6a5be5cb7e0d36a17';

///
/// Stripe
///
final String stripeServerURL = 'http://localhost:3000';
final String stripeCurrency = "usd";
final String stripeMerchantID = "merchant.thegreatestmarkeplace";
final String stripePublishableKey =
    "pk_test_51JAWNlKS0igSTFP16dhgcM1fBayh6DStrpu5OA7jjAzYiFX3Bht0X8ARULBpIAVkgmws7PWEliNi4Q35Iyk8ThQL00aoNnF3OE";
final String appPackageName = "com.infix.lms";


final bool facebookLogin = false;

final bool googleLogin = false;

final stctrl = Get.put(SiteController());
