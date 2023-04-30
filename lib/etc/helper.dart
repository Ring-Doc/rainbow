import 'package:get/get.dart';

class FontSize {
  static final double figmaHeight = 1170.toDouble();
  static final double full = Get.size.height;

  static double ofRatio(double fontSize) {
    return (fontSize / figmaHeight) * full;
  }
}

class Height {
  static final double figmaHeight = 1170.toDouble();
  static final double full = Get.size.height;

  /// 원하는 높이를 파라미터로 전달받으면 비율에 맞는 높이 값을 반환합니다.
  static double ofRatio(double height) {
    return (height / figmaHeight) * full;
  }
}

class Width {
  static final double figmaWidth = 834.toDouble();
  static final double full = Get.size.width;

  /// 원하는 너비를 파라미터로 전달받으면 비율에 맞는 너비 값을 반환합니다.
  static double ofRatio(double width) {
    return (width / figmaWidth) * full;
  }
}

class Console {
  static void log(String text) {
    print("console.log ${DateTime.now()} $text");
  }
}

extension ParseToString on int {
  String toWeekdayString() {
    switch (this) {
      case 1:
        return "월";
      case 2:
        return "화";
      case 3:
        return "수";
      case 4:
        return "목";
      case 5:
        return "금";
      case 6:
        return "토";
      case 7:
        return "일";
      default:
        return "";
    }
  }
}
