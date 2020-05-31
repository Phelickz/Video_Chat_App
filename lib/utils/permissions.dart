

import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/services.dart';


class Permissions {

    Future<bool> cameraAndMicrophonePermissionsGranted() async {
    PermissionStatus cameraPermissionStatus = await _getCameraPermission();
    PermissionStatus microphonePermissionStatus =
        await _getMicrophonePermission();

    if (cameraPermissionStatus == PermissionStatus.granted &&
        microphonePermissionStatus == PermissionStatus.granted) {
      return true;
    } else {
      _handleInvalidPermissions(
          cameraPermissionStatus, microphonePermissionStatus);
      return false;
    }
  }

    Future<PermissionStatus> _getCameraPermission() async {
      final permission = Permission.camera;
    PermissionStatus status =
        await permission.status;
    if (status != PermissionStatus.granted) {
      final permissionStatus =
          (await permission
              .request());
      return permissionStatus ??
          PermissionStatus.undetermined;
    } else {
      return status;
    }
  }

    Future<PermissionStatus> _getMicrophonePermission() async {
      final permission = Permission.microphone;
    PermissionStatus status = await permission
        .status;
    if (status != PermissionStatus.granted) {
      final permissionStatus =
          await permission
              .request();
      return permissionStatus ??
          PermissionStatus.undetermined;
    } else {
      return status;
    }
  }

    void _handleInvalidPermissions(
    PermissionStatus cameraPermissionStatus,
    PermissionStatus microphonePermissionStatus,
  ) {
    if (cameraPermissionStatus == PermissionStatus.denied &&
        microphonePermissionStatus == PermissionStatus.denied) {
      throw new PlatformException(
          code: "PERMISSION_DENIED",
          message: "Access to camera and microphone denied",
          details: null);
    } else if (cameraPermissionStatus == PermissionStatus.denied &&
        microphonePermissionStatus == PermissionStatus.denied) {
      throw new PlatformException(
          code: "PERMISSION_DISABLED",
          message: "Location data is not available on device",
          details: null);
    }
  }
}