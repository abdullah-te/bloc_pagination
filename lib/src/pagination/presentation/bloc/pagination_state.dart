import 'package:equatable/equatable.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../core/models/base_query.dart';

enum ListType {
  listView,
  gridView;

  bool get isListed => this == ListType.listView;
}

class PaginationState<T> extends Equatable {
  final PagingController<int, T> controller;
  final ListType listType;
  final AbstractQueryParameters? queryParameters;

  const PaginationState(
      {this.listType = ListType.listView,
      this.queryParameters,
      required this.controller});

  PaginationState<T> copyWith({
    PagingController<int, T>? controller,
    ListType? listType,
    AbstractQueryParameters? queryParameters,
  }) {
    return PaginationState<T>(
        controller: controller ?? this.controller,
        queryParameters: queryParameters ?? this.queryParameters,
        listType: listType ?? this.listType);
  }

  @override
  List<Object?> get props => [controller, listType, queryParameters];
}
