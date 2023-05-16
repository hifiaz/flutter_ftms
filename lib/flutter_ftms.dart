library flutter_ftms;

import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_ftms/src/bluetooth.dart';
import 'package:flutter_ftms/src/ftms/characteristic/data/ftms_data.dart';
import 'package:flutter_ftms/src/ftms/characteristic/feature/ftms_feature.dart';
import 'package:flutter_ftms/src/ftms/characteristic/status/ftms_machine_status.dart';
import 'package:flutter_ftms/src/ftms_bluetooth.dart';

export 'src/ftms/characteristic/data/ftms_data.dart'
    show FTMSData, FTMSDataType;
export 'src/ftms/characteristic/data/ftms_data_parameter.dart'
    show FTMSDataParameter;
export 'src/ftms/characteristic/data/ftms_data_parameter_value.dart'
    show FTMSDataParameterValue;
export 'src/ftms/characteristic/data/ftms_data_flag.dart' show FTMSDataFlag;
export 'src/ftms/characteristic/data/ftms_data_parameter_name.dart'
    show FTMSDataParameterName;

export 'src/ftms/characteristic/data/device/cross_trainer.dart'
    show CrossTrainer;
export 'src/ftms/characteristic/data/device/indoor_bike.dart' show IndoorBike;
export 'src/ftms/characteristic/data/device/treadmill.dart' show Treadmill;
export 'src/ftms/characteristic/data/device/rower.dart' show Rower;

export 'src/ftms/characteristic/feature/ftms_feature.dart' show FTMSFeature;
export 'src/ftms/characteristic/feature/ftms_feature_flag.dart'
    show FTMSFeatureFlag;

export 'src/ftms/characteristic/status/ftms_machine_status.dart'
    show FTMSMachineStatus;
export 'src/ftms/characteristic/status/ftms_machine_status_opcode.dart'
    show FTMSMachineStatusOpcode;
export 'src/ftms/characteristic/status/ftms_machine_status_parameter_value.dart'
    show FTMSMachineStatusParameterValue;

export 'package:flutter_blue_plus/flutter_blue_plus.dart'
    show BluetoothDevice, BluetoothDeviceState, ScanResult;

class FTMS {
  static Stream<bool> get isScanning => Bluetooth.isScanningStream;
  static Stream<List<ScanResult>> get scanResults =>
      Bluetooth.scanResultsStream;

  static Future<void> scanForBluetoothDevices() async {
    await Bluetooth.scanForBluetoothDevices();
  }

  static Future<void> connectToFTMSDevice(BluetoothDevice device) async {
    await Bluetooth.connectToBluetoothDevice(device);
  }

  static Future<void> disconnectFromFTMSDevice(BluetoothDevice device) async {
    await Bluetooth.disconnectFromBluetoothDevice(device);
  }

  static Future<bool> isBluetoothDeviceFTMSDevice(
      BluetoothDevice device) async {
    return FTMSBluetooth.isBluetoothDeviceFTMSDevice(device);
  }

  static Future<void> useDataCharacteristic(
      BluetoothDevice device, void Function(FTMSData) onData) async {
    var dataType = await getFTMSDeviceType(device);
    if (dataType == null) return;

    var service = await FTMSBluetooth.getFTMSService(device);
    if (service == null) return;

    await FTMSBluetooth.useDataCharacteristic(service, dataType, onData);
  }

  static Future<void> useMachineStatusCharacteristic(
      BluetoothDevice device, void Function(FTMSMachineStatus) onData) async {
    var dataType = await getFTMSDeviceType(device);
    if (dataType == null) return;

    var service = await FTMSBluetooth.getFTMSService(device);
    if (service == null) return;

    await FTMSBluetooth.useMachineStatusCharacteristic(service, onData);
  }

  static Future<FTMSDataType?> getFTMSDeviceType(BluetoothDevice device) async {
    var service = await FTMSBluetooth.getFTMSService(device);
    if (service == null) {
      print("No FTMS Service found!");
      return null;
    }

    return FTMSBluetooth.getFTMSDataType(service);
  }

  static String convertFTMSDataTypeToString(FTMSDataType dataType) {
    switch (dataType) {
      case FTMSDataType.crossTrainer:
        return "Cross Trainer";
      case FTMSDataType.indoorBike:
        return "Indoor Bike";
      case FTMSDataType.treadmill:
        return "Treadmill";
      case FTMSDataType.rower:
        return "Rower";
    }

    // ignore: dead_code
    throw 'FTMSDataType $dataType does not exists';
  }

  static Future<FTMSFeature?> readFeatureCharacteristic(
      BluetoothDevice device) async {
    var service = await FTMSBluetooth.getFTMSService(device);
    if (service == null) {
      print("No FTMS Service found!");
      return null;
    }

    return await FTMSBluetooth.readFeatureCharacteristic(service);
  }
}
