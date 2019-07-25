Return-Path: <SRS0=uZng=VW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10BA5C76194
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 09:14:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1A5421852
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 09:14:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390291AbfGYJON (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 05:14:13 -0400
Received: from mail.us.es ([193.147.175.20]:47980 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390285AbfGYJON (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 05:14:13 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E51CCBAEE0
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jul 2019 11:14:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D1BC2DA732
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jul 2019 11:14:07 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C6D6DDA704; Thu, 25 Jul 2019 11:14:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 72B28DA708
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jul 2019 11:14:05 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 25 Jul 2019 11:14:05 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.183.64])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 222524265A31
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jul 2019 11:14:05 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v1 2/2] src: add tunnel expression support
Date:   Thu, 25 Jul 2019 11:14:00 +0200
Message-Id: <20190725091400.30057-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190725091400.30057-1-pablo@netfilter.org>
References: <20190725091400.30057-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch allows you to match on tunnel metadata.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/Makefile.am       |  4 ++-
 include/expression.h      |  6 ++++
 include/tunnel.h          | 33 +++++++++++++++++++++
 src/Makefile.am           |  1 +
 src/evaluate.c            |  7 +++++
 src/expression.c          |  1 +
 src/netlink_delinearize.c | 17 +++++++++++
 src/netlink_linearize.c   | 14 +++++++++
 src/parser_bison.y        | 33 +++++++++++++++++----
 src/scanner.l             |  2 ++
 src/statement.c           |  1 +
 src/tunnel.c              | 75 +++++++++++++++++++++++++++++++++++++++++++++++
 12 files changed, 188 insertions(+), 6 deletions(-)
 create mode 100644 include/tunnel.h
 create mode 100644 src/tunnel.c

diff --git a/include/Makefile.am b/include/Makefile.am
index 04a4a619a530..2224c5026836 100644
--- a/include/Makefile.am
+++ b/include/Makefile.am
@@ -1,4 +1,4 @@
-SUBDIRS =		linux		\
+uSUBDIRS =		linux		\
 			nftables
 
 noinst_HEADERS = 	cli.h		\
@@ -31,8 +31,10 @@ noinst_HEADERS = 	cli.h		\
 			parser.h	\
 			proto.h		\
 			socket.h	\
+			tunnel.h	\
 			rule.h		\
 			rt.h		\
+			tunnel.h	\
 			utils.h		\
 			xfrm.h		\
 			xt.h
diff --git a/include/expression.h b/include/expression.h
index 717b67550381..9941149a687b 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -70,6 +70,7 @@ enum expr_types {
 	EXPR_RT,
 	EXPR_FIB,
 	EXPR_XFRM,
+	EXPR_TUNNEL,
 };
 
 enum ops {
@@ -196,6 +197,7 @@ enum expr_flags {
 #include <hash.h>
 #include <ct.h>
 #include <socket.h>
+#include <tunnel.h>
 #include <osf.h>
 #include <xfrm.h>
 
@@ -311,6 +313,10 @@ struct expr {
 			enum nft_socket_keys	key;
 		} socket;
 		struct {
+			/* EXPR_TUNNEL */
+			enum nft_tunnel_keys	key;
+		} tunnel;
+		struct {
 			/* EXPR_RT */
 			enum nft_rt_keys	key;
 		} rt;
diff --git a/include/tunnel.h b/include/tunnel.h
new file mode 100644
index 000000000000..90d3f8f75ad7
--- /dev/null
+++ b/include/tunnel.h
@@ -0,0 +1,33 @@
+#ifndef NFTABLES_TUNNEL_H
+#define NFTABLES_TUNNEL_H
+
+/**
+ * struct tunnel_template - template for tunnel expressions
+ *
+ * @token:	parser token for the expression
+ * @dtype:	data type of the expression
+ * @len:	length of the expression
+ * @byteorder:	byteorder
+ */
+struct tunnel_template {
+	const char		*token;
+	const struct datatype	*dtype;
+	enum byteorder		byteorder;
+	unsigned int		len;
+};
+
+extern const struct tunnel_template tunnel_templates[];
+
+#define TUNNEL_TEMPLATE(__token, __dtype, __len, __byteorder) {	\
+	.token		= (__token),				\
+	.dtype		= (__dtype),				\
+	.len		= (__len),				\
+	.byteorder	= (__byteorder),			\
+}
+
+extern struct expr *tunnel_expr_alloc(const struct location *loc,
+				      enum nft_tunnel_keys key);
+
+const struct expr_ops tunnel_expr_ops;
+
+#endif /* NFTABLES_TUNNEL_H */
diff --git a/src/Makefile.am b/src/Makefile.am
index e2b531390cef..9b62c5325c8f 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -63,6 +63,7 @@ libnftables_la_SOURCES =			\
 		nfnl_osf.c			\
 		tcpopt.c			\
 		socket.c			\
+		tunnel.c			\
 		print.c				\
 		libnftables.c			\
 		libnftables.map
diff --git a/src/evaluate.c b/src/evaluate.c
index 0c2a8d0a9571..dca2bdfea917 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1828,6 +1828,11 @@ static int expr_evaluate_osf(struct eval_ctx *ctx, struct expr **expr)
 	return expr_evaluate_primary(ctx, expr);
 }
 
+static int expr_evaluate_tunnel(struct eval_ctx *ctx, struct expr **exprp)
+{
+	return expr_evaluate_primary(ctx, exprp);
+}
+
 static int expr_evaluate_variable(struct eval_ctx *ctx, struct expr **exprp)
 {
 	struct expr *new = expr_clone((*exprp)->sym->expr);
@@ -1884,6 +1889,8 @@ static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
 		return expr_evaluate_meta(ctx, expr);
 	case EXPR_SOCKET:
 		return expr_evaluate_socket(ctx, expr);
+	case EXPR_TUNNEL:
+		return expr_evaluate_tunnel(ctx, expr);
 	case EXPR_OSF:
 		return expr_evaluate_osf(ctx, expr);
 	case EXPR_FIB:
diff --git a/src/expression.c b/src/expression.c
index cb49e0b73f5a..c97b2c9dd5c9 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -1204,6 +1204,7 @@ const struct expr_ops *expr_ops(const struct expr *e)
 	case EXPR_RT: return &rt_expr_ops;
 	case EXPR_FIB: return &fib_expr_ops;
 	case EXPR_XFRM: return &xfrm_expr_ops;
+	case EXPR_TUNNEL: return &tunnel_expr_ops;
 	}
 
 	BUG("Unknown expression type %d\n", e->etype);
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index fc2574b1dea9..25ce874b35d0 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -668,6 +668,21 @@ static void netlink_parse_osf(struct netlink_parse_ctx *ctx,
 	netlink_set_register(ctx, dreg, expr);
 }
 
+static void netlink_parse_tunnel(struct netlink_parse_ctx *ctx,
+				 const struct location *loc,
+				 const struct nftnl_expr *nle)
+{
+	enum nft_registers dreg;
+	struct expr * expr;
+	uint32_t key;
+
+	key = nftnl_expr_get_u32(nle, NFTNL_EXPR_TUNNEL_KEY);
+	expr = tunnel_expr_alloc(loc, key);
+
+	dreg = netlink_parse_register(nle, NFTNL_EXPR_TUNNEL_DREG);
+	netlink_set_register(ctx, dreg, expr);
+}
+
 static void netlink_parse_meta_stmt(struct netlink_parse_ctx *ctx,
 				    const struct location *loc,
 				    const struct nftnl_expr *nle)
@@ -1464,6 +1479,7 @@ static const struct {
 	{ .name = "exthdr",	.parse = netlink_parse_exthdr },
 	{ .name = "meta",	.parse = netlink_parse_meta },
 	{ .name = "socket",	.parse = netlink_parse_socket },
+	{ .name = "tunnel",	.parse = netlink_parse_tunnel },
 	{ .name = "osf",	.parse = netlink_parse_osf },
 	{ .name = "rt",		.parse = netlink_parse_rt },
 	{ .name = "ct",		.parse = netlink_parse_ct },
@@ -2158,6 +2174,7 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 	case EXPR_NUMGEN:
 	case EXPR_FIB:
 	case EXPR_SOCKET:
+	case EXPR_TUNNEL:
 	case EXPR_OSF:
 	case EXPR_XFRM:
 		break;
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 498326d0087a..b337539a44cf 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -232,6 +232,18 @@ static void netlink_gen_osf(struct netlink_linearize_ctx *ctx,
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
 
+static void netlink_gen_tunnel(struct netlink_linearize_ctx *ctx,
+			       const struct expr *expr,
+			       enum nft_registers dreg)
+{
+	struct nftnl_expr *nle;
+
+	nle = alloc_nft_expr("tunnel");
+	netlink_put_register(nle, NFTNL_EXPR_TUNNEL_DREG, dreg);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_TUNNEL_KEY, expr->tunnel.key);
+	nftnl_rule_add_expr(ctx->nlr, nle);
+}
+
 static void netlink_gen_numgen(struct netlink_linearize_ctx *ctx,
 			    const struct expr *expr,
 			    enum nft_registers dreg)
@@ -735,6 +747,8 @@ static void netlink_gen_expr(struct netlink_linearize_ctx *ctx,
 		return netlink_gen_fib(ctx, expr, dreg);
 	case EXPR_SOCKET:
 		return netlink_gen_socket(ctx, expr, dreg);
+	case EXPR_TUNNEL:
+		return netlink_gen_tunnel(ctx, expr, dreg);
 	case EXPR_OSF:
 		return netlink_gen_osf(ctx, expr, dreg);
 	case EXPR_XFRM:
diff --git a/src/parser_bison.y b/src/parser_bison.y
index d3b64b641700..ba28224a3b96 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -225,6 +225,8 @@ int nft_lex(void *, void *, void *);
 %token RULESET			"ruleset"
 %token TRACE			"trace"
 
+%token PATH			"path"
+
 %token INET			"inet"
 %token NETDEV			"netdev"
 
@@ -601,8 +603,8 @@ int nft_lex(void *, void *, void *);
 %destructor { stmt_free($$); }	counter_stmt counter_stmt_alloc stateful_stmt
 %type <stmt>			payload_stmt
 %destructor { stmt_free($$); }	payload_stmt
-%type <stmt>			ct_stmt
-%destructor { stmt_free($$); }	ct_stmt
+%type <stmt>			ct_stmt tunnel_stmt
+%destructor { stmt_free($$); }	ct_stmt tunnel_stmt
 %type <stmt>			meta_stmt
 %destructor { stmt_free($$); }	meta_stmt
 %type <stmt>			log_stmt log_stmt_alloc
@@ -746,9 +748,9 @@ int nft_lex(void *, void *, void *);
 %destructor { expr_free($$); }	mh_hdr_expr
 %type <val>			mh_hdr_field
 
-%type <expr>			meta_expr
-%destructor { expr_free($$); }	meta_expr
-%type <val>			meta_key	meta_key_qualified	meta_key_unqualified	numgen_type
+%type <expr>			meta_expr	tunnel_expr
+%destructor { expr_free($$); }	meta_expr	tunnel_expr
+%type <val>			meta_key	meta_key_qualified	meta_key_unqualified	numgen_type	tunnel_key
 
 %type <expr>			socket_expr
 %destructor { expr_free($$); } socket_expr
@@ -2310,6 +2312,7 @@ stmt			:	verdict_stmt
 			|	tproxy_stmt
 			|	queue_stmt
 			|	ct_stmt
+			|	tunnel_stmt
 			|	masq_stmt
 			|	redir_stmt
 			|	dup_stmt
@@ -2788,6 +2791,7 @@ primary_stmt_expr	:	symbol_expr		{ $$ = $1; }
 			|	integer_expr		{ $$ = $1; }
 			|	boolean_expr		{ $$ = $1; }
 			|	meta_expr		{ $$ = $1; }
+			|	tunnel_expr		{ $$ = $1; }
 			|	rt_expr			{ $$ = $1; }
 			|	ct_expr			{ $$ = $1; }
 			|	numgen_expr             { $$ = $1; }
@@ -3243,6 +3247,7 @@ primary_expr		:	symbol_expr			{ $$ = $1; }
 			|	exthdr_expr			{ $$ = $1; }
 			|	exthdr_exists_expr		{ $$ = $1; }
 			|	meta_expr			{ $$ = $1; }
+			|	tunnel_expr			{ $$ = $1; }
 			|	socket_expr			{ $$ = $1; }
 			|	rt_expr				{ $$ = $1; }
 			|	ct_expr				{ $$ = $1; }
@@ -4095,6 +4100,16 @@ meta_stmt		:	META	meta_key	SET	stmt_expr
 			}
 			;
 
+tunnel_key		:	PATH		{ $$ = NFT_TUNNEL_PATH; }
+			|	ID		{ $$ = NFT_TUNNEL_ID; }
+			;
+
+tunnel_expr		:	TUNNEL	tunnel_key
+			{
+				$$ = tunnel_expr_alloc(&@$, $2);
+			}
+			;
+
 socket_expr		:	SOCKET	socket_key
 			{
 				$$ = socket_expr_alloc(&@$, $2);
@@ -4326,6 +4341,14 @@ ct_stmt			:	CT	ct_key		SET	stmt_expr
 			}
 			;
 
+tunnel_stmt		:	TUNNEL	NAME	stmt_expr
+			{
+				$$ = objref_stmt_alloc(&@$);
+				$$->objref.type = NFT_OBJECT_TUNNEL;
+				$$->objref.expr = $3;
+			}
+			;
+
 payload_stmt		:	payload_expr		SET	stmt_expr
 			{
 				if ($1->etype == EXPR_EXTHDR)
diff --git a/src/scanner.l b/src/scanner.l
index f8575638a47b..7bbe5663dddd 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -329,6 +329,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "tunnel"		{ return TUNNEL; }
 "tunnels"		{ return TUNNELS; }
 
+"path"			{ return PATH; }
+
 "log"			{ return LOG; }
 "prefix"		{ return PREFIX; }
 "group"			{ return GROUP; }
diff --git a/src/statement.c b/src/statement.c
index a9e72de3edfd..ab893be664e3 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -207,6 +207,7 @@ static const char *objref_type[NFT_OBJECT_MAX + 1] = {
 	[NFT_OBJECT_QUOTA]	= "quota",
 	[NFT_OBJECT_CT_HELPER]	= "ct helper",
 	[NFT_OBJECT_LIMIT]	= "limit",
+	[NFT_OBJECT_TUNNEL]	= "tunnel",
 	[NFT_OBJECT_CT_TIMEOUT] = "ct timeout",
 	[NFT_OBJECT_SECMARK]	= "secmark",
 	[NFT_OBJECT_CT_EXPECT]	= "ct expectation",
diff --git a/src/tunnel.c b/src/tunnel.c
new file mode 100644
index 000000000000..de01622246ef
--- /dev/null
+++ b/src/tunnel.c
@@ -0,0 +1,75 @@
+/*
+ * Copyright (c) 2018 Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <errno.h>
+#include <limits.h>
+#include <stddef.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <stdint.h>
+#include <string.h>
+#include <net/if.h>
+#include <net/if_arp.h>
+#include <pwd.h>
+#include <grp.h>
+#include <arpa/inet.h>
+#include <linux/netfilter.h>
+#include <linux/pkt_sched.h>
+#include <linux/if_packet.h>
+
+#include <nftables.h>
+#include <expression.h>
+#include <datatype.h>
+#include <tunnel.h>
+#include <gmputil.h>
+#include <utils.h>
+#include <erec.h>
+
+const struct tunnel_template tunnel_templates[] = {
+	[NFT_TUNNEL_PATH]	= META_TEMPLATE("path", &boolean_type,
+						BITS_PER_BYTE, BYTEORDER_HOST_ENDIAN),
+	[NFT_TUNNEL_ID]		= META_TEMPLATE("id",  &integer_type,
+						4 * 8, BYTEORDER_HOST_ENDIAN),
+};
+
+static void tunnel_expr_print(const struct expr *expr, struct output_ctx *octx)
+{
+	nft_print(octx, "tunnel %s",
+		  tunnel_templates[expr->tunnel.key].token);
+}
+
+static bool tunnel_expr_cmp(const struct expr *e1, const struct expr *e2)
+{
+	return e1->tunnel.key == e2->tunnel.key;
+}
+
+static void tunnel_expr_clone(struct expr *new, const struct expr *expr)
+{
+	new->tunnel.key = expr->tunnel.key;
+}
+
+const struct expr_ops tunnel_expr_ops = {
+	.type		= EXPR_TUNNEL,
+	.name		= "tunnel",
+	.print		= tunnel_expr_print,
+	.cmp		= tunnel_expr_cmp,
+	.clone		= tunnel_expr_clone,
+};
+
+struct expr *tunnel_expr_alloc(const struct location *loc,
+			       enum nft_tunnel_keys key)
+{
+	const struct tunnel_template *tmpl = &tunnel_templates[key];
+	struct expr *expr;
+
+	expr = expr_alloc(loc, EXPR_TUNNEL, tmpl->dtype, tmpl->byteorder,
+			  tmpl->len);
+	expr->tunnel.key = key;
+
+	return expr;
+}
-- 
2.11.0

