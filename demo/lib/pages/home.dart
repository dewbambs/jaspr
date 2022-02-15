import 'package:jaspr/jaspr.dart';
import 'package:jaspr_demo/components/book.dart';
import 'package:jaspr_demo/services/service.dart';

class Home extends StatefulComponent {
  Home() : super(key: StateKey(id: 'books'));

  @override
  State<StatefulComponent> createState() => HomeState();
}

class HomeState extends State<Home> with PreloadStateMixin<Home, List> {
  late List books;

  @override
  Future<List> preloadState() {
    return BooksService.instance!.getBooks();
  }

  @override
  void didLoadState() {
    initState();
  }

  @override
  void initState() {
    super.initState();
    books = preloadedState ?? [];
  }

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield DomComponent(tag: 'div', classes: [
      'books-list'
    ], children: [
      for (var book in books)
        DomComponent(
          tag: 'div',
          events: {
            'click': () => Router.of(context).push('/book/${book['id']}'),
            'mouseenter': () => Router.of(context).preload('/book/${book['id']}'),
          },
          child: BookInfo(book: book),
        ),
    ]);
  }
}
