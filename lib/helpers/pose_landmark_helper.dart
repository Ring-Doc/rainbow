import 'package:rainbow/models/pose.dart';
import 'package:rainbow/models/pose_landmark.dart';
import 'package:rainbow/models/pose_landmark_helper_type.dart';
import 'package:rainbow/models/pose_landmark_type.dart';
import 'package:rainbow/helpers/pose_landmark_kalman_filter.dart';
import 'package:rainbow/helpers/pose_landmark_sliding_window.dart';

class PoseLandmarkHelper {
  PoseLandmarkHelperType helperType;
  final PoseLandmarkSlidingWindow _swRightShoulder =
      PoseLandmarkSlidingWindow();
  final PoseLandmarkSlidingWindow _swLeftShoulder = PoseLandmarkSlidingWindow();
  final PoseLandmarkSlidingWindow _swRightWrist = PoseLandmarkSlidingWindow();
  final PoseLandmarkSlidingWindow _swLeftWrist = PoseLandmarkSlidingWindow();
  final PoseLandmarkSlidingWindow _swRightElbow = PoseLandmarkSlidingWindow();
  final PoseLandmarkSlidingWindow _swLeftElbow = PoseLandmarkSlidingWindow();

  final PoseLandmarkKalman _kRightShoulder = PoseLandmarkKalman([
    [0.0, 0.0, 0.0]
  ]);
  final PoseLandmarkKalman _kLeftShoulder = PoseLandmarkKalman([
    [0.0, 0.0, 0.0]
  ]);
  final PoseLandmarkKalman _kRightWrist = PoseLandmarkKalman([
    [0.0, 0.0, 0.0]
  ]);
  final PoseLandmarkKalman _kLeftWrist = PoseLandmarkKalman([
    [0.0, 0.0, 0.0]
  ]);
  final PoseLandmarkKalman _kRightElbow = PoseLandmarkKalman([
    [0.0, 0.0, 0.0]
  ]);
  final PoseLandmarkKalman _kLeftElbow = PoseLandmarkKalman([
    [0.0, 0.0, 0.0]
  ]);

  PoseLandmarkHelper(this.helperType);

  Pose exec(Pose pose) {
    final List<PoseLandmark> resultLandmarks = [];
    for (PoseLandmark landmark in pose.landmarks) {
      switch (landmark.type) {
        case PoseLandmarkType.leftShoulder:
          if (helperType == PoseLandmarkHelperType.slidingWindow) {
            var result = _swLeftShoulder.run(landmark);
            if (result == null) continue;
            resultLandmarks.add(result);
          } else if (helperType == PoseLandmarkHelperType.kalman) {
            resultLandmarks.add(_kLeftShoulder.getStatePoint(landmark));
          }
          break;
        case PoseLandmarkType.rightShoulder:
          if (helperType == PoseLandmarkHelperType.slidingWindow) {
            var result = _swRightShoulder.run(landmark);
            if (result == null) continue;
            resultLandmarks.add(result);
          } else if (helperType == PoseLandmarkHelperType.kalman) {
            resultLandmarks.add(_kRightShoulder.getStatePoint(landmark));
          }
          break;
        case PoseLandmarkType.rightWrist:
          if (helperType == PoseLandmarkHelperType.slidingWindow) {
            var result = _swRightWrist.run(landmark);
            if (result == null) continue;
            resultLandmarks.add(result);
          } else if (helperType == PoseLandmarkHelperType.kalman) {
            resultLandmarks.add(_kRightWrist.getStatePoint(landmark));
          }
          break;
        case PoseLandmarkType.rightElbow:
          if (helperType == PoseLandmarkHelperType.slidingWindow) {
            var result = _swRightElbow.run(landmark);
            if (result == null) continue;
            resultLandmarks.add(result);
          } else if (helperType == PoseLandmarkHelperType.kalman) {
            resultLandmarks.add(_kRightElbow.getStatePoint(landmark));
          }
          break;
        case PoseLandmarkType.leftWrist:
          if (helperType == PoseLandmarkHelperType.slidingWindow) {
            var result = _swLeftWrist.run(landmark);
            if (result == null) continue;
            resultLandmarks.add(result);
          } else if (helperType == PoseLandmarkHelperType.kalman) {
            resultLandmarks.add(_kLeftWrist.getStatePoint(landmark));
          }
          break;
        case PoseLandmarkType.leftElbow:
          if (helperType == PoseLandmarkHelperType.slidingWindow) {
            var result = _swLeftElbow.run(landmark);
            if (result == null) continue;
            resultLandmarks.add(result);
          } else if (helperType == PoseLandmarkHelperType.kalman) {
            resultLandmarks.add(_kLeftElbow.getStatePoint(landmark));
          }
          break;
        default:
      }
    }
    return Pose(landmarks: resultLandmarks);
  }
}
