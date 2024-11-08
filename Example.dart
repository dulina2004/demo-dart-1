import 'dart:io';

enum BookStatus { available, borrowed }

class Book {
  String _title;
  String _author;
  String _isbn;
  BookStatus _status;

  Book(this._title, this._author, this._isbn, this._status) {
    if (!_isValidISBN(_isbn)) {
      throw ArgumentError('Invalid ISBN: $_isbn');
    }
  }

  // Getters
  String get title => _title;
  String get author => _author;
  String get isbn => _isbn;
  BookStatus get status => _status;

  // Setters
  set title(String newTitle) => _title = newTitle;
  set author(String newAuthor) => _author = newAuthor;
  set isbn(String newIsbn) {
    if (_isValidISBN(newIsbn)) {
      _isbn = newIsbn;
    } else {
      throw ArgumentError('Invalid ISBN format');
    }
  }

  // Method to update book status
  void updateStatus(BookStatus newStatus) {
    _status = newStatus;
  }

  // ISBN validation method
  bool _isValidISBN(String isbn) {
    if (isbn.length != 10 && isbn.length != 13) {
      return false;
    }
    if (isbn.length == 10) {
      return RegExp(r'^[0-9]{9}[0-9X]$').hasMatch(isbn);
    }
    return RegExp(r'^[0-9]{13}$').hasMatch(isbn);
  }

  @override
  String toString() {
    return 'Book: $_title by $_author (ISBN: $_isbn) - ${_status.toString().split('.').last}';
  }
}

class TextBook extends Book {
  String _subjectArea;
  int _gradeLevel;

  TextBook(super._title, super._author, super._isbn, super._status,
      this._subjectArea, this._gradeLevel);

  // Getters
  String get getSubjectArea => _subjectArea;
  int get getGradeLevel => _gradeLevel;

  // Setters
  set setSubjectArea(String newSubject) => _subjectArea = newSubject;
  set setGradeLevel(int newGrade) => _gradeLevel = newGrade;

  @override
  String toString() {
    return 'TextBook: $_title by $_author (ISBN: $_isbn) - ${_status.toString().split('.').last}\n'
        'Subject: $_subjectArea, Grade Level: $_gradeLevel';
  }
}

class BookManagementSystem {
  final List<Book> _books = [];

  void addBook(Book book) {
    if (_books.any((b) => b.isbn == book.isbn)) {
      print('Book with ISBN ${book.isbn} already exists');
      return;
    }
    _books.add(book);
  }

  bool removeBook(String isbn) {
    try {
      Book book = findBookByIsbn(isbn);
      _books.remove(book);
      return true;
    } catch (e) {
      print("Error: ${e}");
      return false;
    }
  }

  bool updateBookStatus(String isbn, BookStatus newStatus) {
    try {
      final book = findBookByIsbn(isbn);
      book.updateStatus(newStatus);
      return true;
    } catch (e) {
      print("Error: ${e}");
      return false;
    }
  }

  Book findBookByIsbn(String isbn) {
    for (var book in _books) {
      if (book.isbn == isbn) {
        return book;
      }
    }
    throw StateError('Book not found');
  }

  List<Book> searchByTitle(String title) {
    List<Book> result = [];
    for (var book in _books) {
      if (book.title == title) {
        result.add(book);
      }
    }
    return result;
  }

  List<Book> searchByAuthor(String author) {
    List<Book> result = [];
    for (var book in _books) {
      if (book.author == author) {
        result.add(book);
      }
    }
    return result;
  }

  List<Book> getAllBooks() {
    List<Book> result = [];
    for (var book in _books) {
      result.add(book);
    }
    return result;
  }
}

void main() {
  var library = BookManagementSystem();

  while (true) {
    print("\n--- Book Management System ---");
    print("1. Add Regular Book");
    print("2. Add Text Book");
    print("3. Remove Book");
    print("4. Search by Title");
    print("5. Search by Author");
    print("6. Update Book Status");
    print("7. Display All Books");
    print("8. Exit");
    stdout.write("Enter your choice: ");

    String? choice = stdin.readLineSync();

    try {
      switch (choice) {
        case "1":
          stdout.write("Enter title: ");
          String title = stdin.readLineSync()!;
          stdout.write("Enter author: ");
          String author = stdin.readLineSync()!;
          stdout.write("Enter ISBN: ");
          String isbn = stdin.readLineSync()!;
          library.addBook(Book(title, author, isbn, BookStatus.available));
          print("Book added successfully.");
          break;

        case "2":
          stdout.write("Enter title: ");
          String title = stdin.readLineSync()!;
          stdout.write("Enter author: ");
          String author = stdin.readLineSync()!;
          stdout.write("Enter ISBN: ");
          String isbn = stdin.readLineSync()!;
          stdout.write("Enter subject area: ");
          String subjectArea = stdin.readLineSync()!;
          stdout.write("Enter grade level: ");
          int gradeLevel = int.parse(stdin.readLineSync()!);
          library.addBook(TextBook(title, author, isbn, BookStatus.available,
              subjectArea, gradeLevel));
          print("Text Book added successfully.");
          break;

        case "3":
          stdout.write("Enter ISBN to remove: ");
          String isbn = stdin.readLineSync()!;
          if (library.removeBook(isbn)) {
            print("Book removed successfully.");
          } else {
            print("Book not found.");
          }
          break;

        case "4":
          stdout.write("Enter title to search: ");
          String title = stdin.readLineSync()!;
          var results = library.searchByTitle(title);
          if (results.isNotEmpty) {
            results.forEach((book) => print(book));
          } else {
            print("No books found with the given title.");
          }
          break;

        case "5":
          stdout.write("Enter author to search: ");
          String author = stdin.readLineSync()!;
          var results = library.searchByAuthor(author);
          if (results.isNotEmpty) {
            results.forEach((book) => print(book));
          } else {
            print("No books found with the given author.");
          }
          break;

        case "6":
          stdout.write("Enter ISBN to update status: ");
          String isbn = stdin.readLineSync()!;
          stdout.write("Enter new status (available/borrowed): ");
          String statusStr = stdin.readLineSync()!;
          BookStatus newStatus = (statusStr.toLowerCase() == "borrowed")
              ? BookStatus.borrowed
              : BookStatus.available;
          if (library.updateBookStatus(isbn, newStatus)) {
            print("Book status updated successfully.");
          } else {
            print("Book not found.");
          }
          break;

        case "7":
          var allBooks = library.getAllBooks();
          if (allBooks.isNotEmpty) {
            allBooks.forEach((book) => print(book));
          } else {
            print("No books available in the library.");
          }
          break;

        case "8":
          print("\nThank you for using the Book Management System!");
          return;

        default:
          print("\nInvalid choice! Please try again.");
      }
    } catch (e) {
      print("Error: ${e}");
    }
  }
}
