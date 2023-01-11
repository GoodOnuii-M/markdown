import 'package:markdown/markdown.dart';
import 'package:test/test.dart';

void main() {
  test('싱글 달러 인라인 구문 파싱 테스트', () {
    /// MD 다큐먼트 생성
    final document = Document(
      inlineSyntaxes: [
        /// $ 구문 분석기 추가
        SingleTexInlineSyntex(),
      ],
      encodeHtml: false,
    );

    /// 파싱결과
    final result = document.parseInline(r'$f(x)$라서$f(a)$');

    expect(result, hasLength(3));

    expect(
      result[0],
      const TypeMatcher<Element>()
          .having(
            (e) => e.textContent,
            r'$ 구문 분석기에 걸러진 문자',
            equals('f(x)'),
          )
          .having(
            (e) => e.tag,
            '태그',
            'tex',
          ),
    );

    expect(
      result[1],
      const TypeMatcher<Text>().having(
        (e) => e.textContent,
        r'$ 구문 분석기에 걸러지지 않은 문자',
        equals('라서'),
      ),
    );

    expect(
      result[2],
      const TypeMatcher<Element>()
          .having(
            (e) => e.textContent,
            r'$ 구문 분석기에 걸러진 문자',
            equals('f(a)'),
          )
          .having(
            (e) => e.tag,
            '태그',
            'tex',
          ),
    );
  });
}
