From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 01/10] evaluate: enforce ip6 proto with exthdr expression
Date: Tue,  1 Mar 2016 16:37:41 +0100
Message-ID: <1456846670-28179-2-git-send-email-fw@strlen.de>
References: <1456846670-28179-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49297 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754540AbcCAPhg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Mar 2016 10:37:36 -0500
In-Reply-To: <1456846670-28179-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Don't allow use of exthdr with e.g. ip family.
Move frag.t to ip6 directory and don't use it with ipv4 anymore.

This change causes major test failures for all exthdr users
since they now fail with inet/bridge/netdev families.

Will be resolved in a later patch -- we need to add
an ipv6 dependency for them.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                  |  18 ++++++-
 tests/py/any/frag.t             |  67 ------------------------
 tests/py/any/frag.t.payload     | 109 ----------------------------------------
 tests/py/ip6/frag.t             |  63 +++++++++++++++++++++++
 tests/py/ip6/frag.t.payload.ip6 | 109 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 189 insertions(+), 177 deletions(-)
 delete mode 100644 tests/py/any/frag.t
 delete mode 100644 tests/py/any/frag.t.payload
 create mode 100644 tests/py/ip6/frag.t
 create mode 100644 tests/py/ip6/frag.t.payload.ip6

diff --git a/src/evaluate.c b/src/evaluate.c
index a49cdd9..47a1f8c 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -343,6 +343,21 @@ conflict_resolution_gen_dependency(struct eval_ctx *ctx, int protocol,
 	return 0;
 }
 
+/*
+ * Exthdr expression: check whether dependencies are fulfilled.
+ */
+static int expr_evaluate_exthdr(struct eval_ctx *ctx, struct expr **expr)
+{
+	const struct proto_desc *base;
+
+	base = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
+	if (base == &proto_ip6)
+		return expr_evaluate_primary(ctx, expr);
+
+	return expr_error(ctx->msgs, *expr,
+			  "exthdr can only be used with ipv6");
+}
+
 /* dependency supersede.
  *
  * 'inet' is a 'phony' l2 dependeny used by NFPROTO_INET to fulfill network
@@ -1320,8 +1335,9 @@ static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
 		return 0;
 	case EXPR_VALUE:
 		return expr_evaluate_value(ctx, expr);
-	case EXPR_VERDICT:
 	case EXPR_EXTHDR:
+		return expr_evaluate_exthdr(ctx, expr);
+	case EXPR_VERDICT:
 	case EXPR_META:
 		return expr_evaluate_primary(ctx, expr);
 	case EXPR_PAYLOAD:
diff --git a/tests/py/any/frag.t b/tests/py/any/frag.t
deleted file mode 100644
index 8b5e34a..0000000
--- a/tests/py/any/frag.t
+++ /dev/null
@@ -1,67 +0,0 @@
-:output;type filter hook output priority 0
-:ingress;type filter hook ingress device lo priority 0
-
-*ip;test-ip4;output
-*ip6;test-ip6;output
-*inet;test-inet;output
-*arp;test-arp;output
-*bridge;test-bridge;output
-*netdev;test-netdev;ingress
-
-frag nexthdr tcp;ok;frag nexthdr 6
-frag nexthdr != icmp;ok;frag nexthdr != 1
-frag nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp};ok;frag nexthdr { 51, 136, 132, 6, 108, 50, 17, 33}
-- frag nexthdr != {esp, ah, comp, udp, udplite, tcp, dccp, sctp};ok
-frag nexthdr esp;ok;frag nexthdr 50
-frag nexthdr ah;ok;frag nexthdr 51
-
-frag reserved 22;ok
-frag reserved != 233;ok
-frag reserved 33-45;ok
-frag reserved != 33-45;ok
-frag reserved { 33, 55, 67, 88};ok
-- frag reserved != { 33, 55, 67, 88};ok
-frag reserved { 33-55};ok
-- frag reserved != { 33-55};ok
-
-# BUG: frag frag-off 22 and frag frag-off { 33-55}
-# This breaks table listing: "netlink: Error: Relational expression size mismatch"
-
-- frag frag-off 22;ok
-- frag frag-off != 233;ok
-- frag frag-off 33-45;ok
-- frag frag-off != 33-45;ok
-- frag frag-off { 33, 55, 67, 88};ok
-- frag frag-off != { 33, 55, 67, 88};ok
-- frag frag-off { 33-55};ok
-- frag frag-off != { 33-55};ok
-
-# BUG  frag reserved2 33 and frag reserved2 1
-# $ sudo nft add rule ip test input frag reserved2 33
-# <cmdline>:1:39-40: Error: Value 33 exceeds valid range 0-3
-# add rule ip test input frag reserved2 33
-#                                      ^^
-# sudo nft add rule ip test input frag reserved2 1
-# <cmdline>:1:1-39: Error: Could not process rule: Invalid argument
-# add rule ip test input frag reserved2 1
-# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-
-# BUG more-fragments 1 and frag more-fragments 4
-# frag more-fragments 1
-# <cmdline>:1:1-44: Error: Could not process rule: Invalid argument
-# add rule ip test input frag more-fragments 1
-# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-# $ sudo nft add rule ip test input frag more-fragments 4
-# <cmdline>:1:44-44: Error: Value 4 exceeds valid range 0-1
-# add rule ip test input frag more-fragments 4
-#                                           ^
-
-frag id 1;ok
-frag id 22;ok
-frag id != 33;ok
-frag id 33-45;ok
-frag id != 33-45;ok
-frag id { 33, 55, 67, 88};ok
-- frag id != { 33, 55, 67, 88};ok
-frag id { 33-55};ok
-- frag id != { 33-55};ok
diff --git a/tests/py/any/frag.t.payload b/tests/py/any/frag.t.payload
deleted file mode 100644
index a91ab3f..0000000
--- a/tests/py/any/frag.t.payload
+++ /dev/null
@@ -1,109 +0,0 @@
-# frag nexthdr tcp
-ip test-ip4 output
-  [ exthdr load 1b @ 44 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-
-# frag nexthdr != icmp
-ip test-ip4 output
-  [ exthdr load 1b @ 44 + 0 => reg 1 ]
-  [ cmp neq reg 1 0x00000001 ]
-
-# frag nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp}
-set%d test-ip4 3
-set%d test-ip4 0
-	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
-ip test-ip4 output
-  [ exthdr load 1b @ 44 + 0 => reg 1 ]
-  [ lookup reg 1 set set%d ]
-
-# frag nexthdr esp
-ip test-ip4 output
-  [ exthdr load 1b @ 44 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000032 ]
-
-# frag nexthdr ah
-ip test-ip4 output
-  [ exthdr load 1b @ 44 + 0 => reg 1 ]
-  [ cmp eq reg 1 0x00000033 ]
-
-# frag reserved 22
-ip test-ip4 output
-  [ exthdr load 1b @ 44 + 1 => reg 1 ]
-  [ cmp eq reg 1 0x00000016 ]
-
-# frag reserved != 233
-ip test-ip4 output
-  [ exthdr load 1b @ 44 + 1 => reg 1 ]
-  [ cmp neq reg 1 0x000000e9 ]
-
-# frag reserved 33-45
-ip test-ip4 output
-  [ exthdr load 1b @ 44 + 1 => reg 1 ]
-  [ cmp gte reg 1 0x00000021 ]
-  [ cmp lte reg 1 0x0000002d ]
-
-# frag reserved != 33-45
-ip test-ip4 output
-  [ exthdr load 1b @ 44 + 1 => reg 1 ]
-  [ cmp lt reg 1 0x00000021 ]
-  [ cmp gt reg 1 0x0000002d ]
-
-# frag reserved { 33, 55, 67, 88}
-set%d test-ip4 3
-set%d test-ip4 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
-ip test-ip4 output
-  [ exthdr load 1b @ 44 + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
-
-# frag reserved { 33-55}
-set%d test-ip4 7
-set%d test-ip4 0
-	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
-ip test-ip4 output
-  [ exthdr load 1b @ 44 + 1 => reg 1 ]
-  [ lookup reg 1 set set%d ]
-
-# frag id 1
-ip test-ip4 output
-  [ exthdr load 4b @ 44 + 4 => reg 1 ]
-  [ cmp eq reg 1 0x01000000 ]
-
-# frag id 22
-ip test-ip4 output
-  [ exthdr load 4b @ 44 + 4 => reg 1 ]
-  [ cmp eq reg 1 0x16000000 ]
-
-# frag id != 33
-ip test-ip4 output
-  [ exthdr load 4b @ 44 + 4 => reg 1 ]
-  [ cmp neq reg 1 0x21000000 ]
-
-# frag id 33-45
-ip test-ip4 output
-  [ exthdr load 4b @ 44 + 4 => reg 1 ]
-  [ cmp gte reg 1 0x21000000 ]
-  [ cmp lte reg 1 0x2d000000 ]
-
-# frag id != 33-45
-ip test-ip4 output
-  [ exthdr load 4b @ 44 + 4 => reg 1 ]
-  [ cmp lt reg 1 0x21000000 ]
-  [ cmp gt reg 1 0x2d000000 ]
-
-# frag id { 33, 55, 67, 88}
-set%d test-ip4 3
-set%d test-ip4 0
-	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
-ip test-ip4 output
-  [ exthdr load 4b @ 44 + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
-
-# frag id { 33-55}
-set%d test-ip4 7
-set%d test-ip4 0
-	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
-ip test-ip4 output
-  [ exthdr load 4b @ 44 + 4 => reg 1 ]
-  [ lookup reg 1 set set%d ]
-
diff --git a/tests/py/ip6/frag.t b/tests/py/ip6/frag.t
new file mode 100644
index 0000000..56801ed
--- /dev/null
+++ b/tests/py/ip6/frag.t
@@ -0,0 +1,63 @@
+:output;type filter hook output priority 0
+:ingress;type filter hook ingress device lo priority 0
+
+*ip6;test-ip6;output
+*inet;test-inet;output
+
+frag nexthdr tcp;ok;frag nexthdr 6
+frag nexthdr != icmp;ok;frag nexthdr != 1
+frag nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp};ok;frag nexthdr { 51, 136, 132, 6, 108, 50, 17, 33}
+- frag nexthdr != {esp, ah, comp, udp, udplite, tcp, dccp, sctp};ok
+frag nexthdr esp;ok;frag nexthdr 50
+frag nexthdr ah;ok;frag nexthdr 51
+
+frag reserved 22;ok
+frag reserved != 233;ok
+frag reserved 33-45;ok
+frag reserved != 33-45;ok
+frag reserved { 33, 55, 67, 88};ok
+- frag reserved != { 33, 55, 67, 88};ok
+frag reserved { 33-55};ok
+- frag reserved != { 33-55};ok
+
+# BUG: frag frag-off 22 and frag frag-off { 33-55}
+# This breaks table listing: "netlink: Error: Relational expression size mismatch"
+
+- frag frag-off 22;ok
+- frag frag-off != 233;ok
+- frag frag-off 33-45;ok
+- frag frag-off != 33-45;ok
+- frag frag-off { 33, 55, 67, 88};ok
+- frag frag-off != { 33, 55, 67, 88};ok
+- frag frag-off { 33-55};ok
+- frag frag-off != { 33-55};ok
+
+# BUG  frag reserved2 33 and frag reserved2 1
+# $ sudo nft add rule ip test input frag reserved2 33
+# <cmdline>:1:39-40: Error: Value 33 exceeds valid range 0-3
+# add rule ip test input frag reserved2 33
+#                                      ^^
+# sudo nft add rule ip test input frag reserved2 1
+# <cmdline>:1:1-39: Error: Could not process rule: Invalid argument
+# add rule ip test input frag reserved2 1
+# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+# BUG more-fragments 1 and frag more-fragments 4
+# frag more-fragments 1
+# <cmdline>:1:1-44: Error: Could not process rule: Invalid argument
+# add rule ip test input frag more-fragments 1
+# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+# $ sudo nft add rule ip test input frag more-fragments 4
+# <cmdline>:1:44-44: Error: Value 4 exceeds valid range 0-1
+# add rule ip test input frag more-fragments 4
+#                                           ^
+
+frag id 1;ok
+frag id 22;ok
+frag id != 33;ok
+frag id 33-45;ok
+frag id != 33-45;ok
+frag id { 33, 55, 67, 88};ok
+- frag id != { 33, 55, 67, 88};ok
+frag id { 33-55};ok
+- frag id != { 33-55};ok
diff --git a/tests/py/ip6/frag.t.payload.ip6 b/tests/py/ip6/frag.t.payload.ip6
new file mode 100644
index 0000000..f2d04b6
--- /dev/null
+++ b/tests/py/ip6/frag.t.payload.ip6
@@ -0,0 +1,109 @@
+# frag nexthdr tcp
+ip6 test-ip6 output
+  [ exthdr load 1b @ 44 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+
+# frag nexthdr != icmp
+ip6 test-ip6 output
+  [ exthdr load 1b @ 44 + 0 => reg 1 ]
+  [ cmp neq reg 1 0x00000001 ]
+
+# frag nexthdr {esp, ah, comp, udp, udplite, tcp, dccp, sctp}
+set%d test-ip6 3
+set%d test-ip6 0
+	element 00000032  : 0 [end]	element 00000033  : 0 [end]	element 0000006c  : 0 [end]	element 00000011  : 0 [end]	element 00000088  : 0 [end]	element 00000006  : 0 [end]	element 00000021  : 0 [end]	element 00000084  : 0 [end]
+ip6 test-ip6 output
+  [ exthdr load 1b @ 44 + 0 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# frag nexthdr esp
+ip6 test-ip6 output
+  [ exthdr load 1b @ 44 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000032 ]
+
+# frag nexthdr ah
+ip6 test-ip6 output
+  [ exthdr load 1b @ 44 + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000033 ]
+
+# frag reserved 22
+ip6 test-ip6 output
+  [ exthdr load 1b @ 44 + 1 => reg 1 ]
+  [ cmp eq reg 1 0x00000016 ]
+
+# frag reserved != 233
+ip6 test-ip6 output
+  [ exthdr load 1b @ 44 + 1 => reg 1 ]
+  [ cmp neq reg 1 0x000000e9 ]
+
+# frag reserved 33-45
+ip6 test-ip6 output
+  [ exthdr load 1b @ 44 + 1 => reg 1 ]
+  [ cmp gte reg 1 0x00000021 ]
+  [ cmp lte reg 1 0x0000002d ]
+
+# frag reserved != 33-45
+ip6 test-ip6 output
+  [ exthdr load 1b @ 44 + 1 => reg 1 ]
+  [ cmp lt reg 1 0x00000021 ]
+  [ cmp gt reg 1 0x0000002d ]
+
+# frag reserved { 33, 55, 67, 88}
+set%d test-ip6 3
+set%d test-ip6 0
+	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
+ip6 test-ip6 output
+  [ exthdr load 1b @ 44 + 1 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# frag reserved { 33-55}
+set%d test-ip6 7
+set%d test-ip6 0
+	element 00000000  : 1 [end]	element 00000021  : 0 [end]	element 00000038  : 1 [end]
+ip6 test-ip6 output
+  [ exthdr load 1b @ 44 + 1 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# frag id 1
+ip6 test-ip6 output
+  [ exthdr load 4b @ 44 + 4 => reg 1 ]
+  [ cmp eq reg 1 0x01000000 ]
+
+# frag id 22
+ip6 test-ip6 output
+  [ exthdr load 4b @ 44 + 4 => reg 1 ]
+  [ cmp eq reg 1 0x16000000 ]
+
+# frag id != 33
+ip6 test-ip6 output
+  [ exthdr load 4b @ 44 + 4 => reg 1 ]
+  [ cmp neq reg 1 0x21000000 ]
+
+# frag id 33-45
+ip6 test-ip6 output
+  [ exthdr load 4b @ 44 + 4 => reg 1 ]
+  [ cmp gte reg 1 0x21000000 ]
+  [ cmp lte reg 1 0x2d000000 ]
+
+# frag id != 33-45
+ip6 test-ip6 output
+  [ exthdr load 4b @ 44 + 4 => reg 1 ]
+  [ cmp lt reg 1 0x21000000 ]
+  [ cmp gt reg 1 0x2d000000 ]
+
+# frag id { 33, 55, 67, 88}
+set%d test-ip6 3
+set%d test-ip6 0
+	element 21000000  : 0 [end]	element 37000000  : 0 [end]	element 43000000  : 0 [end]	element 58000000  : 0 [end]
+ip6 test-ip6 output
+  [ exthdr load 4b @ 44 + 4 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# frag id { 33-55}
+set%d test-ip6 7
+set%d test-ip6 0
+	element 00000000  : 1 [end]	element 21000000  : 0 [end]	element 38000000  : 1 [end]
+ip6 test-ip6 output
+  [ exthdr load 4b @ 44 + 4 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
-- 
2.4.10

