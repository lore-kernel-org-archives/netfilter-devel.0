From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH v2] nft: add reject support
Date: Mon, 18 Aug 2014 10:31:00 +0200
Message-ID: <1408350660-4430-1-git-send-email-alvaroneay@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:49299 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaHRIbB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Aug 2014 04:31:01 -0400
Received: by mail-we0-f174.google.com with SMTP id x48so4649917wes.5
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Aug 2014 01:31:00 -0700 (PDT)
Received: from localhost.localdomain (85.136.70.56.dyn.user.ono.com. [85.136.70.56])
        by mx.google.com with ESMTPSA id h3sm40520202wjn.10.2014.08.18.01.30.58
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Aug 2014 01:30:59 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch allows to use the reject action in rules. Example:

nft add rule filter input udp dport 22 reject

In this rule, we assume that the reason is network unreachable. Also
we can specify the reason with the option "with" and the reason. Example:

nft add rule filter input tcp dport 22 reject with host-unreach

In the bridge tables and inet tables, we can use this action too. Example:

nft add rule inet filter input reject with icmp-host-unreach

In this rule above, this generates a meta nfproto dependency to match
ipv4 traffic because we use a icmpv4 reason to reject.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[Changes in v2]
* Set Up the icmp code only if we establish it.

[Tested with the rules]
[Error ways]
Reject not supported for arp
  * nft add rule arp filter input reject (reject not supported for arp)

Use icmp code field in a ipv6 table or icmpv6 code field in ipv4 table
  * nft add rule ip filter input reject with icmpv6-no-route
  * nft add rule ip6 filter input reject with icmp-host-unreach

Insufficient context for using reject
  * nft add rule inet filter input reject
  * nft add rule bridge filter input reject

Use tcp reset with a udp rule
  * nft add rule ip filter input udp dport 9999 reject with tcp-reset

[Hits ways]
IPV4
  * nft add rule ip filter input udp dport 9999 reject with
  * icmp-host-unreach
  * nft add rule ip filter input tcp dport 9999 reject
  * nft add rule ip filter input reject
IPV6
  * nft add rule ip6 filter input udp dport 9999 reject
  * nft add rule ip6 filter input tcp dport 9999 /
		reject with icmpv6-admin-prohibited
  * nft add rule ip6 filter input reject
INET
  * nft add rule inet filter input reject with icmp-host-unreach
  * nft add rule inet filter input reject with icmpv6-no-route
  * nft add rule inet filter input udp dport 9999 counter /
				      reject with icmpv6-no-route
BRIDGE
  * nft add rule bridge filter input reject with icmp-host-unreach
  * nft add rule bridge filter input reject with icmpv6-no-route

 include/statement.h       |    2 +
 src/evaluate.c            |  116 +++++++++++++++++++++++++++++++++++++++++++--
 src/netlink_delinearize.c |   37 +++++++++++++++
 src/netlink_linearize.c   |    4 +-
 src/parser.y              |   74 +++++++++++++++++++++++++++--
 src/payload.c             |   31 ++++++++++--
 src/scanner.l             |    1 +
 src/statement.c           |   29 ++++++++++++
 8 files changed, 282 insertions(+), 12 deletions(-)

diff --git a/include/statement.h b/include/statement.h
index 480b719..c971aa5 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -47,6 +47,8 @@ extern struct stmt *limit_stmt_alloc(const struct location *loc);
 
 struct reject_stmt {
 	enum nft_reject_types	type;
+	int8_t			icmp_code;
+	unsigned int		family;
 };
 
 extern struct stmt *reject_stmt_alloc(const struct location *loc);
diff --git a/src/evaluate.c b/src/evaluate.c
index e05473a..75fe3fe 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -17,6 +17,7 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter_arp.h>
 #include <linux/netfilter/nf_tables.h>
+#include <netinet/ip_icmp.h>
 
 #include <expression.h>
 #include <statement.h>
@@ -261,6 +262,18 @@ static int expr_evaluate_primary(struct eval_ctx *ctx, struct expr **expr)
 	return 0;
 }
 
+static struct stmt *expr_stmt_alloc_eval(struct eval_ctx *ctx,
+					 struct expr *expr)
+{
+	struct stmt *nstmt;
+
+	nstmt = expr_stmt_alloc(&expr->location, expr);
+	if (stmt_evaluate(ctx, nstmt) < 0)
+		BUG("malformed dependency statement");
+
+	return nstmt;
+}
+
 /*
  * Payload expression: check whether dependencies are fulfilled, otherwise
  * generate the necessary relational expression and prepend it to the current
@@ -276,9 +289,7 @@ static int expr_evaluate_payload(struct eval_ctx *ctx, struct expr **expr)
 	if (ctx->pctx.protocol[base].desc == NULL) {
 		if (payload_gen_dependency(ctx, payload, &nexpr) < 0)
 			return -1;
-		nstmt = expr_stmt_alloc(&nexpr->location, nexpr);
-		if (stmt_evaluate(ctx, nstmt) < 0)
-			return -1;
+		nstmt = expr_stmt_alloc_eval(ctx, nexpr);
 		list_add_tail(&nstmt->list, &ctx->stmt->list);
 	} else if (ctx->pctx.protocol[base].desc != payload->payload.desc)
 		return expr_error(ctx->msgs, payload,
@@ -1131,8 +1142,107 @@ static int stmt_evaluate_meta(struct eval_ctx *ctx, struct stmt *stmt)
 	return 0;
 }
 
+static int stmt_reject_gen_dependency(struct stmt *stmt, struct expr *expr,
+				      struct eval_ctx *ctx)
+{
+	struct expr *payload, *nexpr;
+	struct stmt *nstmt;
+
+	if (stmt->reject.icmp_code < 0)
+		return stmt_error(ctx, stmt, "missing icmp error type");
+
+	switch (stmt->reject.family) {
+	case NFPROTO_IPV4:
+		payload = payload_expr_alloc(&stmt->location, &proto_ip,
+					     IPHDR_PROTOCOL);
+		break;
+	case NFPROTO_IPV6:
+		payload = payload_expr_alloc(&stmt->location, &proto_ip6,
+					     IP6HDR_NEXTHDR);
+		break;
+	default:
+		BUG("unknown reject family");
+	}
+
+	if (payload_gen_dependency(ctx, payload, &nexpr) < 0)
+		BUG("error creating reject payload dependency");
+
+	nstmt = expr_stmt_alloc_eval(ctx, nexpr);
+	list_add(&nstmt->list, &ctx->cmd->rule->stmts);
+	return 0;
+}
+
 static int stmt_evaluate_reject(struct eval_ctx *ctx, struct stmt *stmt)
 {
+	struct proto_ctx *pctx = &ctx->pctx;
+	const struct proto_desc *desc, *base;
+	struct expr *expr = ctx->cmd->expr;
+	int protonum;
+
+	switch (ctx->pctx.family) {
+	case NFPROTO_ARP:
+		return stmt_error(ctx, stmt, "cannot use reject with arp");
+	case NFPROTO_INET:
+	case NFPROTO_BRIDGE:
+		if (stmt->reject.type != NFT_REJECT_TCP_RST) {
+			desc = pctx->protocol[PROTO_BASE_NETWORK_HDR].desc;
+			if (desc == NULL &&
+			    stmt_reject_gen_dependency(stmt, expr, ctx) < 0)
+				return -1;
+		}
+		break;
+	case NFPROTO_IPV4:
+		if (stmt->reject.icmp_code >= 0 &&
+		    stmt->reject.family != NFPROTO_IPV4 &&
+		    stmt->reject.type != NFT_REJECT_TCP_RST) {
+			return stmt_error(ctx, stmt,
+				  "conflicting protocols specified: ip vs ip6");
+		}
+		break;
+	case NFPROTO_IPV6:
+		if (stmt->reject.icmp_code >= 0 &&
+		    stmt->reject.family != NFPROTO_IPV6 &&
+		    stmt->reject.type != NFT_REJECT_TCP_RST) {
+			return stmt_error(ctx, stmt,
+				  "conflicting protocols specified: ip6 vs ip");
+		}
+		break;
+	}
+
+	base = pctx->protocol[PROTO_BASE_NETWORK_HDR].desc;
+	desc = pctx->protocol[PROTO_BASE_TRANSPORT_HDR].desc;
+	/* No sufficient network and transport context */
+	if (base == NULL || desc == NULL) {
+		if (stmt->reject.type == NFT_REJECT_TCP_RST) {
+			return stmt_error(ctx, stmt,
+				    "insufficient context for using tcp-reset");
+		}
+		if (stmt->reject.icmp_code < 0) {
+			stmt->reject.type = NFT_REJECT_ICMP_UNREACH;
+			stmt->reject.icmp_code = ICMP_NET_UNREACH;
+		}
+	} else {
+		protonum = proto_find_num(base, desc);
+		switch (protonum) {
+		case IPPROTO_TCP:
+			if (stmt->reject.icmp_code >= 0 &&
+			    stmt->reject.type != NFT_REJECT_TCP_RST) {
+				stmt->reject.type = NFT_REJECT_ICMP_UNREACH;
+				break;
+			} else
+				stmt->reject.type = NFT_REJECT_TCP_RST;
+			break;
+		default:
+			if (stmt->reject.type == NFT_REJECT_TCP_RST) {
+				return stmt_error(ctx, stmt,
+				     "cannot use tcp-reset without a tcp rule");
+			}
+			if (stmt->reject.type != NFT_REJECT_ICMP_UNREACH) {
+				stmt->reject.type = NFT_REJECT_ICMP_UNREACH;
+				stmt->reject.icmp_code = ICMP_NET_UNREACH;
+			}
+		}
+	}
 	stmt->flags |= STMT_F_TERMINAL;
 	return 0;
 }
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 5c6ca80..c57e164 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -14,6 +14,9 @@
 #include <string.h>
 #include <limits.h>
 #include <linux/netfilter/nf_tables.h>
+#include <arpa/inet.h>
+#include <linux/netfilter.h>
+#include <net/ethernet.h>
 #include <netlink.h>
 #include <rule.h>
 #include <statement.h>
@@ -456,6 +459,9 @@ static void netlink_parse_reject(struct netlink_parse_ctx *ctx,
 	struct stmt *stmt;
 
 	stmt = reject_stmt_alloc(loc);
+	stmt->reject.type = nft_rule_expr_get_u32(expr, NFT_EXPR_REJECT_TYPE);
+	stmt->reject.icmp_code = nft_rule_expr_get_u8(expr,
+						      NFT_EXPR_REJECT_CODE);
 	list_add_tail(&stmt->list, &ctx->rule->stmts);
 }
 
@@ -872,6 +878,34 @@ static void expr_postprocess(struct rule_pp_ctx *ctx,
 	}
 }
 
+static void stmt_reject_postprocess(struct rule_pp_ctx rctx, struct stmt *stmt)
+{
+	const struct proto_desc *desc, *base;
+	int protocol;
+
+	switch (rctx.pctx.family) {
+	case NFPROTO_IPV4:
+	case NFPROTO_IPV6:
+		stmt->reject.family = rctx.pctx.family;
+		break;
+	case NFPROTO_INET:
+	case NFPROTO_BRIDGE:
+		if (rctx.pbase != PROTO_BASE_INVALID) {
+			base = rctx.pctx.protocol[PROTO_BASE_LL_HDR].desc;
+			desc = rctx.pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
+			protocol = proto_find_num(base, desc);
+			if (protocol == ETH_P_IP)
+				stmt->reject.family = NFPROTO_IPV4;
+			else if (protocol == ETH_P_IPV6)
+				stmt->reject.family = NFPROTO_IPV6;
+			else
+				stmt->reject.family = protocol;
+		}
+		break;
+	default:
+		break;
+	}
+}
 static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *rule)
 {
 	struct rule_pp_ctx rctx;
@@ -899,6 +933,9 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 			if (stmt->nat.proto != NULL)
 				expr_postprocess(&rctx, stmt, &stmt->nat.proto);
 			break;
+		case STMT_REJECT:
+			stmt_reject_postprocess(rctx, stmt);
+			break;
 		default:
 			break;
 		}
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 5c1b46d..0e1d87c 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -609,7 +609,9 @@ static void netlink_gen_reject_stmt(struct netlink_linearize_ctx *ctx,
 
 	nle = alloc_nft_expr("reject");
 	nft_rule_expr_set_u32(nle, NFT_EXPR_REJECT_TYPE, stmt->reject.type);
-	nft_rule_expr_set_u8(nle, NFT_EXPR_REJECT_CODE, 0);
+	if (stmt->reject.icmp_code != -1)
+		nft_rule_expr_set_u8(nle, NFT_EXPR_REJECT_CODE, stmt->reject.icmp_code);
+
 	nft_rule_add_expr(ctx->nlr, nle);
 }
 
diff --git a/src/parser.y b/src/parser.y
index 3e08e21..5f15d9d 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -18,6 +18,8 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
+#include <netinet/ip_icmp.h>
+#include <netinet/icmp6.h>
 #include <libnftnl/common.h>
 
 #include <rule.h>
@@ -359,6 +361,7 @@ static int monitor_lookup_event(const char *event)
 %token WEEK			"week"
 
 %token _REJECT			"reject"
+%token WITH			"with"
 
 %token SNAT			"snat"
 %token DNAT			"dnat"
@@ -419,8 +422,8 @@ static int monitor_lookup_event(const char *event)
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
@@ -1396,12 +1399,77 @@ time_unit		:	SECOND		{ $$ = 1ULL; }
 			|	WEEK		{ $$ = 1ULL * 60 * 60 * 24 * 7; }
 			;
 
-reject_stmt		:	_REJECT
+reject_stmt		:	reject_stmt_alloc	reject_opts
+			;
+
+reject_stmt_alloc	:	_REJECT
 			{
 				$$ = reject_stmt_alloc(&@$);
 			}
 			;
 
+reject_opts		:       /* empty */
+			{
+				$<stmt>0->reject.type = -1;
+				$<stmt>0->reject.icmp_code = -1;
+			}
+			|	WITH	STRING
+			{
+				if (strcmp($2, "icmp-net-unreach") == 0) {
+					$<stmt>0->reject.icmp_code = ICMP_NET_UNREACH;
+					$<stmt>0->reject.family = NFPROTO_IPV4;
+					$<stmt>0->reject.type = NFT_REJECT_ICMP_UNREACH;
+				} else if (strcmp($2, "icmp-host-unreach") == 0) {
+					$<stmt>0->reject.icmp_code = ICMP_HOST_UNREACH;
+					$<stmt>0->reject.family = NFPROTO_IPV4;
+					$<stmt>0->reject.type = NFT_REJECT_ICMP_UNREACH;
+				} else if (strcmp($2, "icmp-prot-unreach") == 0) {
+					$<stmt>0->reject.icmp_code = ICMP_PROT_UNREACH;
+					$<stmt>0->reject.family = NFPROTO_IPV4;
+					$<stmt>0->reject.type = NFT_REJECT_ICMP_UNREACH;
+				} else if (strcmp($2, "icmp-port-unreach") == 0) {
+					$<stmt>0->reject.icmp_code = ICMP_PORT_UNREACH;
+					$<stmt>0->reject.family = NFPROTO_IPV4;
+					$<stmt>0->reject.type = NFT_REJECT_ICMP_UNREACH;
+				} else if (strcmp($2, "icmp-net-prohibited") == 0) {
+					$<stmt>0->reject.icmp_code = ICMP_NET_ANO;
+					$<stmt>0->reject.family = NFPROTO_IPV4;
+					$<stmt>0->reject.type = NFT_REJECT_ICMP_UNREACH;
+				} else if (strcmp($2, "icmp-host-prohibited") == 0) {
+					$<stmt>0->reject.icmp_code = ICMP_HOST_ANO;
+					$<stmt>0->reject.family = NFPROTO_IPV4;
+					$<stmt>0->reject.type = NFT_REJECT_ICMP_UNREACH;
+				} else if (strcmp($2, "icmp-admin-prohibited") == 0) {
+					$<stmt>0->reject.icmp_code = ICMP_PKT_FILTERED;
+					$<stmt>0->reject.family = NFPROTO_IPV4;
+					$<stmt>0->reject.type = NFT_REJECT_ICMP_UNREACH;
+				} else if (strcmp($2, "icmpv6-no-route") == 0) {
+					$<stmt>0->reject.icmp_code = ICMP6_DST_UNREACH_NOROUTE;
+					$<stmt>0->reject.family = NFPROTO_IPV6;
+					$<stmt>0->reject.type = NFT_REJECT_ICMP_UNREACH;
+				} else if (strcmp($2, "icmpv6-admin-prohibited") == 0) {
+					$<stmt>0->reject.icmp_code = ICMP6_DST_UNREACH_ADMIN;
+					$<stmt>0->reject.family = NFPROTO_IPV6;
+					$<stmt>0->reject.type = NFT_REJECT_ICMP_UNREACH;
+				} else if (strcmp($2, "icmpv6-addr-unreach") == 0) {
+					$<stmt>0->reject.icmp_code = ICMP6_DST_UNREACH_ADDR;
+					$<stmt>0->reject.family = NFPROTO_IPV6;
+					$<stmt>0->reject.type = NFT_REJECT_ICMP_UNREACH;
+				} else if (strcmp($2, "icmpv6-port-unreach") == 0) {
+					$<stmt>0->reject.icmp_code = ICMP6_DST_UNREACH_NOPORT;
+					$<stmt>0->reject.family = NFPROTO_IPV6;
+					$<stmt>0->reject.type = NFT_REJECT_ICMP_UNREACH;
+				} else if (strcmp($2, "tcp-reset") == 0) {
+					$<stmt>0->reject.type = NFT_REJECT_TCP_RST;
+					$<stmt>0->reject.icmp_code = -1;
+				} else {
+					erec_queue(error(&@2, "invalid icmp code type '%s'",
+							 $2), state->msgs);
+					YYERROR;
+				}
+			}
+			;
+
 nat_stmt		:	nat_stmt_alloc	nat_stmt_args
 			;
 
diff --git a/src/payload.c b/src/payload.c
index a1785a5..76c4ce1 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -183,11 +183,32 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 	}
 
 	desc = ctx->pctx.protocol[expr->payload.base - 1].desc;
-	/* Special case for mixed IPv4/IPv6 tables: use meta L4 proto */
-	if (desc == NULL &&
-	    ctx->pctx.family == NFPROTO_INET &&
-	    expr->payload.base == PROTO_BASE_TRANSPORT_HDR)
-		desc = &proto_inet_service;
+	/* Special case for mixed IPv4/IPv6 and bridge tables */
+	if (desc == NULL) {
+		switch (ctx->pctx.family) {
+		case NFPROTO_INET:
+			switch (expr->payload.base) {
+			case PROTO_BASE_TRANSPORT_HDR:
+				desc = &proto_inet_service;
+				break;
+			case PROTO_BASE_LL_HDR:
+				desc = &proto_inet;
+				break;
+			default:
+				break;
+			}
+			break;
+		case NFPROTO_BRIDGE:
+			switch (expr->payload.base) {
+			case PROTO_BASE_LL_HDR:
+				desc = &proto_eth;
+				break;
+			default:
+				break;
+			}
+			break;
+		}
+	}
 
 	if (desc == NULL)
 		return expr_error(ctx->msgs, expr,
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
index 2dd3f18..846287f 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -15,9 +15,15 @@
 #include <inttypes.h>
 #include <string.h>
 
+#include <netinet/ip_icmp.h>
+#include <netinet/icmp6.h>
 #include <statement.h>
 #include <utils.h>
 #include <list.h>
+#include <arpa/inet.h>
+#include <linux/netfilter.h>
+#include <net/ethernet.h>
+#include <utils.h>
 
 struct stmt *stmt_alloc(const struct location *loc,
 			const struct stmt_ops *ops)
@@ -196,9 +202,32 @@ struct stmt *queue_stmt_alloc(const struct location *loc)
 	return stmt_alloc(loc, &queue_stmt_ops);
 }
 
+const char *reject_stmt_code_ip[] = {
+	[ICMP_NET_UNREACH]	= "icmp-net-unreach",
+	[ICMP_HOST_UNREACH]	= "icmp-host-unreach",
+	[ICMP_PROT_UNREACH]	= "icmp-prot-unreach",
+	[ICMP_PORT_UNREACH]	= "icmp-port-unreach",
+	[ICMP_NET_ANO]		= "icmp-net-prohibited",
+	[ICMP_HOST_ANO]		= "icmp-host-prohibited",
+	[ICMP_PKT_FILTERED]	= "icmp-admin-prohibited",
+};
+
+const char *reject_stmt_code_ip6[] = {
+	[ICMP6_DST_UNREACH_NOROUTE]	= "icmpv6-no-route",
+	[ICMP6_DST_UNREACH_ADMIN]	= "icmpv6-admin-prohibited",
+	[ICMP6_DST_UNREACH_ADDR]	= "icmpv6-addr-unreach",
+	[ICMP6_DST_UNREACH_NOPORT]	= "icmpv6-port-unreach",
+};
+
 static void reject_stmt_print(const struct stmt *stmt)
 {
 	printf("reject");
+	if (stmt->reject.icmp_code >= 0 && stmt->reject.family == NFPROTO_IPV4)
+		printf(" with %s",
+		       reject_stmt_code_ip[stmt->reject.icmp_code]);
+	if (stmt->reject.icmp_code >= 0 && stmt->reject.family == NFPROTO_IPV6)
+		printf(" with %s",
+		       reject_stmt_code_ip6[stmt->reject.icmp_code]);
 }
 
 static const struct stmt_ops reject_stmt_ops = {
-- 
1.7.10.4

