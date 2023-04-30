class DistancesAngle {
  final double distanceAtoB;
  final double distanceBtoC;
  final double angle;

  DistancesAngle(this.distanceAtoB, this.distanceBtoC, this.angle);

  @override
  String toString() {
    return "$distanceAtoB, $distanceBtoC, $angle";
  }
}
