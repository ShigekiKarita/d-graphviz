module dot;

import std.string : replace;
import std.format : format;
import std.conv : to;

struct Option {
    string[string] option;
    alias option this;

    auto toString() {
        if (option.length == 0) return "";
        auto s = " [ ";
        foreach (k, v; option) {
            s ~= "%s = \"%s\", ".format(k, v);
        }
        s = s[0 .. $-2] ~ " ]";
        return s;
    }
}

private struct Edge {
    string ark;
    Node src, dst;
    Option option;

    auto toString() {
        return "\"%s\" %s \"%s\" %s;\n".format(src.label, ark, dst.label, option);
    }
}

private class Node {
    string label;
    Option option;

    this(string label) {
        this.label = label.replace("\"", "\\\"");
    }

    this(string label, Option option) {
        this(label);
        this.option = option;
    }

    auto info() {
        if (option.length == 0) return "";
        auto s = "\"%s\" %s;\n".format(label, option);
        return s;
    }
}


abstract class Graph {
    // TODO use Set
    Node[] nodes;
    Edge[] edges;

    auto node(Node d) { return d; }

    auto node(T)(T t) {
        string[string] opt;
        return node(t, opt);
    }

    auto node(T)(T t, string[string] option) {
        auto n = new Node(t.to!string, Option(option));
        this.nodes ~= [n];
        return n;
    }

    auto edge(S, D)(S src, D dst,) {
        string[string] opt;
        return edge(src, dst, opt);
    }

    auto edge(S, D)(S src, D dst, string[string] option) {
        auto s = node(src);
        auto d = node(dst);
        this.nodes ~= [s, d];
        auto e = Edge(this.ark, s, d, Option(option));
        this.edges ~= [e];
        return e;
    }

    abstract string typename();
    abstract string ark();

    override string toString() {
        auto s = this.typename ~ " g{\n";
        foreach (n; this.nodes) {
            s ~= n.info;
        }
        foreach (e; this.edges) {
            s ~= e.to!string;
        }
        s ~= "}\n";
        return s;
    }

    void save(string path) {
        import std.stdio : File;
        auto f = File(path, "w");
        f.write(this.toString());
        f.detach();
    }
}

class Undirected : Graph {
    override string typename() { return "graph"; }
    override string ark() { return "--"; }
}

class Directed : Graph {
    override string typename() { return "digraph"; }
    override string ark() { return "->"; }
}
