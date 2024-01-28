# BlocPagination


[![All Contributors](https://img.shields.io/badge/all_contributors-5-orange.svg?style=flat-square)](https://github.com/abdullah-te/bloc_pagination)
[![Actions Status](https://github.com/excogitatr/pagination_view/workflows/build/badge.svg)](https://github.com/abdullah-te/bloc_pagination)
[![pub package](https://img.shields.io/badge/pub-v0.0.5-blue)](https://pub.dev/packages/bloc_pagination)


## Installing

In your pubspec.yaml

```yaml
dependencies:
  bloc_pagination: //add latest version
```

```dart
import 'package:bloc_pagination/bloc_pagination.dart';
```

## Basic Usage

```dart
class MyBloc extends PaginationBloc {
  @override
  Future<ListResponse<PaginationModel>> findAll(int page,
      {AbstractQueryParameters? queryParameters}) async {
          /// your data source
    return readRepository.findAll(page, params: queryParameters);
  }
}

class MyWidget extends StatelessWidget {
  final MyBloc _bloc = MyBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  BlocPagination<TempModel, ErrorWrapper>(
        bloc: _bloc,
        blocListener: (context, state) {},
        firstPageErrorBuilder: (context, error) {
          return Center(
            child: Text(error.message.toString()),
          );
        },
        bannerPinned: true,
        banner: SliverAppBarDelegate(
          maxHeight: 100,
          minHeight: 100,
          child: Container(
            color: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text('header widget'),
          ),
        ),
        footerPinned: true,
        footer: Container(
          color: Colors.green,
          height: 100,
          width: double.infinity,
          child: Text('footer widget'),
        ),
        itemsBuilder: (context, item, index) => InkWell(
          onTap: () => _bloc.add(EditListTypePaginationEvent(
              listType: _bloc.state.listType.isListed
                  ? ListType.gridView
                  : ListType.listView)),
          child: Container(
            color: Colors.green,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            height: 200,
            child: Text('index  ${item.id}'),
          ),
        ),
      ),
    );
  }
}
```

## Additional information

For more information on how to use the package, please refer to the official documentation.

I hope this helps! Let me know if you have any other questions.