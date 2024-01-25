import 'package:equatable/equatable.dart';

import 'pagination_state.dart';

abstract class PaginationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialPaginationEvent extends PaginationEvent {
  final int pageKey;
  InitialPaginationEvent({this.pageKey = 1});
}

class EditListTypePaginationEvent extends PaginationEvent {
  final ListType listType;
  EditListTypePaginationEvent({required this.listType});
}

class RefreshIndicatorEvent extends PaginationEvent {}

class RemoveItemPaginationEvent extends PaginationEvent {
  final int? index;
  final dynamic item;

  /// either remove on index or on item
  RemoveItemPaginationEvent({this.index, this.item});
}

class AddItemPaginationEvent extends PaginationEvent {
  ///  default added in the header of list
  final int index;
  final dynamic item;

  /// either add on index or on item
  AddItemPaginationEvent({this.index = 0, this.item});
}
