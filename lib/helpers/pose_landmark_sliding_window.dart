import 'dart:collection';

import 'package:rainbow/models/point3d.dart';
import 'package:rainbow/models/pose_landmark.dart';

class PoseLandmarkSlidingWindow {
  final _maxQueueSize = 3;
  final Queue<PoseLandmark> queue = Queue();

  double xSum = 0;
  double ySum = 0;
  double zSum = 0;
  double inFrameLikelihoodSum = 0;

  PoseLandmarkSlidingWindow();

  bool get isEmpty {
    return queue.isEmpty || queue.length <= _maxQueueSize;
  }

  PoseLandmark? run(PoseLandmark landmark) {
    queue.addLast(landmark);
    xSum += landmark.position.x;
    ySum += landmark.position.y;
    zSum += landmark.position.z;
    inFrameLikelihoodSum += landmark.inFrameLikelihood;

    if (!isEmpty) {
      PoseLandmark poll = queue.removeFirst();
      xSum -= poll.position.x;
      ySum -= poll.position.y;
      zSum -= poll.position.z;
      inFrameLikelihoodSum -= poll.inFrameLikelihood;

      double xAvg = xSum / _maxQueueSize;
      double yAvg = ySum / _maxQueueSize;
      double zAvg = zSum / _maxQueueSize;
      double inFrameLikelihoodAvg = inFrameLikelihoodSum / _maxQueueSize;
      Point3d point3dAvg = Point3d(x: xAvg, y: yAvg, z: zAvg);
      return PoseLandmark(
          inFrameLikelihood: inFrameLikelihoodAvg,
          position: point3dAvg,
          type: landmark.type);
    }
    return null;
  }
}
