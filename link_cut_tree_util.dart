part of link_cut_tree;

_connect(Node ch, Node p, bool leftChild) {
  if (leftChild)p.right = ch; else p.left = ch;
  if (ch != null)ch.parent = p;
}

// rotate an edge x.parent to x

_rotate(Node x) {
  var p = x.parent;
  var g = p.parent;
  bool isRootP = isRoot(p);
  bool leftChildX = (x == p.right);

  _connect(leftChildX ? x.left : x.right, p, leftChildX);
  _connect(p, x, !leftChildX);

  if (!isRootP)_connect(x, g, p == g.right); else x.parent = g;
}

_splay(Node x) {
  while (!isRoot(x)) {
    var p = x.parent;
    var gp = p.parent;
    if (!isRoot(p)) {
      var xIsRight = x == p.right;
      var pIsRight = p == gp.right;
      if(xIsRight == pIsRight) {
        // zig-zig
        _rotate(p);
      } else {
        // zig-zag
        _rotate(x);
      }
    }
    _rotate(x);
  }
}

Node _access(Node x) {
  var last = null;
  for (Node y = x; y != null; y = y.parent) {
    _splay(y);
    y.right = last;
    last = y;
  }
  _splay(x);
  return last;
}