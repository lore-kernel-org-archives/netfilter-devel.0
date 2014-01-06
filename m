From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: [PATCH nftables] Add support for connmark target
Date: Mon,  6 Jan 2014 13:29:44 +0100
Message-ID: <1389011384-11530-1-git-send-email-kristian.evensen@gmail.com>
Cc: Kristian Evensen <kristian.evensen@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:34973 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaAFM3x (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jan 2014 07:29:53 -0500
Received: by mail-ee0-f49.google.com with SMTP id c41so7840078eek.8
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Jan 2014 04:29:52 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Kristian Evensen <kristian.evensen@gmail.com>

This patch adds support for the connmark target. The syntax is the same as for
iptables' xt_CONNMARK. In order to simplify the initial implementation, I have
not added any of the mnemonics. Also, as tables are now created by user-space, I
have not limited where the different connmark modes can be used.

Usage-examples

To set mark:
nft add rule filter output ip protocol icmp connmark set-xmark 0x1
nft add rule filter output ip protocol icmp connmark set-xmark 0x1/0x2

To restore mark:
nft add rule filter prerouting ip protocol icmp connmark restore-mark
nft add rule filter prerouting ip protocol icmp connmark restore-mark mask 0x2

To save mark:
nft add rule filter postrouting ip protocol icmp connmark save-mark
nft add rule filter postrouting ip protocol icmp connmark save-mark nfmask 0x1
nft add rule filter postrouting ip protocol icmp connmark save-mark ctmask 0x2
nft add rule filter postrouting ip protocol icmp connmark save-mark nfmask 0x1 ctmask 0x2

Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
---
 include/linux/netfilter/nf_tables.h | 35 +++++++++++++++++++
 include/statement.h                 | 14 ++++++++
 src/evaluate.c                      |  2 ++
 src/netlink_delinearize.c           | 26 ++++++++++++++
 src/netlink_linearize.c             | 29 +++++++++++++++-
 src/parser.y                        | 69 +++++++++++++++++++++++++++++++++++++
 src/scanner.l                       |  8 +++++
 src/statement.c                     | 38 ++++++++++++++++++++
 8 files changed, 220 insertions(+), 1 deletion(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 1d5a925..a3fb603 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -607,6 +607,41 @@ enum nft_queue_attributes {
 #define NFT_QUEUE_FLAG_MASK		0x03
 
 /**
+ * enum nft_connmark_types - nf_tables connmark expression types
+ *
+ * @NFT_CONNMARK_SAVE: save connmark
+ * @NFT_CONNMARK_RESTORE: restore connmark
+ * @NFT_CONNMARK_SET: set connmark (iptables set-xmark)
+ */
+enum nft_connmark_types {
+	NFT_CONNMARK_SAVE,
+	NFT_CONNMARK_RESTORE,
+	NFT_CONNMARK_SET
+};
+
+/**
+ * enum nft_connmark_attributes - nf_tables connmark expression netlink
+ * attributes
+ *
+ * @NFTA_CONNMARK_MODE: conntrack action (save, set or restore) (NLA_U8)
+ * @NFTA_CONNMARK_CTMARK: conntrack ctmark (NLA_U32)
+ * @NFTA_CONNMARK_CTMASK: conntrack ctmask (NLA_U32)
+ * @NFTA_CONNMARK_NFMASK: conntrack nfmask (NLA_U32)
+ */
+
+enum nft_connmark_attributes {
+	NFTA_CONNMARK_UNSPEC,
+	NFTA_CONNMARK_MODE,
+	NFTA_CONNMARK_CTMARK,
+	NFTA_CONNMARK_CTMASK,
+	NFTA_CONNMARK_NFMASK,
+	__NFTA_CONNMARK_MAX,
+};
+#define NFTA_CONNMARK_MAX		(__NFTA_CONNMARK_MAX - 1)
+
+#define NFT_CONNMARK_DEFAULT_MASK	0xFFFFFFFF
+
+/**
  * enum nft_reject_types - nf_tables reject expression reject types
  *
  * @NFT_REJECT_ICMP_UNREACH: reject using ICMP unreachable
diff --git a/include/statement.h b/include/statement.h
index 14a66df..823e1eb 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -67,6 +67,17 @@ struct queue_stmt {
 
 extern struct stmt *queue_stmt_alloc(const struct location *loc);
 
+struct connmark_stmt {
+	uint32_t                ctmask;
+	union{
+		uint32_t                ctmark;
+		uint32_t                nfmask;
+	};
+	uint8_t			mode;
+};
+
+extern struct stmt *connmark_stmt_alloc(const struct location *loc);
+
 /**
  * enum stmt_types - statement types
  *
@@ -80,6 +91,7 @@ extern struct stmt *queue_stmt_alloc(const struct location *loc);
  * @STMT_REJECT:	REJECT statement
  * @STMT_NAT:		NAT statement
  * @STMT_QUEUE:		QUEUE statement
+ * @STMT_CONNMARK:  CONNMARK statement
  */
 enum stmt_types {
 	STMT_INVALID,
@@ -92,6 +104,7 @@ enum stmt_types {
 	STMT_REJECT,
 	STMT_NAT,
 	STMT_QUEUE,
+	STMT_CONNMARK,
 };
 
 /**
@@ -138,6 +151,7 @@ struct stmt {
 		struct reject_stmt	reject;
 		struct nat_stmt		nat;
 		struct queue_stmt	queue;
+		struct connmark_stmt	connmark;
 	};
 };
 
diff --git a/src/evaluate.c b/src/evaluate.c
index d4f8339..9f47c12 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1176,6 +1176,8 @@ static int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 		return stmt_evaluate_nat(ctx, stmt);
 	case STMT_QUEUE:
 		return 0;
+	case STMT_CONNMARK:
+		return 0;
 	default:
 		BUG("unknown statement type %s\n", stmt->ops->name);
 	}
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index b771da5..ec6328e 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -522,6 +522,31 @@ static void netlink_parse_queue(struct netlink_parse_ctx *ctx,
 	list_add_tail(&stmt->list, &ctx->rule->stmts);
 }
 
+static void netlink_parse_connmark(struct netlink_parse_ctx *ctx,
+			      const struct location *loc,
+			      const struct nft_rule_expr *nle)
+{
+	struct stmt *stmt;
+
+	stmt = connmark_stmt_alloc(loc);
+	stmt->connmark.mode = nft_rule_expr_get_u8(nle, NFT_EXPR_CONNMARK_MODE);
+	stmt->connmark.ctmask = nft_rule_expr_get_u32(nle,
+						      NFT_EXPR_CONNMARK_CTMASK);
+
+	switch (stmt->connmark.mode) {
+	case NFT_CONNMARK_SAVE:
+	case NFT_CONNMARK_RESTORE:
+		stmt->connmark.nfmask =
+			nft_rule_expr_get_u32(nle, NFT_EXPR_CONNMARK_NFMASK);
+		break;
+	case NFT_CONNMARK_SET:
+		stmt->connmark.ctmark =
+			nft_rule_expr_get_u32(nle, NFT_EXPR_CONNMARK_CTMARK);
+		break;
+	}
+
+	list_add_tail(&stmt->list, &ctx->rule->stmts);
+}
 static const struct {
 	const char	*name;
 	void		(*parse)(struct netlink_parse_ctx *ctx,
@@ -543,6 +568,7 @@ static const struct {
 	{ .name = "reject",	.parse = netlink_parse_reject },
 	{ .name = "nat",	.parse = netlink_parse_nat },
 	{ .name = "queue",	.parse = netlink_parse_queue },
+	{ .name = "connmark",	.parse = netlink_parse_connmark },
 };
 
 static const struct input_descriptor indesc_netlink = {
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 9ae9bb7..401a268 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -637,7 +637,7 @@ static void netlink_gen_nat_stmt(struct netlink_linearize_ctx *ctx,
 }
 
 static void netlink_gen_queue_stmt(struct netlink_linearize_ctx *ctx,
-				 const struct stmt *stmt)
+				   const struct stmt *stmt)
 {
 	struct nft_rule_expr *nle;
 
@@ -656,6 +656,31 @@ static void netlink_gen_queue_stmt(struct netlink_linearize_ctx *ctx,
 	nft_rule_add_expr(ctx->nlr, nle);
 }
 
+static void netlink_gen_connmark_stmt(struct netlink_linearize_ctx *ctx,
+				      const struct stmt *stmt){
+	struct nft_rule_expr *nle;
+
+	nle = alloc_nft_expr("connmark");
+	nft_rule_expr_set_u8(nle, NFT_EXPR_CONNMARK_MODE, stmt->connmark.mode);
+	nft_rule_expr_set_u32(nle, NFT_EXPR_CONNMARK_CTMASK,
+			      stmt->connmark.ctmask);
+
+	/* The conntrack modes makes use of different information */
+	switch (stmt->connmark.mode) {
+	case NFT_CONNMARK_SAVE:
+	case NFT_CONNMARK_RESTORE:
+		nft_rule_expr_set_u32(nle, NFT_EXPR_CONNMARK_NFMASK,
+				      stmt->connmark.nfmask);
+		break;
+	case NFT_CONNMARK_SET:
+		nft_rule_expr_set_u32(nle, NFT_EXPR_CONNMARK_CTMARK,
+				      stmt->connmark.ctmark);
+		break;
+	}
+
+	nft_rule_add_expr(ctx->nlr, nle);
+}
+
 static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 			     const struct stmt *stmt)
 {
@@ -678,6 +703,8 @@ static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 		return netlink_gen_nat_stmt(ctx, stmt);
 	case STMT_QUEUE:
 		return netlink_gen_queue_stmt(ctx, stmt);
+	case STMT_CONNMARK:
+		return netlink_gen_connmark_stmt(ctx, stmt);
 	default:
 		BUG("unknown statement type %s\n", stmt->ops->name);
 	}
diff --git a/src/parser.y b/src/parser.y
index 9320f2d..224a098 100644
--- a/src/parser.y
+++ b/src/parser.y
@@ -336,6 +336,14 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token QUEUECPUFANOUT		"fanout"
 %token OPTIONS			"options"
 
+%token CONNMARK         "connmark"
+%token CONNMARKSAVE     "save-mark"
+%token CONNMARKRESTORE  "restore-mark"
+%token CONNMARKSET      "set-xmark"
+%token CONNMARKCTMASK   "ctmask"
+%token CONNMARKNFMASK   "nfmask"
+%token CONNMARKMASK     "mask"
+
 %token POSITION			"position"
 
 %type <string>			identifier string
@@ -386,6 +394,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <stmt>			queue_stmt queue_stmt_alloc
 %destructor { stmt_free($$); }	queue_stmt queue_stmt_alloc
 %type <val>			queue_flags queue_flag
+%type <stmt>			connmark_stmt connmark_stmt_alloc
+%destructor { stmt_free($$); }	connmark_stmt connmark_stmt_alloc
 
 %type <expr>			symbol_expr verdict_expr integer_expr
 %destructor { expr_free($$); }	symbol_expr verdict_expr integer_expr
@@ -937,6 +947,7 @@ stmt			:	verdict_stmt
 			|	reject_stmt
 			|	nat_stmt
 			|	queue_stmt
+			|	connmark_stmt
 			;
 
 verdict_stmt		:	verdict_expr
@@ -1112,6 +1123,64 @@ queue_flag		:	QUEUEBYPASS
 			}
 			;
 
+connmark_stmt		:	connmark_stmt_alloc	connmark_arg
+			;
+connmark_stmt_alloc	:	CONNMARK
+			{
+				$$ = connmark_stmt_alloc(&@$);
+				$$->connmark.ctmask = NFT_CONNMARK_DEFAULT_MASK;
+				$$->connmark.nfmask = NFT_CONNMARK_DEFAULT_MASK;
+			}
+			;
+connmark_arg		:	CONNMARKSET	NUM
+			{
+				$<stmt>0->connmark.mode		= NFT_CONNMARK_SET;
+				$<stmt>0->connmark.ctmark	= $2;
+			}
+			|	CONNMARKSET	NUM	SLASH	NUM
+			{
+				$<stmt>0->connmark.mode		= NFT_CONNMARK_SET;
+				$<stmt>0->connmark.ctmark	= $2;
+				$<stmt>0->connmark.ctmask	= $4;
+			}
+			|	CONNMARKSAVE
+			{
+				$<stmt>0->connmark.mode		= NFT_CONNMARK_SAVE;
+			}
+			|	CONNMARKSAVE	CONNMARKNFMASK	NUM
+			{
+				$<stmt>0->connmark.mode		= NFT_CONNMARK_SAVE;
+				$<stmt>0->connmark.nfmask	= $3;
+			}
+			|	CONNMARKSAVE	CONNMARKCTMASK	NUM
+			{
+				$<stmt>0->connmark.mode		= NFT_CONNMARK_SAVE;
+				$<stmt>0->connmark.ctmask	= $3;
+			}
+			|	CONNMARKSAVE	CONNMARKCTMASK	NUM	CONNMARKNFMASK	NUM
+			{
+				$<stmt>0->connmark.mode		= NFT_CONNMARK_SAVE;
+				$<stmt>0->connmark.ctmask	= $3;
+				$<stmt>0->connmark.nfmask	= $5;
+			}
+			|	CONNMARKSAVE    CONNMARKNFMASK	NUM	CONNMARKCTMASK	NUM
+			{
+				$<stmt>0->connmark.mode		= NFT_CONNMARK_SAVE;
+				$<stmt>0->connmark.nfmask	= $3;
+				$<stmt>0->connmark.ctmask	= $5;
+			}
+			|	CONNMARKRESTORE
+			{
+				$<stmt>0->connmark.mode		= NFT_CONNMARK_RESTORE;
+			}
+			|	CONNMARKRESTORE     CONNMARKMASK   NUM
+			{
+				$<stmt>0->connmark.mode		= NFT_CONNMARK_RESTORE;
+				$<stmt>0->connmark.ctmask	= $3;
+				$<stmt>0->connmark.nfmask	= $3;
+			}
+			;
+
 match_stmt		:	relational_expr
 			{
 				$$ = expr_stmt_alloc(&@$, $1);
diff --git a/src/scanner.l b/src/scanner.l
index 8c4f25d..c836d09 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -261,6 +261,14 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "fanout"		{ return QUEUECPUFANOUT;}
 "options"		{ return OPTIONS;}
 
+"connmark"		{ return CONNMARK;}
+"save-mark"		{ return CONNMARKSAVE;}
+"restore-mark"		{ return CONNMARKRESTORE;}
+"set-xmark"		{ return CONNMARKSET;}
+"mask"			{ return CONNMARKMASK;}
+"ctmask"		{ return CONNMARKCTMASK;}
+"nfmask"		{ return CONNMARKNFMASK;}
+
 "limit"			{ return LIMIT; }
 "rate"			{ return RATE; }
 
diff --git a/src/statement.c b/src/statement.c
index 3fdd9e2..737e66a 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -203,6 +203,44 @@ struct stmt *queue_stmt_alloc(const struct location *loc)
 	return stmt_alloc(loc, &queue_stmt_ops);
 }
 
+static void connmark_stmt_print(const struct stmt *stmt)
+{
+	printf("connmark");
+
+	switch (stmt->connmark.mode) {
+	case NFT_CONNMARK_SAVE:
+		printf(" save-mark");
+		if (stmt->connmark.nfmask != NFT_CONNMARK_DEFAULT_MASK)
+			printf(" nfmask 0x%x", stmt->connmark.nfmask);
+		if (stmt->connmark.ctmask != NFT_CONNMARK_DEFAULT_MASK)
+			printf(" ctmask 0x%x", stmt->connmark.ctmask);
+		break;
+	case NFT_CONNMARK_RESTORE:
+		printf(" restore-mark");
+		/* both nfmask and ctmask is set to the value of restore-mark
+		 * mask  */
+		if (stmt->connmark.nfmask != NFT_CONNMARK_DEFAULT_MASK)
+			printf(" mask 0x%x", stmt->connmark.nfmask);
+		break;
+	case NFT_CONNMARK_SET:
+		printf(" set-xmark 0x%x", stmt->connmark.ctmark);
+		if (stmt->connmark.ctmask != NFT_CONNMARK_DEFAULT_MASK)
+			printf("/0x%x", stmt->connmark.ctmask);
+		break;
+	}
+}
+
+static const struct stmt_ops connmark_stmt_ops = {
+	.type       = STMT_CONNMARK,
+	.name       = "connmark",
+	.print      = connmark_stmt_print,
+};
+
+struct stmt *connmark_stmt_alloc(const struct location *loc)
+{
+	return stmt_alloc(loc, &connmark_stmt_ops);
+}
+
 static void reject_stmt_print(const struct stmt *stmt)
 {
 	printf("reject");
-- 
1.8.3.2

