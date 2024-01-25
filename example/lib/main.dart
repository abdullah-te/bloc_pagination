import 'package:bloc_pagination/bloc_pagination.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _bloc = MyBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Pagination page'),
        ),
        body: BlocPagination<TempModel, ErrorWrapper>(
          bloc: _bloc,
          /*loader: const SkeletonizerWidget(
            repeat: 5,
            child: Card(
              child: ListTile(
                title: Text('Item number as title'),
                subtitle: Text('Subtitle here'),
                trailing: Icon(Icons.ac_unit),
              ),
            ),
          ),*/
          error: (context, error) {
            return Center(
              child: Text(error.message! ?? 'none'),
            );
          },
          builder: (context, item, index) => InkWell(
            onTap: () => _bloc.add(EditListTypePaginationEvent(
                listType: _bloc.state.listType.isListed
                    ? ListType.gridView
                    : ListType.listView)),
            child: Container(
              color: Colors.green,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              height: 200,
              child: Text('index  ${(item as TempModel).id}'),
            ),
          ),
        ));
  }
}

class MyBloc extends PaginationBloc<TempModel> {
  /// you can add other event, but do not forget to add super contractor
  /// such as :
  /// CategoryBloc() : super() {
  ///   on<FilterPaginationEvent>(_onFilterPaginationEvent);
  /// }

  @override
  Future<ListResponse<TempModel>> findAll(int page,
      {AbstractQueryParameters? queryParameters}) async {
    await Future.delayed(const Duration(seconds: 1));

    /// throw exception as ErrorWrapper() or whatever
    //throw ErrorWrapper(message: 'error');
    return ListedData(data: [TempModel(1)], total: 1);
  }
}

class TempModel {
  final int id;
  TempModel(this.id);
}

class ListedData with ListResponse<TempModel> {
  @override
  List<TempModel> data;
  @override
  int? total;
  ListedData({required this.data, this.total});
}

class ErrorWrapper {
  String? message;
  int? statusCode;
  ErrorWrapper({this.message, this.statusCode});
}

/// more info about request you can user like this
// @RestApi()
// abstract class PaginationProvider {
//   factory PaginationProvider(Dio dio) = _PaginationProvider;
//
//   @GET('https://******************')
//   Future<HttpResponse<ListedData<TempModel>>> getAll({
//     @Query('page') required int page,
//     @Query('perPage') int perPage = 10,
//     @Queries() Map<String, String>? params,
//     @CancelRequest() CancelToken? cancelToken,
//   });
// }
