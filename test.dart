library main;

import 'package:unittest/unittest.dart';
import 'dart:math';
import 'link_cut_tree.dart';

main() {
  group('LCA', () {
    var n1 = new Node();
    var n2 = new Node();
    var n3 = new Node();
    var n4 = new Node();
    var n5 = new Node();

    link(n2, n1);
    link(n2, n3);
    link(n3, n4);

    test('Test 1', () {
      expect(n2, equals(lca(n1, n4)));
    });
    test('Test 2', () {
      cut(n4);
      link(n3, n5);
      expect(n2, equals(lca(n1, n5)));
    });
  });
  group('Time', () {
    final int n = 10000;
    var nodes = new List<Node>();
    var nodesRaw = new List<Node>();
    nodes.add(new Node());
    nodesRaw.add(new Node());
    for (var i = 0; i < n; ++i) {
      var tmp = new Node();
      var tmpRaw = new Node();

      link(nodes.last, tmp);
// simple link
      tmpRaw.parent = nodesRaw.last;
      nodesRaw.last.right = tmpRaw;

      nodes.add(tmp);
      nodesRaw.add(tmpRaw);
    }

    Node lcaRaw(Node a, Node b) {
      int findHeight(Node node) {
        int res = 0;
        while (!isRoot(node)) {
          ++res;
          node = node.parent;
        }
        return res;
      }

      int ah = findHeight(a);
      int bh = findHeight(b);

      if (ah < bh) {
        var tmpH = ah;
        ah = bh;
        bh = tmpH;

        var tmpNode = a;
        a = b;
        b = tmpNode;
      }

      while (a != null && b != null && (a != b || a.parent != b.parent)) {
        if (ah > bh) {
          --ah;
          a = a.parent;
          continue;
        }
        a = a.parent;
        b = b.parent;
      }
      if (a == null || b == null) return null;
      return a == b ? b : b.parent;
    }
    test('Performance', () {
      var rng = new Random();

      var stopWatch = new Stopwatch();
      stopWatch.start();
      for (var i = 0; i < n; ++i) {
        var index = rng.nextInt(n);
        var first = nodes[index];
        var last = nodes[index + rng.nextInt(n - index)];
// optimisation: do not count expect invocation
        if (first != lca(first, last)) {
          fail('bad ans');
        }
      }
      stopWatch.stop();
      var fastTime = stopWatch.elapsedMilliseconds;


      stopWatch.reset();
      stopWatch.start();
      for (var i = 0; i < n; ++i) {
        var index = rng.nextInt(n);
        var first = nodesRaw[index];
        var last = nodesRaw[index + rng.nextInt(n - index)];
// optimisation: do not count expect invocation
        if (first != lcaRaw(first, last)) {
          fail('bad ans');
        }
      }
      stopWatch.stop();
      var simpleTime = stopWatch.elapsedMilliseconds;

      expect(fastTime < simpleTime, isTrue, reason:'Fast time: $fastTime ms. Raw time: $simpleTime ms (log = ${log(simpleTime)}}).');
      expect(fastTime < n*log(n), isTrue, reason:'fastTime == $fastTime ms should be less then n*log(n) == ${n*log(n)}}).');
    });
  });
}