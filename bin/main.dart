// Copyright (c) 2017, JCode. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
import 'package:export_files_generator/generator.dart';
import 'package:scarabei/api/debug/debug.dart';
import 'package:scarabei/api/error/err.dart';
import 'package:scarabei/api/files/file.dart';
import 'package:scarabei/api/files/local_file_system.dart';
import 'package:scarabei/api/log/logger.dart';
import 'package:scarabei/api/strings/strings.dart';
import 'package:scarabei/api/sys/execution_mode.dart';
import 'package:scarabei/api/sys/settings/system_settings.dart';
import 'package:scarabei/api/sys/sys.dart';
import 'package:scarabei/api/utils/utils.dart';
import 'package:scarabei_reyer/red-desktop/sys/red_desktop_system.dart';
import 'package:scarabei_reyer/red-desktop/sys/settings/red_system_settings.dart';
import 'package:scarabei_reyer/red/debug/red_debug.dart';
import 'package:scarabei_reyer/red/error/red_error.dart';
import 'package:scarabei_reyer/red/files/posix/unix_file_system.dart';
import 'package:scarabei_reyer/red/files/win/win_file_system.dart';
import 'package:scarabei_reyer/red/log/simple_logger.dart';
import 'package:scarabei_reyer/red/strings/red_strings.dart';
import 'package:scarabei_reyer/red/utils/red_utils.dart';

main(List<String> arguments) {
//  print('Hello world: ${export_files_generator.calculate()}!');

  _setup();

  String targetFolderPath = arguments[0];
  File root = LocalFileSystem.newLocalFile(targetFolderPath);
  if (!root.exists()) {
    Err.reportError("Folder not found: $root");
    Sys.exit();
  }

  ExportFilesGenerator.generate(root);
}

void _setup() {
  L.installComponent(new SimpleLogger());
  Err.installComponent(new RedError());
  Debug.installComponent(new RedDebug());
  Utils.installComponent(new RedUtils());
  Strings.installComponent(new RedStrings());
  Sys.installComponent(new DesktopSystem());
  SystemSettings.installComponent(new RedSystemSettings());

  if (Sys.isUnix()) {
    LocalFileSystem.installComponent(new UnixFileSystem());
  } else {
    LocalFileSystem.installComponent(new WinFileSystem());
  }
  SystemSettings.setExecutionMode(ExecutionMode.DEMO);
}
