# d-graphviz

Graphviz utility for D

![dot](simple.dot.png)

created by

```d
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
    g.save("simple.dot");
}
```

and `$ dot simple.dot -Tpng -O`


## practical example

library dependency graph

```d
import std.path;
import std.process;

void main() {
    // set phobos root
    auto dc = environment.get("DC");
    assert(dc != "", "use DUB or set $DC enviroment variable");
    auto which = executeShell("which " ~ dc);
    assert(which.status == 0);
    version(DigitalMars) {
        auto root = which.output.dirName ~ "/../../src/phobos/";
    }
    version(LDC) {
        auto root = which.output.dirName ~ "/../import/";
    }

    // plot std.range dependency graph
    auto g = libraryDependency(root, "std/range", true);
    g.save("range.dot");
}
```

result `$ dot range.dot -Tpng -O`

![range](range.dot.png)

## TODO

- use set ops to remove duplicated nodes and edges
- do string sanity check
- support subgraph
