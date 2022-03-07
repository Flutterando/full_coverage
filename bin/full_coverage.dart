import 'dart:io';

import 'package:args/args.dart';
import 'package:full_coverage/full_coverage.dart';

void main(List<String> args) async {
  var parser = ArgParser();

  parser.addOption('ignore', abbr: 'i', help: 'Ignore files. ex (*_widget.dart,*_page.dart).');
  parser.addFlag('help', abbr: 'h', help: 'usage doc.');

  final fullCoverage = FullCoverage();

  var results = parser.parse(args);

  if (results['help'] == true) {
    print(parser.usage);
    exit(0);
  }

  final ignoreFile = results['ignore'] == null ? [] : results['ignore'].split(',').map((e) => e.trim()).toList();

  await fullCoverage.execute(
    '',
    ignoreFiles: [
      'generated_plugin_registrant.dart',
      ...ignoreFile,
    ],
  );
}
