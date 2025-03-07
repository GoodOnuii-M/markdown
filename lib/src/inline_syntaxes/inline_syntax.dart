// Copyright (c) 2022, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../inline_parser.dart';
import '../util.dart';

/// Represents one kind of Markdown tag that can be parsed.
/// 설명 - 1줄 단위로 파싱을 하기 위한 문법(syntax)
abstract class InlineSyntax {
  final RegExp pattern;

  /// The first character of [pattern], to be used as an efficient first check
  /// that this syntax matches the current parser position.
  final int? _startCharacter;

  /// Create a new [InlineSyntax] which matches text on [pattern].
  ///
  /// If [startCharacter] is passed, it is used as a pre-matching check which
  /// is faster than matching against [pattern].
  ///
  /// If [caseSensitive] is disabled, then case is ignored when matching
  /// the [pattern].
  InlineSyntax(String pattern, {int? startCharacter, bool caseSensitive = true})
      : pattern =
            RegExp(pattern, multiLine: true, caseSensitive: caseSensitive),
        _startCharacter = startCharacter;

  /// Tries to match at the parser's current position.
  ///
  /// The parser's position can be overriden with [startMatchPos].
  /// Returns whether or not the pattern successfully matched.
  /// 설명 - 현재 위치의 파서를 처리하려고 한다. 
  bool tryMatch(InlineParser parser, [int? startMatchPos]) {
    startMatchPos ??= parser.pos;

    // Before matching with the regular expression [pattern], which can be
    // expensive on some platforms, check if even the first character matches
    // this syntax.
    if (_startCharacter != null &&
        parser.source.codeUnitAt(startMatchPos) != _startCharacter) {
      return false;
    }

    final startMatch = pattern.matchAsPrefix(parser.source, startMatchPos);
    if (startMatch == null) return false;

    // Write any existing plain text up to this point.
    // 설명 - 현재까지 파싱처리된 문자열들을 '트리'에 저장한다. '트리'는 어떻게 문자열을 처리할지를 담은 노드이다.
    parser.writeText();

    if (onMatch(parser, startMatch)) parser.consume(startMatch.match.length);
    return true;
  }

  /// Processes [match], adding nodes to [parser] and possibly advancing
  /// [parser].
  ///
  /// Returns whether the caller should advance [parser] by `match[0].length`.
  bool onMatch(InlineParser parser, Match match);
}
