import 'package:fave_reads/fave_reads.dart';

import '../model/read.dart';

class ReadsController extends ResourceController {
  ReadsController(this.context);

  ManagedContext context;

  @Operation.get()
  Future<Response> getAllReads() async {
    final readQuery = Query<Read>(context);
    return Response.ok(await readQuery.fetch());
  }

  @Operation.get('id')
  Future<Response> getRead(@Bind.path('id') int id) async {
    final readQuery = Query<Read>(context)
      ..where((read) => read.id).equalTo(id);
    final read = await readQuery.fetchOne();

    if (read == null) {
      return Response.notFound(body: 'Item not found.');
    }
    return Response.ok(read);
  }

  @Operation.post()
  Future<Response> createNewRead(@Bind.body() Read body) async {
    final readQuery = Query<Read>(context)..values = body;
    final insertedRead = await readQuery.insert();

    return Response.ok(insertedRead);
  }

  @Operation.put('id')
  Future<Response> updatedRead(
    @Bind.path('id') int id,
    @Bind.body() Read body,
  ) async {
    final readQuery = Query<Read>(context)
      ..values = body
      ..where((read) => read.id).equalTo(id);

    final updatedQuery = await readQuery.updateOne();

    if (updatedQuery == null) {
      return Response.notFound(body: 'Item not found.');
    }

    return Response.ok(updatedQuery);
  }

  @Operation.delete('id')
  Future<Response> deletedRead(@Bind.path('id') int id) async {
    final readQuery = Query<Read>(context)
      ..where((read) => read.id).equalTo(id);

    final int deleteCount = await readQuery.delete();

    if (deleteCount == 0) {
      return Response.notFound(body: 'Item not found.');
    }
    return Response.ok('Deleted $deleteCount items.');
  }
}
