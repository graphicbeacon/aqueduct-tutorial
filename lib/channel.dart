import 'dart:io';

import 'package:fave_reads/controller/reads_controller.dart';

import 'fave_reads.dart';

/// This type initializes an application.
///
/// Override methods in this class to set up routes and initialize services like
/// database connections. See http://aqueduct.io/docs/http/channel/.
class FaveReadsChannel extends ApplicationChannel {
  ManagedContext context;

  /// Initialize services in this method.
  @override
  Future prepare() async {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));

    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    final persistentStore = PostgreSQLPersistentStore.fromConnectionInfo(
      'fave_reads_user',
      'password',
      'localhost',
      5432,
      'fave_reads_official',
    );

    context = ManagedContext(dataModel, persistentStore);
  }

  /// Construct the request channel.
  ///
  /// Return an instance of some [Controller] that will be the initial receiver
  /// of all [Request]s.
  ///
  /// This method is invoked after [prepare].
  @override
  Controller get entryPoint => Router()
    ..route("/reads/[:id]").link(() => ReadsController(context))
    //
    ..route('/').linkFunction((request) =>
        Response.ok('Hello, World!')..contentType = ContentType.html)
    //
    ..route('/client').linkFunction((request) async {
      final client = await File('client.html').readAsString();
      return Response.ok(client)..contentType = ContentType.html;
    });
}
