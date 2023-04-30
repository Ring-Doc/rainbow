import 'package:matrix2d/matrix2d.dart';
import 'package:rainbow/models/point3d.dart';
import 'package:rainbow/models/pose_landmark.dart';

// Apply Kalman filter to the pose landmark
class PoseLandmarkKalman {
  late List<List<double>> stateList;
  // = [[0.0, 0.0, 0.0]]

  List<List<double>> covarianceMatrix = [
    [1.0, 0.0, 0.0],
    [0.0, 1.0, 0.0],
    [0.0, 0.0, 1.0]
  ];

  List<List<double>> transitionMatrix = [
    [1.0, 0.0, 0.0],
    [0.0, 1.0, 0.0],
    [0.0, 0.0, 1.0]
  ];

  List<List<double>> processNoiseCovarianceMatrix = [
    [0.1, 0.0, 0.0],
    [0.0, 0.1, 0.0],
    [0.0, 0.0, 0.1]
  ];

  List<List<double>> observationCovarianceMatrix = [
    [1.0, 0.0, 0.0],
    [0.0, 1.0, 0.0],
    [0.0, 0.0, 1.0]
  ];

  // PoseLandmarkKalman(PoseLandmark landmark) {
  //   stateList = [[landmark.position.x, landmark.position.y, landmark.position.z]];
  // }
  PoseLandmarkKalman(this.stateList);

  // PoseLandmarkKalman -> predict -> calculateKalmanGain(landmark)
  //  -> predict -> calculateKalmanGain(landmark) -> getStatePoint()

  PoseLandmark getStatePoint(PoseLandmark landmark) {
    predict();
    calculateKalmanGain(landmark);

    return PoseLandmark(
        inFrameLikelihood: landmark.inFrameLikelihood,
        position:
            Point3d(x: stateList[0][0], y: stateList[0][1], z: stateList[0][2]),
        type: landmark.type);
  }

  // calculate the predicted state
  void predict() {
    Matrix2d np = const Matrix2d();

    // calculate the predicted state
    var predictedState = np.dot(transitionMatrix, stateList);

    // calculate the predicted covariance
    var predictedCovariance = np.addition(
        np.dot(np.dot(transitionMatrix, covarianceMatrix),
            transitionMatrix.transpose),
        processNoiseCovarianceMatrix);

    // update the state list
    stateList = predictedState.cast<List<double>>();

    // update the covariance matrix
    covarianceMatrix = predictedCovariance.cast();
  }

  // calculate the Kalman gain
  void calculateKalmanGain(PoseLandmark landmark) {
    Matrix2d np = const Matrix2d();

    // make a list of the observation state
    var observationState = [
      landmark.position.x,
      landmark.position.y,
      landmark.position.z,
    ];

    // calculate the kalman gain
    var predictedValue = np.dot(
        np.dot(observationState, covarianceMatrix), observationState.transpose);

    var kalmanGain = np.division(predictedValue,
        np.addition(predictedValue, observationCovarianceMatrix));

    // update the state list
    stateList = np
        .addition(
            stateList,
            np.dot(
                kalmanGain,
                np.subtraction(
                    observationState, np.dot(observationState, stateList))))
        .cast<List<double>>();

    // update the covariance matrix
    covarianceMatrix = np
        .subtraction(covarianceMatrix,
            np.dot(np.dot(kalmanGain, observationState), covarianceMatrix))
        .cast<List<double>>();
  }
}
