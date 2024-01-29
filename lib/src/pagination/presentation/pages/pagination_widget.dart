import 'package:bloc_pagination/src/core/extensions/axis_extension.dart';
import 'package:bloc_pagination/src/pagination/presentation/pages/widgets/custom_scroll_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/pagination_bloc.dart';
import '../bloc/pagination_event.dart';
import '../bloc/pagination_state.dart';
import 'widgets/error_widget.dart';
import 'widgets/sliver_app_bar_delegate.dart';

class BlocPagination<T, ErrorHandler> extends StatefulWidget {
  /// bloc instance that inherited from abstract class PaginationBloc
  final PaginationBloc bloc;

  /// loader that appear in first page before any items appear
  final Widget? firstPageLoader;

  /// Whether status transitions should be animated.
  final bool animateTransitions;

  /// a new page's progress indicator that appear in the bottom of list.
  final Widget? loadMoreLoader;

  /// GridView option
  final SliverGridDelegate? gridDelegate;

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
  final Axis scrollDirection;
  final ScrollPhysics? physics;
  const BlocPagination({
    super.key,
    required this.bloc,
    this.animateTransitions = true,
    this.scrollDirection = Axis.vertical,
    this.firstPageLoader,
    this.physics,
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
          return ErrorButtonWidget(
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
          return ErrorButtonWidget(
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
          if (widget.footerPinned && !widget.scrollDirection.isHorizontal) {
            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CustomScrollViewWidget(
                  scrollDirection: widget.scrollDirection,
                  physics: widget.physics,
                  bannerPinned: widget.bannerPinned,
                  animateTransitions: widget.animateTransitions,
                  state: state,
                  itemsBuilder: widget.itemsBuilder,
                  footerPinned: widget.footerPinned,
                  gridDelegate: widget.gridDelegate,
                  footer: widget.footer,
                  banner: widget.banner,
                  firstPageErrorIndicatorBuilder:
                      _firstPageErrorIndicatorBuilder,
                  newPageErrorIndicatorBuilder: _newPageErrorIndicatorBuilder,
                  firstPageProgressIndicatorBuilder:
                      _firstPageProgressIndicatorBuilder,
                  newPageProgressIndicatorBuilder:
                      _newPageProgressIndicatorBuilder,
                  noItemsFoundIndicatorBuilder: _noItemsFoundIndicatorBuilder,
                  noMoreItemsFoundIndicatorBuilder:
                      _noMoreItemsFoundIndicatorBuilder,
                ),
                if (widget.footer != null) widget.footer!,
              ],
            );
          }
          return CustomScrollViewWidget(
            scrollDirection: widget.scrollDirection,
            physics: widget.physics,
            bannerPinned: widget.bannerPinned,
            animateTransitions: widget.animateTransitions,
            state: state,
            itemsBuilder: widget.itemsBuilder,
            footerPinned: widget.footerPinned,
            gridDelegate: widget.gridDelegate,
            footer: widget.footer,
            banner: widget.banner,
            firstPageErrorIndicatorBuilder: _firstPageErrorIndicatorBuilder,
            newPageErrorIndicatorBuilder: _newPageErrorIndicatorBuilder,
            firstPageProgressIndicatorBuilder:
                _firstPageProgressIndicatorBuilder,
            newPageProgressIndicatorBuilder: _newPageProgressIndicatorBuilder,
            noItemsFoundIndicatorBuilder: _noItemsFoundIndicatorBuilder,
            noMoreItemsFoundIndicatorBuilder: _noMoreItemsFoundIndicatorBuilder,
          );
        },
      ),
    );
  }
}
