import 'dart:io';

import 'package:full_coverage/src/full_coverage_base.dart';
import 'package:test/test.dart';

void main() {
  test('ignoreFiles', () async {
    final fullCoverage = FullCoverage();

    var result = fullCoverage.notIgnoreFiles(File('lib/src/test_remove.dart'), ignoreFiles: ['*_remove.dart']);
    expect(result, false);

    result = fullCoverage.notIgnoreFiles(File('lib/src/test_remove2.dart'), ignoreFiles: ['*_remove.dart']);
    expect(result, true);

    result = fullCoverage.notIgnoreFiles(File('lib/src/test_remove2.dart'), ignoreFiles: ['test_remove2.dart']);
    expect(result, false);
  });
}
