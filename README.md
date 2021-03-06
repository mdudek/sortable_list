# SortableList

[![pub package](https://img.shields.io/pub/v/sortable_list.svg)](https://pub.dartlang.org/packages/sortable_list)

Flutter list widget that allows to drag and drop items and define custom drag handle widget.


## Getting Started

Add `SortableList` component to your widget tree:

```Dart
child: SortableList<String>(
  items: ['Tuna', 'Meat', 'Cheese', 'Potato', 'Eggs', 'Bread'],
  itemExtent: 72.0,
  builder: (context, item, handle) {
    return Container(
      height: 72.0,
      child: Row(children: [
        Spacer(),
        Text(item),
        Spacer(),
        handle,
      ]),
    );
  },
),
```

Optionally, provide custom handle builder:

```Dart
child: SortableList<String>(
  // ...
  handleBuilder: (context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Container(
        color: Colors.green,
        child: Text('Handle'),
      ),
    );
  },
),
```

Add other optional parameter if needed:

```Dart
child: SortableList<String>(
  // ...
  animDuration: Duration(milliseconds: 500),
  dragDelay: Duration(seconds: 1),
  handleAlignment: -0.3,
  scrollDirection: Axis.horizontal,
  onItemReorder: (from, to) {
    // handle item reorder on your own
  },
),
```

Use `handleless` constructor if you want list item to be dragged no matter where it's tapped on:

```Dart
SortableList<String>.handleless(
  // ...
  builder: (context, item) {
    return Container(
      height: 72.0,
      child: Center(child: Text(item)),
    );
  },
),
```

Many thanks to Tomek Wyrowiński - author of original 'Drag_list' package.
