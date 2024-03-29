import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../bloc_pagination.dart';

class CustomScrollViewWidget<T> extends StatelessWidget {
  final SliverAppBarDelegate? banner;
  final bool bannerPinned;
  final CustomScrollOptions scrollOptions;
  final bool animateTransitions;
  final PaginationState state;
  final Widget Function(BuildContext)? firstPageErrorIndicatorBuilder;
  final Widget Function(BuildContext)? newPageErrorIndicatorBuilder;
  final Widget Function(BuildContext)? firstPageProgressIndicatorBuilder;
  final Widget Function(BuildContext)? newPageProgressIndicatorBuilder;
  final Widget Function(BuildContext)? noItemsFoundIndicatorBuilder;
  final Widget Function(BuildContext)? noMoreItemsFoundIndicatorBuilder;
  final Widget Function(BuildContext context, T item, int index) itemsBuilder;
  final SliverGridDelegate? gridDelegate;
  final Widget? footer;
  final bool footerPinned;
  const CustomScrollViewWidget(
      {super.key,
      this.banner,
      required this.scrollOptions,
      required this.bannerPinned,
      required this.animateTransitions,
      required this.state,
      required this.itemsBuilder,
      this.gridDelegate,
      this.footer,
      required this.footerPinned,
      this.firstPageErrorIndicatorBuilder,
      this.newPageErrorIndicatorBuilder,
      this.firstPageProgressIndicatorBuilder,
      this.newPageProgressIndicatorBuilder,
      this.noItemsFoundIndicatorBuilder,
      this.noMoreItemsFoundIndicatorBuilder});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      scrollDirection: scrollOptions.scrollDirection,
      physics: scrollOptions.physics,
      controller: scrollOptions.controller,
      shrinkWrap: scrollOptions.shrinkWrap,
      reverse: scrollOptions.reverse,
      dragStartBehavior: scrollOptions.dragStartBehavior,
      keyboardDismissBehavior: scrollOptions.keyboardDismissBehavior,
      clipBehavior: scrollOptions.clipBehavior,
      slivers: <Widget>[
        if (banner != null)
          SliverPersistentHeader(
            pinned: bannerPinned,
            delegate: banner!,
          ),
        switch (state.listType) {
          ListType.listView => PagedSliverList<int, T>(
              pagingController: state.controller as PagingController<int, T>,
              builderDelegate: PagedChildBuilderDelegate<T>(
                firstPageErrorIndicatorBuilder: firstPageErrorIndicatorBuilder,
                newPageErrorIndicatorBuilder: newPageErrorIndicatorBuilder,
                animateTransitions: animateTransitions,
                firstPageProgressIndicatorBuilder:
                    firstPageProgressIndicatorBuilder,
                newPageProgressIndicatorBuilder:
                    newPageProgressIndicatorBuilder,
                noItemsFoundIndicatorBuilder: noItemsFoundIndicatorBuilder,
                noMoreItemsIndicatorBuilder: noMoreItemsFoundIndicatorBuilder,
                itemBuilder: itemsBuilder,
              ),
            ),
          ListType.gridView => PagedSliverGrid<int, T>(
              pagingController: state.controller as PagingController<int, T>,
              gridDelegate: gridDelegate ??
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 100 / 150,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 3,
                  ),
              builderDelegate: PagedChildBuilderDelegate<T>(
                firstPageErrorIndicatorBuilder: firstPageErrorIndicatorBuilder,
                newPageErrorIndicatorBuilder: newPageErrorIndicatorBuilder,
                animateTransitions: animateTransitions,
                firstPageProgressIndicatorBuilder:
                    firstPageProgressIndicatorBuilder,
                newPageProgressIndicatorBuilder:
                    newPageProgressIndicatorBuilder,
                noItemsFoundIndicatorBuilder: noItemsFoundIndicatorBuilder,
                noMoreItemsIndicatorBuilder: noMoreItemsFoundIndicatorBuilder,
                itemBuilder: itemsBuilder,
              ),
            ),
        },
        if (footer != null && footerPinned)
          SliverToBoxAdapter(
            child: footer,
          ),
      ],
    );
  }
}
