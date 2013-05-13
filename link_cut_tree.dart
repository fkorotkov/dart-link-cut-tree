library link_cut_tree;

import 'dart:collection';

part 'link_cut_tree_node.dart';
part 'link_cut_tree_util.dart';

/*
  See http://en.wikipedia.org/wiki/Link/cut_tree
 */

link(Node parent, Node child) {
  if (findRoot(child) == findRoot(parent)) return;
  _access(child);
  assert (child.left == null);
  child.parent = parent;
}

cut(Node x) {
  _access(x);
  assert (x.left != null);
  x.left.parent = null;
  x.left = null;
}

Node lca(Node x, Node y) {
  if (findRoot(x) != findRoot(y)) return null;
  _access(x);
  return _access(y);
}

Node findRoot(Node x) {
  _access(x);
  while (x.left != null) x = x.left;
  return x;
}

bool isRoot(Node x) {
  return x.parent == null || (x.parent.left != x && x.parent.right != x);
}