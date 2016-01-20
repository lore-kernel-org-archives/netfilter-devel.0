From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/2] src: add fwd statement for netdev
Date: Wed, 20 Jan 2016 14:44:17 +0100
Message-ID: <1453297457-11357-2-git-send-email-pablo@netfilter.org>
References: <1453297457-11357-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58625 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933132AbcATNob (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Jan 2016 08:44:31 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 41CF82EFEC6
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Jan 2016 14:44:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 33001DA7FF
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Jan 2016 14:44:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 81E66DA809
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Jan 2016 14:44:24 +0100 (CET)
In-Reply-To: <1453297457-11357-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch add support for the forward statement, only available at the
netdev family.

 # nft add table netdev filter
 # nft add chain netdev filter ingress { type filter hook ingress device eth0 priority 0\; }
 # nft add rule netdev filter ingress fwd to dummy0

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/statement.h        | 10 ++++++++++
 src/evaluate.c             | 24 ++++++++++++++++++++++++
 src/netlink_delinearize.c  | 29 +++++++++++++++++++++++++++++
 src/netlink_linearize.c    | 18 ++++++++++++++++++
 src/parser_bison.y         | 12 +++++++++++-
 src/scanner.l              |  1 +
 src/statement.c            | 23 +++++++++++++++++++++++
 tests/py/any/fwd.t         |  7 +++++++
 tests/py/any/fwd.t.payload | 14 ++++++++++++++
 9 files changed, 137 insertions(+), 1 deletion(-)
 create mode 100644 tests/py/any/fwd.t
 create mode 100644 tests/py/any/fwd.t.payload

diff --git a/include/statement.h b/include/statement.h
index 6be3a24..102d95f 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -122,6 +122,13 @@ struct dup_stmt {
 struct stmt *dup_stmt_alloc(const struct location *loc);
 uint32_t dup_stmt_type(const char *type);
 
+struct fwd_stmt {
+	struct expr		*to;
+};
+
+struct stmt *fwd_stmt_alloc(const struct location *loc);
+uint32_t fwd_stmt_type(const char *type);
+
 struct set_stmt {
 	struct expr		*set;
 	struct expr		*key;
@@ -149,6 +156,7 @@ extern struct stmt *set_stmt_alloc(const struct location *loc);
  * @STMT_CT:		conntrack statement
  * @STMT_SET:		set statement
  * @STMT_DUP:		dup statement
+ * @STMT_FWD:		forward statement
  */
 enum stmt_types {
 	STMT_INVALID,
@@ -167,6 +175,7 @@ enum stmt_types {
 	STMT_CT,
 	STMT_SET,
 	STMT_DUP,
+	STMT_FWD,
 };
 
 /**
@@ -219,6 +228,7 @@ struct stmt {
 		struct ct_stmt		ct;
 		struct set_stmt		set;
 		struct dup_stmt		dup;
+		struct fwd_stmt		fwd;
 	};
 };
 
diff --git a/src/evaluate.c b/src/evaluate.c
index ce132e3..5e9783d 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1883,6 +1883,28 @@ static int stmt_evaluate_dup(struct eval_ctx *ctx, struct stmt *stmt)
 	return 0;
 }
 
+static int stmt_evaluate_fwd(struct eval_ctx *ctx, struct stmt *stmt)
+{
+	int err;
+
+	switch (ctx->pctx.family) {
+	case NFPROTO_NETDEV:
+		if (stmt->fwd.to == NULL)
+			return stmt_error(ctx, stmt,
+					  "missing destination interface");
+
+		err = stmt_evaluate_arg(ctx, stmt, &ifindex_type,
+					sizeof(uint32_t) * BITS_PER_BYTE,
+					&stmt->fwd.to);
+		if (err < 0)
+			return err;
+		break;
+	default:
+		return stmt_error(ctx, stmt, "unsupported family");
+	}
+	return 0;
+}
+
 static int stmt_evaluate_queue(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	if (stmt->queue.queue != NULL) {
@@ -1970,6 +1992,8 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 		return stmt_evaluate_queue(ctx, stmt);
 	case STMT_DUP:
 		return stmt_evaluate_dup(ctx, stmt);
+	case STMT_FWD:
+		return stmt_evaluate_fwd(ctx, stmt);
 	case STMT_SET:
 		return stmt_evaluate_set(ctx, stmt);
 	default:
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 3f01781..cb9c3ab 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -831,6 +831,30 @@ static void netlink_parse_dup(struct netlink_parse_ctx *ctx,
 	list_add_tail(&stmt->list, &ctx->rule->stmts);
 }
 
+static void netlink_parse_fwd(struct netlink_parse_ctx *ctx,
+			      const struct location *loc,
+			      const struct nftnl_expr *nle)
+{
+	enum nft_registers reg1;
+	struct expr *dev;
+	struct stmt *stmt;
+
+	stmt = fwd_stmt_alloc(loc);
+
+	reg1 = netlink_parse_register(nle, NFTNL_EXPR_FWD_SREG_DEV);
+	if (reg1) {
+		dev = netlink_get_register(ctx, loc, reg1);
+		if (dev == NULL)
+			return netlink_error(ctx, loc,
+					     "fwd statement has no output expression");
+
+		expr_set_type(dev, &ifindex_type, BYTEORDER_HOST_ENDIAN);
+		stmt->fwd.to = dev;
+	}
+
+	list_add_tail(&stmt->list, &ctx->rule->stmts);
+}
+
 static void netlink_parse_queue(struct netlink_parse_ctx *ctx,
 			      const struct location *loc,
 			      const struct nftnl_expr *nle)
@@ -922,6 +946,7 @@ static const struct {
 	{ .name = "dup",	.parse = netlink_parse_dup },
 	{ .name = "queue",	.parse = netlink_parse_queue },
 	{ .name = "dynset",	.parse = netlink_parse_dynset },
+	{ .name = "fwd",	.parse = netlink_parse_fwd },
 };
 
 static int netlink_parse_expr(struct nftnl_expr *nle, void *arg)
@@ -1639,6 +1664,10 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 			if (stmt->dup.dev != NULL)
 				expr_postprocess(&rctx, &stmt->dup.dev);
 			break;
+		case STMT_FWD:
+			if (stmt->fwd.to != NULL)
+				expr_postprocess(&rctx, &stmt->fwd.to);
+			break;
 		default:
 			break;
 		}
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 0dc7f97..63b3146 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -969,6 +969,22 @@ static void netlink_gen_dup_stmt(struct netlink_linearize_ctx *ctx,
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
 
+static void netlink_gen_fwd_stmt(struct netlink_linearize_ctx *ctx,
+				 const struct stmt *stmt)
+{
+	enum nft_registers sreg1;
+	struct nftnl_expr *nle;
+
+	nle = alloc_nft_expr("fwd");
+
+	sreg1 = get_register(ctx, stmt->fwd.to);
+	netlink_gen_expr(ctx, stmt->fwd.to, sreg1);
+	netlink_put_register(nle, NFTNL_EXPR_FWD_SREG_DEV, sreg1);
+	release_register(ctx, stmt->fwd.to);
+
+	nftnl_rule_add_expr(ctx->nlr, nle);
+}
+
 static void netlink_gen_queue_stmt(struct netlink_linearize_ctx *ctx,
 				 const struct stmt *stmt)
 {
@@ -1069,6 +1085,8 @@ static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 		return netlink_gen_ct_stmt(ctx, stmt);
 	case STMT_SET:
 		return netlink_gen_set_stmt(ctx, stmt);
+	case STMT_FWD:
+		return netlink_gen_fwd_stmt(ctx, stmt);
 	default:
 		BUG("unknown statement type %s\n", stmt->ops->name);
 	}
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 514dd7e..05ade0f 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -398,7 +398,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token FANOUT			"fanout"
 
 %token DUP			"dup"
-%token ON			"on"
+%token FWD			"fwd"
 
 %token POSITION			"position"
 %token COMMENT			"comment"
@@ -471,6 +471,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <val>			queue_stmt_flags queue_stmt_flag
 %type <stmt>			dup_stmt
 %destructor { stmt_free($$); }	dup_stmt
+%type <stmt>			fwd_stmt
+%destructor { stmt_free($$); }	fwd_stmt
 %type <stmt>			set_stmt
 %destructor { stmt_free($$); }	set_stmt
 %type <val>			set_stmt_op
@@ -1337,6 +1339,7 @@ stmt			:	verdict_stmt
 			|	masq_stmt
 			|	redir_stmt
 			|	dup_stmt
+			|	fwd_stmt
 			|	set_stmt
 			;
 
@@ -1687,6 +1690,13 @@ dup_stmt		:	DUP	TO	stmt_expr
 			}
 			;
 
+fwd_stmt		:	FWD	TO	expr
+			{
+				$$ = fwd_stmt_alloc(&@$);
+				$$->fwd.to = $3;
+			}
+			;
+
 nf_nat_flags		:	nf_nat_flag
 			|	nf_nat_flags	COMMA	nf_nat_flag
 			{
diff --git a/src/scanner.l b/src/scanner.l
index e5ac8aa..a0dee47 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -462,6 +462,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "label"			{ return LABEL; }
 
 "dup"			{ return DUP; }
+"fwd"			{ return FWD; }
 
 "xml"			{ return XML; }
 "json"			{ return JSON; }
diff --git a/src/statement.c b/src/statement.c
index 153e93b..ca92441 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -490,3 +490,26 @@ struct stmt *dup_stmt_alloc(const struct location *loc)
 {
 	return stmt_alloc(loc, &dup_stmt_ops);
 }
+
+static void fwd_stmt_print(const struct stmt *stmt)
+{
+	printf("fwd to ");
+	expr_print(stmt->fwd.to);
+}
+
+static void fwd_stmt_destroy(struct stmt *stmt)
+{
+	expr_free(stmt->fwd.to);
+}
+
+static const struct stmt_ops fwd_stmt_ops = {
+	.type		= STMT_FWD,
+	.name		= "fwd",
+	.print		= fwd_stmt_print,
+	.destroy	= fwd_stmt_destroy,
+};
+
+struct stmt *fwd_stmt_alloc(const struct location *loc)
+{
+	return stmt_alloc(loc, &fwd_stmt_ops);
+}
diff --git a/tests/py/any/fwd.t b/tests/py/any/fwd.t
new file mode 100644
index 0000000..fb15ace
--- /dev/null
+++ b/tests/py/any/fwd.t
@@ -0,0 +1,7 @@
+:ingress;type filter hook ingress device lo priority 0
+
+*netdev;test-netdev;ingress
+
+fwd to lo;ok
+fwd to mark map { 0x00000001 : lo, 0x00000002 : lo};ok
+
diff --git a/tests/py/any/fwd.t.payload b/tests/py/any/fwd.t.payload
new file mode 100644
index 0000000..e7ecc7c
--- /dev/null
+++ b/tests/py/any/fwd.t.payload
@@ -0,0 +1,14 @@
+# fwd to lo
+netdev test-netdev ingress 
+  [ immediate reg 1 0x00000001 ]
+  [ fwd sreg_dev 1 ]
+
+# fwd to mark map { 0x00000001 : lo, 0x00000002 : lo}
+map%d test-netdev b
+map%d test-netdev 0
+	element 00000001  : 00000001 0 [end]	element 00000002  : 00000001 0 [end]
+netdev test-netdev ingress 
+  [ meta load mark => reg 1 ]
+  [ lookup reg 1 set map%d dreg 1 ]
+  [ fwd sreg_dev 1 ]
+
-- 
2.1.4

