// Copyright (c) 2022, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import './fenced_tex_block_syntax.dart';

import '../ast.dart';
import '../block_parser.dart';
import '../patterns.dart';

class FencedLargeTexBlockSyntax extends FencedTexBlockSyntax {
  const FencedLargeTexBlockSyntax();

  @override
  Node parse(BlockParser parser) {
    /// canParse 조건을 만족한 라인 매치 결과
    final match = pattern.firstMatch(parser.current.content)!;

    /// 캡처그룹 1번 ($)
    final endBlock = match.group(1);

    /// 블록 하위 문장리스트
    final childLines = parseChildLines(parser, endBlock);

    /// 하나의 문장으로 합침
    final text = childLines.join();

    /// tex 엘리먼트를 포함한 블록 엘리먼트
    final element = Element.text('texblock', text)
      ..attributes['type'] = 'large';

    return element;
  }

  @override
  RegExp get pattern => largeTexFencePattern;
}
