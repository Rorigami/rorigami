import 'dart:html';
import 'package:yaml/yaml.dart';
import 'app/application/application.dart';
import 'app/application/models/logging.dart';

/// The configuration file has to sit inside the <head> tag,
/// under <meta name="rorigamiconf" content="[config.yml]">
/// where the [config.yml] has to be full or relative path to the
/// configuration file. Please refer to the documentation for
/// more details.
void main() {
  String config =
      querySelector('meta[name="rorigamiconf"]').getAttribute('content');
  HttpRequest.getString(config).then((resp) {
    YamlMap config = loadYaml(resp);
    AppLog(config['logLevel']);
    Application(config);
  }).catchError((err) => window.alert('Unable to load configuration,'
      'please check the developer console for more details.'));
}
