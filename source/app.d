import std.stdio;
import std.format;

static import dot;

struct A {
    auto toString() {
        return "A\n\"struct\"";
    }
}

void main()
{
    auto g = new dot.Directed;
    A a;
    with (g) {
        node(a, ["shape": "box", "color": "#ff0000"]);
        edge(a, true);
        edge(a, 1, ["style": "dashed", "label": "a-to-1"]);
        edge(true, "foo");
    }
    g.save("test.dot");
}
