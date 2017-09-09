Recursively scans target folder for Dart projects (identifiable by `pubsec.yaml` file) and creates export files.

# main
```Dart
main(List<String> arguments) {
  ...
  File root = LocalFileSystem.ApplicationHome();
  if (arguments.length > 0) {
    String targetFolderPath = arguments[0]; //argument containing target folder path
    root = LocalFileSystem.newLocalFile(targetFolderPath);
  }

  if (!root.exists()) {
    Err.reportError("Folder not found: $root");
    Sys.exit();
  }

  ExportFilesGenerator.generate(root);
}
```

# the code
```Dart
static void generate(File root) {
    FileFilter pubsecFilter = (file) => file.getName() == PUBSEC;

    FilesList pubsecFiles = root.listAllChildren(fileFilter: pubsecFilter);

    for (File pubsec in pubsecFiles.toList()) {
      processProject(pubsec);
    }
  }

  static void processProject(File pubsec) {
    File project_root = pubsec.parent();
    String pubsecData = pubsec.readString();
    final String name = pubsecData.split(N)[0].replaceAll("name: ", "").replaceAll(N, "").replaceAll(R, "");
    L.d("project", project_root);
    L.d("   name", name);

    final File lib = project_root.child("lib");
    final File exportFile = lib.child(name + ".dart");

    FileFilter dartFilter = (file) => file.extensionIs("dart");

    final FilesList dartFiles = lib.listAllChildren(fileFilter: dartFilter);
    final List<String> exportFileContent = [];
    final RelativePath prefix = project_root.getAbsoluteFilePath().getRelativePath();
    for (final File dart in dartFiles.toList()) {
      final RelativePath dart_prefix = dart.getAbsoluteFilePath().getRelativePath();
      List<String> postfix = dart_prefix.steps();
      postfix = postfix.sublist(prefix.size() + 1, postfix.length); //lib
      final RelativePath split = Utils.newRelativePath(path_steps: postfix);
      final String fileName = split.getLastStep();
      if (fileName == ("main.dart")) {
        continue;
      }
      if (fileName == (exportFile.getName())) {
        continue;
      }
      exportFileContent.add("export 'package:" + name + RelativePath.SEPARATOR + split.toString() + "';");
      exportFileContent.add(N);

    }
    L.d("writing", exportFile);
    String data = exportFileContent.join("");

    exportFile.writeString(data);
    L.d("");
  }

```