import 'package:fave_reads/fave_reads.dart';

class Read extends ManagedObject<_Read> implements _Read {
  String get detail => '$title by $author';
}

class _Read {
  @primaryKey
  int id;

  @Column(unique: true)
  String title;

  @Column()
  String author;

  @Column()
  int year;
}

/// For reference
// class Read extends Serializable {
//   String title;
//   String author;
//   int year;

//   @override
//   Map<String, dynamic> asMap() => {
//         'title': title,
//         'author': author,
//         'year': year,
//       };

//   @override
//   void readFromMap(Map<String, dynamic> requestBody) {
//     title = requestBody['title'] as String;
//     author = requestBody['author'] as String;
//     year = requestBody['year'] as int;
//   }
// }
