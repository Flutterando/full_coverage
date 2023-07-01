import 'dart:io';

import 'package:path/path.dart';

class FullCoverage {
  bool _hasNotPartOfImport(FileSystemEntity file) {
    if (file is! File) {
      return false;
    }
    final lines = file.readAsStringSync().split('\n');
    for (var line in lines) {
      if (RegExp('part of [\'"].+[\'"];').hasMatch(line)) {
        return false;
      }
    }

    return true;
  }

  bool notIgnoreFiles(FileSystemEntity file, {List<String> ignoreFiles = const []}) {
    final name = basename(file.path);

    for (var ignore in ignoreFiles) {
      final expression = '^${ignore.replaceAll('*', '(.*)?')}\$';
      if (RegExp(expression).hasMatch(name)) {
        return false;
      }
    }

    return true;
  }

  Future<void> execute(String workDir, {List<String> ignoreFiles = const []}) async {
    final slash = Platform.pathSeparator;

    workDir = workDir.isEmpty ? workDir : '$workDir$slash';

    final testFile = File('${workDir}test${slash}full_coverage_test.dart');
    final dir = Directory('${workDir}lib');
    final name = File('${workDir}pubspec.yaml').readAsStringSync().split('\n').first.replaceFirst('name: ', '').trim();

    final filter = await dir
        .list(recursive: true)
        .where((event) => event is File)
        .where((event) => event.path.endsWith('.dart'))
        .where(_hasNotPartOfImport)
        .where((event) => notIgnoreFiles(event, ignoreFiles: ignoreFiles))
        .toList();

    filter.sort((a, b) => a.path.compareTo(b.path));

    final importList = <String>[];

    for (var item in filter) {
      var path = 'import \'${item.path.replaceFirst('lib', 'package:$name')}\';';
      path = path.replaceAll(r'\', '/');
      importList.add(path);
    }

    final buffer = StringBuffer();
    buffer.writeln('// ignore_for_file: unused_import, no-empty-block');

    for (var item in importList) {
      buffer.writeln(item);
    }

    buffer.writeln();
    buffer.writeln('void main() {}');

    if (testFile.existsSync()) {
      testFile.deleteSync();
    }
    testFile.createSync(recursive: true);

    testFile.writeAsStringSync(buffer.toString());
  }
}
