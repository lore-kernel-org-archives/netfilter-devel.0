From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 08/10] src: add stateful object reference expression
Date: Fri, 23 Dec 2016 15:26:53 +0100
Message-ID: <1482503215-25422-8-git-send-email-pablo@netfilter.org>
References: <1482503215-25422-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40182 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941195AbcLWO1R (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Dec 2016 09:27:17 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 454302519A1
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Dec 2016 15:27:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 34A2F8E66A
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Dec 2016 15:27:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CB0218E66A
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Dec 2016 15:27:12 +0100 (CET)
In-Reply-To: <1482503215-25422-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a new objref statement to refer to existing stateful
objects from rules, eg.

 # nft add rule filter input counter name test counter

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/statement.h       | 10 ++++++++++
 src/evaluate.c            | 16 ++++++++++++++++
 src/netlink_delinearize.c | 33 +++++++++++++++++++++++++++++++++
 src/netlink_linearize.c   | 16 ++++++++++++++++
 src/parser_bison.y        | 13 +++++++++++++
 src/scanner.l             |  1 +
 src/statement.c           | 33 +++++++++++++++++++++++++++++++++
 7 files changed, 122 insertions(+)

diff --git a/include/statement.h b/include/statement.h
index 9d0f601f98a2..8f874c881bd9 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -10,6 +10,13 @@ extern struct stmt *expr_stmt_alloc(const struct location *loc,
 extern struct stmt *verdict_stmt_alloc(const struct location *loc,
 				       struct expr *expr);
 
+struct objref_stmt {
+	uint32_t		type;
+	struct expr		*expr;
+};
+
+struct stmt *objref_stmt_alloc(const struct location *loc);
+
 struct counter_stmt {
 	uint64_t		packets;
 	uint64_t		bytes;
@@ -212,6 +219,7 @@ extern struct stmt *xt_stmt_alloc(const struct location *loc);
  * @STMT_XT:		XT statement
  * @STMT_QUOTA:		quota statement
  * @STMT_NOTRACK:	notrack statement
+ * @STMT_OBJREF:	stateful object reference statement
  */
 enum stmt_types {
 	STMT_INVALID,
@@ -235,6 +243,7 @@ enum stmt_types {
 	STMT_XT,
 	STMT_QUOTA,
 	STMT_NOTRACK,
+	STMT_OBJREF,
 };
 
 /**
@@ -292,6 +301,7 @@ struct stmt {
 		struct dup_stmt		dup;
 		struct fwd_stmt		fwd;
 		struct xt_stmt		xt;
+		struct objref_stmt	objref;
 	};
 };
 
diff --git a/src/evaluate.c b/src/evaluate.c
index cedf259fcba9..b868f1bc283a 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2464,6 +2464,20 @@ static int stmt_evaluate_set(struct eval_ctx *ctx, struct stmt *stmt)
 	return 0;
 }
 
+static int stmt_evaluate_objref(struct eval_ctx *ctx, struct stmt *stmt)
+{
+	if (stmt_evaluate_arg(ctx, stmt,
+			      &string_type, NFT_OBJ_MAXNAMELEN * BITS_PER_BYTE,
+			      &stmt->objref.expr) < 0)
+		return -1;
+
+	if (!expr_is_constant(stmt->objref.expr))
+		return expr_error(ctx->msgs, stmt->objref.expr,
+				  "Counter expression must be constant");
+
+	return 0;
+}
+
 int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 {
 #ifdef DEBUG
@@ -2511,6 +2525,8 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 		return stmt_evaluate_fwd(ctx, stmt);
 	case STMT_SET:
 		return stmt_evaluate_set(ctx, stmt);
+	case STMT_OBJREF:
+		return stmt_evaluate_objref(ctx, stmt);
 	default:
 		BUG("unknown statement type %s\n", stmt->ops->name);
 	}
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 9a16926e3817..90fb9e670751 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1125,6 +1125,35 @@ static void netlink_parse_dynset(struct netlink_parse_ctx *ctx,
 	ctx->stmt = stmt;
 }
 
+static void netlink_parse_objref(struct netlink_parse_ctx *ctx,
+				 const struct location *loc,
+				 const struct nftnl_expr *nle)
+{
+	uint32_t type = nftnl_expr_get_u32(nle, NFTNL_EXPR_OBJREF_IMM_TYPE);
+	struct expr *expr;
+	struct stmt *stmt;
+
+	if (nftnl_expr_is_set(nle, NFTNL_EXPR_OBJREF_IMM_NAME)) {
+		struct nft_data_delinearize nld;
+
+		type = nftnl_expr_get_u32(nle, NFTNL_EXPR_OBJREF_IMM_TYPE);
+		nld.value = nftnl_expr_get(nle, NFTNL_EXPR_OBJREF_IMM_NAME,
+					   &nld.len);
+		expr = netlink_alloc_value(&netlink_location, &nld);
+		expr->dtype = &string_type;
+		expr->byteorder = BYTEORDER_HOST_ENDIAN;
+	} else {
+		netlink_error(ctx, loc, "unknown objref expression type %u",
+			      type);
+		return;
+	}
+
+	stmt = objref_stmt_alloc(loc);
+	stmt->objref.type = type;
+	stmt->objref.expr = expr;
+	ctx->stmt = stmt;
+}
+
 static const struct {
 	const char	*name;
 	void		(*parse)(struct netlink_parse_ctx *ctx,
@@ -1156,6 +1185,7 @@ static const struct {
 	{ .name = "fwd",	.parse = netlink_parse_fwd },
 	{ .name = "target",	.parse = netlink_parse_target },
 	{ .name = "match",	.parse = netlink_parse_match },
+	{ .name = "objref",	.parse = netlink_parse_objref },
 	{ .name = "quota",	.parse = netlink_parse_quota },
 	{ .name = "numgen",	.parse = netlink_parse_numgen },
 	{ .name = "hash",	.parse = netlink_parse_hash },
@@ -2164,6 +2194,9 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 		case STMT_XT:
 			stmt_xt_postprocess(&rctx, stmt, rule);
 			break;
+		case STMT_OBJREF:
+			expr_postprocess(&rctx, &stmt->objref.expr);
+			break;
 		default:
 			break;
 		}
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 144068d23378..c9488b3212bc 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -689,6 +689,20 @@ static void netlink_gen_expr(struct netlink_linearize_ctx *ctx,
 	}
 }
 
+static void netlink_gen_objref_stmt(struct netlink_linearize_ctx *ctx,
+				    const struct stmt *stmt)
+{
+	struct nft_data_linearize nld;
+	struct nftnl_expr *nle;
+
+	nle = alloc_nft_expr("objref");
+	netlink_gen_data(stmt->objref.expr, &nld);
+	nftnl_expr_set(nle, NFTNL_EXPR_OBJREF_IMM_NAME, nld.value, nld.len);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_OBJREF_IMM_TYPE, stmt->objref.type);
+
+	nftnl_rule_add_expr(ctx->nlr, nle);
+}
+
 static struct nftnl_expr *
 netlink_gen_counter_stmt(struct netlink_linearize_ctx *ctx,
 			 const struct stmt *stmt)
@@ -1225,6 +1239,8 @@ static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 		break;
 	case STMT_NOTRACK:
 		return netlink_gen_notrack_stmt(ctx, stmt);
+	case STMT_OBJREF:
+		return netlink_gen_objref_stmt(ctx, stmt);
 	default:
 		BUG("unknown statement type %s\n", stmt->ops->name);
 	}
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 5b829a243128..795b0ee210a3 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -365,6 +365,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token LABEL			"label"
 
 %token COUNTER			"counter"
+%token NAME			"name"
 %token PACKETS			"packets"
 %token BYTES			"bytes"
 
@@ -1623,6 +1624,12 @@ counter_stmt_alloc	:	COUNTER
 			{
 				$$ = counter_stmt_alloc(&@$);
 			}
+			|	COUNTER		NAME	stmt_expr
+			{
+				$$ = objref_stmt_alloc(&@$);
+				$$->objref.type = NFT_OBJECT_COUNTER;
+				$$->objref.expr = $3;
+			}
 			;
 
 counter_args		:	counter_arg
@@ -1823,6 +1830,12 @@ quota_stmt		:	QUOTA	quota_mode NUM quota_unit quota_used
 				$$->quota.used = $5;
 				$$->quota.flags	= $2;
 			}
+			|	QUOTA	NAME	stmt_expr
+			{
+				$$ = objref_stmt_alloc(&@$);
+				$$->objref.type = NFT_OBJECT_QUOTA;
+				$$->objref.expr = $3;
+			}
 			;
 
 limit_mode		:	OVER				{ $$ = NFT_LIMIT_F_INV; }
diff --git a/src/scanner.l b/src/scanner.l
index 1aa2e96b9f64..69406bd0164e 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -291,6 +291,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "flow"			{ return FLOW; }
 
 "counter"		{ return COUNTER; }
+"name"			{ return NAME; }
 "packets"		{ return PACKETS; }
 "bytes"			{ return BYTES; }
 
diff --git a/src/statement.c b/src/statement.c
index fbd78aafe69a..24a53ee1b0fc 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -161,6 +161,39 @@ struct stmt *counter_stmt_alloc(const struct location *loc)
 	return stmt;
 }
 
+static const char *objref_type[NFT_OBJECT_MAX + 1] = {
+	[NFT_OBJECT_COUNTER]	= "counter",
+	[NFT_OBJECT_QUOTA]	= "quota",
+};
+
+static const char *objref_type_name(uint32_t type)
+{
+	if (type > NFT_OBJECT_MAX)
+		return "unknown";
+
+	return objref_type[type];
+}
+
+static void objref_stmt_print(const struct stmt *stmt)
+{
+	printf("%s name ", objref_type_name(stmt->objref.type));
+	expr_print(stmt->objref.expr);
+}
+
+static const struct stmt_ops objref_stmt_ops = {
+	.type		= STMT_OBJREF,
+	.name		= "objref",
+	.print		= objref_stmt_print,
+};
+
+struct stmt *objref_stmt_alloc(const struct location *loc)
+{
+	struct stmt *stmt;
+
+	stmt = stmt_alloc(loc, &objref_stmt_ops);
+	return stmt;
+}
+
 static const char *syslog_level[LOG_DEBUG + 1] = {
 	[LOG_EMERG]	= "emerg",
 	[LOG_ALERT]	= "alert",
-- 
2.1.4

