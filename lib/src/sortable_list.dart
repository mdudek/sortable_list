import 'package:flutter/material.dart';

import 'axis_dimensions.dart';
import 'sortable_list_state.dart';

typedef Widget SortableItemBuilder<T>(BuildContext context, SortableItem<T> item, Widget handle);
typedef Widget DragHandleBuilder(BuildContext context);

typedef Widget FeedbackSortableItemBuilder<T>(BuildContext context, SortableItem<T> item, Widget handle, Animation<double> transition);
typedef Widget FeedbackDragHandleBuilder(BuildContext context, Animation<double> transition);

typedef Widget BareSortableItemBuilder<T>(BuildContext context, SortableItem<T> item);
typedef Widget BareFeedbackSortableItemBuilder<T>(BuildContext context, SortableItem<T> item, Animation<double> transition);

typedef void ItemReorderCallback(int? from, int to);

class SortableItem<T> {
  final T value;
  final int? itemIndex;
  final int? displayIndex;

  SortableItem(this.value, this.itemIndex, this.displayIndex);

  @override
  String toString() => "SortableItem<$T>(value: $value, itemIndex: $itemIndex, dispIndex: $displayIndex)";
}

class SortableList<T> extends StatefulWidget with AxisDimensions {
  /// List of items displayed in the list.
  final List<T> items;

  /// Extent of each item widget in the list. Corresponds to
  /// width/height in case of horizontal/vertical axis orientation.
  final double itemExtent;

  /// Relative position within item widget that corresponds to the center of
  /// handle, where -1.0 stands for beginning and 1.0 for end of the item.
  late double handleAlignment;

  /// Duration of raise and drop animation of dragged item.
  Duration? animDuration;

  /// Duration between list item touch and drag start.
  Duration dragDelay;

  /// Builder function that creates handle widget for each element of the list.
  late DragHandleBuilder handleBuilder;

  /// Builder function that creates widget for each element of the list.
  final SortableItemBuilder<T> itemBuilder;

  /// Builder function that creates handle widget of currently dragged item.
  /// If null, [handleBuilder] function will be used instead.
  late FeedbackDragHandleBuilder feedbackHandleBuilder;

  /// Builder function that creates widget of currently dragged item.
  /// If null, [builder] function will be used instead.
  late FeedbackSortableItemBuilder<T> feedbackItemBuilder;

  /// Callback function that invokes if dragged item changed
  /// its index and drag action is ended. By default this
  /// will swap start and end position in [items] list.
  ItemReorderCallback? onItemReorder;

  /// Axis orientation of the list widget.
  late Axis scrollDirection;

  /// Whether the extent of the scroll view in the scrollDirection
  /// should be determined by the contents being viewed.
  late bool shrinkWrap;

  /// An object that can be used to control the position to which this scroll
  /// view is scrolled.
  ScrollController? controller;

  /// The amount of space by which to inset the children.
  EdgeInsetsGeometry? padding;

  /// How the scroll view should respond to user input.
  ScrollPhysics? physics;

  SortableList({
    required this.items,
    required this.itemExtent,
    required this.itemBuilder,
    Key? key,
    Duration? animDuration = const Duration(milliseconds: 300),
    this.dragDelay = Duration.zero,
    double handleAlignment = 0.0,
    Axis? scrollDirection = Axis.vertical,
    bool? shrinkWrap = false,
    feedbackItemBuilder,
    feedbackHandleBuilder,
    handleBuilder,
    this.onItemReorder,
    this.controller,
    this.padding,
    this.physics,
  }) : super(key: key) {
    assert(this.handleAlignment >= -1.0 && this.handleAlignment <= 1.0, 'Handle alignment has to be in bounds (-1, 1) inclusive. Passed value was: $handleAlignment.');

    this.handleBuilder = handleBuilder ?? ((_) => Center(child: Icon(Icons.drag_handle, size: 24.0)));
    this.feedbackItemBuilder = feedbackItemBuilder ?? ((context, item, handle, _) => itemBuilder(context, item, handle));
    this.feedbackHandleBuilder = feedbackHandleBuilder ?? ((context, _) => this.handleBuilder(context));
  }

  SortableList.handleLess({
    required List<T> items,
    required double itemExtent,
    required BareSortableItemBuilder<T> itemBuilder,
    Key? key,
    BareFeedbackSortableItemBuilder<T>? feedbackItemBuilder,
    Duration? animDuration,
    Duration? dragDelay,
    double? handleAlignment,
    Axis? scrollDirection,
    ScrollPhysics? physics,
    bool? shrinkWrap,
    ItemReorderCallback? onItemReorder,
  }) : this(
            items: items,
            itemExtent: itemExtent,
            key: key,
            scrollDirection: scrollDirection,
            physics: physics,
            shrinkWrap: shrinkWrap,
            animDuration: animDuration,
            dragDelay: dragDelay ?? Duration(milliseconds: 300),
            onItemReorder: onItemReorder,
            handleBuilder: (_) => Container(),
            itemBuilder: (context, item, handle) => Stack(children: [
                  itemBuilder(context, item),
                  Positioned.fill(child: handle),
                ]),
            feedbackItemBuilder: (context, item, _, transition) {
                return feedbackItemBuilder!(context, item, transition);
            });

  @override
  SortableListState<T> createState() => SortableListState<T>();

  @override
  Axis get axis => scrollDirection;
}
