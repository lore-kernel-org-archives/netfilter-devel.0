From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nftables PATCH 2/2] reject: add ICMP code field parameter for indicating the type of error
Date: Wed, 11 Jun 2014 18:51:03 +0200
Message-ID: <1402505463-8420-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38792 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbaFKQvW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jun 2014 12:51:22 -0400
Received: by mail-wi0-f178.google.com with SMTP id n15so1513141wiw.17
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Jun 2014 09:51:20 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch allows to indicate the code field in case that we
use reject. Before, we have sent always network unreachable error
like code fiend and now we can determine the code field that
we want to use. Example:

nft add rule filter input tcp dport 22 reject with host-unreach
or
nft add rule filter input udp dport 22 reject with host-unreach

In this case, we are going to use the code field host unreachable.

The default code field still is network unreachable and we can use
also the rules without the with like that:

nft add rule filter input udp dport 22 reject

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 include/statement.h       |    1 +
 src/evaluate.c            |   10 ++++++++--
 src/netlink_delinearize.c |    2 ++
 src/netlink_linearize.c   |    2 +-
 src/parser.y              |   34 +++++++++++++++++++++++++++++++---
 src/scanner.l             |    1 +
 src/statement.c           |   31 +++++++++++++++++++++++++++++++
 7 files changed, 75 insertions(+), 6 deletions(-)

diff --git a/include/statement.h b/include/statement.h
index 480b719..28f9a35 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -47,6 +47,7 @@ extern struct stmt *limit_stmt_alloc(const struct location *loc);
 
 struct reject_stmt {
 	enum nft_reject_types	type;
+	int8_t			icmp_code;
 };
 
 extern struct stmt *reject_stmt_alloc(const struct location *loc);
diff --git a/src/evaluate.c b/src/evaluate.c
index c15cd55..12d96cf 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -17,6 +17,7 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter_arp.h>
 #include <linux/netfilter/nf_tables.h>
+#include <linux/icmp.h>
 
 #include <expression.h>
 #include <statement.h>
@@ -1139,10 +1140,15 @@ static int stmt_evaluate_reject(struct eval_ctx *ctx, struct stmt *stmt)
 	if (base == NULL)
 		return -1;
 
-	if (strcmp(base->name, "tcp") == 0)
+	if (strcmp(base->name, "tcp") == 0 && stmt->reject.icmp_code == -1) {
 		stmt->reject.type = NFT_REJECT_TCP_RST;
-	else
+		stmt->reject.icmp_code = ICMP_NET_UNREACH;
+	} else {
+		if (stmt->reject.icmp_code < 0)
+			stmt->reject.icmp_code = ICMP_NET_UNREACH;
+
 		stmt->reject.type = NFT_REJECT_ICMP_UNREACH;
+	}
 
 	stmt->flags |= STMT_F_TERMINAL;
 	return 0;
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index a98c68f..112ad81 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -457,6 +457,8 @@ static void netlink_parse_reject(struct netlink_parse_ctx *ctx,
 
 	stmt = reject_stmt_alloc(loc);
 	stmt->reject.type = nft_rule_expr_get_u32(expr, NFT_EXPR_REJECT_TYPE);
+	stmt->reject.icmp_code = nft_rule_expr_get_u8(expr,
+						      NFT_EXPR_REJECT_CODE);
 	list_add_tail(&stmt->list, &ctx->rule->stmts);
 }
 
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 8db333c..b0ca241 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -609,7 +609,7 @@ static void netlink_gen_reject_stmt(struct netlink_linearize_ctx *ctx,
 
 	nle = alloc_nft_expr("reject");
 	nft_rule_expr_set_u32(nle, NFT_EXPR_REJECT_TYPE, stmt->reject.type);
-	nft_rule_expr_set_u8(nle, NFT_EXPR_REJECT_CODE, 0);
+	nft_rule_expr_set_u8(nle, NFT_EXPR_REJECT_CODE, stmt->reject.icmp_code);
 	nft_rule_add_expr(ctx->nlr, nle);
 }
 
diff --git a/src/parser.y b/src/parser.y
index 3e08e21..a427216 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -18,6 +18,7 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
+#include <linux/icmp.h>
 #include <libnftnl/common.h>
 
 #include <rule.h>
@@ -359,6 +360,7 @@ static int monitor_lookup_event(const char *event)
 %token WEEK			"week"
 
 %token _REJECT			"reject"
+%token WITH			"with"
 
 %token SNAT			"snat"
 %token DNAT			"dnat"
@@ -419,8 +421,8 @@ static int monitor_lookup_event(const char *event)
 %type <stmt>			limit_stmt
 %destructor { stmt_free($$); }	limit_stmt
 %type <val>			time_unit
-%type <stmt>			reject_stmt
-%destructor { stmt_free($$); }	reject_stmt
+%type <stmt>			reject_stmt reject_stmt_alloc
+%destructor { stmt_free($$); }	reject_stmt reject_stmt_alloc
 %type <stmt>			nat_stmt nat_stmt_alloc
 %destructor { stmt_free($$); }	nat_stmt nat_stmt_alloc
 %type <stmt>			queue_stmt queue_stmt_alloc queue_range
@@ -1396,12 +1398,38 @@ time_unit		:	SECOND		{ $$ = 1ULL; }
 			|	WEEK		{ $$ = 1ULL * 60 * 60 * 24 * 7; }
 			;
 
-reject_stmt		:	_REJECT
+
+reject_stmt		:	reject_stmt_alloc	reject_opts
+
+reject_stmt_alloc	:	_REJECT
 			{
 				$$ = reject_stmt_alloc(&@$);
 			}
 			;
 
+reject_opts		:       /* empty */
+			{
+				$<stmt>0->reject.icmp_code = -1;
+			}
+			|	WITH	STRING
+			{
+				if (strcmp($2, "net-unreach") == 0)
+					$<stmt>0->reject.icmp_code = ICMP_NET_UNREACH;
+				else if (strcmp($2, "host-unreach") == 0)
+					$<stmt>0->reject.icmp_code = ICMP_HOST_UNREACH;
+				else if (strcmp($2, "prot-unreach") == 0)
+					$<stmt>0->reject.icmp_code = ICMP_PROT_UNREACH;
+				else if (strcmp($2, "port-unreach") == 0)
+					$<stmt>0->reject.icmp_code = ICMP_PORT_UNREACH;
+				else if (strcmp($2, "net-prohibited") == 0)
+					$<stmt>0->reject.icmp_code = ICMP_NET_ANO;
+				else if (strcmp($2, "host-prohibited") == 0)
+					$<stmt>0->reject.icmp_code = ICMP_HOST_ANO;
+				else if (strcmp($2, "admin-prohibited") == 0)
+					$<stmt>0->reject.icmp_code = ICMP_PKT_FILTERED;
+			}
+			;
+
 nat_stmt		:	nat_stmt_alloc	nat_stmt_args
 			;
 
diff --git a/src/scanner.l b/src/scanner.l
index 73a1a3f..f91886c 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -295,6 +295,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "week"			{ return WEEK; }
 
 "reject"		{ return _REJECT; }
+"with"			{ return WITH; }
 
 "snat"			{ return SNAT; }
 "dnat"			{ return DNAT; }
diff --git a/src/statement.c b/src/statement.c
index 2dd3f18..c566fb8 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -18,6 +18,7 @@
 #include <statement.h>
 #include <utils.h>
 #include <list.h>
+#include <linux/icmp.h>
 
 struct stmt *stmt_alloc(const struct location *loc,
 			const struct stmt_ops *ops)
@@ -198,7 +199,37 @@ struct stmt *queue_stmt_alloc(const struct location *loc)
 
 static void reject_stmt_print(const struct stmt *stmt)
 {
+	const char *icmp_code_name = NULL;
+
 	printf("reject");
+	if (stmt->reject.type != NFT_REJECT_TCP_RST) {
+		switch (stmt->reject.icmp_code) {
+		case ICMP_NET_UNREACH:
+			icmp_code_name = "net-unreach";
+			break;
+		case ICMP_HOST_UNREACH:
+			icmp_code_name = "host-unreach";
+			break;
+		case ICMP_PROT_UNREACH:
+			icmp_code_name = "prot-unreach";
+			break;
+		case ICMP_PORT_UNREACH:
+			icmp_code_name = "port-unreach";
+			break;
+		case ICMP_NET_ANO:
+			icmp_code_name = "net-prohibited";
+			break;
+		case ICMP_HOST_ANO:
+			icmp_code_name = "host-prohibited";
+			break;
+		case ICMP_PKT_FILTERED:
+			icmp_code_name = "admin-prohibited";
+			break;
+		default:
+			icmp_code_name = "Unknown icmp code";
+		}
+		printf(" with %s", icmp_code_name);
+	}
 }
 
 static const struct stmt_ops reject_stmt_ops = {
-- 
1.7.10.4

