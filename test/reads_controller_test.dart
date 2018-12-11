import 'package:fave_reads/model/read.dart';

import 'harness/app.dart';

void main() {
  final harness = Harness()..install();

  setUp(() async {
    final readQuery = Query<Read>(harness.application.channel.context)
      ..values.title = 'Head First Design Patterns'
      ..values.author = 'Eric Freeman'
      ..values.year = 2004;
    await readQuery.insert();
  });

  test('GET /reads returns a 200 OK', () async {
    final response = await harness.agent.get('/reads');
    expectResponse(response, 200,
        body: everyElement(partial({
          'id': greaterThan(0),
          'title': isString,
          'author': isString,
          'year': isInteger,
        })));
  });

  test('GET /reads/:id returns a single read', () async {
    final response = await harness.agent.get('/reads/1');
    expectResponse(response, 200, body: {
      'id': 1,
      'title': 'Head First Design Patterns',
      'author': 'Eric Freeman',
      'year': 2004,
      'detail': 'Head First Design Patterns by Eric Freeman',
    });
  });

  test('GET /reads/2 returns a 404 response', () async {
    final response = await harness.agent.get('/reads/2');
    expectResponse(response, 404, body: 'Item not found.');
  });

  test('POST /reads creates a new read', () async {
    final response = await harness.agent.post('/reads', body: {
      'title': 'Code Complete (Updated)',
      'author': 'Steve McConnell',
      'year': 2018
    });
    expectResponse(response, 200, body: {
      'id': 2,
      'title': 'Code Complete (Updated)',
      'author': 'Steve McConnell',
      'year': 2018,
      'detail': 'Code Complete (Updated) by Steve McConnell',
    });
  });

  test('PUT /reads/:id updates a read', () async {
    final response = await harness.agent.put('/reads/1', body: {
      'title': 'Head First Design Patterns (Updated)',
      'author': 'Eric Freeman',
      'year': 2004,
    });
    expectResponse(response, 200, body: {
      'id': 1,
      'title': 'Head First Design Patterns (Updated)',
      'author': 'Eric Freeman',
      'year': 2004,
      'detail': 'Head First Design Patterns (Updated) by Eric Freeman',
    });
  });

  test('PUT /reads/2 returns a 404 response', () async {
    final response = await harness.agent.put('/reads/2', body: {
      'title': 'Head First Design Patterns (Updated)',
      'author': 'Eric Freeman',
      'year': 2004,
    });
    expectResponse(response, 404, body: 'Item not found.');
  });

  test('DELETE /reads/:id deletes a read', () async {
    final response = await harness.agent.delete('/reads/1');
    expectResponse(response, 200, body: 'Deleted 1 items.');
  });

  test('DELETE /reads/2 returns a 404 response', () async {
    final response = await harness.agent.delete('/reads/2');
    expectResponse(response, 404, body: 'Item not found.');
  });
}
