import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../core/blocs/base_bloc.dart';
import '../../../core/models/base_query.dart';
import '../../../core/models/list_response/list_response.dart';
import 'pagination_event.dart';
import 'pagination_state.dart';

abstract class PaginationBloc<T>
    extends BaseBloc<PaginationEvent, PaginationState<T>> {
  PaginationBloc()
      : super(PaginationState(
            controller: PagingController<int, T>(firstPageKey: 1))) {
    on<InitialPaginationEvent>(_onInitialPaginationEvent);
    on<RefreshIndicatorEvent>(_onRefreshIndicatorEvent);
    on<AddItemPaginationEvent>(_onAddItemPaginationEvent);
    on<RemoveItemPaginationEvent>(_onRemoveItemPaginationEvent);
    on<EditListTypePaginationEvent>(_onEditListTypePaginationEvent);
    state.controller.addPageRequestListener((pageKey) {
      add(InitialPaginationEvent(pageKey: pageKey));
    });
  }

  int page = 1;

  Future<ListResponse<T>> findAll(int page,
      {AbstractQueryParameters? queryParameters});

  Future<void> _onInitialPaginationEvent(
      InitialPaginationEvent event, Emitter<PaginationState<T>> emit) async {
    try {
      PagingController<int, T> controller = state.controller;
      ListResponse<T> list = await findAll(
        event.pageKey,
        queryParameters: state.queryParameters,
      );
      int count = controller.value.itemList?.length ?? 0 + list.data.length;
      if (count < list.total!) {
        controller.appendPage(list.data, page + 1);
        page += 1;
      } else {
        controller.appendLastPage(list.data);
      }
      emit(state.copyWith(controller: controller));
    } catch (e) {
      var controller = state.controller;
      controller.error = e;
      emit(state.copyWith(controller: controller));
    }
  }

  Future<void> _onRefreshIndicatorEvent(
      RefreshIndicatorEvent event, Emitter<PaginationState<T>> emit) async {
    state.controller.refresh();
    emit(state.copyWith(queryParameters: null));
    page = 1;
  }

  @override
  void onDispose() {
    super.onDispose();
    state.controller.dispose();
  }

  Future<void> _onAddItemPaginationEvent(
      AddItemPaginationEvent event, Emitter<PaginationState<T>> emit) async {
    List<T> items = state.controller.itemList ?? [];
    items.insert(event.index, event.item);
    var controller = state.controller;
    controller.itemList = [...items];
    emit(state.copyWith(controller: controller));
  }

  Future<void> _onRemoveItemPaginationEvent(
      RemoveItemPaginationEvent event, Emitter<PaginationState<T>> emit) async {
    List<T> items = state.controller.itemList ?? [];
    if (event.index != null) {
      items.removeAt(event.index!);
    } else if (event.item != null) {
      items.remove(event.item);
    }
    var controller = state.controller;
    controller.itemList = [...items];
    emit(state.copyWith(controller: controller));
  }

  Future<void> _onEditListTypePaginationEvent(EditListTypePaginationEvent event,
      Emitter<PaginationState<T>> emit) async {
    emit(state.copyWith(listType: event.listType));
  }
}
