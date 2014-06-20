From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] src: revert broken reject icmp code support
Date: Fri, 20 Jun 2014 18:16:55 +0200
Message-ID: <1403281015-9774-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, alvaroneay@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47747 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753457AbaFTQRF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Jun 2014 12:17:05 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch reverts Alvaro's 34040b1 ("reject: add ICMP code parameter
for indicating the type of error") and 11b2bb2 ("reject: Use protocol
context for indicating the reject type").

These patches are flawed by several things:

1) IPv6 support is broken, only ICMP codes are considered.
2) If you don't specify any transport context, the utility exits without
   adding the rule, eg. nft add rule ip filter input reject.
3) If you mistype the ICMP code name, the tool doesn't bail out.

Let's revert this until we can provide appropriate reject reason support.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
On top of this, there's another problem we have to solve. If reject
is used from the inet table, it uses the same ICMP code but that is
not good since IPv4 and IPv6 destination unreachable codes are different
and they don't overlap.

I'm considering different alternatives to fix this, such as renaming
NFTA_REJECT_ICMP_CODE to NFTA_REJECT_REASON which provides an abstract
representation. But the abstraction doesn't seem straight forward to me.

 include/statement.h       |    1 -
 src/evaluate.c            |   17 -----------------
 src/netlink_delinearize.c |    3 ---
 src/netlink_linearize.c   |    2 +-
 src/parser.y              |   34 +++-------------------------------
 src/scanner.l             |    1 -
 src/statement.c           |   31 -------------------------------
 7 files changed, 4 insertions(+), 85 deletions(-)

diff --git a/include/statement.h b/include/statement.h
index 28f9a35..480b719 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -47,7 +47,6 @@ extern struct stmt *limit_stmt_alloc(const struct location *loc);

 struct reject_stmt {
 	enum nft_reject_types	type;
-	int8_t			icmp_code;
 };

 extern struct stmt *reject_stmt_alloc(const struct location *loc);
diff --git a/src/evaluate.c b/src/evaluate.c
index 216194f..2330bbb 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -17,7 +17,6 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter_arp.h>
 #include <linux/netfilter/nf_tables.h>
-#include <linux/icmp.h>

 #include <expression.h>
 #include <statement.h>
@@ -1133,22 +1132,6 @@ static int stmt_evaluate_meta(struct eval_ctx *ctx, struct stmt *stmt)

 static int stmt_evaluate_reject(struct eval_ctx *ctx, struct stmt *stmt)
 {
-	struct proto_ctx *pctx = &ctx->pctx;
-	const struct proto_desc *base;
-
-	base = pctx->protocol[PROTO_BASE_TRANSPORT_HDR].desc;
-	if (base == NULL)
-		return -1;
-
-	if (strcmp(base->name, "tcp") == 0 && stmt->reject.icmp_code == -1) {
-		stmt->reject.type = NFT_REJECT_TCP_RST;
-		stmt->reject.icmp_code = ICMP_NET_UNREACH;
-	} else {
-		stmt->reject.type = NFT_REJECT_ICMP_UNREACH;
-		if (stmt->reject.icmp_code < 0)
-			stmt->reject.icmp_code = ICMP_NET_UNREACH;
-	}
-
 	stmt->flags |= STMT_F_TERMINAL;
 	return 0;
 }
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 8d30b2d..5c6ca80 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -456,9 +456,6 @@ static void netlink_parse_reject(struct netlink_parse_ctx *ctx,
 	struct stmt *stmt;

 	stmt = reject_stmt_alloc(loc);
-	stmt->reject.type = nft_rule_expr_get_u32(expr, NFT_EXPR_REJECT_TYPE);
-	stmt->reject.icmp_code =
-		nft_rule_expr_get_u8(expr, NFT_EXPR_REJECT_CODE);
 	list_add_tail(&stmt->list, &ctx->rule->stmts);
 }

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index b0ca241..8db333c 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -609,7 +609,7 @@ static void netlink_gen_reject_stmt(struct netlink_linearize_ctx *ctx,

 	nle = alloc_nft_expr("reject");
 	nft_rule_expr_set_u32(nle, NFT_EXPR_REJECT_TYPE, stmt->reject.type);
-	nft_rule_expr_set_u8(nle, NFT_EXPR_REJECT_CODE, stmt->reject.icmp_code);
+	nft_rule_expr_set_u8(nle, NFT_EXPR_REJECT_CODE, 0);
 	nft_rule_add_expr(ctx->nlr, nle);
 }

diff --git a/src/parser.y b/src/parser.y
index a427216..3e08e21 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -18,7 +18,6 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
-#include <linux/icmp.h>
 #include <libnftnl/common.h>

 #include <rule.h>
@@ -360,7 +359,6 @@ static int monitor_lookup_event(const char *event)
 %token WEEK			"week"

 %token _REJECT			"reject"
-%token WITH			"with"

 %token SNAT			"snat"
 %token DNAT			"dnat"
@@ -421,8 +419,8 @@ static int monitor_lookup_event(const char *event)
 %type <stmt>			limit_stmt
 %destructor { stmt_free($$); }	limit_stmt
 %type <val>			time_unit
-%type <stmt>			reject_stmt reject_stmt_alloc
-%destructor { stmt_free($$); }	reject_stmt reject_stmt_alloc
+%type <stmt>			reject_stmt
+%destructor { stmt_free($$); }	reject_stmt
 %type <stmt>			nat_stmt nat_stmt_alloc
 %destructor { stmt_free($$); }	nat_stmt nat_stmt_alloc
 %type <stmt>			queue_stmt queue_stmt_alloc queue_range
@@ -1398,38 +1396,12 @@ time_unit		:	SECOND		{ $$ = 1ULL; }
 			|	WEEK		{ $$ = 1ULL * 60 * 60 * 24 * 7; }
 			;

-
-reject_stmt		:	reject_stmt_alloc	reject_opts
-
-reject_stmt_alloc	:	_REJECT
+reject_stmt		:	_REJECT
 			{
 				$$ = reject_stmt_alloc(&@$);
 			}
 			;

-reject_opts		:       /* empty */
-			{
-				$<stmt>0->reject.icmp_code = -1;
-			}
-			|	WITH	STRING
-			{
-				if (strcmp($2, "net-unreach") == 0)
-					$<stmt>0->reject.icmp_code = ICMP_NET_UNREACH;
-				else if (strcmp($2, "host-unreach") == 0)
-					$<stmt>0->reject.icmp_code = ICMP_HOST_UNREACH;
-				else if (strcmp($2, "prot-unreach") == 0)
-					$<stmt>0->reject.icmp_code = ICMP_PROT_UNREACH;
-				else if (strcmp($2, "port-unreach") == 0)
-					$<stmt>0->reject.icmp_code = ICMP_PORT_UNREACH;
-				else if (strcmp($2, "net-prohibited") == 0)
-					$<stmt>0->reject.icmp_code = ICMP_NET_ANO;
-				else if (strcmp($2, "host-prohibited") == 0)
-					$<stmt>0->reject.icmp_code = ICMP_HOST_ANO;
-				else if (strcmp($2, "admin-prohibited") == 0)
-					$<stmt>0->reject.icmp_code = ICMP_PKT_FILTERED;
-			}
-			;
-
 nat_stmt		:	nat_stmt_alloc	nat_stmt_args
 			;

diff --git a/src/scanner.l b/src/scanner.l
index f91886c..73a1a3f 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -295,7 +295,6 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "week"			{ return WEEK; }

 "reject"		{ return _REJECT; }
-"with"			{ return WITH; }

 "snat"			{ return SNAT; }
 "dnat"			{ return DNAT; }
diff --git a/src/statement.c b/src/statement.c
index c566fb8..2dd3f18 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -18,7 +18,6 @@
 #include <statement.h>
 #include <utils.h>
 #include <list.h>
-#include <linux/icmp.h>

 struct stmt *stmt_alloc(const struct location *loc,
 			const struct stmt_ops *ops)
@@ -199,37 +198,7 @@ struct stmt *queue_stmt_alloc(const struct location *loc)

 static void reject_stmt_print(const struct stmt *stmt)
 {
-	const char *icmp_code_name = NULL;
-
 	printf("reject");
-	if (stmt->reject.type != NFT_REJECT_TCP_RST) {
-		switch (stmt->reject.icmp_code) {
-		case ICMP_NET_UNREACH:
-			icmp_code_name = "net-unreach";
-			break;
-		case ICMP_HOST_UNREACH:
-			icmp_code_name = "host-unreach";
-			break;
-		case ICMP_PROT_UNREACH:
-			icmp_code_name = "prot-unreach";
-			break;
-		case ICMP_PORT_UNREACH:
-			icmp_code_name = "port-unreach";
-			break;
-		case ICMP_NET_ANO:
-			icmp_code_name = "net-prohibited";
-			break;
-		case ICMP_HOST_ANO:
-			icmp_code_name = "host-prohibited";
-			break;
-		case ICMP_PKT_FILTERED:
-			icmp_code_name = "admin-prohibited";
-			break;
-		default:
-			icmp_code_name = "Unknown icmp code";
-		}
-		printf(" with %s", icmp_code_name);
-	}
 }

 static const struct stmt_ops reject_stmt_ops = {
--
1.7.10.4

