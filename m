From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 15/17] src: rt: add keyword distinction for nexthop vs nexthop6
Date: Wed, 28 Jun 2017 12:14:08 +0200
Message-ID: <20170628101410.29134-5-fw@strlen.de>
References: <20170628100659.26976-1-fw@strlen.de>
 <20170628101410.29134-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>,
        "Anders K . Pedersen" <akp@cohaesio.com>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:33450 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751899AbdF1KOQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Jun 2017 06:14:16 -0400
In-Reply-To: <20170628101410.29134-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

the rt expression currently always sets NFT_RT_NEXTHOP4 and then
uses the network base to determine if its really supposed to be
NEXTHOP6.

For inet, this will fail because the network base is not known,
so this currently enforces need for "meta nfproto" to dermine the
type.

Allow following syntax instead:
  rt ip nexthop
  rt ip6 nexthop

There is no need for a dependency anymore, as rt expression
checks the hook protocol, ie. NEXTHOP4 will break if the hook pf
is not NFPROTO_IPV4.

Cc: Anders K. Pedersen <akp@cohaesio.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c     | 22 +++++++++-------------
 src/parser_bison.y | 24 +++++++++++++++++++++++-
 src/rt.c           | 14 +++++++++++++-
 3 files changed, 45 insertions(+), 15 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 2d63de0c84e4..12ee091771aa 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -651,32 +651,28 @@ static int expr_evaluate_payload(struct eval_ctx *ctx, struct expr **exprp)
 	return 0;
 }
 
-static int expr_error_base(struct list_head *msgs, const struct expr *e)
-{
-	return expr_error(msgs, e,
-			  "meta nfproto ipv4 or ipv6 must be specified "
-			  "before %s expression", e->ops->name);
-}
-
 /*
  * RT expression: validate protocol dependencies.
  */
 static int expr_evaluate_rt(struct eval_ctx *ctx, struct expr **expr)
 {
-	const struct proto_desc *base;
+	static const char emsg[] = "cannot determine ip protocol version, use \"ip nexthop\" or \"ip6 nexthop\" instead";
 	struct expr *rt = *expr;
 
 	rt_expr_update_type(&ctx->pctx, rt);
 
-	base = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
 	switch (rt->rt.key) {
 	case NFT_RT_NEXTHOP4:
-		if (base != &proto_ip)
-			return expr_error_base(ctx->msgs, rt);
+		if (rt->dtype != &ipaddr_type)
+			return expr_error(ctx->msgs, rt, "%s", emsg);
+		if (ctx->pctx.family == NFPROTO_IPV6)
+			return expr_error(ctx->msgs, rt, "%s nexthop will not match", "ip");
 		break;
 	case NFT_RT_NEXTHOP6:
-		if (base != &proto_ip6)
-			return expr_error_base(ctx->msgs, rt);
+		if (rt->dtype != &ip6addr_type)
+			return expr_error(ctx->msgs, rt, "%s", emsg);
+		if (ctx->pctx.family == NFPROTO_IPV4)
+			return expr_error(ctx->msgs, rt, "%s nexthop will not match", "ip6");
 		break;
 	default:
 		break;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 352acb5dda20..ae3bbcf54801 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -642,7 +642,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 
 %type <expr>			rt_expr
 %destructor { expr_free($$); }	rt_expr
-%type <val>			rt_key
+%type <val>			rt_key_proto	rt_key
 
 %type <expr>			list_stmt_expr
 %destructor { expr_free($$); }	list_stmt_expr
@@ -3035,10 +3035,32 @@ hash_expr		:	JHASH		expr	MOD	NUM	SEED	NUM	offset_opt
 			}
 			;
 
+rt_key_proto		:	IP		{ $$ = NFPROTO_IPV4; }
+			|	IP6		{ $$ = NFPROTO_IPV6; }
+			;
+
 rt_expr			:	RT	rt_key
 			{
 				$$ = rt_expr_alloc(&@$, $2, true);
 			}
+			|	RT	rt_key_proto	rt_key
+			{
+				enum nft_rt_keys rtk = $3;
+
+				switch ($2) {
+				case NFPROTO_IPV4:
+					break;
+				case NFPROTO_IPV6:
+					if ($3 == NFT_RT_NEXTHOP4)
+						rtk = NFT_RT_NEXTHOP6;
+					break;
+				default:
+					YYERROR;
+					break;
+				}
+
+				$$ = rt_expr_alloc(&@$, rtk, false);
+			}
 			;
 
 rt_key			:	CLASSID		{ $$ = NFT_RT_CLASSID; }
diff --git a/src/rt.c b/src/rt.c
index eb5f9c33a595..a39545bfeb27 100644
--- a/src/rt.c
+++ b/src/rt.c
@@ -77,7 +77,19 @@ static const struct rt_template rt_templates[] = {
 
 static void rt_expr_print(const struct expr *expr, struct output_ctx *octx)
 {
-	printf("rt %s", rt_templates[expr->rt.key].token);
+	printf("rt ");
+
+	switch (expr->rt.key) {
+	case NFT_RT_NEXTHOP4:
+		printf("ip ");
+		break;
+	case NFT_RT_NEXTHOP6:
+		printf("ip6 ");
+		break;
+	default:
+		break;
+	}
+	printf("%s", rt_templates[expr->rt.key].token);
 }
 
 static bool rt_expr_cmp(const struct expr *e1, const struct expr *e2)
-- 
2.13.0

