From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v2 1/3] fib: Support existence check
Date: Sat, 11 Mar 2017 14:31:39 +0100
Message-ID: <20170311133141.8748-2-phil@nwl.cc>
References: <20170311133141.8748-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:50549 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753959AbdCKNby (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 Mar 2017 08:31:54 -0500
In-Reply-To: <20170311133141.8748-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This allows to check whether a FIB entry exists for a given packet by
comparing the expression with a boolean keyword like so:

| fib daddr oif exists

The implementation requires introduction of a generic expression flag
EXPR_F_BOOLEAN which allows relational expression to signal it's LHS
that a boolean comparison is being done (indicated by boolean type on
RHS). In contrast to exthdr existence checks, fib expression can't know
this in beforehand because the LHS syntax is absolutely identical to a
non-boolean comparison.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Adjust tests to changed libnftnl debug output.
---
 include/expression.h                |  2 ++
 include/linux/netfilter/nf_tables.h |  1 +
 src/evaluate.c                      | 14 +++++++++++++-
 src/expression.c                    |  4 ++++
 src/fib.c                           |  5 ++++-
 tests/py/inet/fib.t                 |  3 +++
 tests/py/inet/fib.t.payload         | 10 ++++++++++
 7 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 423eae7128f5c..94573de087ad7 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -171,12 +171,14 @@ struct expr_ops {
  * @EXPR_F_SINGLETON:		singleton (implies primary and constant)
  * @EXPR_F_PROTOCOL:		expressions describes upper layer protocol
  * @EXPR_F_INTERVAL_END:	set member ends an open interval
+ * @EXPR_F_BOOLEAN:		expression is boolean (set by relational expr on LHS)
  */
 enum expr_flags {
 	EXPR_F_CONSTANT		= 0x1,
 	EXPR_F_SINGLETON	= 0x2,
 	EXPR_F_PROTOCOL		= 0x4,
 	EXPR_F_INTERVAL_END	= 0x8,
+	EXPR_F_BOOLEAN		= 0x10,
 };
 
 #include <payload.h>
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 4f7d75682c591..a9280a6541ac6 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -1257,6 +1257,7 @@ enum nft_fib_flags {
 	NFTA_FIB_F_MARK		= 1 << 2,	/* use skb->mark */
 	NFTA_FIB_F_IIF		= 1 << 3,	/* restrict to iif */
 	NFTA_FIB_F_OIF		= 1 << 4,	/* restrict to oif */
+	NFTA_FIB_F_PRESENT	= 1 << 5,	/* check existence only */
 };
 
 #define NFT_OBJECT_UNSPEC	0
diff --git a/src/evaluate.c b/src/evaluate.c
index 7c039cbab5ec3..7ddbb658f96fa 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1658,6 +1658,17 @@ range:
 	return 0;
 }
 
+static int expr_evaluate_fib(struct eval_ctx *ctx, struct expr **exprp)
+{
+	struct expr *expr = *exprp;
+
+	if (expr->flags & EXPR_F_BOOLEAN) {
+		expr->fib.flags |= NFTA_FIB_F_PRESENT;
+		expr->dtype = &boolean_type;
+	}
+	return expr_evaluate_primary(ctx, exprp);
+}
+
 static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
 {
 #ifdef DEBUG
@@ -1680,8 +1691,9 @@ static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
 		return expr_evaluate_exthdr(ctx, expr);
 	case EXPR_VERDICT:
 	case EXPR_META:
-	case EXPR_FIB:
 		return expr_evaluate_primary(ctx, expr);
+	case EXPR_FIB:
+		return expr_evaluate_fib(ctx, expr);
 	case EXPR_PAYLOAD:
 		return expr_evaluate_payload(ctx, expr);
 	case EXPR_RT:
diff --git a/src/expression.c b/src/expression.c
index da94b79f1d913..a6065524f8be8 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -592,6 +592,10 @@ struct expr *relational_expr_alloc(const struct location *loc, enum ops op,
 	expr->left  = left;
 	expr->op    = op;
 	expr->right = right;
+
+	if (right->dtype == &boolean_type)
+		left->flags |= EXPR_F_BOOLEAN;
+
 	return expr;
 }
 
diff --git a/src/fib.c b/src/fib.c
index c65677c811abc..28ef4b50b3ea3 100644
--- a/src/fib.c
+++ b/src/fib.c
@@ -73,7 +73,7 @@ static void __fib_expr_print_f(unsigned int *flags, unsigned int f, const char *
 
 static void fib_expr_print(const struct expr *expr)
 {
-	unsigned int flags = expr->fib.flags;
+	unsigned int flags = expr->fib.flags & ~NFTA_FIB_F_PRESENT;
 
 	printf("fib ");
 	__fib_expr_print_f(&flags, NFTA_FIB_F_SADDR, "saddr");
@@ -130,6 +130,9 @@ struct expr *fib_expr_alloc(const struct location *loc,
 		BUG("Unknown result %d\n", result);
 	}
 
+	if (flags & NFTA_FIB_F_PRESENT)
+		type = &boolean_type;
+
 	expr = expr_alloc(loc, &fib_expr_ops, type,
 			  BYTEORDER_HOST_ENDIAN, len);
 
diff --git a/tests/py/inet/fib.t b/tests/py/inet/fib.t
index 9ee282ab1c93d..dbe45d95b4cfe 100644
--- a/tests/py/inet/fib.t
+++ b/tests/py/inet/fib.t
@@ -12,3 +12,6 @@ fib saddr . iif oifname "lo";ok
 fib daddr . iif type local;ok
 fib daddr . iif type vmap { blackhole : drop, prohibit : drop, unicast : accept };ok
 fib daddr . oif type local;fail
+
+fib daddr oif exists;ok
+fib daddr oif missing;ok
diff --git a/tests/py/inet/fib.t.payload b/tests/py/inet/fib.t.payload
index f5258165384dc..1d4c3d94aa0bf 100644
--- a/tests/py/inet/fib.t.payload
+++ b/tests/py/inet/fib.t.payload
@@ -20,3 +20,13 @@ __map%d test-ip 0
 ip test-ip prerouting
   [ fib daddr . iif type => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
+
+# fib daddr oif exists
+ip test-ip prerouting
+  [ fib daddr oif present => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# fib daddr oif missing
+ip test-ip prerouting
+  [ fib daddr oif present => reg 1 ]
+  [ cmp eq reg 1 0x00000000 ]
-- 
2.11.0

