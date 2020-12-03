import 'dart:io';

String fixture(String fileName) =>
    File('./test/core/fixtures/$fileName').readAsStringSync();
