From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH 4/4 v4] nft: complete reject support
Date: Fri, 26 Sep 2014 18:50:55 +0200
Message-ID: <1411750255-7663-4-git-send-email-alvaroneay@gmail.com>
References: <1411750255-7663-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:65284 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703AbaIZQur (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Sep 2014 12:50:47 -0400
Received: by mail-we0-f171.google.com with SMTP id k48so9927202wev.2
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Sep 2014 09:50:46 -0700 (PDT)
In-Reply-To: <1411750255-7663-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch allows to use the reject action in rules. For example:

  nft add rule filter input udp dport 22 reject

In this rule, we assume that the reason is network unreachable. Also
we can specify the reason with the option "with" and the reason. For example:

  nft add rule filter input tcp dport 22 reject with icmp type host-unreach

In the bridge tables and inet tables, we can use this action too. For example:

  nft add rule inet filter input reject with icmp type host-unreach

In this rule above, this generates a meta nfproto dependency to match
ipv4 traffic because we use a icmpv4 reason to reject.

If the reason is not specified, we infer it from the context.

Moreover, we have the new icmpx datatype. You can use this datatype for
the bridge and the inet tables to simplify your ruleset. For example:

  nft add rule inet filter input reject with icmpx type host-unreach

We have four icmpx reason and the mapping is:

ICMPX REASON	 	|	ICMPv6		|	ICMPv4
			|			|
admin-prohibited 	| admin-prohibited	|	admin-prohibited
port-unreach	 	| port-unreach		|	port-unreach
no-route	 	| no-route		|	net-unreach
host-unreach	 	| addr-unreach		|	host-unreach

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[Changes in v4]
* Fixed some cosmetic errors
* Added the new datatype icmpx.

[Tested with the rules]
[Error ways]
Reject not supported for arp
 * nft add rule arp filter input reject (reject not supported for arp)

Use icmp code field in a ipv6 table or icmpv6 code field in ipv4 table
 * nft add rule ip filter input reject with icmp type no-route
 * nft add rule ip6 filter input reject with icmpv6 type host-unreach

Use tcp reset with a udp rule
 * nft add rule ip filter input udp dport 9999 reject with tcp reset

[Hits ways]
IPV4
 * nft add rule ip filter input udp dport 9999 /
 					reject with icmp type host-unreach
 * nft add rule ip filter input tcp dport 9999 reject
 * nft add rule ip filter input reject
 * nft add rule ip filter input reject with tcp reset

IPV6
 * nft add rule ip6 filter input udp dport 9999 reject
 * nft add rule ip6 filter input tcp dport 9999 /
   					reject with icmpv6 type admin-prohibited
 * nft add rule ip6 filter input reject

INET
 * nft add rule inet filter input reject with icmp type host-unreach
 * nft add rule inet filter input reject with icmpv6 type no-route
 * nft add rule inet filter input udp dport 9999 counter /
    					reject with icmpv6 type no-route
 * nft add rule inet filter input reject with tcp reset
 * nft add rule inet filter input reject

BRIDGE
 * nft add rule bridge filter input reject with icmp type host-unreach
 * nft add rule bridge filter input reject with icmpv6 type no-route
 * nft add rule bridge filter input reject

 include/datatype.h                  |    9 ++
 include/linux/netfilter/nf_tables.h |   21 +++++
 include/statement.h                 |    3 +
 src/datatype.c                      |  105 +++++++++++++++++++++++
 src/evaluate.c                      |  160 ++++++++++++++++++++++++++++++++++-
 src/netlink_delinearize.c           |   41 +++++++++
 src/netlink_linearize.c             |    5 +-
 src/parser.y                        |   54 +++++++++++-
 src/payload.c                       |   31 +++++--
 src/scanner.l                       |    3 +
 src/statement.c                     |   49 +++++++++++
 11 files changed, 471 insertions(+), 10 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 5182263..15fea44 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -36,6 +36,9 @@
  * @TYPE_ICMP6_TYPE:	ICMPv6 type codes (integer subtype)
  * @TYPE_CT_LABEL:	Conntrack Label (bitmask subtype)
  * @TYPE_PKTTYPE:	packet type (integer subtype)
+ * @TYPE_ICMP_CODE:	icmp code (integer subtype)
+ * @TYPE_ICMPV6_CODE:	icmpv6 code (integer subtype)
+ * @TYPE_ICMPX_CODE:	icmpx code (integer subtype)
  */
 enum datatypes {
 	TYPE_INVALID,
@@ -70,6 +73,9 @@ enum datatypes {
 	TYPE_ICMP6_TYPE,
 	TYPE_CT_LABEL,
 	TYPE_PKTTYPE,
+	TYPE_ICMP_CODE,
+	TYPE_ICMPV6_CODE,
+	TYPE_ICMPX_CODE,
 	__TYPE_MAX
 };
 #define TYPE_MAX		(__TYPE_MAX - 1)
@@ -194,6 +200,9 @@ extern const struct datatype arphrd_type;
 extern const struct datatype inet_protocol_type;
 extern const struct datatype inet_service_type;
 extern const struct datatype mark_type;
+extern const struct datatype icmp_code_type;
+extern const struct datatype icmpv6_code_type;
+extern const struct datatype icmpx_code_type;
 extern const struct datatype time_type;
 
 extern const struct datatype *concat_type_alloc(const struct expr *expr);
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index b72ccfe..f04d997 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -749,13 +749,34 @@ enum nft_queue_attributes {
  *
  * @NFT_REJECT_ICMP_UNREACH: reject using ICMP unreachable
  * @NFT_REJECT_TCP_RST: reject using TCP RST
+ * @NFT_REJECT_ICMPX_UNREACH: abstracted ICMP unreachable for bridge and inet
  */
 enum nft_reject_types {
 	NFT_REJECT_ICMP_UNREACH,
 	NFT_REJECT_TCP_RST,
+	NFT_REJECT_ICMPX_UNREACH,
 };
 
 /**
+ * enum nft_reject_code - Abstracted reject codes
+ *
+ * @NFT_REJECT_ICMPX_NO_ROUTE: no route to host - network unreachable
+ * @NFT_REJECT_ICMPX_PORT_UNREACH: port unreachable
+ * @NFT_REJECT_ICMPX_HOST_UNREACH: host unreachable
+ * @NFT_REJECT_ICMPX_ADMIN_PROHIBITED: administratevely prohibited
+ *
+ * These codes are mapped to real ICMP and ICMPv6 codes.
+ */
+enum nft_reject_inet_code {
+	NFT_REJECT_ICMPX_NO_ROUTE	= 0,
+	NFT_REJECT_ICMPX_PORT_UNREACH,
+	NFT_REJECT_ICMPX_HOST_UNREACH,
+	NFT_REJECT_ICMPX_ADMIN_PROHIBITED,
+	__NFT_REJECT_ICMPX_MAX
+};
+#define NFT_REJECT_ICMPX_MAX	(__NFT_REJECT_ICMPX_MAX + 1)
+
+/**
  * enum nft_reject_attributes - nf_tables reject expression netlink attributes
  *
  * @NFTA_REJECT_TYPE: packet type to use (NLA_U32: nft_reject_types)
diff --git a/include/statement.h b/include/statement.h
index 7a57f7d..574835c 100644
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
index 9bfe46d..8ab6913 100644
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
@@ -41,6 +44,9 @@ static const struct datatype *datatypes[TYPE_MAX + 1] = {
 	[TYPE_TIME]		= &time_type,
 	[TYPE_MARK]		= &mark_type,
 	[TYPE_ARPHRD]		= &arphrd_type,
+	[TYPE_ICMP_CODE]	= &icmp_code_type,
+	[TYPE_ICMPV6_CODE]	= &icmpv6_code_type,
+	[TYPE_ICMPX_CODE]	= &icmpx_code_type,
 };
 
 void datatype_register(const struct datatype *dtype)
@@ -683,6 +689,105 @@ const struct datatype mark_type = {
 	.flags		= DTYPE_F_PREFIX,
 };
 
+static const struct symbol_table icmp_code_tbl = {
+	.symbols	= {
+		SYMBOL("net-unreach",		ICMP_NET_UNREACH),
+		SYMBOL("host-unreach",		ICMP_HOST_UNREACH),
+		SYMBOL("prot-unreach",		ICMP_PROT_UNREACH),
+		SYMBOL("port-unreach",		ICMP_PORT_UNREACH),
+		SYMBOL("net-prohibited",	ICMP_NET_ANO),
+		SYMBOL("host-prohibited",	ICMP_HOST_ANO),
+		SYMBOL("admin-prohibited",	ICMP_PKT_FILTERED),
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
+	return symbolic_constant_parse(sym, &icmp_code_tbl, res);
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
+		SYMBOL("no-route",		ICMP6_DST_UNREACH_NOROUTE),
+		SYMBOL("admin-prohibited",	ICMP6_DST_UNREACH_ADMIN),
+		SYMBOL("addr-unreach",		ICMP6_DST_UNREACH_ADDR),
+		SYMBOL("port-unreach",		ICMP6_DST_UNREACH_NOPORT),
+		SYMBOL_LIST_END
+	},
+};
+
+static void icmpv6_code_type_print(const struct expr *expr)
+{
+	return symbolic_constant_print(&icmpv6_code_tbl, expr);
+}
+
+static struct error_record *icmpv6_code_type_parse(const struct expr *sym,
+					    struct expr **res)
+{
+	return symbolic_constant_parse(sym, &icmpv6_code_tbl, res);
+}
+
+const struct datatype icmpv6_code_type = {
+	.type		= TYPE_ICMPV6_CODE,
+	.name		= "icmpv6 code",
+	.desc		= "icmpv6 code type",
+	.size		= BITS_PER_BYTE,
+	.byteorder	= BYTEORDER_BIG_ENDIAN,
+	.basetype	= &integer_type,
+	.print		= icmpv6_code_type_print,
+	.parse		= icmpv6_code_type_parse,
+};
+
+static const struct symbol_table icmpx_code_tbl = {
+	.symbols	= {
+		SYMBOL("port-unreach",		NFT_REJECT_ICMPX_PORT_UNREACH),
+		SYMBOL("admin-prohibited",	NFT_REJECT_ICMPX_ADMIN_PROHIBITED),
+		SYMBOL("no-route",		NFT_REJECT_ICMPX_NO_ROUTE),
+		SYMBOL("host-unreach",		NFT_REJECT_ICMPX_HOST_UNREACH),
+		SYMBOL_LIST_END
+	},
+};
+
+static void icmpx_code_type_print(const struct expr *expr)
+{
+	return symbolic_constant_print(&icmpx_code_tbl, expr);
+}
+
+static struct error_record *icmpx_code_type_parse(const struct expr *sym,
+						  struct expr **res)
+{
+	return symbolic_constant_parse(sym, &icmpx_code_tbl, res);
+}
+
+const struct datatype icmpx_code_type = {
+	.type		= TYPE_ICMPX_CODE,
+	.name		= "icmpx code",
+	.desc		= "icmpx code type",
+	.size		= BITS_PER_BYTE,
+	.byteorder	= BYTEORDER_BIG_ENDIAN,
+	.basetype	= &integer_type,
+	.print		= icmpx_code_type_print,
+	.parse		= icmpx_code_type_parse,
+};
+
 static void time_type_print(const struct expr *expr)
 {
 	uint64_t days, hours, minutes, seconds;
diff --git a/src/evaluate.c b/src/evaluate.c
index 52ce548..41a23d1 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -17,6 +17,8 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter_arp.h>
 #include <linux/netfilter/nf_tables.h>
+#include <netinet/ip_icmp.h>
+#include <netinet/icmp6.h>
 
 #include <expression.h>
 #include <statement.h>
@@ -1126,12 +1128,168 @@ static int stmt_evaluate_meta(struct eval_ctx *ctx, struct stmt *stmt)
 	return 0;
 }
 
-static int stmt_evaluate_reject(struct eval_ctx *ctx, struct stmt *stmt)
+static int stmt_reject_gen_dependency(struct stmt *stmt, struct expr *expr,
+				      struct eval_ctx *ctx)
 {
+	struct expr *payload;
+	struct stmt *nstmt;
+	const struct proto_desc *desc, *base;
+
+	if (stmt->reject.type == NFT_REJECT_TCP_RST) {
+		desc = ctx->pctx.protocol[PROTO_BASE_TRANSPORT_HDR].desc;
+		if (desc != NULL)
+			return 0;
+		/* Generate a TCP dependency */
+		payload = payload_expr_alloc(&stmt->location, &proto_tcp,
+					     TCPHDR_DPORT);
+		goto gen_dep;
+	}
+
+	base = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
+	if (base != NULL)
+		return 0;
+
+	if (stmt->reject.icmp_code < 0)
+		return stmt_error(ctx, stmt, "missing icmp error type");
+
+	/* Generate a network dependency */
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
+gen_dep:
+	if (payload_gen_dependency(ctx, payload, &nstmt) < 0)
+		return -1;
+
+	list_add(&nstmt->list, &ctx->cmd->rule->stmts);
+	return 0;
+}
+
+static int stmt_evaluate_reject_family(struct eval_ctx *ctx, struct stmt *stmt,
+				       struct expr *expr)
+{
+	switch (ctx->pctx.family) {
+	case NFPROTO_ARP:
+		return stmt_error(ctx, stmt, "cannot use reject with arp");
+	case NFPROTO_IPV4:
+	case NFPROTO_IPV6:
+		switch (stmt->reject.type) {
+		case NFT_REJECT_TCP_RST:
+			if (stmt_reject_gen_dependency(stmt, expr, ctx) < 0)
+				return -1;
+			break;
+		case NFT_REJECT_ICMPX_UNREACH:
+			return stmt_error(ctx, stmt,
+				   "abstracted ICMP unreachable not supported");
+		default:
+			break;
+		}
+		break;
+	case NFPROTO_INET:
+	case NFPROTO_BRIDGE:
+		if (stmt->reject.type == NFT_REJECT_ICMPX_UNREACH)
+			break;
+		if (stmt_reject_gen_dependency(stmt, expr, ctx) < 0)
+			return -1;
+		break;
+	}
+
 	stmt->flags |= STMT_F_TERMINAL;
 	return 0;
 }
 
+/* The reason to reject this hasn't been specified */
+static int stmt_evaluate_reject_no_reason(struct eval_ctx *ctx,
+					  struct stmt *stmt)
+{
+	switch (ctx->pctx.family) {
+	case NFPROTO_IPV4:
+	case NFPROTO_IPV6:
+		stmt->reject.type = NFT_REJECT_ICMP_UNREACH;
+		stmt->reject.family = ctx->pctx.family;
+		if (ctx->pctx.family == NFPROTO_IPV4)
+			stmt->reject.icmp_code = ICMP_PORT_UNREACH;
+		else
+			stmt->reject.icmp_code = ICMP6_DST_UNREACH_NOPORT;
+		break;
+	case NFPROTO_INET:
+	case NFPROTO_BRIDGE:
+		stmt->reject.type = NFT_REJECT_ICMPX_UNREACH;
+		stmt->reject.icmp_code = NFT_REJECT_ICMPX_PORT_UNREACH;
+		break;
+	}
+	return 0;
+}
+
+/* The reason to reject this has been specified with icmp reason */
+static int stmt_evaluate_reject_icmp_reason(struct eval_ctx *ctx,
+					    struct stmt *stmt)
+{
+	struct error_record *erec;
+	struct expr *code;
+
+	erec = symbol_parse(stmt->reject.expr, &code);
+	if (erec != NULL) {
+		erec_queue(erec, ctx->msgs);
+		return -1;
+	}
+	stmt->reject.icmp_code = mpz_get_uint8(code->value);
+	return 0;
+}
+
+/* The reason to reject this has been specified with tcp reset */
+static int stmt_evaluate_reject_tcp_reason(struct eval_ctx *ctx,
+					   struct stmt *stmt)
+{
+	int protonum;
+	const struct proto_desc *desc, *base;
+	struct proto_ctx *pctx = &ctx->pctx;
+
+	base = pctx->protocol[PROTO_BASE_NETWORK_HDR].desc;
+	desc = pctx->protocol[PROTO_BASE_TRANSPORT_HDR].desc;
+	if (desc == NULL)
+		return 0;
+
+	protonum = proto_find_num(base, desc);
+	switch (protonum) {
+	case IPPROTO_TCP:
+		break;
+	default:
+		if (stmt->reject.type == NFT_REJECT_TCP_RST) {
+			return stmt_error(ctx, stmt,
+				 "you cannot use tcp reset with this protocol");
+		}
+		break;
+	}
+	return 0;
+}
+
+static int stmt_evaluate_reject(struct eval_ctx *ctx, struct stmt *stmt)
+{
+	struct expr *expr = ctx->cmd->expr;
+
+	if (stmt->reject.icmp_code < 0) {
+		stmt_evaluate_reject_no_reason(ctx, stmt);
+	} else if (stmt->reject.expr != NULL) {
+		if (stmt_evaluate_reject_icmp_reason(ctx, stmt) < 0)
+			return -1;
+	} else {
+		if (stmt_evaluate_reject_tcp_reason(ctx, stmt) < 0)
+			return -1;
+	}
+
+	return stmt_evaluate_reject_family(ctx, stmt, expr);
+}
+
 static int stmt_evaluate_nat(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	struct proto_ctx *pctx = &ctx->pctx;
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 796b632..12cb9e0 100644
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
 
@@ -899,6 +905,38 @@ static void expr_postprocess(struct rule_pp_ctx *ctx,
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
+		if (stmt->reject.type == NFT_REJECT_ICMPX_UNREACH)
+			break;
+
+		base = rctx.pctx.protocol[PROTO_BASE_LL_HDR].desc;
+		desc = rctx.pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
+		protocol = proto_find_num(base, desc);
+		if (protocol == __constant_htons(ETH_P_IP))
+			stmt->reject.family = NFPROTO_IPV4;
+		else if (protocol == __constant_htons(ETH_P_IPV6))
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
@@ -926,6 +964,9 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
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
index c46b6d4..29f8e9a 100644
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
index 32d5455..83d45d3 100644
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
@@ -362,6 +364,9 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token WEEK			"week"
 
 %token _REJECT			"reject"
+%token RESET			"reset"
+%token WITH			"with"
+%token ICMPX			"icmpx"
 
 %token SNAT			"snat"
 %token DNAT			"dnat"
@@ -423,8 +428,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <stmt>			limit_stmt
 %destructor { stmt_free($$); }	limit_stmt
 %type <val>			time_unit
-%type <stmt>			reject_stmt
-%destructor { stmt_free($$); }	reject_stmt
+%type <stmt>			reject_stmt reject_stmt_alloc
+%destructor { stmt_free($$); }	reject_stmt reject_stmt_alloc
 %type <stmt>			nat_stmt nat_stmt_alloc
 %destructor { stmt_free($$); }	nat_stmt nat_stmt_alloc
 %type <stmt>			queue_stmt queue_stmt_alloc
@@ -1346,12 +1351,55 @@ time_unit		:	SECOND		{ $$ = 1ULL; }
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
+			|	WITH	ICMP	TYPE	STRING
+	       		{
+				$<stmt>0->reject.family = NFPROTO_IPV4;
+				$<stmt>0->reject.type = NFT_REJECT_ICMP_UNREACH;
+				$<stmt>0->reject.expr = symbol_expr_alloc(&@$,
+								   SYMBOL_VALUE,
+							   current_scope(state),
+									 $4);
+				$<stmt>0->reject.expr->dtype = &icmp_code_type;
+			}
+			|	WITH	ICMP6	TYPE	STRING
+			{
+				$<stmt>0->reject.family = NFPROTO_IPV6;
+				$<stmt>0->reject.type = NFT_REJECT_ICMP_UNREACH;
+				$<stmt>0->reject.expr = symbol_expr_alloc(&@$,
+								   SYMBOL_VALUE,
+							   current_scope(state),
+									 $4);
+				$<stmt>0->reject.expr->dtype = &icmpv6_code_type;
+			}
+			|	WITH	ICMPX	TYPE	STRING
+			{
+				$<stmt>0->reject.type = NFT_REJECT_ICMPX_UNREACH;
+				$<stmt>0->reject.expr = symbol_expr_alloc(&@$,
+								   SYMBOL_VALUE,
+							   current_scope(state),
+									 $4);
+				$<stmt>0->reject.expr->dtype = &icmpx_code_type;
+			}
+			|	WITH	TCP	RESET
+			{
+				$<stmt>0->reject.type = NFT_REJECT_TCP_RST;
+			}
+			;
+
 nat_stmt		:	nat_stmt_alloc	nat_stmt_args
 			;
 
diff --git a/src/payload.c b/src/payload.c
index b7b74ed..ebf8079 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -198,11 +198,32 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
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
index 772f658..bbf2797 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -308,6 +308,9 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "week"			{ return WEEK; }
 
 "reject"		{ return _REJECT; }
+"with"			{ return WITH; }
+"reset"			{ return RESET; }
+"icmpx"			{ return ICMPX; }
 
 "snat"			{ return SNAT; }
 "dnat"			{ return DNAT; }
diff --git a/src/statement.c b/src/statement.c
index 8e4b49e..9ff6749 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -16,6 +16,10 @@
 #include <string.h>
 #include <syslog.h>
 
+#include <arpa/inet.h>
+#include <linux/netfilter.h>
+#include <netinet/ip_icmp.h>
+#include <netinet/icmp6.h>
 #include <statement.h>
 #include <utils.h>
 #include <list.h>
@@ -224,9 +228,54 @@ struct stmt *queue_stmt_alloc(const struct location *loc)
 	return stmt_alloc(loc, &queue_stmt_ops);
 }
 
+const char *reject_stmt_code_ip[] = {
+	[ICMP_NET_UNREACH]	= "net-unreach",
+	[ICMP_HOST_UNREACH]	= "host-unreach",
+	[ICMP_PROT_UNREACH]	= "prot-unreach",
+	[ICMP_NET_ANO]		= "net-prohibited",
+	[ICMP_HOST_ANO]		= "host-prohibited",
+	[ICMP_PKT_FILTERED]	= "admin-prohibited",
+};
+
+const char *reject_stmt_code_ip6[] = {
+	[ICMP6_DST_UNREACH_NOROUTE]	= "no-route",
+	[ICMP6_DST_UNREACH_ADMIN]	= "admin-prohibited",
+	[ICMP6_DST_UNREACH_ADDR]	= "addr-unreach",
+};
+
+const char *reject_stmt_code_icmpx[] = {
+	[NFT_REJECT_ICMPX_NO_ROUTE]		= "no-route",
+	[NFT_REJECT_ICMPX_HOST_UNREACH]		= "host-unreach",
+	[NFT_REJECT_ICMPX_ADMIN_PROHIBITED]	= "admin-prohibited",
+};
+
 static void reject_stmt_print(const struct stmt *stmt)
 {
 	printf("reject");
+	switch (stmt->reject.type) {
+	case NFT_REJECT_TCP_RST:
+		printf(" with tcp reset");
+		break;
+	case NFT_REJECT_ICMPX_UNREACH:
+		if (stmt->reject.icmp_code == NFT_REJECT_ICMPX_PORT_UNREACH)
+			break;
+		printf(" with icmpx type %s",
+			reject_stmt_code_icmpx[stmt->reject.icmp_code]);
+		break;
+	case NFT_REJECT_ICMP_UNREACH:
+		if (stmt->reject.family == NFPROTO_IPV4) {
+			if (stmt->reject.icmp_code == ICMP_PORT_UNREACH)
+				break;
+			printf(" with icmp type %s",
+			       reject_stmt_code_ip[stmt->reject.icmp_code]);
+		} else if (stmt->reject.family == NFPROTO_IPV6) {
+			if (stmt->reject.icmp_code == ICMP6_DST_UNREACH_NOPORT)
+				break;
+
+			printf(" with icmpv6 type %s",
+			       reject_stmt_code_ip6[stmt->reject.icmp_code]);
+		}
+	}
 }
 
 static const struct stmt_ops reject_stmt_ops = {
-- 
1.7.10.4

