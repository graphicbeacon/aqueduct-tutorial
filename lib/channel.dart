import 'dart:io';

import 'package:fave_reads/controller/reads_controller.dart';

import 'fave_reads.dart';

/// This type initializes an application.
class FaveReadsChannel extends ApplicationChannel {
  ManagedContext context;

  /// Initialize services in this method.
  @override
  Future prepare() async {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));

    final config = ReadConfig(options.configurationFilePath);
    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    final persistentStore = PostgreSQLPersistentStore.fromConnectionInfo(
      config.database.username,
      config.database.password,
      config.database.host,
      config.database.port,
      config.database.databaseName,
    );

    context = ManagedContext(dataModel, persistentStore);
  }

  /// Construct the request channel.
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

class ReadConfig extends Configuration {
  ReadConfig(String path) : super.fromFile(File(path));

  DatabaseConfiguration database;
}
