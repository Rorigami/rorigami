import 'package:markdown/markdown.dart';

/// Handles the rendering of data from the html/markdown
/// files.
class View {

  /// Returns an html string which is rendered in the main
  /// container. In essence, the [data] parameter is whatever
  /// has been loaded from the static file, while [ext] is the
  /// extension of the file, either '.html' or '.md', '.html'
  /// being the default. If '.md' is passed, then the markdown
  /// is translated and returned as plain html.
  String render(String data, [String ext = '.html']){
    if(ext != '.html') {
      data = markdownToHtml(data);
    }
    print(data);
    return data;
  }
}