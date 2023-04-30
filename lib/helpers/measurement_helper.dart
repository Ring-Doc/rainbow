import 'dart:math';

import 'package:ml_linalg/vector.dart';
import 'package:rainbow/models/distances_angle.dart';
import 'package:rainbow/models/point3d.dart';
import 'package:rainbow/models/pose.dart';
import 'package:rainbow/models/pose_landmark.dart';
import 'package:rainbow/models/pose_landmark_type.dart';

enum DistancesAngleByLandmarksType { left, right }

class MeasurementHelper {
  static List<PoseLandmarkType> measurementType = [
    PoseLandmarkType.leftShoulder,
    PoseLandmarkType.rightShoulder,
    PoseLandmarkType.rightWrist,
    PoseLandmarkType.rightElbow,
    PoseLandmarkType.leftWrist,
    PoseLandmarkType.leftElbow
  ];

  /// likelihood로 필터링 한다.
  static Iterable<PoseLandmark> getFilteredLandmarks(Pose pose,
      {double? inFrameLikelihood}) {
    if (inFrameLikelihood == null) {
      return pose.landmarks.where((element) =>
          measurementType.contains(element.type) &&
          element.inFrameLikelihood > 0);
    }
    return pose.landmarks.where((element) =>
        measurementType.contains(element.type) &&
        element.inFrameLikelihood > inFrameLikelihood);
  }

  static DistancesAngle getDistancesAngleByLandmarks(
      Iterable<PoseLandmark> filteredLandmarks,
      DistancesAngleByLandmarksType type) {
    PoseLandmark? leftShoulder;
    PoseLandmark? leftElbow;
    PoseLandmark? leftWrist;
    PoseLandmark? rightShoulder;
    PoseLandmark? rightElbow;
    PoseLandmark? rightWrist;

    for (PoseLandmark poseLandmark in filteredLandmarks) {
      switch (poseLandmark.type) {
        case PoseLandmarkType.leftShoulder:
          leftShoulder = poseLandmark;
          break;
        case PoseLandmarkType.leftElbow:
          leftElbow = poseLandmark;
          break;
        case PoseLandmarkType.leftWrist:
          leftWrist = poseLandmark;
          break;
        case PoseLandmarkType.rightShoulder:
          rightShoulder = poseLandmark;
          break;
        case PoseLandmarkType.rightElbow:
          rightElbow = poseLandmark;
          break;
        case PoseLandmarkType.rightWrist:
          rightWrist = poseLandmark;
          break;
        default:
      }
    }
    return type == DistancesAngleByLandmarksType.left
        ? getDistancesAngle(
            leftShoulder?.position, leftElbow?.position, leftWrist?.position)
        : getDistancesAngle(rightShoulder?.position, rightElbow?.position,
            rightWrist?.position);
  }

  static DistancesAngle getDistancesAngle(Point3d? a, Point3d? b, Point3d? c) {
    if (a == null || b == null || c == null) return DistancesAngle(0, 0, 0);
    // distance between A and B
    double diffXAB = a.x - b.x;
    double diffYAB = a.y - b.y;
    double diffZAB = a.z - b.z;
    double distanceAB =
        sqrt(diffXAB * diffXAB + diffYAB * diffYAB + diffZAB * diffZAB);

    // distance between B and C
    double diffXBC = c.x - b.x;
    double diffYBC = c.y - b.y;
    double diffZBC = c.z - b.z;
    double distanceBC =
        sqrt(diffXBC * diffXBC + diffYBC * diffYBC + diffZBC * diffZBC);

    // distance between 2d position
    double distance2dBC = sqrt(diffXBC * diffXBC + diffYBC * diffYBC);
    double distance2dAB = sqrt(diffXAB * diffXAB + diffYAB * diffYAB);

    // Angle between two vectors
    double angle = acos((diffXAB * diffXBC + diffYAB * diffYBC) /
            (distance2dBC * distance2dAB)) *
        180 /
        pi;
    return DistancesAngle(distanceAB, distanceBC, angle);
  }

  static double getERAngle({required Point3d? wrist, required Point3d? elbow}) {
    if (elbow == null || wrist == null) return 0;
    var vector1 = Vector.fromList(
        [wrist.x - elbow.x, wrist.y - elbow.y, wrist.z - elbow.z]);
    var vector2 = Vector.fromList([0, 0, -1]);
    var cosTheta = vector1.dot(vector2) / (vector1.norm() * vector2.norm());
    return acos(cosTheta) * 180 / pi;
  }

  static double getABDAngle(
      {required Point3d? wrist, required Point3d? shoulder}) {
    if (wrist == null || shoulder == null) return 0;
    var vector1 = Vector.fromList(
        [wrist.x - shoulder.x, wrist.y - shoulder.y, wrist.z - shoulder.z]);
    var vector2 = Vector.fromList([0, 1, 0]);
    var cosTheta = vector1.dot(vector2) / (vector1.norm() * vector2.norm());
    return acos(cosTheta) * 180 / pi;
  }

  static double getFFAngle(
      {required Point3d? wrist, required Point3d? shoulder}) {
    if (wrist == null || shoulder == null) return 0;
    var vector1 = Vector.fromList(
        [wrist.x - shoulder.x, wrist.y - shoulder.y, wrist.z - shoulder.z]);
    var vector2 = Vector.fromList([0, 1, 0]);
    var cosTheta = vector1.dot(vector2) / (vector1.norm() * vector2.norm());
    return acos(cosTheta) * 180 / pi;
  }

  static double getIRAngle({required Point3d? wrist, required Point3d? elbow}) {
    if (wrist == null || elbow == null) return 0;
    var vector1 = Vector.fromList(
        [wrist.x - elbow.x, wrist.y - elbow.y, wrist.z - elbow.z]);
    var vector2 = Vector.fromList([0, 1, 0]);
    var cosTheta = vector1.dot(vector2) / (vector1.norm() * vector2.norm());
    return acos(cosTheta) * 180 / pi;
  }

  static Iterable<PoseLandmark> posesToAvgPose(List<Pose> poses) {
    List<PoseLandmark> landmarks = [];
    landmarks.add(getTargetLandmarkAvg(poses, PoseLandmarkType.leftShoulder));
    landmarks.add(getTargetLandmarkAvg(poses, PoseLandmarkType.leftElbow));
    landmarks.add(getTargetLandmarkAvg(poses, PoseLandmarkType.leftWrist));
    landmarks.add(getTargetLandmarkAvg(poses, PoseLandmarkType.rightShoulder));
    landmarks.add(getTargetLandmarkAvg(poses, PoseLandmarkType.rightElbow));
    landmarks.add(getTargetLandmarkAvg(poses, PoseLandmarkType.rightWrist));
    return landmarks;
  }

  static PoseLandmark getTargetLandmarkAvg(
      List<Pose> poses, PoseLandmarkType type) {
    List<PoseLandmark> targetLandmarks = [];
    for (var pose in poses) {
      for (var target
          in pose.landmarks.where((landmark) => landmark.type == type)) {
        targetLandmarks.add(target);
      }
    }
    double likelihoodAvg = getLikelihoodAvg(targetLandmarks);
    double xAvg = getXAvg(targetLandmarks);
    double yAvg = getYAvg(targetLandmarks);
    double zAvg = getZAvg(targetLandmarks);
    Point3d pointAvg = Point3d(x: xAvg, y: yAvg, z: zAvg);
    return PoseLandmark(
        inFrameLikelihood: likelihoodAvg, position: pointAvg, type: type);
  }

  static double getLikelihoodAvg(List<PoseLandmark> targetLandmarks) {
    return targetLandmarks
            .map((e) => e.inFrameLikelihood)
            .reduce((value, element) => value + element) /
        targetLandmarks.length;
  }

  static double getXAvg(List<PoseLandmark> targetLandmarks) {
    return targetLandmarks
            .map((e) => e.position.x)
            .reduce((value, element) => value + element) /
        targetLandmarks.length;
  }

  static double getYAvg(List<PoseLandmark> targetLandmarks) {
    return targetLandmarks
            .map((e) => e.position.y)
            .reduce((value, element) => value + element) /
        targetLandmarks.length;
  }

  static double getZAvg(List<PoseLandmark> targetLandmarks) {
    return targetLandmarks
            .map((e) => e.position.z)
            .reduce((value, element) => value + element) /
        targetLandmarks.length;
  }
}
