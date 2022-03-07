import 'dart:io';

class FullCoverage {
  static Future<void> execute(String workDir) async {
    final slash = Platform.pathSeparator;

    workDir = workDir.isEmpty ? workDir : '$workDir$slash';

    final testFile = File('${workDir}test${slash}full_coverage_test.dart');
    final dir = Directory('${workDir}lib');
    final name = File('${workDir}pubspec.yaml').readAsStringSync().split('\n').first.replaceFirst('name: ', '').trim();

    final filter = dir.list(recursive: true).where((event) => event is File).where((event) => event.path.endsWith('.dart'));

    final importList = <String>[];

    await for (var item in filter) {
      var path = 'import \'${item.path.replaceFirst('lib', 'package:$name')}\';';
      path = path.replaceAll(r'\', '/');
      importList.add(path);
    }

    final buffer = StringBuffer();

    for (var item in importList) {
      buffer.writeln('// ignore: unused_import');
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
