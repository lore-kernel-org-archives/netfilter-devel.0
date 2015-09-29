From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/2] src: add dup statement support
Date: Tue, 29 Sep 2015 20:27:47 +0200
Message-ID: <1443551268-3317-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37669 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965111AbbI2SU7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Sep 2015 14:20:59 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This allows you to clone packets to destination address, eg.

... dup to 172.20.0.2
... dup to 172.20.0.2 device eth1
... dup to ip saddr map { 192.168.0.2 : 172.20.0.2, ... } device eth1

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_tables.h | 14 ++++++++++
 include/meta.h                      |  2 ++
 include/statement.h                 | 10 +++++++
 src/evaluate.c                      | 33 +++++++++++++++++++++--
 src/meta.c                          |  2 +-
 src/netlink_delinearize.c           | 53 +++++++++++++++++++++++++++++++++++++
 src/netlink_linearize.c             | 37 ++++++++++++++++++++++++++
 src/parser_bison.y                  | 19 +++++++++++++
 src/scanner.l                       |  2 ++
 src/statement.c                     | 32 ++++++++++++++++++++++
 10 files changed, 201 insertions(+), 3 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index db0457d..5ebe3d8 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -936,6 +936,20 @@ enum nft_redir_attributes {
 #define NFTA_REDIR_MAX		(__NFTA_REDIR_MAX - 1)
 
 /**
+ * enum nft_tee_attributes - nf_tables tee expression netlink attributes
+ *
+ * @NFTA_DUP_SREG_ADDR: source register of destination (NLA_U32: nft_registers)
+ * @NFTA_DUP_SREG_DEV: output interface name (NLA_U32: nft_register)
+ */
+enum nft_tee_attributes {
+	NFTA_DUP_UNSPEC,
+	NFTA_DUP_SREG_ADDR,
+	NFTA_DUP_SREG_DEV,
+	__NFTA_DUP_MAX
+};
+#define NFTA_DUP_MAX		(__NFTA_DUP_MAX - 1)
+
+/**
  * enum nft_gen_attributes - nf_tables ruleset generation attributes
  *
  * @NFTA_GEN_ID: Ruleset generation ID (NLA_U32)
diff --git a/include/meta.h b/include/meta.h
index 459221f..abe74ec 100644
--- a/include/meta.h
+++ b/include/meta.h
@@ -26,4 +26,6 @@ struct meta_template {
 extern struct expr *meta_expr_alloc(const struct location *loc,
 				    enum nft_meta_keys key);
 
+const struct datatype ifindex_type;
+
 #endif /* NFTABLES_META_H */
diff --git a/include/statement.h b/include/statement.h
index bead0a6..8b035d3 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -105,6 +105,13 @@ struct ct_stmt {
 extern struct stmt *ct_stmt_alloc(const struct location *loc,
 				  enum nft_ct_keys key,
 				  struct expr *expr);
+struct dup_stmt {
+	struct expr		*to;
+	struct expr		*dev;
+};
+
+struct stmt *dup_stmt_alloc(const struct location *loc);
+uint32_t dup_stmt_type(const char *type);
 
 struct set_stmt {
 	struct expr		*set;
@@ -131,6 +138,7 @@ extern struct stmt *set_stmt_alloc(const struct location *loc);
  * @STMT_QUEUE:		QUEUE statement
  * @STMT_CT:		conntrack statement
  * @STMT_SET:		set statement
+ * @STMT_DUP:		dup statement
  */
 enum stmt_types {
 	STMT_INVALID,
@@ -147,6 +155,7 @@ enum stmt_types {
 	STMT_QUEUE,
 	STMT_CT,
 	STMT_SET,
+	STMT_DUP,
 };
 
 /**
@@ -197,6 +206,7 @@ struct stmt {
 		struct queue_stmt	queue;
 		struct ct_stmt		ct;
 		struct set_stmt		set;
+		struct dup_stmt		dup;
 	};
 };
 
diff --git a/src/evaluate.c b/src/evaluate.c
index 581f364..e8eafc6 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -20,6 +20,7 @@
 #include <netinet/ip_icmp.h>
 #include <netinet/icmp6.h>
 #include <net/ethernet.h>
+#include <net/if.h>
 
 #include <expression.h>
 #include <statement.h>
@@ -1617,7 +1618,7 @@ static int nat_evaluate_family(struct eval_ctx *ctx, struct stmt *stmt)
 	}
 }
 
-static int nat_evaluate_addr(struct eval_ctx *ctx, struct stmt *stmt,
+static int evaluate_addr(struct eval_ctx *ctx, struct stmt *stmt,
 			     struct expr **expr)
 {
 	struct proto_ctx *pctx = &ctx->pctx;
@@ -1659,7 +1660,7 @@ static int stmt_evaluate_nat(struct eval_ctx *ctx, struct stmt *stmt)
 		return err;
 
 	if (stmt->nat.addr != NULL) {
-		err = nat_evaluate_addr(ctx, stmt, &stmt->nat.addr);
+		err = evaluate_addr(ctx, stmt, &stmt->nat.addr);
 		if (err < 0)
 			return err;
 	}
@@ -1703,6 +1704,32 @@ static int stmt_evaluate_redir(struct eval_ctx *ctx, struct stmt *stmt)
 	return 0;
 }
 
+static int stmt_evaluate_dup(struct eval_ctx *ctx, struct stmt *stmt)
+{
+	int err;
+
+	switch (ctx->pctx.family) {
+	case NFPROTO_IPV4:
+	case NFPROTO_IPV6:
+		if (stmt->dup.to == NULL)
+			return stmt_error(ctx, stmt,
+					  "missing destination address");
+		err = evaluate_addr(ctx, stmt, &stmt->dup.to);
+		if (err < 0)
+			return err;
+
+		if (stmt->dup.dev != NULL) {
+			err = stmt_evaluate_arg(ctx, stmt, &ifindex_type,
+						sizeof(uint32_t) * BITS_PER_BYTE,
+						&stmt->dup.dev);
+			if (err < 0)
+				return err;
+		}
+		break;
+	}
+	return 0;
+}
+
 static int stmt_evaluate_queue(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	if (stmt->queue.queue != NULL) {
@@ -1786,6 +1813,8 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 		return stmt_evaluate_redir(ctx, stmt);
 	case STMT_QUEUE:
 		return stmt_evaluate_queue(ctx, stmt);
+	case STMT_DUP:
+		return stmt_evaluate_dup(ctx, stmt);
 	case STMT_SET:
 		return stmt_evaluate_set(ctx, stmt);
 	default:
diff --git a/src/meta.c b/src/meta.c
index bfc1258..6f79c40 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -160,7 +160,7 @@ static struct error_record *ifindex_type_parse(const struct expr *sym,
 	return NULL;
 }
 
-static const struct datatype ifindex_type = {
+const struct datatype ifindex_type = {
 	.type		= TYPE_IFINDEX,
 	.name		= "iface_index",
 	.desc		= "network interface index",
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 2360681..09f5932 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -749,6 +749,52 @@ static void netlink_parse_redir(struct netlink_parse_ctx *ctx,
 	list_add_tail(&stmt->list, &ctx->rule->stmts);
 }
 
+static void netlink_parse_dup(struct netlink_parse_ctx *ctx,
+			      const struct location *loc,
+			      const struct nftnl_expr *nle)
+{
+	enum nft_registers reg1, reg2;
+	struct expr *addr, *dev;
+	struct stmt *stmt;
+
+	stmt = dup_stmt_alloc(loc);
+
+	reg1 = netlink_parse_register(nle, NFTNL_EXPR_DUP_SREG_ADDR);
+	if (reg1) {
+		addr = netlink_get_register(ctx, loc, reg1);
+		if (addr == NULL)
+			return netlink_error(ctx, loc,
+					     "DUP statement has no destination expression");
+
+		switch (ctx->table->handle.family) {
+		case NFPROTO_IPV4:
+			expr_set_type(addr, &ipaddr_type, BYTEORDER_BIG_ENDIAN);
+			break;
+		case NFPROTO_IPV6:
+			expr_set_type(addr, &ip6addr_type,
+				      BYTEORDER_BIG_ENDIAN);
+			break;
+		}
+		stmt->dup.to = addr;
+	}
+
+	reg2 = netlink_parse_register(nle, NFTNL_EXPR_DUP_SREG_DEV);
+	if (reg2) {
+		dev = netlink_get_register(ctx, loc, reg2);
+		if (dev == NULL)
+			return netlink_error(ctx, loc,
+					     "DUP statement has no output expression");
+
+		expr_set_type(dev, &ifindex_type, BYTEORDER_HOST_ENDIAN);
+		if (stmt->dup.to == NULL)
+			stmt->dup.to = dev;
+		else
+			stmt->dup.dev = dev;
+	}
+
+	list_add_tail(&stmt->list, &ctx->rule->stmts);
+}
+
 static void netlink_parse_queue(struct netlink_parse_ctx *ctx,
 			      const struct location *loc,
 			      const struct nftnl_expr *nle)
@@ -837,6 +883,7 @@ static const struct {
 	{ .name = "nat",	.parse = netlink_parse_nat },
 	{ .name = "masq",	.parse = netlink_parse_masq },
 	{ .name = "redir",	.parse = netlink_parse_redir },
+	{ .name = "dup",	.parse = netlink_parse_dup },
 	{ .name = "queue",	.parse = netlink_parse_queue },
 	{ .name = "dynset",	.parse = netlink_parse_dynset },
 };
@@ -1460,6 +1507,12 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 		case STMT_SET:
 			expr_postprocess(&rctx, &stmt->set.key);
 			break;
+		case STMT_DUP:
+			if (stmt->dup.to != NULL)
+				expr_postprocess(&rctx, &stmt->dup.to);
+			if (stmt->dup.dev != NULL)
+				expr_postprocess(&rctx, &stmt->dup.dev);
+			break;
 		default:
 			break;
 		}
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index f697ea5..aa44eea 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -18,6 +18,10 @@
 #include <netlink.h>
 #include <gmputil.h>
 #include <utils.h>
+#include <netinet/in.h>
+
+#include <linux/netfilter.h>
+
 
 struct netlink_linearize_ctx {
 	struct nftnl_rule	*nlr;
@@ -859,6 +863,37 @@ static void netlink_gen_redir_stmt(struct netlink_linearize_ctx *ctx,
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
 
+static void netlink_gen_dup_stmt(struct netlink_linearize_ctx *ctx,
+				 const struct stmt *stmt)
+{
+	struct nftnl_expr *nle;
+	enum nft_registers sreg1, sreg2;
+
+	nle = alloc_nft_expr("dup");
+
+	if (stmt->dup.to != NULL) {
+		if (stmt->dup.to->dtype == &ifindex_type) {
+			sreg1 = get_register(ctx, stmt->dup.to);
+			netlink_gen_expr(ctx, stmt->dup.to, sreg1);
+			netlink_put_register(nle, NFTNL_EXPR_DUP_SREG_DEV, sreg1);
+		} else {
+			sreg1 = get_register(ctx, stmt->dup.to);
+			netlink_gen_expr(ctx, stmt->dup.to, sreg1);
+			netlink_put_register(nle, NFTNL_EXPR_DUP_SREG_ADDR, sreg1);
+		}
+	}
+	if (stmt->dup.dev != NULL) {
+		sreg2 = get_register(ctx, stmt->dup.dev);
+		netlink_gen_expr(ctx, stmt->dup.dev, sreg2);
+		netlink_put_register(nle, NFTNL_EXPR_DUP_SREG_DEV, sreg2);
+		release_register(ctx, stmt->dup.dev);
+	}
+	if (stmt->dup.to != NULL)
+		release_register(ctx, stmt->dup.to);
+
+	nftnl_rule_add_expr(ctx->nlr, nle);
+}
+
 static void netlink_gen_queue_stmt(struct netlink_linearize_ctx *ctx,
 				 const struct stmt *stmt)
 {
@@ -949,6 +984,8 @@ static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 		return netlink_gen_masq_stmt(ctx, stmt);
 	case STMT_REDIR:
 		return netlink_gen_redir_stmt(ctx, stmt);
+	case STMT_DUP:
+		return netlink_gen_dup_stmt(ctx, stmt);
 	case STMT_QUEUE:
 		return netlink_gen_queue_stmt(ctx, stmt);
 	case STMT_CT:
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 385e214..36271b3 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -393,6 +393,9 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token BYPASS			"bypass"
 %token FANOUT			"fanout"
 
+%token DUP			"dup"
+%token ON			"on"
+
 %token POSITION			"position"
 %token COMMENT			"comment"
 
@@ -460,6 +463,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %type <stmt>			queue_stmt queue_stmt_alloc
 %destructor { stmt_free($$); }	queue_stmt queue_stmt_alloc
 %type <val>			queue_stmt_flags queue_stmt_flag
+%type <stmt>			dup_stmt
+%destructor { stmt_free($$); }	dup_stmt
 %type <stmt>			set_stmt
 %destructor { stmt_free($$); }	set_stmt
 %type <val>			set_stmt_op
@@ -1310,6 +1315,7 @@ stmt			:	verdict_stmt
 			|	ct_stmt
 			|	masq_stmt
 			|	redir_stmt
+			|	dup_stmt
 			|	set_stmt
 			;
 
@@ -1609,6 +1615,19 @@ redir_stmt_arg		:	TO	expr
 			}
 			;
 
+dup_stmt		:	DUP	TO	expr
+			{
+				$$ = dup_stmt_alloc(&@$);
+				$$->dup.to = $3;
+			}
+			|	DUP	TO	expr 	DEVICE	expr
+			{
+				$$ = dup_stmt_alloc(&@$);
+				$$->dup.to = $3;
+				$$->dup.dev = $5;
+			}
+			;
+
 nf_nat_flags		:	nf_nat_flag
 			|	nf_nat_flags	COMMA	nf_nat_flag
 			{
diff --git a/src/scanner.l b/src/scanner.l
index bd8e572..b827489 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -457,6 +457,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "proto-dst"		{ return PROTO_DST; }
 "label"			{ return LABEL; }
 
+"dup"			{ return DUP; }
+
 "xml"			{ return XML; }
 "json"			{ return JSON; }
 
diff --git a/src/statement.c b/src/statement.c
index d620d1b..2d1a3e6 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -455,3 +455,35 @@ struct stmt *set_stmt_alloc(const struct location *loc)
 {
 	return stmt_alloc(loc, &set_stmt_ops);
 }
+
+static void dup_stmt_print(const struct stmt *stmt)
+{
+	printf("dup");
+	if (stmt->dup.to != NULL) {
+		printf(" to ");
+		expr_print(stmt->dup.to);
+
+		if (stmt->dup.dev != NULL) {
+			printf(" device ");
+			expr_print(stmt->dup.dev);
+		}
+	}
+}
+
+static void dup_stmt_destroy(struct stmt *stmt)
+{
+	expr_free(stmt->dup.to);
+	expr_free(stmt->dup.dev);
+}
+
+static const struct stmt_ops dup_stmt_ops = {
+	.type		= STMT_DUP,
+	.name		= "dup",
+	.print		= dup_stmt_print,
+	.destroy	= dup_stmt_destroy,
+};
+
+struct stmt *dup_stmt_alloc(const struct location *loc)
+{
+	return stmt_alloc(loc, &dup_stmt_ops);
+}
-- 
2.1.4

