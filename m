Return-Path: <SRS0=sCaZ=AK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2884BC433E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Jun 2020 21:15:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02D31206A1
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Jun 2020 21:15:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730064AbgF2VO7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 29 Jun 2020 17:14:59 -0400
Received: from correo.us.es ([193.147.175.20]:52514 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387824AbgF2VO5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 Jun 2020 17:14:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3C9ECD1623
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Jun 2020 23:14:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2C7E2DA73F
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Jun 2020 23:14:52 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 221BEDA78C; Mon, 29 Jun 2020 23:14:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D70D0DA73F
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Jun 2020 23:14:48 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 29 Jun 2020 23:14:48 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id C1868426CCB9
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Jun 2020 23:14:48 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft WIP] src: support for implicit chain bindings
Date:   Mon, 29 Jun 2020 23:14:44 +0200
Message-Id: <20200629211444.1514-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds allows you to define implicit chain bindings, e.g.

 table inet x {
        chain y {
                type filter hook input priority 0;
                tcp dport 22 jump {
                        ip saddr { 127.0.0.0/8, 172.23.0.0/16, 192.168.13.0/24 } accept
                        ip6 saddr ::1/128 accept;
                }
        }
 }

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/expression.h                |  1 +
 include/linux/netfilter/nf_tables.h |  2 ++
 include/netlink.h                   |  1 +
 include/parser.h                    |  2 +-
 include/rule.h                      |  2 ++
 include/statement.h                 | 10 +++++++
 src/evaluate.c                      | 29 ++++++++++++++++++++
 src/mnl.c                           | 14 ++++++++--
 src/netlink.c                       | 42 ++++++++++++++++++-----------
 src/netlink_linearize.c             | 14 ++++++++--
 src/parser_bison.y                  | 13 +++++++++
 src/rule.c                          |  9 +++++++
 src/statement.c                     | 20 ++++++++++++++
 13 files changed, 138 insertions(+), 21 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 8135a516cf3a..1cea45058a70 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -249,6 +249,7 @@ struct expr {
 			/* EXPR_VERDICT */
 			int			verdict;
 			struct expr		*chain;
+			uint32_t		chain_id;
 		};
 		struct {
 			/* EXPR_VALUE */
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 4565456c0ef4..1341b52f0694 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -209,6 +209,7 @@ enum nft_chain_attributes {
 	NFTA_CHAIN_COUNTERS,
 	NFTA_CHAIN_PAD,
 	NFTA_CHAIN_FLAGS,
+	NFTA_CHAIN_ID,
 	__NFTA_CHAIN_MAX
 };
 #define NFTA_CHAIN_MAX		(__NFTA_CHAIN_MAX - 1)
@@ -238,6 +239,7 @@ enum nft_rule_attributes {
 	NFTA_RULE_PAD,
 	NFTA_RULE_ID,
 	NFTA_RULE_POSITION_ID,
+	NFTA_RULE_CHAIN_ID,
 	__NFTA_RULE_MAX
 };
 #define NFTA_RULE_MAX		(__NFTA_RULE_MAX - 1)
diff --git a/include/netlink.h b/include/netlink.h
index 0a5fde3cf08c..9ba04eb28fa0 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -83,6 +83,7 @@ struct nft_data_linearize {
 	uint32_t	len;
 	uint32_t	value[4];
 	char		chain[NFT_CHAIN_MAXNAMELEN];
+	uint32_t	chain_id;
 	int		verdict;
 };
 
diff --git a/include/parser.h b/include/parser.h
index 636d1c8810e4..9baa3a4db789 100644
--- a/include/parser.h
+++ b/include/parser.h
@@ -11,7 +11,7 @@
 #define YYLTYPE_IS_TRIVIAL		0
 #define YYENABLE_NLS			0
 
-#define SCOPE_NEST_MAX			3
+#define SCOPE_NEST_MAX			4
 
 struct parser_state {
 	struct input_descriptor		*indesc;
diff --git a/include/rule.h b/include/rule.h
index cfb76b8a0c10..63b1ef1bc035 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -79,6 +79,7 @@ struct handle {
 	struct position_spec	position;
 	struct position_spec	index;
 	uint32_t		set_id;
+	uint32_t		chain_id;
 	uint32_t		rule_id;
 	uint32_t		position_id;
 };
@@ -176,6 +177,7 @@ extern struct table *table_lookup_fuzzy(const struct handle *h,
 enum chain_flags {
 	CHAIN_F_BASECHAIN	= 0x1,
 	CHAIN_F_HW_OFFLOAD	= 0x2,
+	CHAIN_F_BINDING		= 0x4,
 };
 
 /**
diff --git a/include/statement.h b/include/statement.h
index 7d96b3947dfc..fac1f9d6c2a5 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -11,6 +11,13 @@ extern struct stmt *expr_stmt_alloc(const struct location *loc,
 extern struct stmt *verdict_stmt_alloc(const struct location *loc,
 				       struct expr *expr);
 
+struct chain_stmt {
+	struct chain		*chain;
+	struct expr		*expr;
+};
+
+struct stmt *chain_stmt_alloc(const struct location *loc, struct chain *chain);
+
 struct flow_stmt {
 	const char		*table_name;
 };
@@ -287,6 +294,7 @@ extern struct stmt *xt_stmt_alloc(const struct location *loc);
  * @STMT_CONNLIMIT:	connection limit statement
  * @STMT_MAP:		map statement
  * @STMT_SYNPROXY:	synproxy statement
+ * @STMT_CHAIN:		chain statement
  */
 enum stmt_types {
 	STMT_INVALID,
@@ -315,6 +323,7 @@ enum stmt_types {
 	STMT_CONNLIMIT,
 	STMT_MAP,
 	STMT_SYNPROXY,
+	STMT_CHAIN,
 };
 
 /**
@@ -380,6 +389,7 @@ struct stmt {
 		struct flow_stmt	flow;
 		struct map_stmt		map;
 		struct synproxy_stmt	synproxy;
+		struct chain_stmt	chain;
 	};
 };
 
diff --git a/src/evaluate.c b/src/evaluate.c
index 42040b6efe02..ff30279a5cfe 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3094,6 +3094,33 @@ static int stmt_evaluate_synproxy(struct eval_ctx *ctx, struct stmt *stmt)
 	return 0;
 }
 
+static int stmt_evaluate_chain(struct eval_ctx *ctx, struct stmt *stmt)
+{
+	struct chain *chain = stmt->chain.chain;
+	struct cmd *cmd;
+	struct handle h;
+
+	handle_merge(&chain->handle, &ctx->cmd->handle);
+	chain->handle.chain.location = ctx->cmd->handle.chain.location;
+	chain->handle.chain.name = xstrdup("__chain%d");
+	chain->flags |= CHAIN_F_BINDING;
+
+	memset(&h, 0, sizeof(h));
+	handle_merge(&h, &chain->handle);
+	h.chain.location = stmt->location;
+
+	if (ctx->table != NULL) {
+		list_add_tail(&chain->list, &ctx->table->chains);
+	} else {
+		cmd = cmd_alloc(CMD_ADD, CMD_OBJ_CHAIN, &h, &stmt->location,
+				chain);
+		cmd->location = stmt->location;
+		list_add_tail(&cmd->list, &ctx->cmd->list);
+	}
+
+	return 0;
+}
+
 static int stmt_evaluate_dup(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	int err;
@@ -3440,6 +3467,8 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 		return stmt_evaluate_map(ctx, stmt);
 	case STMT_SYNPROXY:
 		return stmt_evaluate_synproxy(ctx, stmt);
+	case STMT_CHAIN:
+		return stmt_evaluate_chain(ctx, stmt);
 	default:
 		BUG("unknown statement type %s\n", stmt->ops->name);
 	}
diff --git a/src/mnl.c b/src/mnl.c
index 19f666416909..b43a39adfda7 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -466,7 +466,10 @@ int mnl_nft_rule_add(struct netlink_ctx *ctx, struct cmd *cmd,
 	cmd_add_loc(cmd, nlh->nlmsg_len, &h->table.location);
 	mnl_attr_put_strz(nlh, NFTA_RULE_TABLE, h->table.name);
 	cmd_add_loc(cmd, nlh->nlmsg_len, &h->chain.location);
-	mnl_attr_put_strz(nlh, NFTA_RULE_CHAIN, h->chain.name);
+	if (h->chain_id)
+		mnl_attr_put_u32(nlh, NFTA_RULE_CHAIN_ID, htonl(h->chain_id));
+	else
+		mnl_attr_put_strz(nlh, NFTA_RULE_CHAIN, h->chain.name);
 
 	nftnl_rule_nlmsg_build_payload(nlh, nlr);
 	nftnl_rule_free(nlr);
@@ -679,7 +682,14 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
 	cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.table.location);
 	mnl_attr_put_strz(nlh, NFTA_CHAIN_TABLE, cmd->handle.table.name);
 	cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.chain.location);
-	mnl_attr_put_strz(nlh, NFTA_CHAIN_NAME, cmd->handle.chain.name);
+
+	if (!cmd->chain || !(cmd->chain->flags & CHAIN_F_BINDING)) {
+		mnl_attr_put_strz(nlh, NFTA_CHAIN_NAME, cmd->handle.chain.name);
+	} else {
+		mnl_attr_put_u32(nlh, NFTA_CHAIN_ID, htonl(cmd->handle.chain_id));
+		if (cmd->chain->flags)
+			nftnl_chain_set_u32(nlc, NFTNL_CHAIN_FLAGS, cmd->chain->flags);
+	}
 
 	if (cmd->chain && cmd->chain->policy) {
 		mpz_export_data(&policy, cmd->chain->policy->value,
diff --git a/src/netlink.c b/src/netlink.c
index fb0a17bac0d7..f81a5b185b12 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -269,31 +269,41 @@ static void netlink_gen_constant_data(const struct expr *expr,
 			     div_round_up(expr->len, BITS_PER_BYTE), data);
 }
 
-static void netlink_gen_verdict(const struct expr *expr,
-				struct nft_data_linearize *data)
+static void netlink_gen_chain(const struct expr *expr,
+			      struct nft_data_linearize *data)
 {
 	char chain[NFT_CHAIN_MAXNAMELEN];
 	unsigned int len;
 
-	data->verdict = expr->verdict;
+	len = expr->chain->len / BITS_PER_BYTE;
 
-	switch (expr->verdict) {
-	case NFT_JUMP:
-	case NFT_GOTO:
-		len = expr->chain->len / BITS_PER_BYTE;
+	if (!len)
+		BUG("chain length is 0");
+
+	if (len > sizeof(chain))
+		BUG("chain is too large (%u, %u max)",
+		    len, (unsigned int)sizeof(chain));
+
+	memset(chain, 0, sizeof(chain));
 
-		if (!len)
-			BUG("chain length is 0");
+	mpz_export_data(chain, expr->chain->value,
+			BYTEORDER_HOST_ENDIAN, len);
+	snprintf(data->chain, NFT_CHAIN_MAXNAMELEN, "%s", chain);
+}
 
-		if (len > sizeof(chain))
-			BUG("chain is too large (%u, %u max)",
-			    len, (unsigned int)sizeof(chain));
+static void netlink_gen_verdict(const struct expr *expr,
+				struct nft_data_linearize *data)
+{
 
-		memset(chain, 0, sizeof(chain));
+	data->verdict = expr->verdict;
 
-		mpz_export_data(chain, expr->chain->value,
-				BYTEORDER_HOST_ENDIAN, len);
-		snprintf(data->chain, NFT_CHAIN_MAXNAMELEN, "%s", chain);
+	switch (expr->verdict) {
+	case NFT_JUMP:
+	case NFT_GOTO:
+		if (expr->chain)
+			netlink_gen_chain(expr, data);
+		else
+			data->chain_id = expr->chain_id;
 		break;
 	}
 }
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 08f7f89f1066..94e369ebf1cf 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -712,10 +712,12 @@ static void netlink_gen_immediate(struct netlink_linearize_ctx *ctx,
 		nftnl_expr_set(nle, NFTNL_EXPR_IMM_DATA, nld.value, nld.len);
 		break;
 	case EXPR_VERDICT:
-		if ((expr->chain != NULL) &&
-		    !nftnl_expr_is_set(nle, NFTNL_EXPR_IMM_CHAIN)) {
+		if (expr->chain != NULL) {
 			nftnl_expr_set_str(nle, NFTNL_EXPR_IMM_CHAIN,
 					   nld.chain);
+		} else if (expr->chain_id) {
+			nftnl_expr_set_u32(nle, NFTNL_EXPR_IMM_CHAIN_ID,
+					   nld.chain_id);
 		}
 		nftnl_expr_set_u32(nle, NFTNL_EXPR_IMM_VERDICT, nld.verdict);
 		break;
@@ -1442,6 +1444,12 @@ static void netlink_gen_meter_stmt(struct netlink_linearize_ctx *ctx,
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
 
+static void netlink_gen_chain_stmt(struct netlink_linearize_ctx *ctx,
+				   const struct stmt *stmt)
+{
+	return netlink_gen_expr(ctx, stmt->chain.expr, NFT_REG_VERDICT);
+}
+
 static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 			     const struct stmt *stmt)
 {
@@ -1495,6 +1503,8 @@ static void netlink_gen_stmt(struct netlink_linearize_ctx *ctx,
 		return netlink_gen_objref_stmt(ctx, stmt);
 	case STMT_MAP:
 		return netlink_gen_map_stmt(ctx, stmt);
+	case STMT_CHAIN:
+		return netlink_gen_chain_stmt(ctx, stmt);
 	default:
 		BUG("unknown statement type %s\n", stmt->ops->name);
 	}
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 461d9bf24d95..07fc2d80f4df 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -642,6 +642,8 @@ int nft_lex(void *, void *, void *);
 %destructor { stmt_free($$); }	tproxy_stmt
 %type <stmt>			synproxy_stmt synproxy_stmt_alloc
 %destructor { stmt_free($$); }	synproxy_stmt synproxy_stmt_alloc
+%type <stmt>			chain_stmt
+%destructor { stmt_free($$); }	chain_stmt
 
 
 %type <stmt>			queue_stmt queue_stmt_alloc
@@ -2527,6 +2529,17 @@ stmt			:	verdict_stmt
 			|	set_stmt
 			|	map_stmt
 			|	synproxy_stmt
+			|	chain_stmt
+			;
+
+chain_stmt		:	JUMP	chain_block_alloc	'{'	chain_block	'}'
+			{
+				struct handle h = {};
+				$4->location = @4;
+				handle_merge(&h, &$2->handle);
+				close_scope(state);
+				$$ = chain_stmt_alloc(&@$, $4);
+			}
 			;
 
 verdict_stmt		:	verdict_expr
diff --git a/src/rule.c b/src/rule.c
index 21a52157391d..43201f528683 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -858,12 +858,16 @@ const char *chain_hookname_lookup(const char *name)
 	return NULL;
 }
 
+/* internal ID to uniquely identify a set in the batch */
+static uint32_t chain_id;
+
 struct chain *chain_alloc(const char *name)
 {
 	struct chain *chain;
 
 	chain = xzalloc(sizeof(*chain));
 	chain->refcnt = 1;
+	chain->handle.chain_id = ++chain_id;
 	init_list_head(&chain->rules);
 	init_list_head(&chain->scope.symbols);
 	if (name != NULL)
@@ -1437,6 +1441,7 @@ void nft_cmd_expand(struct cmd *cmd)
 		list_for_each_entry(chain, &table->chains, list) {
 			memset(&h, 0, sizeof(h));
 			handle_merge(&h, &chain->handle);
+			h.chain_id = chain->handle.chain_id;
 			new = cmd_alloc(CMD_ADD, CMD_OBJ_CHAIN, &h,
 					&chain->location, chain_get(chain));
 			list_add_tail(&new->list, &new_cmds);
@@ -1469,6 +1474,10 @@ void nft_cmd_expand(struct cmd *cmd)
 			list_for_each_entry(rule, &chain->rules, list) {
 				memset(&h, 0, sizeof(h));
 				handle_merge(&h, &rule->handle);
+				if (chain->flags & CHAIN_F_BINDING) {
+					rule->handle.chain_id =
+						chain->handle.chain_id;
+				}
 				new = cmd_alloc(CMD_ADD, CMD_OBJ_RULE, &h,
 						&rule->location,
 						rule_get(rule));
diff --git a/src/statement.c b/src/statement.c
index 21a1bc8d40dd..0bdba4741bb8 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -15,6 +15,7 @@
 #include <inttypes.h>
 #include <string.h>
 #include <syslog.h>
+#include <rule.h>
 
 #include <arpa/inet.h>
 #include <linux/netfilter.h>
@@ -111,6 +112,25 @@ struct stmt *verdict_stmt_alloc(const struct location *loc, struct expr *expr)
 	return stmt;
 }
 
+static const struct stmt_ops chain_stmt_ops = {
+	.type		= STMT_CHAIN,
+	.name		= "chain",
+	.print		= expr_stmt_print,
+	.destroy	= expr_stmt_destroy,
+};
+
+struct stmt *chain_stmt_alloc(const struct location *loc, struct chain *chain)
+{
+	struct stmt *stmt;
+
+	stmt = stmt_alloc(loc, &chain_stmt_ops);
+	stmt->chain.chain = chain;
+	stmt->chain.expr = verdict_expr_alloc(loc, NFT_JUMP, NULL);
+	stmt->chain.expr->chain_id = chain->handle.chain_id;
+
+	return stmt;
+}
+
 static void meter_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
 {
 	unsigned int flags = octx->flags;
-- 
2.20.1

