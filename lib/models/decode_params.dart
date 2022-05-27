import 'dart:io';
import 'dart:isolate';

class DecodeParams {
  final File source;
  final File destination;
  final SendPort port;

  DecodeParams({
    required this.source,
    required this.destination,
    required this.port,
  });
}
