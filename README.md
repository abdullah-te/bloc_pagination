# BlocPagination


[![All Contributors](https://img.shields.io/badge/all_contributors-5-orange.svg?style=flat-square)](#contributors-)



[![Actions Status](https://github.com/excogitatr/pagination_view/workflows/build/badge.svg)](https://github.com/abdullah-te/bloc_pagination)
[![pub package](https://img.shields.io/pub/v/pagination_view.svg)](https://pub.dev/packages/bloc_pagination)


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
  final MyBloc bloc = MyBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocPagination<String,error>(
        bloc: bloc,
        builder: (BuildContext context, String item) {
          return ListTile(
            title: Text(item),
          );
        },
      ),
    );
  }
}
```

## Additional information

For more information on how to use the package, please refer to the official documentation.

I hope this helps! Let me know if you have any other questions.