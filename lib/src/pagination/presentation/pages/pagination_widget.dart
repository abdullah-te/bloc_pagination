import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../bloc/pagination_bloc.dart';
import '../bloc/pagination_event.dart';
import '../bloc/pagination_state.dart';

class BlocPagination<T, ErrorHandler> extends StatefulWidget {
  final PaginationBloc bloc;
  final Widget? loader;
  final bool animateTransitions;
  final Widget? loadMoreLoader;
  final SliverGridDelegate? gridDelegate;
  final Widget? banner;
  final Widget? footer;
  final bool pinned;
  final bool footerPinned;
  final Widget Function(BuildContext context, ErrorHandler error)? error;
  final Widget Function(BuildContext context, ErrorHandler error)?
      loadMoreError;
  final Widget? noItemFound;
  final Widget? noMoreItemFound;
  final Widget Function(BuildContext context, T item, int index) builder;

  const BlocPagination({
    super.key,
    required this.bloc,
    this.animateTransitions = true,
    this.loader,
    this.error,
    this.gridDelegate,
    this.banner,
    this.footer,
    this.pinned = false,
    this.footerPinned = false,
    required this.builder,
    this.noItemFound,
    this.noMoreItemFound,
    this.loadMoreError,
    this.loadMoreLoader,
  });

  @override
  State<BlocPagination<T, ErrorHandler>> createState() =>
      _BlocPaginationState<T, ErrorHandler>();
}

class _BlocPaginationState<T, ErrorHandler>
    extends State<BlocPagination<T, ErrorHandler>> {
  get _firstPageProgressIndicatorBuilder => widget.loader != null
      ? (_) {
          return widget.loader!;
        }
      : null;

  get _newPageProgressIndicatorBuilder => widget.loadMoreLoader != null
      ? (_) {
          return widget.loadMoreLoader!;
        }
      : null;
  get _noMoreItemsFoundIndicatorBuilder => widget.noMoreItemFound != null
      ? (_) {
          return widget.noMoreItemFound!;
        }
      : null;
  get _noItemsFoundIndicatorBuilder => (_) {
        return widget.noMoreItemFound ?? const Text('No Items Found');
      };
  get _newPageErrorIndicatorBuilder => (_) {
        if (widget.loadMoreError != null) {
          return widget.loadMoreError!(
              context,
              widget.bloc.state.controller.error != null
                  ? (widget.bloc.state.controller.error) as ErrorHandler
                  : Exception() as ErrorHandler);
        } else {
          return _ErrorWidget(
            error: widget.bloc.state.controller.error.toString(),
            reload: () => widget.bloc.state.controller.retryLastFailedRequest(),
          );
        }
      };

  get _firstPageErrorIndicatorBuilder => (_) {
        if (widget.error != null) {
          return widget.error!(
              context,
              widget.bloc.state.controller.error != null
                  ? (widget.bloc.state.controller.error) as ErrorHandler
                  : Exception() as ErrorHandler);
        } else {
          return _ErrorWidget(
            error: widget.bloc.state.controller.error.toString(),
            reload: () => widget.bloc.add(RefreshIndicatorEvent()),
          );
        }
      };

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        widget.bloc.add(RefreshIndicatorEvent());
      },
      child: BlocBuilder<PaginationBloc, PaginationState>(
        bloc: widget.bloc,
        builder: (context, state) {
          return CustomScrollView(
            slivers: <Widget>[
              if (widget.banner != null)
                SliverAppBar(
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  pinned: widget.pinned,
                  bottom: const PreferredSize(
                      preferredSize: Size.fromHeight(-10.0), child: SizedBox()),
                  flexibleSpace: widget.banner,
                ),
              switch (state.listType) {
                ListType.listView => PagedSliverList<int, T>(
                    pagingController:
                        state.controller as PagingController<int, T>,
                    builderDelegate: PagedChildBuilderDelegate<T>(
                      firstPageErrorIndicatorBuilder:
                          _firstPageErrorIndicatorBuilder,
                      newPageErrorIndicatorBuilder:
                          _newPageErrorIndicatorBuilder,
                      animateTransitions: widget.animateTransitions,
                      firstPageProgressIndicatorBuilder:
                          _firstPageProgressIndicatorBuilder,
                      newPageProgressIndicatorBuilder:
                          _newPageProgressIndicatorBuilder,
                      noItemsFoundIndicatorBuilder:
                          _noItemsFoundIndicatorBuilder,
                      noMoreItemsIndicatorBuilder:
                          _noMoreItemsFoundIndicatorBuilder,
                      itemBuilder: widget.builder,
                    ),
                  ),
                ListType.gridView => PagedSliverGrid<int, T>(
                    pagingController:
                        state.controller as PagingController<int, T>,
                    gridDelegate: widget.gridDelegate ??
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 100 / 150,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          crossAxisCount: 3,
                        ),
                    builderDelegate: PagedChildBuilderDelegate<T>(
                      firstPageErrorIndicatorBuilder:
                          _firstPageErrorIndicatorBuilder,
                      newPageErrorIndicatorBuilder:
                          _newPageErrorIndicatorBuilder,
                      animateTransitions: widget.animateTransitions,
                      firstPageProgressIndicatorBuilder:
                          _firstPageProgressIndicatorBuilder,
                      newPageProgressIndicatorBuilder:
                          _newPageProgressIndicatorBuilder,
                      noItemsFoundIndicatorBuilder:
                          _noItemsFoundIndicatorBuilder,
                      noMoreItemsIndicatorBuilder:
                          _noMoreItemsFoundIndicatorBuilder,
                      itemBuilder: widget.builder,
                    ),
                  ),
              },
              if (widget.footer != null)
                SliverFillRemaining(
                  fillOverscroll: true,
                  hasScrollBody: false,
                  child: widget.footer,
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final String error;
  final Function() reload;
  const _ErrorWidget({required this.error, required this.reload});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(error),
        SizedBox(
          width: 150,
          child: ElevatedButton(
            onPressed: reload,
            child: const Center(
              child: Text('reload'),
            ),
          ),
        ),
      ],
    );
  }
}
