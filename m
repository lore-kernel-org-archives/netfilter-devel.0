From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] ct: fix inet/bridge/netdev family handling for saddr/daddr
Date: Mon, 29 May 2017 19:25:38 +0200
Message-ID: <20170529172538.27878-2-fw@strlen.de>
References: <20170529172538.27878-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:33232 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750886AbdE2RZj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 May 2017 13:25:39 -0400
In-Reply-To: <20170529172538.27878-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

"ct orignal saddr" has an invalid data type, as the address can be either ipv4 or ipv6.
For some cases we could infer it from the rhs, but there are cases where we don't have any
information, e.g. when passing ct original saddr to jhash expression.

So do the same thing that we do for "rt nexthop" -- error out and hint to user
they need to specifiy the desired address type with "meta nfproto".

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c            | 27 ++++++++++++++++++++-------
 tests/py/any/ct.t         |  4 ++++
 tests/py/any/ct.t.payload |  7 +++++++
 3 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 4ca14842a184..311c86c5abe9 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -649,6 +649,13 @@ static int expr_evaluate_payload(struct eval_ctx *ctx, struct expr **exprp)
 	return 0;
 }
 
+static int expr_error_base(struct list_head *msgs, const struct expr *e)
+{
+	return expr_error(msgs, e,
+			  "meta nfproto ipv4 or ipv6 must be specified "
+			  "before %s expression", e->ops->name);
+}
+
 /*
  * RT expression: validate protocol dependencies.
  */
@@ -663,22 +670,17 @@ static int expr_evaluate_rt(struct eval_ctx *ctx, struct expr **expr)
 	switch (rt->rt.key) {
 	case NFT_RT_NEXTHOP4:
 		if (base != &proto_ip)
-			goto err;
+			return expr_error_base(ctx->msgs, rt);
 		break;
 	case NFT_RT_NEXTHOP6:
 		if (base != &proto_ip6)
-			goto err;
+			return expr_error_base(ctx->msgs, rt);
 		break;
 	default:
 		break;
 	}
 
 	return expr_evaluate_primary(ctx, expr);
-
-err:
-	return expr_error(ctx->msgs, rt,
-			  "meta nfproto ipv4 or ipv6 must be specified "
-			  "before routing expression");
 }
 
 /*
@@ -687,10 +689,21 @@ err:
  */
 static int expr_evaluate_ct(struct eval_ctx *ctx, struct expr **expr)
 {
+	const struct proto_desc *base;
 	struct expr *ct = *expr;
 
 	ct_expr_update_type(&ctx->pctx, ct);
 
+	base = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
+	switch (ct->ct.key) {
+	case NFT_CT_SRC:
+	case NFT_CT_DST:
+		if (base != &proto_ip && base != &proto_ip6)
+			return expr_error_base(ctx->msgs, ct);
+	default:
+		break;
+	}
+
 	return expr_evaluate_primary(ctx, expr);
 }
 
diff --git a/tests/py/any/ct.t b/tests/py/any/ct.t
index 96a80f84a218..667126e656ae 100644
--- a/tests/py/any/ct.t
+++ b/tests/py/any/ct.t
@@ -91,6 +91,10 @@ ct bytes original reply;fail
 # missing direction
 ct saddr 1.2.3.4;fail
 
+meta nfproto ipv4 ct original saddr 1.2.3.4;ok
+# wrong base (ip6 but ipv4 address given)
+meta nfproto ipv6 ct original saddr 1.2.3.4;fail
+
 # direction, but must be used without
 ct original mark 42;fail
 # swapped key and direction
diff --git a/tests/py/any/ct.t.payload b/tests/py/any/ct.t.payload
index 6077e5da63b8..c5fa7c8d49e4 100644
--- a/tests/py/any/ct.t.payload
+++ b/tests/py/any/ct.t.payload
@@ -373,6 +373,13 @@ ip test-ip4 output
   [ byteorder reg 1 = hton(reg 1, 8, 8) ]
   [ cmp lt reg 1 0x00000000 0xf4010000 ]
 
+# meta nfproto ipv4 ct original saddr 1.2.3.4
+ip test-ip4 output
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ ct load src => reg 1 , dir original ]
+  [ cmp eq reg 1 0x04030201 ]
+
 # ct status expected,seen-reply,assured,confirmed,snat,dnat,dying
 ip test-ip4 output
   [ ct load status => reg 1 ]
-- 
2.13.0

