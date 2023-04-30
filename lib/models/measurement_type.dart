/// ff : 정면으로 팔 들어올리기
/// abd : 측면으로 팔 들어올리기
/// er : 팔 굽혀 측면으로 돌리기
/// ir : 팔 굽혀 뒤로 올리기

// TODO 타입들마다 각도 측정 방식 고유하게 갖게 끔 설계
enum MeasurementType { l_ff, l_abd, l_er, l_ir, r_ff, r_abd, r_er, r_ir }

extension ParseToString on MeasurementType {
  String toValue() {
    return toString().split('.').last;
  }
}

extension LeftOrRight on MeasurementType {
  bool isLeft() {
    List<MeasurementType> leftList = [
      MeasurementType.l_abd,
      MeasurementType.l_er,
      MeasurementType.l_ff,
      MeasurementType.l_ir
    ];
    return leftList.contains(this);
  }

  bool isRight() {
    List<MeasurementType> rightList = [
      MeasurementType.r_abd,
      MeasurementType.r_er,
      MeasurementType.r_ff,
      MeasurementType.r_ir
    ];
    return rightList.contains(this);
  }
}
