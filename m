Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F23EDC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Feb 2022 13:37:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234741AbiBSNiP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 19 Feb 2022 08:38:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231447AbiBSNiO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Feb 2022 08:38:14 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7773B100747
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Feb 2022 05:37:55 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nLPvu-0007Yj-0O; Sat, 19 Feb 2022 14:37:54 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] src: add tcp option reset support
Date:   Sat, 19 Feb 2022 14:37:50 +0100
Message-Id: <20220219133750.13369-1-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This allows to replace a tcp tcp option with nops, similar
to the TCPOPTSTRIP feature of iptables.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/statements.txt            |  9 ++++++++-
 include/json.h                |  2 ++
 include/statement.h           |  9 +++++++++
 src/evaluate.c                |  7 +++++++
 src/json.c                    |  6 ++++++
 src/netlink_delinearize.c     |  4 ++++
 src/netlink_linearize.c       | 16 +++++++++++++++-
 src/parser_bison.y            | 11 +++++++++++
 src/parser_json.c             |  9 +++++++++
 src/statement.c               | 32 ++++++++++++++++++++++++++++++++
 tests/py/any/tcpopt.t         |  6 ++++++
 tests/py/any/tcpopt.t.json    | 35 +++++++++++++++++++++++++++++++++++
 tests/py/any/tcpopt.t.payload | 12 ++++++++++++
 13 files changed, 156 insertions(+), 2 deletions(-)

diff --git a/doc/statements.txt b/doc/statements.txt
index 8675892a3159..c491e800d383 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -71,7 +71,7 @@ EXTENSION HEADER STATEMENT
 
 The extension header statement alters packet content in variable-sized headers.
 This can currently be used to alter the TCP Maximum segment size of packets,
-similar to TCPMSS.
+similar to TCPMSS target in iptables.
 
 .change tcp mss
 ---------------
@@ -80,6 +80,13 @@ tcp flags syn tcp option maxseg size set 1360
 tcp flags syn tcp option maxseg size set rt mtu
 ---------------
 
+You can also remove tcp options via *reset* keyword.
+
+.remove tcp option
+---------------
+tcp flags syn reset tcp option sack-perm
+---------------
+
 LOG STATEMENT
 ~~~~~~~~~~~~~
 [verse]
diff --git a/include/json.h b/include/json.h
index a753f359aa52..b0d78eb84987 100644
--- a/include/json.h
+++ b/include/json.h
@@ -91,6 +91,7 @@ json_t *verdict_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
 json_t *connlimit_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
 json_t *tproxy_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
 json_t *synproxy_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
+json_t *optstrip_stmt_json(const struct stmt *stmt, struct output_ctx *octx);
 
 int do_command_list_json(struct netlink_ctx *ctx, struct cmd *cmd);
 
@@ -192,6 +193,7 @@ STMT_PRINT_STUB(verdict)
 STMT_PRINT_STUB(connlimit)
 STMT_PRINT_STUB(tproxy)
 STMT_PRINT_STUB(synproxy)
+STMT_PRINT_STUB(optstrip)
 
 #undef STMT_PRINT_STUB
 #undef EXPR_PRINT_STUB
diff --git a/include/statement.h b/include/statement.h
index 06221040fa0c..2a2d30010618 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -145,6 +145,12 @@ struct nat_stmt {
 extern struct stmt *nat_stmt_alloc(const struct location *loc,
 				   enum nft_nat_etypes type);
 
+struct optstrip_stmt {
+	struct expr	*expr;
+};
+
+extern struct stmt *optstrip_stmt_alloc(const struct location *loc, struct expr *e);
+
 struct tproxy_stmt {
 	struct expr	*addr;
 	struct expr	*port;
@@ -297,6 +303,7 @@ extern struct stmt *xt_stmt_alloc(const struct location *loc);
  * @STMT_MAP:		map statement
  * @STMT_SYNPROXY:	synproxy statement
  * @STMT_CHAIN:		chain statement
+ * @STMT_OPTSTRIP:	optstrip statement
  */
 enum stmt_types {
 	STMT_INVALID,
@@ -326,6 +333,7 @@ enum stmt_types {
 	STMT_MAP,
 	STMT_SYNPROXY,
 	STMT_CHAIN,
+	STMT_OPTSTRIP,
 };
 
 /**
@@ -380,6 +388,7 @@ struct stmt {
 		struct reject_stmt	reject;
 		struct nat_stmt		nat;
 		struct tproxy_stmt	tproxy;
+		struct optstrip_stmt	optstrip;
 		struct queue_stmt	queue;
 		struct quota_stmt	quota;
 		struct ct_stmt		ct;
diff --git a/src/evaluate.c b/src/evaluate.c
index 437eacb8209f..2732f5f49e06 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3448,6 +3448,11 @@ static int stmt_evaluate_chain(struct eval_ctx *ctx, struct stmt *stmt)
 	return 0;
 }
 
+static int stmt_evaluate_optstrip(struct eval_ctx *ctx, struct stmt *stmt)
+{
+	return expr_evaluate(ctx, &stmt->optstrip.expr);
+}
+
 static int stmt_evaluate_dup(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	int err;
@@ -3857,6 +3862,8 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 		return stmt_evaluate_synproxy(ctx, stmt);
 	case STMT_CHAIN:
 		return stmt_evaluate_chain(ctx, stmt);
+	case STMT_OPTSTRIP:
+		return stmt_evaluate_optstrip(ctx, stmt);
 	default:
 		BUG("unknown statement type %s\n", stmt->ops->name);
 	}
diff --git a/src/json.c b/src/json.c
index 4f800c908c66..0b7224c28736 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1578,6 +1578,12 @@ json_t *synproxy_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
 	return json_pack("{s:o}", "synproxy", root);
 }
 
+json_t *optstrip_stmt_json(const struct stmt *stmt, struct output_ctx *octx)
+{
+	return json_pack("{s:o}", "reset",
+			 expr_print_json(stmt->optstrip.expr, octx));
+}
+
 static json_t *table_print_json_full(struct netlink_ctx *ctx,
 				     struct table *table)
 {
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 6619b4121a2c..a1b00dee209a 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -696,6 +696,10 @@ static void netlink_parse_exthdr(struct netlink_parse_ctx *ctx,
 		expr_set_type(val, expr->dtype, expr->byteorder);
 
 		stmt = exthdr_stmt_alloc(loc, expr, val);
+		rule_stmt_append(ctx->rule, stmt);
+	} else {
+		struct stmt *stmt = optstrip_stmt_alloc(loc, expr);
+
 		rule_stmt_append(ctx->rule, stmt);
 	}
 }
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 34a6e1a941b5..c8bbcb7452b0 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -986,7 +986,7 @@ static void netlink_gen_exthdr_stmt(struct netlink_linearize_ctx *ctx,
 	nle = alloc_nft_expr("exthdr");
 	netlink_put_register(nle, NFTNL_EXPR_EXTHDR_SREG, sreg);
 	nftnl_expr_set_u8(nle, NFTNL_EXPR_EXTHDR_TYPE,
-			  expr->exthdr.desc->type);
+			  expr->exthdr.raw_type);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_EXTHDR_OFFSET, offset / BITS_PER_BYTE);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_EXTHDR_LEN,
 			   div_round_up(expr->len, BITS_PER_BYTE));
@@ -1353,6 +1353,18 @@ static void netlink_gen_fwd_stmt(struct netlink_linearize_ctx *ctx,
 	nft_rule_add_expr(ctx, nle, &stmt->location);
 }
 
+static void netlink_gen_optstrip_stmt(struct netlink_linearize_ctx *ctx,
+				      const struct stmt *stmt)
+{
+	struct nftnl_expr *nle = alloc_nft_expr("exthdr");
+	struct expr *expr = stmt->optstrip.expr;
+
+	nftnl_expr_set_u8(nle, NFTNL_EXPR_EXTHDR_TYPE,
+			  expr->exthdr.raw_type);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_EXTHDR_OP, expr->exthdr.op);
+	nft_rule_add_expr(ctx, nle, &expr->location);
+}
+
 static void netlink_gen_queue_stmt(struct netlink_linearize_ctx *ctx,
 				 const struct stmt *stmt)
 {
@@ -1616,6 +1628,8 @@ static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 		return netlink_gen_map_stmt(ctx, stmt);
 	case STMT_CHAIN:
 		return netlink_gen_chain_stmt(ctx, stmt);
+	case STMT_OPTSTRIP:
+		return netlink_gen_optstrip_stmt(ctx, stmt);
 	default:
 		BUG("unknown statement type %s\n", stmt->ops->name);
 	}
diff --git a/src/parser_bison.y b/src/parser_bison.y
index d67d16b8bc8c..ffbaf1813e63 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -886,6 +886,9 @@ int nft_lex(void *, void *, void *);
 %type <val>			tcpopt_field_maxseg	tcpopt_field_mptcp	tcpopt_field_sack	 tcpopt_field_tsopt	tcpopt_field_window
 %type <tcp_kind_field>		tcp_hdr_option_kind_and_field
 
+%type <stmt>			optstrip_stmt
+%destructor { stmt_free($$); }	optstrip_stmt
+
 %type <expr>			boolean_expr
 %destructor { expr_free($$); }	boolean_expr
 %type <val8>			boolean_keys
@@ -2828,6 +2831,7 @@ stmt			:	verdict_stmt
 			|	map_stmt
 			|	synproxy_stmt
 			|	chain_stmt
+			|	optstrip_stmt
 			;
 
 chain_stmt_type		:	JUMP	{ $$ = NFT_JUMP; }
@@ -5516,6 +5520,13 @@ tcp_hdr_expr		:	TCP	tcp_hdr_field
 			}
 			;
 
+optstrip_stmt		:	RESET	TCP	OPTION	tcp_hdr_option_type	close_scope_tcp
+			{
+				$$ = optstrip_stmt_alloc(&@$, tcpopt_expr_alloc(&@$,
+										$4, TCPOPT_COMMON_KIND));
+			}
+			;
+
 tcp_hdr_field		:	SPORT		{ $$ = TCPHDR_SPORT; }
 			|	DPORT		{ $$ = TCPHDR_DPORT; }
 			|	SEQUENCE	{ $$ = TCPHDR_SEQ; }
diff --git a/src/parser_json.c b/src/parser_json.c
index 4913260434f4..fb401009a499 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -2652,6 +2652,14 @@ static struct stmt *json_parse_connlimit_stmt(struct json_ctx *ctx,
 	return stmt;
 }
 
+static struct stmt *json_parse_optstrip_stmt(struct json_ctx *ctx,
+					     const char *key, json_t *value)
+{
+	struct expr *expr = json_parse_expr(ctx, value);
+
+	return expr ? optstrip_stmt_alloc(int_loc, expr) : NULL;
+}
+
 static struct stmt *json_parse_stmt(struct json_ctx *ctx, json_t *root)
 {
 	struct {
@@ -2688,6 +2696,7 @@ static struct stmt *json_parse_stmt(struct json_ctx *ctx, json_t *root)
 		{ "ct count", json_parse_connlimit_stmt },
 		{ "tproxy", json_parse_tproxy_stmt },
 		{ "synproxy", json_parse_synproxy_stmt },
+		{ "reset", json_parse_optstrip_stmt },
 	};
 	const char *type;
 	unsigned int i;
diff --git a/src/statement.c b/src/statement.c
index 03c0acf6a361..30caf9c7f6e1 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -23,6 +23,7 @@
 #include <netinet/ip_icmp.h>
 #include <netinet/icmp6.h>
 #include <statement.h>
+#include <tcpopt.h>
 #include <utils.h>
 #include <list.h>
 #include <xt.h>
@@ -909,6 +910,37 @@ struct stmt *fwd_stmt_alloc(const struct location *loc)
 	return stmt_alloc(loc, &fwd_stmt_ops);
 }
 
+static void optstrip_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
+{
+	const struct expr *expr = stmt->optstrip.expr;
+
+	nft_print(octx, "reset ");
+	expr_print(expr, octx);
+}
+
+static void optstrip_stmt_destroy(struct stmt *stmt)
+{
+	expr_free(stmt->optstrip.expr);
+}
+
+static const struct stmt_ops optstrip_stmt_ops = {
+	.type		= STMT_OPTSTRIP,
+	.name		= "optstrip",
+	.print		= optstrip_stmt_print,
+	.json		= optstrip_stmt_json,
+	.destroy	= optstrip_stmt_destroy,
+};
+
+struct stmt *optstrip_stmt_alloc(const struct location *loc, struct expr *e)
+{
+	struct stmt *stmt = stmt_alloc(loc, &optstrip_stmt_ops);
+
+	e->exthdr.flags |= NFT_EXTHDR_F_PRESENT;
+	stmt->optstrip.expr = e;
+
+	return stmt;
+}
+
 static void tproxy_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
 	nft_print(octx, "tproxy");
diff --git a/tests/py/any/tcpopt.t b/tests/py/any/tcpopt.t
index 3d4be2a274df..177f01c45506 100644
--- a/tests/py/any/tcpopt.t
+++ b/tests/py/any/tcpopt.t
@@ -54,3 +54,9 @@ tcp option mptcp exists;ok
 tcp option mptcp subtype 0;ok
 tcp option mptcp subtype 1;ok
 tcp option mptcp subtype { 0, 2};ok
+
+reset tcp option mptcp;ok
+reset tcp option 2;ok;reset tcp option maxseg
+reset tcp option 123;ok
+reset tcp option meh;fail
+reset tcp option 256;fail
diff --git a/tests/py/any/tcpopt.t.json b/tests/py/any/tcpopt.t.json
index 5cc6f8f42446..4466f14fac63 100644
--- a/tests/py/any/tcpopt.t.json
+++ b/tests/py/any/tcpopt.t.json
@@ -585,3 +585,38 @@
         }
    }
 ]
+
+# reset tcp option mptcp
+[
+    {
+        "reset": {
+            "tcp option": {
+                "name": "mptcp"
+            }
+        }
+    }
+]
+
+# reset tcp option 2
+[
+    {
+        "reset": {
+            "tcp option": {
+                "name": "maxseg"
+            }
+        }
+    }
+]
+
+# reset tcp option 123
+[
+    {
+        "reset": {
+            "tcp option": {
+                "base": 123,
+                "len": 0,
+                "offset": 0
+            }
+        }
+    }
+]
diff --git a/tests/py/any/tcpopt.t.payload b/tests/py/any/tcpopt.t.payload
index 121cc97fac09..99b8985f0f68 100644
--- a/tests/py/any/tcpopt.t.payload
+++ b/tests/py/any/tcpopt.t.payload
@@ -188,3 +188,15 @@ inet
   [ exthdr load tcpopt 1b @ 30 + 2 => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x000000f0 ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
+
+# reset tcp option mptcp
+ip test-ip4 input
+  [ exthdr reset tcpopt 30 ]
+
+# reset tcp option 2
+ip test-ip4 input
+  [ exthdr reset tcpopt 2 ]
+
+# reset tcp option 123
+ip test-ip4 input
+  [ exthdr reset tcpopt 123 ]
-- 
2.35.1

