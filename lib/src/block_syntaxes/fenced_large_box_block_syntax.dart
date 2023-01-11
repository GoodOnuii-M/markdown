import '../patterns.dart';
import 'fenced_box_block_syntax.dart';

class FencedLargeBoxBlockSyntax extends FencedBoxBlockSyntax {
  FencedLargeBoxBlockSyntax();

  @override
  RegExp get pattern => largeBoxFencePattern;
}
