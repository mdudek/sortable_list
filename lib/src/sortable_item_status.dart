class SortableItemStatus {
  const SortableItemStatus._(this.name);

  final String name;

  static const BEFORE = SortableItemStatus._('BEFORE');
  static const AFTER = SortableItemStatus._('AFTER');
  static const HOVER = SortableItemStatus._('HOVER');
  static const SETTLED = SortableItemStatus._('SETTLED');

  factory SortableItemStatus(int currentIndex, int? hoverIndex) {
    if (hoverIndex == null) return SortableItemStatus.SETTLED;
    if (currentIndex == hoverIndex) return SortableItemStatus.HOVER;
    if (currentIndex < hoverIndex) return SortableItemStatus.BEFORE;
    if (currentIndex > hoverIndex) return SortableItemStatus.AFTER;
    throw Exception('Cannot determine SortableItemStatus. ' +
        'Indices were: $currentIndex (current), $hoverIndex (hover).');
  }

  @override
  String toString() => '$runtimeType.$name';
}
