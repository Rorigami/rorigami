import 'dart:html';

/// Simply allows adding href links to external
/// sites.
class AllowedUriPolicy implements UriPolicy {
  @override
  bool allowsUri(String uri) {
    return true;
  }
}