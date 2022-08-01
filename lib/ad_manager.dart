// import 'dart:io';
//
// import 'package:google_mobile_ads/google_mobile_ads.dart';
//
// class AdManager {
//   Future<InitializationStatus> initialization;
//
//   AdManager({this.initialization});
//   static String get appId {
//     if (Platform.isAndroid) {
//       return "ca-app-pub-2825223105842229~5080131478";
//     } else if (Platform.isIOS) {
//       return "<YOUR_IOS_ADMOB_APP_ID>";
//     } else {
//       throw new UnsupportedError("Unsupported platform");
//     }
//   }
//   BannerAdListener get adListener => _adListener;
//   BannerAdListener _adListener = BannerAdListener(
//     // Called when an ad is successfully received.
//     onAdLoaded: (Ad ad) => print('Ad loaded.'),
//     // Called when an ad request failed.
//     onAdFailedToLoad: (Ad ad, LoadAdError error) {
//       // Dispose the ad here to free resources.
//       ad.dispose();
//       print('Ad failed to load: $error');
//     },
//     // Called when an ad opens an overlay that covers the screen.
//     onAdOpened: (Ad ad) => print('Ad opened.'),
//     // Called when an ad removes an overlay that covers the screen.
//     onAdClosed: (Ad ad) => print('Ad closed.'),
//     // Called when an impression occurs on the ad.
//     onAdImpression: (Ad ad) => print('Ad impression.'),
//   );
//
//   static String get bannerAdUnitId {
//     final String testAd = 'ca-app-pub-3940256099942544/6300978111';
//     final String clientAd = 'ca-app-pub-2794435023110821/8346542428';
//     final String myAd = 'ca-app-pub-2825223105842229/8827804794';
//     if (Platform.isAndroid) {
//       return clientAd;
//     } else if (Platform.isIOS) {
//       return "<YOUR_IOS_BANNER_AD_UNIT_ID>";
//     } else {
//       throw new UnsupportedError("Unsupported platform");
//     }
//   }
//   static String get interstitialAdUnitId {
//     if (Platform.isAndroid) {
//       return "<YOUR_ANDROID_INTERSTITIAL_AD_UNIT_ID>";
//     } else if (Platform.isIOS) {
//       return "<YOUR_IOS_INTERSTITIAL_AD_UNIT_ID>";
//     } else {
//       throw new UnsupportedError("Unsupported platform");
//     }
//   }
//
//   static String get rewardedAdUnitId {
//     if (Platform.isAndroid) {
//       return "<YOUR_ANDROID_REWARDED_AD_UNIT_ID>";
//     } else if (Platform.isIOS) {
//       return "<YOUR_IOS_REWARDED_AD_UNIT_ID>";
//     } else {
//       throw new UnsupportedError("Unsupported platform");
//     }
//   }
// }