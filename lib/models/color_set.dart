import 'package:flutter/material.dart';

class ColorSet {
  static Color mainColor = const Color(0xff59EDCC);
  static Color disableColor = const Color(0xffBFBFBF);

  static Color whiteColor = const Color(0xFFFFFFFF);
  static Color blackColor = const Color(0xFF000000);

  static Color primaryColor(int index) => PrimaryColor.at(index);
  static Color secondaryColor(int index) => SecondaryColor.at(index);
  static Color greyColor(int index) => GreyColor.at(index);
}

class PrimaryColor {
  /// 1 => #0xFF59EDCC
  ///
  /// 2 => #0xFFA5EEDE
  ///
  /// 3 => #0xFF17D74B
  ///
  /// 4 => #0xFFFFFFFF
  static Color at(index) {
    if (index == 1) return const Color(0xFF59EDCC);
    if (index == 2) return const Color(0xFFA5EEDE);
    if (index == 3) return const Color(0xFF17D74B);
    if (index == 4) return const Color(0xFFFFFFFF);
    return Colors.white;
  }
}

class SecondaryColor {
  /// 1 => #0xFFEFC5FF
  ///
  /// 2 => #0xFFFC5E93
  ///
  /// 3 => #0xFFFD0464
  ///
  /// 4 => #0xFF6E61B5
  static Color at(index) {
    if (index == 1) return const Color(0xFFEFC5FF);
    if (index == 2) return const Color(0xFFFC5E93);
    if (index == 3) return const Color(0xFFFD0464);
    if (index == 4) return const Color(0xFF6E61B5);
    return Colors.white;
  }
}

class GreyColor {
  /// 1 => #0xFFF9F9F9
  ///
  /// 2 => #0xFFF6F6F6
  ///
  /// 3 => #0xFFEAEAEA
  ///
  /// 4 => #0xFFBFBFBF
  ///
  /// 5 => #0xFF696969
  ///
  /// 6 => #0xFF202020
  ///
  /// 7 => #0xFF26282B
  ///
  /// 8 => #0xFF26282B
  static Color at(index) {
    if (index == 1) return const Color(0xFFF9F9F9);
    if (index == 2) return const Color(0xFFF6F6F6);
    if (index == 3) return const Color(0xFFEAEAEA);
    if (index == 4) return const Color(0xFFBFBFBF);
    if (index == 5) return const Color(0xFF696969);
    if (index == 6) return const Color(0xFF202020);
    if (index == 7) return const Color(0xFF26282B);
    if (index == 8) return const Color(0xFF26282B);
    return Colors.white;
  }
}

class ConversationGreyColor {
  /// 1 => #0xFFF9F9F9
  ///
  /// 2 => #0xFFF6F6F6
  ///
  /// 3 => #0xFFEAEAEA
  ///
  /// 4 => #0xFFBFBFBF
  ///
  /// 5 => #0xFF696969
  ///
  /// 6 => #0xFF202020
  ///
  /// 7 => #0xFF26282B
  ///
  /// 8 => #0xFF26282B
  static Color at(index) {
    // if (index == 1) return const Color(0xFFF9F9F9);
    if (index == 2) return const Color(0xFFF7F9FB);
    // if (index == 3) return const Color(0xFFEAEAEA);
    if (index == 4) return const Color(0xFFC9CDD2);
    // if (index == 5) return const Color(0xFF696969);
    // if (index == 6) return const Color(0xFF202020);
    // if (index == 7) return const Color(0xFF26282B);
    if (index == 8) return const Color(0xFF26282B);
    return Colors.white;
  }
}
