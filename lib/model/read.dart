import 'package:fave_reads/fave_reads.dart';

class Read extends ManagedObject<_Read> implements _Read {
  @Serialize()
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
