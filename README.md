# full_coverage

Coverage tools like codecov only see the files that were actually triggered by tests. This means that a coverage of 100% can easily be a lie, e.g. you can just write a dummy test that does not import any files and a coverage tool will ignore all the code base.

Luckily, this package resolves this problem.

## How it works

The **full_coverage** package harvests the power of Bash to find all files in specified directory, by default it is lib directory, where all Flutter files are. It then creates a dummy test file **test/full_coverage_test.dart** that imports all the Dart files that were found and has an empty ```void main() {}``` function so that it actually starts.

## Install

Use this command:
```dart
dart pub global activate full_coverage
```

## Execute

Use the command:
``` 
dart pub global run full_coverage
```

Or add the cache-system to your PATH environment variable for run directly.
[Check documentation](https://dart.dev/tools/pub/cmd/pub-global#running-a-script-from-your-path) for more;

```
full_coverage
```

For more details [Telegram Group Flutterando](https://t.me/flutterando).

