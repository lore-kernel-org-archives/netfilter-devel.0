Return-Path: <SRS0=AjNT=AP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5770AC433E1
	for <netfilter-devel@archiver.kernel.org>; Sat,  4 Jul 2020 00:45:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E09F20723
	for <netfilter-devel@archiver.kernel.org>; Sat,  4 Jul 2020 00:45:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbgGDApH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Jul 2020 20:45:07 -0400
Received: from correo.us.es ([193.147.175.20]:59172 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726455AbgGDApG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Jul 2020 20:45:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 11EA8ED5BE
        for <netfilter-devel@vger.kernel.org>; Sat,  4 Jul 2020 02:45:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EBA94DA72F
        for <netfilter-devel@vger.kernel.org>; Sat,  4 Jul 2020 02:44:59 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E0A30DA722; Sat,  4 Jul 2020 02:44:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C174DDA72F
        for <netfilter-devel@vger.kernel.org>; Sat,  4 Jul 2020 02:44:56 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 04 Jul 2020 02:44:56 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id AAB3642EF529
        for <netfilter-devel@vger.kernel.org>; Sat,  4 Jul 2020 02:44:56 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 2/2] src: support for implicit chain bindings
Date:   Sat,  4 Jul 2020 02:44:52 +0200
Message-Id: <20200704004452.2347-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200704004452.2347-1-pablo@netfilter.org>
References: <20200704004452.2347-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch allows you to group rules in a subchain, e.g.

 table inet x {
        chain y {
                type filter hook input priority 0;
                tcp dport 22 jump {
                        ip saddr { 127.0.0.0/8, 172.23.0.0/16, 192.168.13.0/24 } accept
                        ip6 saddr ::1/128 accept;
                }
        }
 }

This also supports for the `goto' chain verdict.

This patch adds a new chain binding list to avoid a chain list lookup from the
delinearize path for the usual chains. This can be simplified later on with a
single hashtable per table for all chains.

From the shell, you have to use the explicit separator ';', in bash you
have to escape this:

 # nft add rule inet x y tcp dport 80 jump { ip saddr 127.0.0.1 accept\; ip6 saddr ::1 accept \; }

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/expression.h                |  1 +
 include/linux/netfilter/nf_tables.h |  2 +
 include/netlink.h                   |  2 +
 include/parser.h                    |  2 +-
 include/rule.h                      |  7 ++++
 include/statement.h                 | 11 ++++++
 src/evaluate.c                      | 61 ++++++++++++++++++++++++++++-
 src/mnl.c                           | 19 ++++++++-
 src/netlink.c                       | 47 ++++++++++++++--------
 src/netlink_delinearize.c           | 37 +++++++++++++++--
 src/netlink_linearize.c             | 14 ++++++-
 src/parser_bison.y                  | 31 +++++++++++++--
 src/rule.c                          | 49 +++++++++++++++++++++--
 src/statement.c                     | 45 +++++++++++++++++++++
 14 files changed, 294 insertions(+), 34 deletions(-)

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
index 0a5fde3cf08c..14fcec160e20 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -64,6 +64,7 @@ struct netlink_ctx {
 	struct nft_ctx		*nft;
 	struct list_head	*msgs;
 	struct list_head	list;
+	struct list_head	list_bindings;
 	struct set		*set;
 	const void		*data;
 	uint32_t		seqnum;
@@ -83,6 +84,7 @@ struct nft_data_linearize {
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
index cfb76b8a0c10..4de7a0d950ec 100644
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
@@ -155,6 +156,7 @@ struct table {
 	struct list_head	sets;
 	struct list_head	objs;
 	struct list_head	flowtables;
+	struct list_head	chain_bindings;
 	enum table_flags 	flags;
 	unsigned int		refcnt;
 };
@@ -176,6 +178,7 @@ extern struct table *table_lookup_fuzzy(const struct handle *h,
 enum chain_flags {
 	CHAIN_F_BASECHAIN	= 0x1,
 	CHAIN_F_HW_OFFLOAD	= 0x2,
+	CHAIN_F_BINDING		= 0x4,
 };
 
 /**
@@ -244,12 +247,16 @@ extern struct chain *chain_lookup(const struct table *table,
 extern struct chain *chain_lookup_fuzzy(const struct handle *h,
 					const struct nft_cache *cache,
 					const struct table **table);
+extern struct chain *chain_binding_lookup(const struct table *table,
+					  const char *chain_name);
 
 extern const char *family2str(unsigned int family);
 extern const char *hooknum2str(unsigned int family, unsigned int hooknum);
 extern const char *chain_policy2str(uint32_t policy);
 extern void chain_print_plain(const struct chain *chain,
 			      struct output_ctx *octx);
+extern void chain_rules_print(const struct chain *chain,
+			      struct output_ctx *octx, const char *indent);
 
 /**
  * struct rule - nftables rule
diff --git a/include/statement.h b/include/statement.h
index 7d96b3947dfc..9851b7222423 100644
--- a/include/statement.h
+++ b/include/statement.h
@@ -11,6 +11,14 @@ extern struct stmt *expr_stmt_alloc(const struct location *loc,
 extern struct stmt *verdict_stmt_alloc(const struct location *loc,
 				       struct expr *expr);
 
+struct chain_stmt {
+	struct chain		*chain;
+	struct expr		*expr;
+};
+
+struct stmt *chain_stmt_alloc(const struct location *loc, struct chain *chain,
+			      enum nft_verdicts verdict);
+
 struct flow_stmt {
 	const char		*table_name;
 };
@@ -287,6 +295,7 @@ extern struct stmt *xt_stmt_alloc(const struct location *loc);
  * @STMT_CONNLIMIT:	connection limit statement
  * @STMT_MAP:		map statement
  * @STMT_SYNPROXY:	synproxy statement
+ * @STMT_CHAIN:		chain statement
  */
 enum stmt_types {
 	STMT_INVALID,
@@ -315,6 +324,7 @@ enum stmt_types {
 	STMT_CONNLIMIT,
 	STMT_MAP,
 	STMT_SYNPROXY,
+	STMT_CHAIN,
 };
 
 /**
@@ -380,6 +390,7 @@ struct stmt {
 		struct flow_stmt	flow;
 		struct map_stmt		map;
 		struct synproxy_stmt	synproxy;
+		struct chain_stmt	chain;
 	};
 };
 
diff --git a/src/evaluate.c b/src/evaluate.c
index 42040b6efe02..827ee48a48ed 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3094,6 +3094,63 @@ static int stmt_evaluate_synproxy(struct eval_ctx *ctx, struct stmt *stmt)
 	return 0;
 }
 
+static int rule_evaluate(struct eval_ctx *ctx, struct rule *rule,
+			 enum cmd_ops op);
+
+static int stmt_evaluate_chain(struct eval_ctx *ctx, struct stmt *stmt)
+{
+	struct chain *chain = stmt->chain.chain;
+	struct cmd *cmd;
+
+	chain->flags |= CHAIN_F_BINDING;
+
+	if (ctx->table != NULL) {
+		list_add_tail(&chain->list, &ctx->table->chains);
+	} else {
+		struct rule *rule, *next;
+		struct handle h;
+
+		memset(&h, 0, sizeof(h));
+		handle_merge(&h, &chain->handle);
+		h.family = ctx->rule->handle.family;
+		xfree(h.table.name);
+		h.table.name = xstrdup(ctx->rule->handle.table.name);
+		h.chain.location = stmt->location;
+		h.chain_id = chain->handle.chain_id;
+
+		cmd = cmd_alloc(CMD_ADD, CMD_OBJ_CHAIN, &h, &stmt->location,
+				chain);
+		cmd->location = stmt->location;
+		list_add_tail(&cmd->list, &ctx->cmd->list);
+		h.chain_id = chain->handle.chain_id;
+
+		list_for_each_entry_safe(rule, next, &chain->rules, list) {
+			struct eval_ctx rule_ctx = {
+				.nft	= ctx->nft,
+				.msgs	= ctx->msgs,
+			};
+			struct handle h2 = {};
+
+			handle_merge(&rule->handle, &ctx->rule->handle);
+			xfree(rule->handle.table.name);
+			rule->handle.table.name = xstrdup(ctx->rule->handle.table.name);
+			xfree(rule->handle.chain.name);
+			rule->handle.chain.name = NULL;
+			rule->handle.chain_id = chain->handle.chain_id;
+			if (rule_evaluate(&rule_ctx, rule, CMD_INVALID) < 0)
+				return -1;
+
+			handle_merge(&h2, &rule->handle);
+			cmd = cmd_alloc(CMD_ADD, CMD_OBJ_RULE, &h2,
+					&rule->location, rule);
+			list_add_tail(&cmd->list, &ctx->cmd->list);
+			list_del(&rule->list);
+		}
+	}
+
+	return 0;
+}
+
 static int stmt_evaluate_dup(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	int err;
@@ -3440,6 +3497,8 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
 		return stmt_evaluate_map(ctx, stmt);
 	case STMT_SYNPROXY:
 		return stmt_evaluate_synproxy(ctx, stmt);
+	case STMT_CHAIN:
+		return stmt_evaluate_chain(ctx, stmt);
 	default:
 		BUG("unknown statement type %s\n", stmt->ops->name);
 	}
@@ -3829,7 +3888,7 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
 			chain_add_hash(chain, table);
 		}
 		return 0;
-	} else {
+	} else if (!(chain->flags & CHAIN_F_BINDING)) {
 		if (chain_lookup(table, &chain->handle) == NULL)
 			chain_add_hash(chain_get(chain), table);
 	}
diff --git a/src/mnl.c b/src/mnl.c
index 19f666416909..e5e88f3bd990 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -466,7 +466,11 @@ int mnl_nft_rule_add(struct netlink_ctx *ctx, struct cmd *cmd,
 	cmd_add_loc(cmd, nlh->nlmsg_len, &h->table.location);
 	mnl_attr_put_strz(nlh, NFTA_RULE_TABLE, h->table.name);
 	cmd_add_loc(cmd, nlh->nlmsg_len, &h->chain.location);
-	mnl_attr_put_strz(nlh, NFTA_RULE_CHAIN, h->chain.name);
+
+	if (h->chain_id)
+		mnl_attr_put_u32(nlh, NFTA_RULE_CHAIN_ID, htonl(h->chain_id));
+	else
+		mnl_attr_put_strz(nlh, NFTA_RULE_CHAIN, h->chain.name);
 
 	nftnl_rule_nlmsg_build_payload(nlh, nlr);
 	nftnl_rule_free(nlr);
@@ -679,7 +683,18 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
 	cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.table.location);
 	mnl_attr_put_strz(nlh, NFTA_CHAIN_TABLE, cmd->handle.table.name);
 	cmd_add_loc(cmd, nlh->nlmsg_len, &cmd->handle.chain.location);
-	mnl_attr_put_strz(nlh, NFTA_CHAIN_NAME, cmd->handle.chain.name);
+
+	if (!cmd->chain || !(cmd->chain->flags & CHAIN_F_BINDING)) {
+		mnl_attr_put_strz(nlh, NFTA_CHAIN_NAME, cmd->handle.chain.name);
+	} else {
+		if (cmd->handle.chain.name)
+			mnl_attr_put_strz(nlh, NFTA_CHAIN_NAME,
+					  cmd->handle.chain.name);
+
+		mnl_attr_put_u32(nlh, NFTA_CHAIN_ID, htonl(cmd->handle.chain_id));
+		if (cmd->chain->flags)
+			nftnl_chain_set_u32(nlc, NFTNL_CHAIN_FLAGS, cmd->chain->flags);
+	}
 
 	if (cmd->chain && cmd->chain->policy) {
 		mpz_export_data(&policy, cmd->chain->policy->value,
diff --git a/src/netlink.c b/src/netlink.c
index fb0a17bac0d7..f752c3c932aa 100644
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
 
-		if (!len)
-			BUG("chain length is 0");
+	if (len > sizeof(chain))
+		BUG("chain is too large (%u, %u max)",
+		    len, (unsigned int)sizeof(chain));
 
-		if (len > sizeof(chain))
-			BUG("chain is too large (%u, %u max)",
-			    len, (unsigned int)sizeof(chain));
+	memset(chain, 0, sizeof(chain));
 
-		memset(chain, 0, sizeof(chain));
+	mpz_export_data(chain, expr->chain->value,
+			BYTEORDER_HOST_ENDIAN, len);
+	snprintf(data->chain, NFT_CHAIN_MAXNAMELEN, "%s", chain);
+}
 
-		mpz_export_data(chain, expr->chain->value,
-				BYTEORDER_HOST_ENDIAN, len);
-		snprintf(data->chain, NFT_CHAIN_MAXNAMELEN, "%s", chain);
+static void netlink_gen_verdict(const struct expr *expr,
+				struct nft_data_linearize *data)
+{
+
+	data->verdict = expr->verdict;
+
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
@@ -546,7 +556,10 @@ static int list_chain_cb(struct nftnl_chain *nlc, void *arg)
 		return 0;
 
 	chain = netlink_delinearize_chain(ctx, nlc);
-	list_add_tail(&chain->list, &ctx->list);
+	if (chain->flags & CHAIN_F_BINDING)
+		list_add_tail(&chain->list, &ctx->list_bindings);
+	else
+		list_add_tail(&chain->list, &ctx->list);
 
 	return 0;
 }
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 8de4830c4f80..b508cacef1ee 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -163,6 +163,24 @@ err:
 	return NULL;
 }
 
+static void netlink_parse_chain_verdict(struct netlink_parse_ctx *ctx,
+					const struct location *loc,
+					struct expr *expr,
+					enum nft_verdicts verdict)
+{
+	char chain_name[NFT_CHAIN_MAXNAMELEN] = {};
+	struct chain *chain;
+
+	expr_chain_export(expr->chain, chain_name);
+	chain = chain_binding_lookup(ctx->table, chain_name);
+	if (chain) {
+		ctx->stmt = chain_stmt_alloc(loc, chain, verdict);
+		expr_free(expr);
+	} else {
+		ctx->stmt = verdict_stmt_alloc(loc, expr);
+	}
+}
+
 static void netlink_parse_immediate(struct netlink_parse_ctx *ctx,
 				    const struct location *loc,
 				    const struct nftnl_expr *nle)
@@ -182,12 +200,23 @@ static void netlink_parse_immediate(struct netlink_parse_ctx *ctx,
 	}
 
 	dreg = netlink_parse_register(nle, NFTNL_EXPR_IMM_DREG);
-
 	expr = netlink_alloc_data(loc, &nld, dreg);
-	if (dreg == NFT_REG_VERDICT)
-		ctx->stmt = verdict_stmt_alloc(loc, expr);
-	else
+
+	if (dreg == NFT_REG_VERDICT) {
+		switch (expr->verdict) {
+		case NFT_JUMP:
+			netlink_parse_chain_verdict(ctx, loc, expr, NFT_JUMP);
+			break;
+		case NFT_GOTO:
+			netlink_parse_chain_verdict(ctx, loc, expr, NFT_GOTO);
+			break;
+		default:
+			ctx->stmt = verdict_stmt_alloc(loc, expr);
+			break;
+		}
+	} else {
 		netlink_set_register(ctx, dreg, expr);
+	}
 }
 
 static void netlink_parse_xfrm(struct netlink_parse_ctx *ctx,
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 08f7f89f1066..ff0d740286d3 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -712,10 +712,12 @@ static void netlink_gen_immediate(struct netlink_linearize_ctx *ctx,
 		nftnl_expr_set(nle, NFTNL_EXPR_IMM_DATA, nld.value, nld.len);
 		break;
 	case EXPR_VERDICT:
-		if ((expr->chain != NULL) &&
-		    !nftnl_expr_is_set(nle, NFTNL_EXPR_IMM_CHAIN)) {
+		if (expr->chain) {
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
index 461d9bf24d95..8a04d3b409a5 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -594,8 +594,8 @@ int nft_lex(void *, void *, void *);
 
 %type <table>			table_block_alloc table_block
 %destructor { close_scope(state); table_free($$); }	table_block_alloc
-%type <chain>			chain_block_alloc chain_block
-%destructor { close_scope(state); chain_free($$); }	chain_block_alloc
+%type <chain>			chain_block_alloc chain_block subchain_block
+%destructor { close_scope(state); chain_free($$); }	chain_block_alloc subchain_block
 %type <rule>			rule rule_alloc
 %destructor { rule_free($$); }	rule
 
@@ -642,7 +642,9 @@ int nft_lex(void *, void *, void *);
 %destructor { stmt_free($$); }	tproxy_stmt
 %type <stmt>			synproxy_stmt synproxy_stmt_alloc
 %destructor { stmt_free($$); }	synproxy_stmt synproxy_stmt_alloc
-
+%type <stmt>			chain_stmt
+%destructor { stmt_free($$); }	chain_stmt
+%type <val>			chain_stmt_type
 
 %type <stmt>			queue_stmt queue_stmt_alloc
 %destructor { stmt_free($$); }	queue_stmt queue_stmt_alloc
@@ -1682,6 +1684,15 @@ chain_block		:	/* empty */	{ $$ = $<chain>-1; }
 			}
 			;
 
+subchain_block		:	/* empty */	{ $$ = $<chain>-1; }
+			|	subchain_block	stmt_separator
+			|	subchain_block	rule stmt_separator
+			{
+				list_add_tail(&$2->list, &$1->rules);
+				$$ = $1;
+			}
+			;
+
 typeof_expr		:	primary_expr
 			{
 				if (expr_ops($1)->build_udata == NULL) {
@@ -2527,6 +2538,20 @@ stmt			:	verdict_stmt
 			|	set_stmt
 			|	map_stmt
 			|	synproxy_stmt
+			|	chain_stmt
+			;
+
+chain_stmt_type		:	JUMP	{ $$ = NFT_JUMP; }
+			|	GOTO	{ $$ = NFT_GOTO; }
+			;
+
+chain_stmt		:	chain_stmt_type	chain_block_alloc '{'	subchain_block	'}'
+			{
+				$2->location = @2;
+				close_scope(state);
+				$4->location = @4;
+				$$ = chain_stmt_alloc(&@$, $4, $1);
+			}
 			;
 
 verdict_stmt		:	verdict_expr
diff --git a/src/rule.c b/src/rule.c
index 21a52157391d..fa1861403ba1 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -177,7 +177,10 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags)
 			ret = netlink_list_chains(ctx, &table->handle);
 			if (ret < 0)
 				return -1;
+
 			list_splice_tail_init(&ctx->list, &table->chains);
+			list_splice_tail_init(&ctx->list_bindings,
+					      &table->chain_bindings);
 		}
 		if (flags & NFT_CACHE_FLOWTABLE_BIT) {
 			ret = netlink_list_flowtables(ctx, &table->handle);
@@ -196,6 +199,9 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags)
 			ret = netlink_list_rules(ctx, &table->handle);
 			list_for_each_entry_safe(rule, nrule, &ctx->list, list) {
 				chain = chain_lookup(table, &rule->handle);
+				if (!chain)
+					chain = chain_binding_lookup(table,
+							rule->handle.chain.name);
 				list_move_tail(&rule->list, &chain->rules);
 			}
 			if (ret < 0)
@@ -245,6 +251,7 @@ int cache_update(struct nft_ctx *nft, unsigned int flags, struct list_head *msgs
 {
 	struct netlink_ctx ctx = {
 		.list		= LIST_HEAD_INIT(ctx.list),
+		.list_bindings	= LIST_HEAD_INIT(ctx.list_bindings),
 		.nft		= nft,
 		.msgs		= msgs,
 	};
@@ -858,12 +865,16 @@ const char *chain_hookname_lookup(const char *name)
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
@@ -916,6 +927,18 @@ struct chain *chain_lookup(const struct table *table, const struct handle *h)
 	return NULL;
 }
 
+struct chain *chain_binding_lookup(const struct table *table,
+				   const char *chain_name)
+{
+	struct chain *chain;
+
+	list_for_each_entry(chain, &table->chain_bindings, list) {
+		if (!strcmp(chain->handle.chain.name, chain_name))
+			return chain;
+	}
+	return NULL;
+}
+
 struct chain *chain_lookup_fuzzy(const struct handle *h,
 				 const struct nft_cache *cache,
 				 const struct table **t)
@@ -1175,6 +1198,9 @@ static void chain_print_declaration(const struct chain *chain,
 	char priobuf[STD_PRIO_BUFSIZE];
 	int policy, i;
 
+	if (chain->flags & CHAIN_F_BINDING)
+		return;
+
 	nft_print(octx, "\tchain %s {", chain->handle.chain.name);
 	if (nft_output_handle(octx))
 		nft_print(octx, " # handle %" PRIu64, chain->handle.handle.id);
@@ -1210,17 +1236,22 @@ static void chain_print_declaration(const struct chain *chain,
 	}
 }
 
-static void chain_print(const struct chain *chain, struct output_ctx *octx)
+void chain_rules_print(const struct chain *chain, struct output_ctx *octx,
+		       const char *indent)
 {
 	struct rule *rule;
 
-	chain_print_declaration(chain, octx);
-
 	list_for_each_entry(rule, &chain->rules, list) {
-		nft_print(octx, "\t\t");
+		nft_print(octx, "\t\t%s", indent ? : "");
 		rule_print(rule, octx);
 		nft_print(octx, "\n");
 	}
+}
+
+static void chain_print(const struct chain *chain, struct output_ctx *octx)
+{
+	chain_print_declaration(chain, octx);
+	chain_rules_print(chain, octx, NULL);
 	nft_print(octx, "\t}\n");
 }
 
@@ -1255,6 +1286,7 @@ struct table *table_alloc(void)
 	init_list_head(&table->sets);
 	init_list_head(&table->objs);
 	init_list_head(&table->flowtables);
+	init_list_head(&table->chain_bindings);
 	init_list_head(&table->scope.symbols);
 	table->refcnt = 1;
 
@@ -1272,6 +1304,8 @@ void table_free(struct table *table)
 		return;
 	list_for_each_entry_safe(chain, next, &table->chains, list)
 		chain_free(chain);
+	list_for_each_entry_safe(chain, next, &table->chain_bindings, list)
+		chain_free(chain);
 	list_for_each_entry_safe(set, nset, &table->sets, list)
 		set_free(set);
 	list_for_each_entry_safe(ft, nft, &table->flowtables, list)
@@ -1437,6 +1471,7 @@ void nft_cmd_expand(struct cmd *cmd)
 		list_for_each_entry(chain, &table->chains, list) {
 			memset(&h, 0, sizeof(h));
 			handle_merge(&h, &chain->handle);
+			h.chain_id = chain->handle.chain_id;
 			new = cmd_alloc(CMD_ADD, CMD_OBJ_CHAIN, &h,
 					&chain->location, chain_get(chain));
 			list_add_tail(&new->list, &new_cmds);
@@ -1469,6 +1504,12 @@ void nft_cmd_expand(struct cmd *cmd)
 			list_for_each_entry(rule, &chain->rules, list) {
 				memset(&h, 0, sizeof(h));
 				handle_merge(&h, &rule->handle);
+				if (chain->flags & CHAIN_F_BINDING) {
+					rule->handle.chain_id =
+						chain->handle.chain_id;
+					rule->handle.chain.location =
+						chain->location;
+				}
 				new = cmd_alloc(CMD_ADD, CMD_OBJ_RULE, &h,
 						&rule->location,
 						rule_get(rule));
diff --git a/src/statement.c b/src/statement.c
index 21a1bc8d40dd..3cbc49703f2d 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -15,6 +15,7 @@
 #include <inttypes.h>
 #include <string.h>
 #include <syslog.h>
+#include <rule.h>
 
 #include <arpa/inet.h>
 #include <linux/netfilter.h>
@@ -111,6 +112,50 @@ struct stmt *verdict_stmt_alloc(const struct location *loc, struct expr *expr)
 	return stmt;
 }
 
+static const char *chain_verdict(const struct expr *expr)
+{
+	switch (expr->verdict) {
+	case NFT_JUMP:
+		return "jump";
+	case NFT_GOTO:
+		return "goto";
+	default:
+		BUG("unknown chain verdict");
+	}
+}
+
+static void chain_stmt_print(const struct stmt *stmt, struct output_ctx *octx)
+{
+	nft_print(octx, "%s {\n", chain_verdict(stmt->chain.expr));
+	chain_rules_print(stmt->chain.chain, octx, "\t");
+	nft_print(octx, "\t\t}");
+}
+
+static void chain_stmt_destroy(struct stmt *stmt)
+{
+	expr_free(stmt->chain.expr);
+}
+
+static const struct stmt_ops chain_stmt_ops = {
+	.type		= STMT_CHAIN,
+	.name		= "chain",
+	.print		= chain_stmt_print,
+	.destroy	= chain_stmt_destroy,
+};
+
+struct stmt *chain_stmt_alloc(const struct location *loc, struct chain *chain,
+			      enum nft_verdicts verdict)
+{
+	struct stmt *stmt;
+
+	stmt = stmt_alloc(loc, &chain_stmt_ops);
+	stmt->chain.chain = chain;
+	stmt->chain.expr = verdict_expr_alloc(loc, verdict, NULL);
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

