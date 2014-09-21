From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH 4/4 v3] nft: complete reject support
Date: Sun, 21 Sep 2014 21:32:37 +0200
Message-ID: <1411327957-19379-4-git-send-email-alvaroneay@gmail.com>
References: <1411327957-19379-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:36382 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbaIUTcb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Sep 2014 15:32:31 -0400
Received: by mail-we0-f179.google.com with SMTP id u56so1913026wes.24
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Sep 2014 12:32:30 -0700 (PDT)
In-Reply-To: <1411327957-19379-1-git-send-email-alvaroneay@gmail.com>
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

If the reason is not specified, we infer it from the context.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[changes in v3]
* Use a datatype to parse the icmp reason
* Evaluate the reason, the type and the family in evaluation step for completing
  the reject statement
* Refactor code in the patch.

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
* nft add rule ip filter input udp dport 9999 /
	      			reject with icmp-host-unreach
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

 include/datatype.h        |    6 ++
 include/statement.h       |    3 +
 src/datatype.c            |   72 +++++++++++++++++++
 src/evaluate.c            |  167 ++++++++++++++++++++++++++++++++++++++++++++-
 src/netlink_delinearize.c |   38 +++++++++++
 src/netlink_linearize.c   |    5 +-
 src/parser.y              |   26 ++++++-
 src/payload.c             |   31 +++++++--
 src/scanner.l             |    1 +
 src/statement.c           |   29 ++++++++
 10 files changed, 368 insertions(+), 10 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 5182263..5188dca 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -36,6 +36,8 @@
  * @TYPE_ICMP6_TYPE:	ICMPv6 type codes (integer subtype)
  * @TYPE_CT_LABEL:	Conntrack Label (bitmask subtype)
  * @TYPE_PKTTYPE:	packet type (integer subtype)
+ * @TYPE_ICMP_CODE:	icmp code (integer subtype)
+ * @TYPE_ICMPV6_CODE:	icmpv6 code (integer subtype)
  */
 enum datatypes {
 	TYPE_INVALID,
@@ -70,6 +72,8 @@ enum datatypes {
 	TYPE_ICMP6_TYPE,
 	TYPE_CT_LABEL,
 	TYPE_PKTTYPE,
+	TYPE_ICMP_CODE,
+	TYPE_ICMPV6_CODE,
 	__TYPE_MAX
 };
 #define TYPE_MAX		(__TYPE_MAX - 1)
@@ -194,6 +198,8 @@ extern const struct datatype arphrd_type;
 extern const struct datatype inet_protocol_type;
 extern const struct datatype inet_service_type;
 extern const struct datatype mark_type;
+extern const struct datatype icmp_code_type;
+extern const struct datatype icmpv6_code_type;
 extern const struct datatype time_type;
 
 extern const struct datatype *concat_type_alloc(const struct expr *expr);
diff --git a/include/statement.h b/include/statement.h
index 9d90dd5..d87371f 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -56,7 +56,10 @@ struct limit_stmt {
 extern struct stmt *limit_stmt_alloc(const struct location *loc);
 
 struct reject_stmt {
+	struct expr		*expr;
 	enum nft_reject_types	type;
+	int8_t			icmp_code;
+	unsigned int		family;
 };
 
 extern struct stmt *reject_stmt_alloc(const struct location *loc);
diff --git a/src/datatype.c b/src/datatype.c
index 1954dd6..70d4c34 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -24,6 +24,9 @@
 #include <gmputil.h>
 #include <erec.h>
 
+#include <netinet/ip_icmp.h>
+#include <netinet/icmp6.h>
+
 static const struct datatype *datatypes[TYPE_MAX + 1] = {
 	[TYPE_INVALID]		= &invalid_type,
 	[TYPE_VERDICT]		= &verdict_type,
@@ -41,6 +44,8 @@ static const struct datatype *datatypes[TYPE_MAX + 1] = {
 	[TYPE_TIME]		= &time_type,
 	[TYPE_MARK]		= &mark_type,
 	[TYPE_ARPHRD]		= &arphrd_type,
+	[TYPE_ICMP_CODE]	= &icmp_code_type,
+	[TYPE_ICMPV6_CODE]	= &icmpv6_code_type,
 };
 
 void datatype_register(const struct datatype *dtype)
@@ -702,6 +707,73 @@ const struct datatype mark_type = {
 	.flags		= DTYPE_F_PREFIX,
 };
 
+static const struct symbol_table icmp_code_tbl = {
+	.symbols	= {
+		SYMBOL("icmp-net-unreach",		ICMP_NET_UNREACH),
+		SYMBOL("icmp-host-unreach",		ICMP_HOST_UNREACH),
+		SYMBOL("icmp-prot-unreach",		ICMP_PROT_UNREACH),
+		SYMBOL("icmp-port-unreach",		ICMP_PORT_UNREACH),
+		SYMBOL("icmp-net-prohibited",		ICMP_NET_ANO),
+		SYMBOL("icmp-host-prohibited",		ICMP_HOST_ANO),
+		SYMBOL("icmp-admin-prohibited",		ICMP_PKT_FILTERED),
+		SYMBOL_LIST_END
+	},
+};
+
+static void icmp_code_type_print(const struct expr *expr)
+{
+	return symbolic_constant_print(&icmp_code_tbl, expr);
+}
+
+static struct error_record *icmp_code_type_parse(const struct expr *sym,
+						 struct expr **res)
+{
+	return symbolic_constant_table_parse(&icmp_code_tbl, sym, res);
+}
+
+const struct datatype icmp_code_type = {
+	.type		= TYPE_ICMP_CODE,
+	.name		= "icmp code",
+	.desc		= "icmp code type",
+	.size		= BITS_PER_BYTE,
+	.byteorder	= BYTEORDER_BIG_ENDIAN,
+	.basetype	= &integer_type,
+	.print		= icmp_code_type_print,
+	.parse		= icmp_code_type_parse,
+};
+
+static const struct symbol_table icmpv6_code_tbl = {
+	.symbols	= {
+		SYMBOL("icmpv6-no-route",	ICMP6_DST_UNREACH_NOROUTE),
+		SYMBOL("icmpv6-admin-prohibited", ICMP6_DST_UNREACH_ADMIN),
+		SYMBOL("icmpv6-addr-unreach",	ICMP6_DST_UNREACH_ADDR),
+		SYMBOL("icmpv6-port-unreach",	ICMP6_DST_UNREACH_NOPORT),
+		SYMBOL_LIST_END
+	},
+};
+
+static void icmpv6_code_type_print(const struct expr *expr)
+{
+	return symbolic_constant_print(&icmp_code_tbl, expr);
+}
+
+static struct error_record *icmpv6_code_type_parse(const struct expr *sym,
+					    struct expr **res)
+{
+	return symbolic_constant_table_parse(&icmpv6_code_tbl, sym, res);
+}
+
+const struct datatype icmpv6_code_type = {
+	.type		= TYPE_ICMP_CODE,
+	.name		= "icmpv6 code",
+	.desc		= "icmpv6 code type",
+	.size		= BITS_PER_BYTE,
+	.byteorder	= BYTEORDER_BIG_ENDIAN,
+	.basetype	= &integer_type,
+	.print		= icmpv6_code_type_print,
+	.parse		= icmpv6_code_type_parse,
+};
+
 static void time_type_print(const struct expr *expr)
 {
 	uint64_t days, hours, minutes, seconds;
diff --git a/src/evaluate.c b/src/evaluate.c
index 3b3eee8..c275953 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -17,6 +17,7 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter_arp.h>
 #include <linux/netfilter/nf_tables.h>
+#include <netinet/ip_icmp.h>
 
 #include <expression.h>
 #include <statement.h>
@@ -1126,12 +1127,176 @@ static int stmt_evaluate_meta(struct eval_ctx *ctx, struct stmt *stmt)
 	return 0;
 }
 
-static int stmt_evaluate_reject(struct eval_ctx *ctx, struct stmt *stmt)
+static int stmt_reject_gen_dependency(struct stmt *stmt, struct expr *expr,
+				      struct eval_ctx *ctx)
+{
+	struct expr *payload;
+	struct stmt *nstmt;
+	const struct proto_desc *desc;
+
+	if (stmt->reject.type == NFT_REJECT_TCP_RST)
+		return 0;
+
+	desc = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
+	if (desc != NULL)
+		return 0;
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
+	if (payload_gen_dependency(ctx, payload, &nstmt) < 0)
+		BUG("error creating reject payload dependency");
+
+	list_add(&nstmt->list, &ctx->cmd->rule->stmts);
+	return 0;
+}
+
+static int stmt_reject_icmp_code(struct eval_ctx *ctx, struct stmt *stmt)
 {
+	struct expr *code;
+	struct error_record *erec;
+	const char *identifier;
+
+	identifier = stmt->reject.expr->identifier;
+	if (strcmp(identifier, "tcp-reset") == 0) {
+		stmt->reject.type = NFT_REJECT_TCP_RST;
+		stmt->reject.family = ctx->pctx.family;
+		return 0;
+	}
+
+	switch (ctx->pctx.family) {
+	case NFPROTO_IPV4:
+		stmt->reject.expr->dtype = &icmp_code_type;
+		stmt->reject.family = NFPROTO_IPV4;
+		break;
+	case NFPROTO_IPV6:
+		stmt->reject.expr->dtype = &icmpv6_code_type;
+		stmt->reject.family = NFPROTO_IPV6;
+		break;
+	case NFPROTO_INET:
+	case NFPROTO_BRIDGE:
+		if (strncmp(identifier, "icmpv6", 6) == 0) {
+			stmt->reject.expr->dtype = &icmpv6_code_type;
+			stmt->reject.family = NFPROTO_IPV6;
+		} else {
+			stmt->reject.expr->dtype = &icmp_code_type;
+			stmt->reject.family = NFPROTO_IPV4;
+		}
+		break;
+	}
+
+	stmt->reject.type = NFT_REJECT_ICMP_UNREACH;
+	erec = symbol_parse(stmt->reject.expr, &code);
+	if (erec != NULL) {
+		erec_queue(erec, ctx->msgs);
+		return -1;
+	}
+	stmt->reject.icmp_code = mpz_get_uint8(code->value);
+
+	return 0;
+}
+
+static int stmt_evaluate_reject_family(struct eval_ctx *ctx, struct stmt *stmt,
+				       struct expr *expr)
+{
+	switch (ctx->pctx.family) {
+	case NFPROTO_ARP:
+		return stmt_error(ctx, stmt, "cannot use reject with arp");
+	case NFPROTO_INET:
+	case NFPROTO_BRIDGE:
+		if (stmt_reject_gen_dependency(stmt, expr, ctx) < 0)
+			return -1;
+		break;
+	case NFPROTO_IPV4:
+	case NFPROTO_IPV6:
+		if (stmt->reject.family != ctx->pctx.family) {
+			return stmt_error(ctx, stmt,
+				  "conflicting protocols specified: ip vs ip6");
+		}
+		break;
+	}
 	stmt->flags |= STMT_F_TERMINAL;
 	return 0;
 }
 
+static int stmt_evaluate_reject(struct eval_ctx *ctx, struct stmt *stmt)
+{
+	struct proto_ctx *pctx = &ctx->pctx;
+	const struct proto_desc *desc, *base;
+	struct expr *expr = ctx->cmd->expr;
+	int protonum;
+
+	/* The reason to reject this has been specified */
+	if (stmt->reject.expr != NULL &&
+	    stmt_reject_icmp_code(ctx, stmt) < 0)
+		return -1;
+
+	base = pctx->protocol[PROTO_BASE_NETWORK_HDR].desc;
+	desc = pctx->protocol[PROTO_BASE_TRANSPORT_HDR].desc;
+	/* The reason to reject this hasn't been specified */
+	switch (ctx->pctx.family) {
+	case NFPROTO_IPV4:
+	case NFPROTO_IPV6:
+		if (stmt->reject.icmp_code < 0 &&
+		    stmt->reject.type != NFT_REJECT_TCP_RST) {
+			stmt->reject.type = NFT_REJECT_ICMP_UNREACH;
+			stmt->reject.icmp_code = ICMP_NET_UNREACH;
+			stmt->reject.family = ctx->pctx.family;
+			return stmt_evaluate_reject_family(ctx, stmt, expr);
+		}
+		break;
+	case NFPROTO_BRIDGE:
+	case NFPROTO_INET:
+		if (stmt->reject.icmp_code < 0) {
+			return stmt_error(ctx, stmt,
+			"insufficient context to use reject without reason");
+		}
+		/* No sufficient network or/and transport context */
+		if (base == NULL &&
+		    stmt->reject.type != NFT_REJECT_TCP_RST) {
+			return stmt_evaluate_reject_family(ctx, stmt, expr);
+		} else if (base == NULL &&
+			   stmt->reject.type == NFT_REJECT_TCP_RST) {
+			return stmt_error(ctx, stmt,
+				       "insufficient context to use tcp-reset");
+		}
+		break;
+	}
+	protonum = proto_find_num(base, desc);
+	switch (protonum) {
+	case IPPROTO_TCP:
+		if (stmt->reject.icmp_code >= 0 &&
+		    stmt->reject.type != NFT_REJECT_TCP_RST) {
+			stmt->reject.type = NFT_REJECT_ICMP_UNREACH;
+			return stmt_evaluate_reject_family(ctx, stmt, expr);
+		} else {
+			stmt->reject.type = NFT_REJECT_TCP_RST;
+			return stmt_evaluate_reject_family(ctx, stmt, expr);
+		}
+		break;
+	}
+
+	if (stmt->reject.type == NFT_REJECT_TCP_RST) {
+		return stmt_error(ctx, stmt,
+			    "insufficient context to use tcp-reset");
+	}
+
+	return stmt_evaluate_reject_family(ctx, stmt, expr);
+}
+
 static int stmt_evaluate_nat(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	struct proto_ctx *pctx = &ctx->pctx;
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 195d432..60d0513 100644
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
@@ -474,6 +477,9 @@ static void netlink_parse_reject(struct netlink_parse_ctx *ctx,
 	struct stmt *stmt;
 
 	stmt = reject_stmt_alloc(loc);
+	stmt->reject.type = nft_rule_expr_get_u32(expr, NFT_EXPR_REJECT_TYPE);
+	stmt->reject.icmp_code = nft_rule_expr_get_u8(expr,
+						      NFT_EXPR_REJECT_CODE);
 	list_add_tail(&stmt->list, &ctx->rule->stmts);
 }
 
@@ -890,6 +896,35 @@ static void expr_postprocess(struct rule_pp_ctx *ctx,
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
+		if (rctx.pbase == PROTO_BASE_INVALID)
+			return;
+
+		base = rctx.pctx.protocol[PROTO_BASE_LL_HDR].desc;
+		desc = rctx.pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
+		protocol = proto_find_num(base, desc);
+		if (protocol == ETH_P_IP)
+			stmt->reject.family = NFPROTO_IPV4;
+		else if (protocol == ETH_P_IPV6)
+			stmt->reject.family = NFPROTO_IPV6;
+		else
+			stmt->reject.family = protocol;
+		break;
+	default:
+		break;
+	}
+}
 static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *rule)
 {
 	struct rule_pp_ctx rctx;
@@ -917,6 +952,9 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
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
index 17375a5..16d88ff 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -612,7 +612,10 @@ static void netlink_gen_reject_stmt(struct netlink_linearize_ctx *ctx,
 
 	nle = alloc_nft_expr("reject");
 	nft_rule_expr_set_u32(nle, NFT_EXPR_REJECT_TYPE, stmt->reject.type);
-	nft_rule_expr_set_u8(nle, NFT_EXPR_REJECT_CODE, 0);
+	if (stmt->reject.icmp_code != -1)
+		nft_rule_expr_set_u8(nle, NFT_EXPR_REJECT_CODE,
+				     stmt->reject.icmp_code);
+
 	nft_rule_add_expr(ctx->nlr, nle);
 }
 
diff --git a/src/parser.y b/src/parser.y
index ac3d890..c92a4a8 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -19,6 +19,8 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
+#include <netinet/ip_icmp.h>
+#include <netinet/icmp6.h>
 #include <libnftnl/common.h>
 
 #include <rule.h>
@@ -362,6 +364,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token WEEK			"week"
 
 %token _REJECT			"reject"
+%token WITH			"with"
 
 %token SNAT			"snat"
 %token DNAT			"dnat"
@@ -423,8 +426,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
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
@@ -1368,12 +1371,29 @@ time_unit		:	SECOND		{ $$ = 1ULL; }
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
+				$<stmt>0->reject.expr = symbol_expr_alloc(&@$,
+								   SYMBOL_VALUE,
+							   current_scope(state),
+									 $2);
+			}
+			;
+
 nat_stmt		:	nat_stmt_alloc	nat_stmt_args
 			;
 
diff --git a/src/payload.c b/src/payload.c
index 19fd4f4..48f81d2 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -196,11 +196,32 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
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
index 8aab38f..d323be4 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -308,6 +308,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "week"			{ return WEEK; }
 
 "reject"		{ return _REJECT; }
+"with"			{ return WITH; }
 
 "snat"			{ return SNAT; }
 "dnat"			{ return DNAT; }
diff --git a/src/statement.c b/src/statement.c
index 4be6625..12a0e80 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -16,9 +16,15 @@
 #include <string.h>
 #include <syslog.h>
 
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
@@ -219,9 +225,32 @@ struct stmt *queue_stmt_alloc(const struct location *loc)
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

