// Copyright (c) 2017, JCode. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
import 'package:export_files_generator/generator.dart';
import 'package:scarabei/scarabei.dart';
import 'package:scarabei_reyer/scarabei_reyer.dart';

main(List<String> arguments) {

  _setup();
  File root = LocalFileSystem.ApplicationHome();
  if (arguments.length > 0) {
    String targetFolderPath = arguments[0];
    root = LocalFileSystem.newLocalFile(targetFolderPath);
  }

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
