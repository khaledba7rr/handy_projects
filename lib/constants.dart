import 'package:flutter/material.dart';

import 'package:rflutter_alert/rflutter_alert.dart';

bool dark = false;

final Color kBackgroundColor = dark ? Color(0xff141C20) : Color(0xFFf0e3ca);
final Color kAppbarColor = Color(0xFF23292D);
final Color kMainTextColor = dark ?  Colors.black87 : Colors.black87.withOpacity(0.8);
final Color kFirstButtonColor = dark ? Color(0xFF24364C) : Color(0xFFCDBA96);
final Color kSecondButtonColor = Color(0xFFf3ab00);
final Color kBorderColor = dark ?  Color(0xFF272E31) : kBackgroundColor;
final Color kFieldTextColor = dark ? Color(0xFF1b1a17) : Colors.black87;
final Color kErrorColor = Color(0xFFA90F03);
final Color kGridTileColor = Colors.white70;

final kMainTextStyle = TextStyle(
  color: kMainTextColor,
  fontSize: 20,
  fontWeight: FontWeight.bold,
  fontFamily: 'DelaGothic',
);

final kAnimatedText = TextStyle(
  fontSize: 17,
  color: kMainTextColor,
  fontFamily: 'DelaGothic',
);

final kFieldTextStyle = TextStyle(
  fontSize: 17,
  fontWeight: FontWeight.w400,
  color: kFieldTextColor,

);

final kAlert = AlertStyle(
  animationType: AnimationType.fromTop,
  backgroundColor: kBorderColor,
  isCloseButton: false,
  isOverlayTapDismiss: false,
  titleStyle: TextStyle(fontWeight: FontWeight.bold , color: kMainTextColor),
  descStyle: TextStyle(fontWeight: FontWeight.bold , color: kMainTextColor),
  animationDuration: Duration(milliseconds: 400),
  alertBorder: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(30),
    side: BorderSide(
      color: kFieldTextColor,
    ),
  ),
);

final kLabelTextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  color: kMainTextColor,
); //modify

final kButtonTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.black87,
  fontWeight: FontWeight.bold,
  fontFamily: 'Roboto',
);

final kBigTextStyle = TextStyle(
  fontSize: 18,
  color: kMainTextColor,
  fontFamily: 'DelaGothic',
);
final kErrorTextStyle = TextStyle(
  fontSize: 18,
  color: kErrorColor,
  fontFamily: 'DelaGothic',
);
final kSmallErrorTextStyle = TextStyle(
  fontSize: 14,
  color: kErrorColor,
  fontFamily: 'DelaGothic',
);

final kImageErrorTextStyle = TextStyle(
  fontSize: 18,
  color: Colors.white,
  fontFamily: 'DelaGothic',
);

final kSmallTextStyle = TextStyle(
  fontSize: 14,
  color: kMainTextColor,
  fontFamily: 'DelaGothic',
);

final kVerySmallTextStyle = TextStyle(
  fontSize: 10,
  color: kMainTextColor,
  fontFamily: 'DelaGothic',
);


final kTermsStyle = TextStyle(
  fontSize: 17,
  fontWeight: FontWeight.w400,
  color: kMainTextColor,
);





List<Map> categories = [
  {'title' : 'Accessories', 'image': 'https://image.freepik.com/free-photo/woman-accessories-black-side-view_155003-7887.jpg'},
  {'title' : 'Decoration & crafting', 'image': 'https://image.freepik.com/free-photo/wooden-art-pieces-painting-process_23-2148271008.jpg'},
  {'title' : 'Fashion & clothing', 'image': 'https://image.freepik.com/free-photo/top-view-open-woman-bag_155003-8360.jpg'},
  {'title' : 'Art & collectibles', 'image': 'https://image.freepik.com/free-photo/golden-bronze-metallic-photo-frame_114579-45175.jpg'},
  {'title' : 'Gift & wrapping', 'image': 'https://image.freepik.com/free-photo/christmas-gift-box-wrapped-recycled-paper-with-ribbon-bow_114579-45941.jpg'},
];

const kTermsText = 'The following terms of service (“Terms of Service”) describe the terms and conditions applicable'
    'to your use of Handy’s application (“Handy”).'
    'Shop is a service that allows you to save and manage your information '
    'for a seamless checkout on certain stores that offer Shop Pay as a payment '
    'option, (each, a “Merchant”),'
    ' track all of your orders and shipments in one place, '
    'and allows you to search Merchants and browse and purchase products.'
    'This document is a legally binding agreement between you as the user of `Handy` (referred to as “you” or “your”) '
    'and Handy Inc. and its Affiliates (referred to as “we”, “our”, “us” or “Handy”), '
    'where “Affiliates” means any entity that directly or indirectly controls, is controlled by, '
    'or is under common control with Handy Inc.'
    'By using the Shop app, you agree to be bound by these Terms of Service. Any new features or tools '
    'which are added to the current Shop offering shall also be subject to these Terms of Service. '
    'We reserve the right, in our sole and absolute discretion, to update and change any portion of the Terms'
    ' of Service at any time by posting a notification in-app, or otherwise communicating the notification to you.'
    ' You are advised to check the Terms of Service from time to time for any updates or changes that may impact you.'
    ' Your continued use of Shop after the amended Terms of Service that are posted here constitutes your agreement to, '
    'and acceptance of, the amended Terms of Service. In the event you do not agree with any such updates, '
    'your sole and exclusive remedy is to terminate your use of Shop (refer to section 3). '
    'References in Shop to third party brands do not necessarily denote a relationship between Handy and such third party.';

const kHowitWorks =
    '1.1 Shop powers an accelerated checkout (“Shop Pay"). When you complete an order on a'
    ' Merchant’s web or mobile e-commerce site, whether hosted by Shopify or a third party,'
    ' with Shop Pay’s accelerated checkout enabled (each a “Shop Pay Site”), you will be ask'
    'ed on the checkout page if you would like to save your information. When you opt-in to '
    'save your information with Shop Pay, Shopify will collect and store certain personal inf'
    'ormation from you, such as your name, email address, mobile phone number (“Account Inform'
    'ation”); your credit card information and billing address (“Payment Information”); your sh'
    'ipping address and the shipping method you select on the checkout page of the Shop Pay Site'
    ' (“Shipping Information”); and information related to your order details of goods and servic'
    'es purchased from Merchants using Shop (including information such as the type or size or oth'
    'er variants) (“Order Information”). Together, your Account Information, Payment Information, S'
    'hipping Information and Order Information are your “Saved Information”. All personal informatio'
    'n collected from you in connection with your use of Shop will be governed by the Shop Privacy Policy.'
    '1.2 If you use Shop Pay on a Shop Pay Site, Shopify will place a cookie on your web browser to recogni'
    'ze you when you return to that Shop Pay Site which will allow you to make purchases using your Saved In'
    'formation. If you visit a Shop Pay Site and you are not recognized by Shop (for example, because it’s yo'
    'ur first time at that Shop Pay Site, you’ve cleared your cookies, logged out, or you’re using a device th'
    'at is different from the one you used to access the Shop Pay Site during your last checkout), you will be'
    ' able to access your Saved Information by inputting your email address and a verification code sent to you'
    ' via SMS text message or via the Shop App. After you verify your identity, Shop will allow you to make purc'
    'hases using your Saved Information, including your Shipping Information provided that the Merchant offers the'
    ' applicable shipping method.1.3 You may manage your Payment Information and Shipping Information in Shop, or t'
    'he next time you checkout from a Shop Pay Site. Should you update your Payment Information, you consent to Shop'
    'ify validating your Payment Information, including your credit card on file.1.4 Note that message and data rates'
    ' may apply for any SMS messages sent to you from us and to us from you. If you have any questions about your text'
    ' plan or data plan, contact your wireless provider.';
