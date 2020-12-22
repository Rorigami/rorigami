import 'dart:html';
import 'package:yaml/yaml.dart';
import 'package:logging/logging.dart';
import 'models/policies.dart';
import 'models/render.dart';

/// Where most of the magic truly happens. After loading the yml configuration,
/// the application consecutively loads the header, the body and the footer.
/// The site will allow you to create links within the site, as well as outside
/// of it. All the internal ones must begin with a hash '#' sign, followed by the
/// directory in which the static file is located. For instance, if you want to
/// add a link to an html file inside views/example/some-example.html, the <a>
/// tag must look like <a href="#example/some-example">this</a>. For more details,
/// please refer to the documentation.
///
/// The following tags allow using the attributes listed below:
/// <a>     : href, target, data-toggle, data-target
/// <nav>   : role, area-label
/// <img>   : src
class Application extends View {
  final Logger _log = Logger('Rorigami');
  final NodeValidatorBuilder _htmlValidator = NodeValidatorBuilder.common()
    ..allowElement('a',
        attributes: ['data-target', 'data-toggle', 'href', 'target'],
        uriPolicy: AllowedUriPolicy())
    ..allowElement('nav',
        attributes: ['aria-label', 'role'], uriPolicy: AllowedUriPolicy())
    ..allowElement('img', attributes: ['src'], uriPolicy: AllowedUriPolicy())
    ..allowElement('code',
        attributes: ['data-language'], uriPolicy: AllowedUriPolicy());
  YamlMap _config;

  final HtmlElement _body = querySelector('body');
  String initialPage;
  String page;

  /// The application is initialized in this constructor. the [Config] is
  /// a YamlMap, that is the yaml inside the configuration yaml set in the
  /// meta tag inside <head>. The constructor simply sets the config as a
  /// class property nd calls the _preInit method.
  Application(YamlMap Config) {
    _config = Config;
    if (_config['elements'] != null) {
      _config['elements'].forEach((el, attrs) => {
            _htmlValidator.allowElement(el,
                attributes: List<String>.from(attrs),
                uriPolicy: AllowedUriPolicy())
          });
    }
    _preInit();
  }

  void _preInit() {
    initialPage = _config['initialPage'];
    _log.info(_config);
    querySelector('title').text = _config['title'];
    loadStyles();
    _setup();
  }

  /// Consecutively loads:
  ///
  /// 1. Header html template.
  /// 2. Contents html template.
  /// 3. Index template within the contents template.
  /// 4. Footer template.
  void _setup() {
    HttpRequest.getString('${_config['views']}/${_config['header']}')
        .then((header) {
      _log.info(
          'Header `${_config['views']}/${_config['header']}` loaded sucesfully');
      _body.appendHtml(header, validator: _htmlValidator);
      HttpRequest.getString('${_config['views']}/${_config['contents']}')
          .then((contents) {
        _body.appendHtml(contents, validator: _htmlValidator);
        window.onPopState.listen((PopStateEvent e) {
          initContents(getLocation());
        });
        initContents(getLocation());
        HttpRequest.getString('${_config['views']}/${_config['footer']}').then(
            (footer) {
          _body.appendHtml(footer, validator: _htmlValidator);
          _log.info(
              'Footer `${_config['views']}/${_config['footer']}` loaded sucesfuly');
        }).catchError((_) => _log.shout(
            'Unable to load footer: ${_config['views']}/${_config['footer']}'));
      });
    }).catchError((_) => _log.shout(
            'Unable to load header: ${_config['views']}/${_config['header']}'));
  }

  /// Loads all css files from the yaml config into the <head> tag.
  void loadStyles() {
    _config['styles'].forEach((style) {
      Element el = Element.tag('link');
      el.setAttribute('href', style);
      el.setAttribute('rel', 'stylesheet');
      querySelector('head').append(el);
    });
  }

  /// Loads the html/markdown files into the main contents template,
  /// Based on the uri.
  void initContents(String template) {
    if (!template.contains('/')) {
      return;
    }
    String ext = '.html';
    if (template.endsWith('.md')) {
      ext = '';
    }
    HttpRequest.getString('${_config["views"]}/$template$ext').then((resp) {
      querySelector('#_contents')
          .setInnerHtml(render(resp, ext), validator: _htmlValidator);
      window.scrollTo(0, 0);
      querySelector('table').classes.add('table');
      _log.info('File `${_config["views"]}/$template$ext` loaded successfully.');
    }).catchError((_) =>
        _log.shout('Unable to load file: ${_config["views"]}/$template$ext'));
  }

  /// Handles the routing. Any href attribute starting with '#' is treated as a
  /// template, everything else goes to wherever you point it.
  String getLocation() {
    String loc = window.location.hash;
    if (loc.startsWith('#')) {
      loc = loc.substring(1);
    }
    if (loc == '#/' || loc == '/' || loc == '' || loc == 'index') {
      loc = initialPage;
    }
    return loc;
  }
}
