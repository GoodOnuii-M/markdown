// ~~abc~~ 과 같은 기호의 정보를 담는 클래스
class TagPos {
  late int length; // 전체 문자열의 길이, ~~abc~~의 경우 7
  late int? startWholePos;
  late int? endWholePos;
  late int tagSize;
  String? tag; // 태그  

  TagPos({
    required this.length,
    this.startWholePos,
    this.endWholePos,
    this.tagSize = 0,
    this.tag,
  });
}