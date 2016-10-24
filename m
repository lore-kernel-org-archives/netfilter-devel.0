From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 3/3 nft] src: add fib expression
Date: Mon, 24 Oct 2016 16:56:42 +0200
Message-ID: <1477321002-14056-4-git-send-email-fw@strlen.de>
References: <1477321002-14056-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46006 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932806AbcJXO4f (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Oct 2016 10:56:35 -0400
In-Reply-To: <1477321002-14056-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This adds the 'fib' expression which can be used to
obtain the output interface from the route table based on either
source or destination address of a packet.

This can be used to e.g. add reverse path filtering:

 # drop if not coming from the same interface packet
 # arrived on
 # nft add rule x prerouting fib saddr . iif oif eq 0 drop

 # accept only if from eth0
 # nft add rule x prerouting fib saddr . iif oif eq "eth0" accept

 # accept if from any valid interface
 # nft add rule x prerouting fib saddr oif accept

Querying of address type is also supported.  This can be used
to e.g. only accept packets to addresses configured in the same
interface:
 # fib daddr . iif type local

Its also possible to use mark and verdict map, e.g.:
    blackhole : drop,
    prohibit : drop,
    unicast : accept
}

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/nft.xml                         | 103 ++++++++++++++++++++++++++
 include/datatype.h                  |   1 +
 include/expression.h                |   7 ++
 include/fib.h                       |   7 ++
 include/linux/netfilter/nf_tables.h |  36 +++++++++
 src/Makefile.am                     |   1 +
 src/evaluate.c                      |   1 +
 src/fib.c                           | 144 ++++++++++++++++++++++++++++++++++++
 src/netlink_delinearize.c           |  19 +++++
 src/netlink_linearize.c             |  16 ++++
 src/parser_bison.y                  |  50 +++++++++++++
 src/scanner.l                       |   2 +
 12 files changed, 387 insertions(+)
 create mode 100644 include/fib.h
 create mode 100644 src/fib.c

diff --git a/doc/nft.xml b/doc/nft.xml
index 3b215f8c34f4..986b1ff9e115 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -1222,6 +1222,109 @@ filter output oif eth0
 				</example>
 			</para>
 		</refsect2>
+
+		<refsect2>
+			<title>fib expressions</title>
+			<para>
+				<cmdsynopsis>
+					<command>fib</command>
+					<group choice="req">
+						<arg>saddr</arg>
+						<arg>daddr</arg>
+					<group choice="opt">
+						<arg>mark</arg>
+						<arg>iif</arg>
+						<arg>oif</arg>
+					</group>
+					</group>
+					<group choice="req">
+						<arg>oif</arg>
+						<arg>oifname</arg>
+						<arg>type</arg>
+					</group>
+				</cmdsynopsis>
+			</para>
+			<para>
+				A fib expression queries the fib (forwarding information base)
+				to obtain information such as the output interface index a particular address would use.  The input is a tuple of elements that is used as input to the fib lookup
+				functions.
+			</para>
+			<para>
+				fib expressions return 				or as qualified meta expressions.
+			</para>
+			<para>
+				<table frame="all">
+					<title>Meta expression types</title>
+					<tgroup cols='3' align='left' colsep='1' rowsep='1'>
+						<colspec colname='c1'/>
+						<colspec colname='c2'/>
+						<colspec colname='c3'/>
+						<thead>
+							<row>
+								<entry>Keyword</entry>
+								<entry>Description</entry>
+								<entry>Type</entry>
+							</row>
+						</thead>
+						<tbody>
+							<row>
+								<entry>oif</entry>
+								<entry>Output interface index</entry>
+								<entry>integer (32 bit)</entry>
+							</row>
+							<row>
+								<entry>oifname</entry>
+								<entry>Output interface name</entry>
+								<entry>string</entry>
+							</row>
+							<row>
+								<entry>type</entry>
+								<entry>Address type</entry>
+								<entry>fib_addrtype</entry>
+							</row>
+						</tbody>
+					</tgroup>
+				</table>
+			</para>
+			<para>
+				<table frame="all">
+					<title>fib expression specific types</title>
+					<tgroup cols='2' align='left' colsep='1' rowsep='1'>
+						<colspec colname='c1'/>
+						<colspec colname='c2'/>
+						<thead>
+							<row>
+								<entry>Type</entry>
+								<entry>Description</entry>
+							</row>
+						</thead>
+						<tbody>
+							<row>
+								<entry>fib_addrtype</entry>
+								<entry>
+									Address type stored in the fib.
+								</entry>
+							</row>
+						</tbody>
+					</tgroup>
+				</table>
+			</para>
+			<para>
+				<example>
+					<title>Using fib expressions</title>
+					<programlisting>
+# drop packets without a reverse path
+filter prerouting fib saddr . iif oif eq 0 drop
+
+# drop packets to address not configured on ininterface
+filter input fib daddr . iif type not { local, broadcast, multicast } drop
+
+# perform lookup in a specific 'blackhole' table (0xdead, needs ip appropriate ip rule)
+filter prerouting meta mark set 0xdead fib daddr . mark type vmap { backhole : drop, prohibit : jump prohibited, unreachable : drop }
+					</programlisting>
+				</example>
+			</para>
+		</refsect2>
 	</refsect1>
 
 	<refsect1>
diff --git a/include/datatype.h b/include/datatype.h
index 12ec46bcc7bb..9f3f711c7bb0 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -81,6 +81,7 @@ enum datatypes {
 	TYPE_DEVGROUP,
 	TYPE_DSCP,
 	TYPE_ECN,
+	TYPE_FIB_ADDR,
 	__TYPE_MAX
 };
 #define TYPE_MAX		(__TYPE_MAX - 1)
diff --git a/include/expression.h b/include/expression.h
index 13ca315cb9e7..33f8abeee690 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -59,6 +59,7 @@ enum expr_types {
 	EXPR_RELATIONAL,
 	EXPR_NUMGEN,
 	EXPR_HASH,
+	EXPR_FIB,
 };
 
 enum ops {
@@ -178,6 +179,7 @@ enum expr_flags {
 
 #include <payload.h>
 #include <exthdr.h>
+#include <fib.h>
 #include <numgen.h>
 #include <meta.h>
 #include <hash.h>
@@ -298,6 +300,11 @@ struct expr {
 			uint32_t		mod;
 			uint32_t		seed;
 		} hash;
+		struct {
+			/* EXPR_FIB */
+			uint32_t		flags;
+			uint32_t		result;
+		} fib;
 	};
 };
 
diff --git a/include/fib.h b/include/fib.h
new file mode 100644
index 000000000000..3a019e65c814
--- /dev/null
+++ b/include/fib.h
@@ -0,0 +1,7 @@
+#ifndef NFTABLES_FIB_H
+#define NFTABLES_FIB_H
+
+extern struct expr *fib_expr_alloc(const struct location *loc,
+				   unsigned int flags,
+				   unsigned int result);
+#endif /* NFTABLES_FIB_H */
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index b21a844cf5d5..e71df36fd097 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -1099,6 +1099,42 @@ enum nft_gen_attributes {
 };
 #define NFTA_GEN_MAX		(__NFTA_GEN_MAX - 1)
 
+/*
+ * enum nft_fib_attributes - nf_tables fib expression netlink attributes
+ *
+ * @NFTA_FIB_DREG: destination register (NLA_U32)
+ * @NFTA_FIB_RESULT: desired result (NLA_U32)
+ * @NFTA_FIB_FLAGS: flowi fields to initialize when querying the FIB (NLA_U32)
+ *
+ * The FIB expression performs a route lookup according
+ * to the packet data.
+ */
+enum nft_fib_attributes {
+	NFTA_FIB_UNSPEC,
+	NFTA_FIB_DREG,
+	NFTA_FIB_RESULT,
+	NFTA_FIB_FLAGS,
+	__NFTA_FIB_MAX
+};
+#define NFTA_FIB_MAX (__NFTA_FIB_MAX - 1)
+
+enum nft_fib_result {
+	NFT_FIB_RESULT_UNSPEC,
+	NFT_FIB_RESULT_OIF,
+	NFT_FIB_RESULT_OIFNAME,
+	NFT_FIB_RESULT_ADDRTYPE,
+	__NFT_FIB_RESULT_MAX
+};
+#define NFT_FIB_RESULT_MAX	(__NFT_FIB_RESULT_MAX - 1)
+
+enum nft_fib_flags {
+	NFTA_FIB_F_SADDR	= 1 << 0,	/* look up src */
+	NFTA_FIB_F_DADDR	= 1 << 1,	/* look up dst */
+	NFTA_FIB_F_MARK		= 1 << 2,	/* use skb->mark */
+	NFTA_FIB_F_IIF		= 1 << 3,	/* restrict to iif */
+	NFTA_FIB_F_OIF		= 1 << 4,	/* restrict to oif */
+};
+
 /**
  * enum nft_trace_attributes - nf_tables trace netlink attributes
  *
diff --git a/src/Makefile.am b/src/Makefile.am
index 63bbef2cc151..60877b240014 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -36,6 +36,7 @@ nft_SOURCES =	main.c				\
 		proto.c				\
 		payload.c			\
 		exthdr.c			\
+		fib.c				\
 		hash.c				\
 		meta.c				\
 		numgen.c			\
diff --git a/src/evaluate.c b/src/evaluate.c
index 45af3298537c..81b8c26bcc79 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1606,6 +1606,7 @@ static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
 		return expr_evaluate_exthdr(ctx, expr);
 	case EXPR_VERDICT:
 	case EXPR_META:
+	case EXPR_FIB:
 		return expr_evaluate_primary(ctx, expr);
 	case EXPR_PAYLOAD:
 		return expr_evaluate_payload(ctx, expr);
diff --git a/src/fib.c b/src/fib.c
new file mode 100644
index 000000000000..346cce322da2
--- /dev/null
+++ b/src/fib.c
@@ -0,0 +1,144 @@
+/*
+ * FIB expression.
+ *
+ * Copyright (c) Red Hat GmbH.  Author: Florian Westphal <fw@strlen.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <nftables.h>
+#include <erec.h>
+#include <expression.h>
+#include <datatype.h>
+#include <gmputil.h>
+#include <utils.h>
+#include <string.h>
+#include <fib.h>
+
+#include <linux/rtnetlink.h>
+#include <net/if.h>
+
+static const char *fib_result[NFT_FIB_RESULT_MAX + 1] = {
+	[NFT_FIB_RESULT_OIF] = "oif",
+	[NFT_FIB_RESULT_OIFNAME] = "oifname",
+	[NFT_FIB_RESULT_ADDRTYPE] = "type",
+};
+
+static const struct symbol_table addrtype_tbl = {
+	.symbols	= {
+		SYMBOL("unspec",	RTN_UNSPEC),
+		SYMBOL("unicast",	RTN_UNICAST),
+		SYMBOL("local",		RTN_LOCAL),
+		SYMBOL("broadcast",	RTN_BROADCAST),
+		SYMBOL("anycast",	RTN_ANYCAST),
+		SYMBOL("multicast",	RTN_MULTICAST),
+		SYMBOL("blackhole",	RTN_BLACKHOLE),
+		SYMBOL("unreachable",	RTN_UNREACHABLE),
+		SYMBOL("prohibit",	RTN_PROHIBIT),
+		SYMBOL_LIST_END
+	}
+};
+
+static const struct datatype fib_addr_type = {
+	.type		= TYPE_FIB_ADDR,
+	.name		= "fib_addrtype",
+	.desc		= "fib address type",
+	.byteorder	= BYTEORDER_HOST_ENDIAN,
+	.size		= 4 * BITS_PER_BYTE,
+	.basetype	= &integer_type,
+	.sym_tbl	= &addrtype_tbl,
+};
+
+static const char *fib_result_str(enum nft_fib_result result)
+{
+	if (result <= NFT_FIB_RESULT_MAX)
+		return fib_result[result];
+
+	return "unknown";
+}
+
+static void __fib_expr_print_f(unsigned int *flags, unsigned int f, const char *s)
+{
+	if ((*flags & f) == 0)
+		return;
+
+	printf("%s", s);
+	*flags &= ~f;
+	if (*flags)
+		printf(" . ");
+}
+
+static void fib_expr_print(const struct expr *expr)
+{
+	unsigned int flags = expr->fib.flags;
+
+	printf("fib ");
+	__fib_expr_print_f(&flags, NFTA_FIB_F_SADDR, "saddr");
+	__fib_expr_print_f(&flags, NFTA_FIB_F_DADDR, "daddr");
+	__fib_expr_print_f(&flags, NFTA_FIB_F_MARK, "mark");
+	__fib_expr_print_f(&flags, NFTA_FIB_F_IIF, "iif");
+	__fib_expr_print_f(&flags, NFTA_FIB_F_OIF, "oif");
+
+	if (flags)
+		printf("0x%x", flags);
+
+	printf(" %s", fib_result_str(expr->fib.result));
+}
+
+static bool fib_expr_cmp(const struct expr *e1, const struct expr *e2)
+{
+	return  e1->fib.result == e2->fib.result &&
+		e1->fib.flags == e2->fib.flags;
+}
+
+static void fib_expr_clone(struct expr *new, const struct expr *expr)
+{
+	new->fib.result = expr->fib.result;
+	new->fib.flags= expr->fib.flags;
+}
+
+static const struct expr_ops fib_expr_ops = {
+	.type		= EXPR_FIB,
+	.name		= "fib",
+	.print		= fib_expr_print,
+	.cmp		= fib_expr_cmp,
+	.clone		= fib_expr_clone,
+};
+
+struct expr *fib_expr_alloc(const struct location *loc,
+			    unsigned int flags, unsigned int result)
+{
+	const struct datatype *type;
+	unsigned int len = 4 * BITS_PER_BYTE;
+	struct expr *expr;
+
+	switch (result) {
+	case NFT_FIB_RESULT_OIF:
+		type = &ifindex_type;
+		break;
+	case NFT_FIB_RESULT_OIFNAME:
+		type = &string_type;
+		len = IFNAMSIZ * BITS_PER_BYTE;
+		break;
+	case NFT_FIB_RESULT_ADDRTYPE:
+		type = &fib_addr_type;
+		break;
+	default:
+		BUG("Unknown result %d\n", result);
+	}
+
+	expr = expr_alloc(loc, &fib_expr_ops, type,
+			  BYTEORDER_HOST_ENDIAN, len);
+
+	expr->fib.result = result;
+	expr->fib.flags	= flags;
+
+	return expr;
+}
+
+static void __init fib_init(void)
+{
+	datatype_register(&fib_addr_type);
+}
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index d8d1d7d7aaa7..afa9b99a0559 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -538,6 +538,23 @@ static void netlink_parse_hash(struct netlink_parse_ctx *ctx,
 	netlink_set_register(ctx, dreg, expr);
 }
 
+static void netlink_parse_fib(struct netlink_parse_ctx *ctx,
+			      const struct location *loc,
+			      const struct nftnl_expr *nle)
+{
+	enum nft_registers dreg;
+	struct expr *expr;
+	uint32_t flags, result;
+
+	flags = nftnl_expr_get_u32(nle, NFTNL_EXPR_FIB_FLAGS);
+	result = nftnl_expr_get_u32(nle, NFTNL_EXPR_FIB_RESULT);
+
+	expr = fib_expr_alloc(loc, flags, result);
+
+	dreg = netlink_parse_register(nle, NFTNL_EXPR_FIB_DREG);
+	netlink_set_register(ctx, dreg, expr);
+}
+
 static void netlink_parse_meta_expr(struct netlink_parse_ctx *ctx,
 				    const struct location *loc,
 				    const struct nftnl_expr *nle)
@@ -1103,6 +1120,7 @@ static const struct {
 	{ .name = "quota",	.parse = netlink_parse_quota },
 	{ .name = "numgen",	.parse = netlink_parse_numgen },
 	{ .name = "hash",	.parse = netlink_parse_hash },
+	{ .name = "fib",	.parse = netlink_parse_fib },
 };
 
 static int netlink_parse_expr(const struct nftnl_expr *nle,
@@ -1725,6 +1743,7 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 	case EXPR_META:
 	case EXPR_VERDICT:
 	case EXPR_NUMGEN:
+	case EXPR_FIB:
 		break;
 	case EXPR_HASH:
 		expr_postprocess(ctx, &expr->hash.expr);
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 0072dca091ea..048e3979e6e9 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -104,6 +104,20 @@ static void netlink_gen_concat(struct netlink_linearize_ctx *ctx,
 	}
 }
 
+static void netlink_gen_fib(struct netlink_linearize_ctx *ctx,
+			    const struct expr *expr,
+			    enum nft_registers dreg)
+{
+	struct nftnl_expr *nle;
+
+	nle = alloc_nft_expr("fib");
+	netlink_put_register(nle, NFTNL_EXPR_FIB_DREG, dreg);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_FIB_RESULT, expr->fib.result);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_FIB_FLAGS, expr->fib.flags);
+
+	nftnl_rule_add_expr(ctx->nlr, nle);
+}
+
 static void netlink_gen_hash(struct netlink_linearize_ctx *ctx,
 			     const struct expr *expr,
 			     enum nft_registers dreg)
@@ -648,6 +662,8 @@ static void netlink_gen_expr(struct netlink_linearize_ctx *ctx,
 		return netlink_gen_numgen(ctx, expr, dreg);
 	case EXPR_HASH:
 		return netlink_gen_hash(ctx, expr, dreg);
+	case EXPR_FIB:
+		return netlink_gen_fib(ctx, expr, dreg);
 	default:
 		BUG("unknown expression type %s\n", expr->ops->name);
 	}
diff --git a/src/parser_bison.y b/src/parser_bison.y
index baf0a539efa0..dd265db47a82 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -162,10 +162,13 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token DASH			"-"
 %token AT			"@"
 %token VMAP			"vmap"
+%token LOOKUP			"lookup"
 
 %token INCLUDE			"include"
 %token DEFINE			"define"
 
+%token FIB			"fib"
+
 %token HOOK			"hook"
 %token DEVICE			"device"
 %token TABLE			"table"
@@ -595,6 +598,10 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %destructor { expr_free($$); }	ct_expr
 %type <val>			ct_key		ct_key_dir	ct_key_counters
 
+%type <expr>			fib_expr
+%destructor { expr_free($$); }	fib_expr
+%type <val>			fib_tuple	fib_result	fib_flag
+
 %type <val>			export_format
 %type <string>			monitor_event
 %destructor { xfree($$); }	monitor_event
@@ -1983,9 +1990,52 @@ primary_expr		:	symbol_expr			{ $$ = $1; }
 			|	ct_expr				{ $$ = $1; }
 			|	numgen_expr			{ $$ = $1; }
 			|	hash_expr			{ $$ = $1; }
+			|	fib_expr			{ $$ = $1; }
 			|	'('	basic_expr	')'	{ $$ = $2; }
 			;
 
+fib_expr		:	FIB	fib_tuple	fib_result
+			{
+				if (($2 & (NFTA_FIB_F_SADDR|NFTA_FIB_F_DADDR)) == 0) {
+					erec_queue(error(&@2, "fib: need either saddr or daddr"), state->msgs);
+					YYERROR;
+				}
+
+				if (($2 & (NFTA_FIB_F_SADDR|NFTA_FIB_F_DADDR)) ==
+					  (NFTA_FIB_F_SADDR|NFTA_FIB_F_DADDR)) {
+					erec_queue(error(&@2, "fib: saddr and daddr are mutually exclusive"), state->msgs);
+					YYERROR;
+				}
+
+				if (($2 & (NFTA_FIB_F_IIF|NFTA_FIB_F_OIF)) ==
+					  (NFTA_FIB_F_IIF|NFTA_FIB_F_OIF)) {
+					erec_queue(error(&@2, "fib: iif and oif are mutually exclusive"), state->msgs);
+					YYERROR;
+				}
+
+				$$ = fib_expr_alloc(&@$, $2, $3);
+			}
+			;
+
+fib_result		:	OIF	{ $$ =NFT_FIB_RESULT_OIF; }
+			|	OIFNAME { $$ =NFT_FIB_RESULT_OIFNAME; }
+			|	TYPE	{ $$ =NFT_FIB_RESULT_ADDRTYPE; }
+			;
+
+fib_flag		:       SADDR	{ $$ = NFTA_FIB_F_SADDR; }
+			|	DADDR	{ $$ = NFTA_FIB_F_DADDR; }
+			|	MARK	{ $$ = NFTA_FIB_F_MARK; }
+			|	IIF	{ $$ = NFTA_FIB_F_IIF; }
+			|	OIF	{ $$ = NFTA_FIB_F_OIF; }
+			;
+
+fib_tuple		:  	fib_flag	DOT	fib_tuple
+			{
+				$$ = $1 | $3;
+			}
+			|	fib_flag
+			;
+
 shift_expr		:	primary_expr
 			|	shift_expr		LSHIFT		primary_expr
 			{
diff --git a/src/scanner.l b/src/scanner.l
index 8b5a383bd095..a68def8d1293 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -477,6 +477,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "dup"			{ return DUP; }
 "fwd"			{ return FWD; }
 
+"fib"			{ return FIB; }
+
 "xml"			{ return XML; }
 "json"			{ return JSON; }
 
-- 
2.7.3

