import 'package:markdown/markdown.dart';

class FencedBoxBlockSyntax extends BlockSyntax {
  FencedBoxBlockSyntax();

  @override
  RegExp get pattern => boxFencePattern;
  // late final fencePattern = pattern == boxFencePattern
  //     ? RegExp(r'^(\:{3,})(.*)$')
  //     : RegExp(r'^(\:{4,})(.*)$');
  late final fencePattern = RegExp(r'^(\:{3,})(.*)$');

  @override
  List<Line?> parseChildLines(BlockParser parser, [String? endBlock]) {
    endBlock ??= '';

    /// 블록 하위 문장 리스트
    final childLines = <Line>[];

    /// 포지션을 다음 라인으로 이동시키기
    parser.advance();

    /// 파싱이 끝날때까지
    while (!parser.isDone) {
      /// 현재 라인에 같은 패턴이 존재하는 확인
      final match = fencePattern.firstMatch(parser.current.content);

      /// 같은 패턴이 존재하지 않거나 :::으로 시작하지 않는다
      if (match == null || !match[1]!.startsWith(endBlock)) {
        /// 하위 문장리스트에 삽입
        childLines.add(parser.current);

        /// 다음 라인으로 이동
        parser.advance();
      } else {
        /// 다음 라인으로 이동
        parser.advance();
        break;
      }
    }

    /// 블록 하위 문장리스트 리턴
    return childLines;
  }

  @override
  Node parse(BlockParser parser) {
    final element = Element('boxedblock', []);

    /// canParse 조건을 만족한 라인 매치 결과
    final match = pattern.firstMatch(parser.current.content)!;

    /// 박스 블록 끝 문자열 :::
    final endBlock = match.group(1);

    /// 박스 정보 문자열
    final boxInfo = match.group(2) ?? '';

    /// 박스 타입 boxed | checked | voca
    final boxType = boxInfo;

    /// 박스 라벨 [label]
    final label = (match.groupCount < 3 ? null : match.group(3)) ?? '';
    final parsedChildlines = parseChildLines(parser, endBlock);

    final childrenLines = parsedChildlines
        .where((element) => element != null)
        .cast<Line>()
        .toList();

    final nodes = BlockParser(childrenLines, parser.document).parseLines();

    if (boxType == 'checked') {
      /// 첫번재 h1 인덱스
      final titleH1Index = nodes
          .indexWhere((element) => element is Element && element.tag == 'h1');

      /// 첫번째 h1이 존재한다면
      if (titleH1Index != -1) {
        final titleH1 = nodes[titleH1Index];

        /// nodes에서 삭제가 성공하면
        if (nodes.remove(titleH1)) {
          /// checked 블록의 타이틀을 첫번재 h1의 text로 설정
          element.attributes['title'] = titleH1.textContent;
        }
      }
    } else if (boxType == 'voca') {
      // 다른 box 문법과 다르게 voca는 내부에서 다른 문법을 적용하기 위해서 전처리가 안된 child lines를 사용함
      final lines = <String>[];
      var text = '';

      childrenLines.forEach((line) {
        var content = line.content;
        content = content
              .replaceAll('&nbsp;', ' ')
              .replaceAll('&ensp;', '  ')
              .replaceAll('&emsp;', '   ');

        if (vocaStrongCodeLongPattern.hasMatch(content)) {
          content = content.replaceAll('<br>', ' ');
        }

        final split = content.split('<br>');

        lines.addAll(split);
        content = content.replaceAll('<br>', ' ');
        text += '$content\n';
      });

      
      var strongCode = '?';
      
      for (var content in lines) {
        content = content
            .replaceAll('&nbsp;', ' ')
            .replaceAll('&ensp;', '  ')
            .replaceAll('&emsp;', '   ');
        
        var attrKey = '';
        if (content.contains('[') && content.contains(']')) {
          attrKey = 'voca-pronunciation-eng';
        } else if (vocaLevelPattern.hasMatch(content)) {
          attrKey = 'voca-level';
          content = content.replaceAll('`', '');
        } else if (vocaStrongCodeOnlyPattern.hasMatch(content)) {
          attrKey = 'voca-strong-code';
          
          final code = vocaStrongCodeLongPattern.firstMatch(content)!.group(0)!;
          if (code != strongCode) {

               if (element.attributes['voca-lang-kor'] != null && content != '') {
                element.attributes['voca-lang-kor'] = '${element.attributes['voca-lang-kor']!}---|---';
                
              }
              if (element.attributes['voca-lang-eng'] != null && content != '') {
                element.attributes['voca-lang-eng'] = '${element.attributes['voca-lang-eng']!}---|---'; 
              }
          }

          strongCode = code;

        } else if (vocaKorPattern.hasMatch(content)) {
          attrKey = 'voca-lang-kor';
        } else if (vocaEngPattern.hasMatch(content)) {
          attrKey = 'voca-lang-eng';
        }

        // 품사가 2개인것 처럼 여러개 처리해야할때는 임의로 정한 특수 기호 ||| 로 분류해준다.
        if (element.attributes[attrKey] != null && content != '') {
          final existingValue = element.attributes[attrKey]!;
          content = '$existingValue|||$content';
        }

        if (attrKey != '') {
          element.attributes[attrKey] = content;
        }        
      }

      if (vocaStrongCodeTextPattern.hasMatch(text)) {
        final matches =
            vocaStrongCodeTextPattern.allMatches(text);
        
        for (var m in matches) {
          if (m.groupCount > 1) {
            final vocaStrongCode = m.group(1)!;
            final vocaText = m.group(2)!;
            
            // TODO - attribute set하는 코드가 중복임, 따로 뺄것
            if (element.attributes['voca-strong-codes-without-text'] != null &&
                vocaStrongCode != '') {
              final existingValue =
                  element.attributes['voca-strong-codes-without-text']!;
              element.attributes['voca-strong-codes-without-text'] =
                  '$existingValue|||$vocaStrongCode';
            } else {
              element.attributes['voca-strong-codes-without-text'] =
                  vocaStrongCode;
            }

            if (element.attributes['voca-text'] != null && vocaText != '') {
              final existingValue = element.attributes['voca-text']!;
              element.attributes['voca-text'] = '$existingValue|||$vocaText';
            } else {
              element.attributes['voca-text'] = vocaText;
            }
          }
        }
      }
    }

    /// 라벨에서 '[' ']' 제거
    if (label.trim().isNotEmpty) {
      element.attributes['label'] =
          label.replaceAll('[', '').replaceAll(']', '');
    }

    return element
      ..children?.addAll(nodes)
      ..attributes['type'] = boxType;
  }
}
