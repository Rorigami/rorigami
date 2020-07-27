# Wanna get involved? Awesome!

As stated before, the base project relies on [bulma.css](https://bulma.io) and [fontawesome](https://fontawesome.com/).

While the final product is a ~300kb javascript file, the original source is written in Dart. There are many reasons for
this choice but the major one is my very unhealthy relationship and negative views on js. Dart on the other hand is a
very decent language and behaves just as you would expect, so this is what Rorigami relies on.

## The index.

Like anything on the web, we need to start with the index. index.html. It is very small and compact:

```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="rorigamiconf" content="application.yml">
    <title></title>
    <link rel="icon" href="static/favicon.ico">
    <script defer src="main.dart.js"></script>
</head>
<body class="main">
</body>
</html>
```

There isn't really a lot to see here. The important things to note are the `rorogamiconf` meta. This attribute
tells where the configuration yml file is located. In most cases you shouldn't need to touch that but in case
you need to, the option is there.

The second part is the favicon, and there isn't a whole lot to say about it.

The third part is the `main.dart.js` script and this is where everything happens.

The entry point in the dart source code is located [here](https://github.com/rorigami/rorigami/blob/master/web/main.dart) and 
looks like this:

```
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
  });
}
```

What it does is it parses the configuration yml file and creates an instance of the `Application` class,
located [here](https://github.com/Rorigami/rorigami/blob/master/web/app/application/application.dart)

From here on out, the constructor loads, the css stylesheets, header and footer, initializes the router and
dispatches the requested view. Simple as that.

### Running in development.

You will need to install the [Dart SDK](https://dart.dev/get-dart) as well as [webdev](https://pub.dev/packages/webdev).

Open up a terminal, cd into the root directory and pull the dependencies by running:

```
$ pub get
```

This will fetch all the dependencies. Once it's done you can run the application with:

```
$ webdev serve
```

At this point you can navigate to [http://127.0.0.1:8080](http://127.0.0.1:8080) and you should
see the skeleton application.

To build the changes run

```
$ webdev build
```

This will generate all the files needed for running Rorigami in production under the `build` directory.

## IMORTANT

the build directory should be added to your `.gitignore`.

PR's are welcome, under some guidelines:

1. There must be an explanation for any changes/additions/deletions.
2. Do not submit pull requests which include builds.
3. Document your code.
4. Do not over-complicate things.
5. A PR does not mean it will be accepted unconditionally. The aim of the project is to be simple and if a PR adds 
unnecessary complexity which isn't beneficial, your best course of action is to fork the repo into a separate project. 
