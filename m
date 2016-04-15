From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/1] payload: only merge if adjacent and combined size fits into a register
Date: Fri, 15 Apr 2016 15:09:39 +0200
Message-ID: <1460725779-12066-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:44448 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750722AbcDONJX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Apr 2016 09:09:23 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

add rule ip6 filter input ip6 saddr ::1/128 ip6 daddr ::1/128 fails,
we ask to compare a 32byte immediate which is not supported:

  [ payload load 32b @ network header + 8 => reg 1 ]
  [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x01000000 0x00000000 0x00000000 0x00000000 0x02000000 ]

We would need to use two cmps in this case, i.e.:

  [ payload load 32b @ network header + 8 => reg 1 ]
  [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x01000000 ]
  [ cmp eq reg 2 0x00000000 0x00000000 0x00000000 0x02000000 ]

Seems however that this requires a bit more changes to how nft
handles register allocations, we'd also need to undo the constant merge.

Lets disable merging for now so that we generate

  [ payload load 16b @ network header + 8 => reg 1 ]
  [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x01000000 ]
  [ payload load 16b @ network header + 24 => reg 1 ]
  [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x02000000 ]

... if merge would bring us over the 128 bit register size.

Closes: http://bugzilla.netfilter.org/show_bug.cgi?id=1032
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/payload.h               |  2 +-
 src/payload.c                   | 27 ++++++++++++++++++++-------
 src/rule.c                      |  2 +-
 tests/py/ip6/ip6.t              |  1 +
 tests/py/ip6/ip6.t.payload.inet |  9 +++++++++
 tests/py/ip6/ip6.t.payload.ip6  |  7 +++++++
 6 files changed, 39 insertions(+), 9 deletions(-)

diff --git a/include/payload.h b/include/payload.h
index a19e690..fae3c67 100644
--- a/include/payload.h
+++ b/include/payload.h
@@ -17,7 +17,7 @@ extern int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 extern int exthdr_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 				  struct stmt **res);
 
-extern bool payload_is_adjacent(const struct expr *e1, const struct expr *e2);
+extern bool payload_can_merge(const struct expr *e1, const struct expr *e2);
 extern struct expr *payload_expr_join(const struct expr *e1,
 				      const struct expr *e2);
 
diff --git a/src/payload.c b/src/payload.c
index 7e38061..f6c0a97 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -483,23 +483,36 @@ raw:
 	list_add_tail(&new->list, list);
 }
 
+static bool payload_is_adjacent(const struct expr *e1, const struct expr *e2)
+{
+	if (e1->payload.base		 == e2->payload.base &&
+	    e1->payload.offset + e1->len == e2->payload.offset)
+		return true;
+	return false;
+}
+
 /**
- * payload_is_adjacent - return whether two payload expressions refer to
- * 			 adjacent header locations
+ * payload_can_merge - return whether two payload expressions can be merged
  *
  * @e1:		first payload expression
  * @e2:		second payload expression
  */
-bool payload_is_adjacent(const struct expr *e1, const struct expr *e2)
+bool payload_can_merge(const struct expr *e1, const struct expr *e2)
 {
+	unsigned int total;
+
+	if (!payload_is_adjacent(e1, e2))
+		return false;
+
 	if (e1->payload.offset % BITS_PER_BYTE || e1->len % BITS_PER_BYTE ||
 	    e2->payload.offset % BITS_PER_BYTE || e2->len % BITS_PER_BYTE)
 		return false;
 
-	if (e1->payload.base		 == e2->payload.base &&
-	    e1->payload.offset + e1->len == e2->payload.offset)
-		return true;
-	return false;
+	total = e1->len + e2->len;
+	if (total < e1->len || total > (NFT_REG_SIZE * BITS_PER_BYTE))
+		return false;
+
+	return true;
 }
 
 /**
diff --git a/src/rule.c b/src/rule.c
index b7f4a07..2fe6745 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1292,7 +1292,7 @@ static void payload_do_merge(struct stmt *sa[], unsigned int n)
 		stmt = sa[i];
 		this = stmt->expr;
 
-		if (!payload_is_adjacent(last->left, this->left) ||
+		if (!payload_can_merge(last->left, this->left) ||
 		    last->op != this->op) {
 			last = this;
 			j = i;
diff --git a/tests/py/ip6/ip6.t b/tests/py/ip6/ip6.t
index 9636672..2a1eee7 100644
--- a/tests/py/ip6/ip6.t
+++ b/tests/py/ip6/ip6.t
@@ -139,6 +139,7 @@ ip6 saddr 1234::;ok
 # v61		({v610}|{v611})
 # v60		(::)
 ip6 saddr ::/64;ok
+ip6 saddr ::1 ip6 daddr ::2;ok
 
 - ip6 daddr != {::1234:1234:1234:1234:1234:1234:1234, 1234:1234::1234:1234:1234:1234:1234 };ok
 ip6 daddr != ::1234:1234:1234:1234:1234:1234:1234-1234:1234::1234:1234:1234:1234:1234;ok;ip6 daddr != 0:1234:1234:1234:1234:1234:1234:1234-1234:1234:0:1234:1234:1234:1234:1234
diff --git a/tests/py/ip6/ip6.t.payload.inet b/tests/py/ip6/ip6.t.payload.inet
index 4bafb26..4d2ea35 100644
--- a/tests/py/ip6/ip6.t.payload.inet
+++ b/tests/py/ip6/ip6.t.payload.inet
@@ -449,6 +449,15 @@ inet test-inet input
   [ bitwise reg 1 = (reg=1 & 0xffffffff 0xffffffff 0x00000000 0x00000000 ) ^ 0x00000000 0x00000000 0x00000000 0x00000000 ]
   [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x00000000 ]
 
+# ip6 saddr ::1 ip6 daddr ::2
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x01000000 ]
+  [ payload load 16b @ network header + 24 => reg 1 ]
+  [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x02000000 ]
+
 # ip6 daddr != ::1234:1234:1234:1234:1234:1234:1234-1234:1234::1234:1234:1234:1234:1234
 inet test-inet input
   [ meta load nfproto => reg 1 ]
diff --git a/tests/py/ip6/ip6.t.payload.ip6 b/tests/py/ip6/ip6.t.payload.ip6
index c6e856c..db59bfb 100644
--- a/tests/py/ip6/ip6.t.payload.ip6
+++ b/tests/py/ip6/ip6.t.payload.ip6
@@ -329,6 +329,13 @@ ip6 test-ip6 input
   [ bitwise reg 1 = (reg=1 & 0xffffffff 0xffffffff 0x00000000 0x00000000 ) ^ 0x00000000 0x00000000 0x00000000 0x00000000 ]
   [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x00000000 ]
 
+# ip6 saddr ::1 ip6 daddr ::2
+ip6 test-ip6 input
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x01000000 ]
+  [ payload load 16b @ network header + 24 => reg 1 ]
+  [ cmp eq reg 1 0x00000000 0x00000000 0x00000000 0x02000000 ]
+
 # ip6 daddr != ::1234:1234:1234:1234:1234:1234:1234-1234:1234::1234:1234:1234:1234:1234
 ip6 test-ip6 input
   [ payload load 16b @ network header + 24 => reg 1 ]
-- 
2.7.3

