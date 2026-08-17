
// import 'package:crypto_app/view/screens/home/home_screen.dart';

import 'package:get/get.dart';
import 'package:mobile_scanner_app/routes/views/screens/details_screen.dart';
import 'package:mobile_scanner_app/routes/views/screens/qrscanner_page.dart';

class Routes {
  // static String homescreen = '/home';
  static String qrscannerpage = '/qrscanner';
  static String detailsscreen = '/details';
  // static String congratulation = '/congratulation';
  // static String profile = '/profile';

}

final getPages = [
  // GetPage(
  //   name: Routes.homescreen,
  //   page: () => Home(),
  // ),
  GetPage(
    name: Routes.qrscannerpage,
    page: () =>  QRScannerPage(),
  ),
  GetPage(
    name: Routes.detailsscreen,
    page: () => const DetailsScreen(),
  ),
  // GetPage(
  //   name: Routes.signIn,
  //   page: () => SignIn(),
  // ),
  // GetPage(
  //   name: Routes.signUp,
  //   page: () => SignUp(),
  // ),
  // GetPage(
  //   name: Routes.forgetPassword,
  //   page: () => ForgetPassword(),
  // ),
  // GetPage(
  //   name: Routes.signUpVerification,
  //   page: () => const SignUpVerification(),
  // ),
  // GetPage(
  //   name: Routes.signInVerification,
  //   page: () => const SignInVerification(),
  // ),
  
];
