import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'dart:math' as math;
import '../bloc/pagination_bloc.dart';
import '../bloc/pagination_event.dart';
import '../bloc/pagination_state.dart';

class BlocPagination<T, ErrorHandler> extends StatefulWidget {
  final PaginationBloc bloc;
  final Widget? firstPageLoader;
  final bool animateTransitions;
  final Widget? loadMoreLoader;
  final SliverGridDelegate? gridDelegate;
  //final Widget? banner;
  final SliverAppBarDelegate? banner;

  final Widget? footer;
  final bool bannerPinned;
  final bool footerPinned;
  final Widget Function(BuildContext context, ErrorHandler error)?
      firstPageErrorBuilder;
  final void Function(BuildContext context, PaginationState<dynamic> state)?
      blocListener;
  final Widget Function(BuildContext context, ErrorHandler error)?
      loadMoreErrorBuilder;
  final Widget? noItemFound;
  final Widget? noMoreItemFound;
  final Widget Function(BuildContext context, T item, int index) itemsBuilder;

  const BlocPagination({
    super.key,
    required this.bloc,
    this.animateTransitions = true,
    this.firstPageLoader,
    this.blocListener,
    this.firstPageErrorBuilder,
    this.gridDelegate,
    this.banner,
    this.footer,
    this.bannerPinned = false,
    this.footerPinned = false,
    required this.itemsBuilder,
    this.noItemFound,
    this.noMoreItemFound,
    this.loadMoreErrorBuilder,
    this.loadMoreLoader,
  });

  @override
  State<BlocPagination<T, ErrorHandler>> createState() =>
      _BlocPaginationState<T, ErrorHandler>();
}

class _BlocPaginationState<T, ErrorHandler>
    extends State<BlocPagination<T, ErrorHandler>> {
  get _firstPageProgressIndicatorBuilder => widget.firstPageLoader != null
      ? (_) {
          return widget.firstPageLoader!;
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
        return widget.noItemFound ?? const Text('No Items Found');
      };
  get _newPageErrorIndicatorBuilder => (_) {
        if (widget.loadMoreErrorBuilder != null) {
          return widget.loadMoreErrorBuilder!(
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
        if (widget.firstPageErrorBuilder != null) {
          return widget.firstPageErrorBuilder!(
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
      child: BlocConsumer<PaginationBloc, PaginationState>(
        bloc: widget.bloc,
        listener: widget.blocListener ?? (context, state) {},
        builder: (context, state) {
          var child = CustomScrollView(
            slivers: <Widget>[
              if (widget.banner != null)
                SliverPersistentHeader(
                  pinned: widget.bannerPinned,
                  delegate: widget.banner!,
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
                      itemBuilder: widget.itemsBuilder,
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
                      itemBuilder: widget.itemsBuilder,
                    ),
                  ),
              },
              if (widget.footer != null && !widget.footerPinned)
                SliverToBoxAdapter(
                  child: widget.footer,
                ),
            ],
          );
          if (widget.footerPinned) {
            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                child,
                if (widget.footer != null) widget.footer!,
              ],
            );
          }
          return child;
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

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
