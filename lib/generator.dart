import 'package:scarabei/api/files/file.dart';
import 'package:scarabei/api/files/files_list.dart';
import 'package:scarabei/api/log/logger.dart';
import 'package:scarabei/api/path/relative_path.dart';
import 'package:scarabei/api/utils/utils.dart';

class ExportFilesGenerator {
  static final String PUBSEC = "pubspec.yaml";
  static final String N = "\n";
  static final String R = "\r";

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
//    L.d("       ", pubsec);

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
//    postfix = postfix.splitAt(prefix.size() + 1);// lib
      final RelativePath split = Utils.newRelativePath(path_steps: postfix);
// import 'package:van_mobile_api/van_mobile_api.dart'
      final String fileName = split.getLastStep();
      if (fileName == ("main.dart")) {
        continue;
      }
      if (fileName == (exportFile.getName())) {
        continue;
      }
      exportFileContent.add("export 'package:" + name + RelativePath.SEPARATOR + split.toString() + "';");
      exportFileContent.add(N);

// L.d("split", split);
    }
// L.d(exportFileContent);
    L.d("writing", exportFile);
    String data = exportFileContent.join("");

//    L.d("       ", data);
        exportFile.writeString(data);
    L.d("");
  }
}
