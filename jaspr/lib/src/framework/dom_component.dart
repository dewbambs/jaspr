part of framework;

typedef EventCallback = void Function();

/// Represents a dom element
class DomComponent extends Component {
  DomComponent({
    Key? key,
    required this.tag,
    this.id,
    this.classes,
    this.styles,
    this.attributes,
    this.events,
    Component? child,
    List<Component>? children,
  })  : children = [if (child != null) child, ...children ?? []],
        super(key: key);

  final String tag;
  final String? id;
  final Iterable<String>? classes;
  final Map<String, String>? styles;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;
  final List<Component>? children;

  @override
  Element createElement() => DomElement(this);
}

class DomElement extends MultiChildElement with BuildScheduler {
  DomElement(DomComponent component) : super(component);

  @override
  DomComponent get component => super.component as DomComponent;

  @override
  Iterable<Component> build() => component.children ?? [];

  @override
  void update(DomComponent newComponent) {
    super.update(newComponent);
    _dirty = true;
    root.performRebuildOn(this);
  }

  @override
  void render(DomBuilder b) {
    b.open(
      component.tag,
      key: component.key?.hashCode.toString(),
      id: component.id,
      classes: component.classes,
      styles: component.styles,
      attributes: component.attributes,
      events: component.events?.map((k, v) => MapEntry(k, (e) => v())),
      onCreate: (event) {
        view = event.view;
      },
      onUpdate: (event) {
        view = event.view;
      },
    );

    super.render(b);

    b.close(tag: component.tag);
  }
}

/// Represents a plain text node
/// This has no other properties. I.e. styling is done through the parent element(s) and their styles.
class Text extends Component {
  Text(this.text, {Key? key}) : super(key: key);

  final String text;

  @override
  Element createElement() {
    return TextElement(this);
  }
}

class TextElement extends Element {
  TextElement(Text component) : super(component);

  @override
  Text get _component => super._component as Text;

  @override
  void render(DomBuilder b) {
    b.text(_component.text);
  }

  @override
  void rebuild() {}

  @override
  void visitChildren(ElementVisitor visitor) {}
}
