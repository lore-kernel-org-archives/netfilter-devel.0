Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0A4FC3DA78
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Jan 2023 15:18:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233576AbjAQPSN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Jan 2023 10:18:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233027AbjAQPRg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Jan 2023 10:17:36 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2CA40BC3
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Jan 2023 07:17:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ALxWOWB/kM6Ek4Tn4+1ELB9swWVL7q00Ks95sW5+kJc=; b=EvcSgK/S2wEL0Dlh6x20bvSsaV
        lcGHYb4JC8ad+qzsh7BCjsmEfhMTCVAiNY+2euFkNQh6sd6PYsnfidEB0SYmr/I+u/x6kzmo/ggiG
        URl0W8wdvbXSzQnJ6S+4+hXqa+o4Bnbz/jbnTZBO6zgch3smhr+Kvtyd7eWuejhHNXCNMrAKNkS2h
        AXQpT8PgFQXxFXFj7V/aHAL/GgGzHuR5lQOgHQu+LLE2UYJ2pDeEYy7ZJMzHf/H6E64r5VAXPoJZj
        NOIBYcxickIBw0/hB6hWIyi2U9NuXLcIgW8CNAvXAH+Ih6xMrhDTWjb55H6/7DN4yA5pmes9VqlSW
        zj7rExog==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pHniL-0002qa-E1; Tue, 17 Jan 2023 16:17:29 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH v3] Implement 'reset rule' and 'reset rules' commands
Date:   Tue, 17 Jan 2023 16:17:24 +0100
Message-Id: <20230117151724.4437-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Reset rule counters and quotas in kernel, i.e. without having to reload
them. Requires respective kernel patch to support NFT_MSG_GETRULE_RESET
message type.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v2:
- Reduce cache requirements.
- Make list_rule_cb() work with NFPROTO_UNSPEC, too. Needed for full
  ruleset reset without rule cache.

Changes since v1:
- Rename struct nft_cache_filter::rule_id to rule_handle as requested
- Drop accidental whitespace change from parser_json.c
- Add test case
---
 doc/libnftables-json.adoc                     |   2 +-
 doc/nft.txt                                   |   6 +-
 include/cache.h                               |   7 +
 include/linux/netfilter/nf_tables.h           |   1 +
 include/mnl.h                                 |   4 +-
 include/netlink.h                             |   3 +
 include/rule.h                                |   1 +
 src/cache.c                                   |  42 +++++-
 src/evaluate.c                                |   2 +
 src/json.c                                    |   1 +
 src/mnl.c                                     |  18 ++-
 src/netlink.c                                 |  49 +++++++
 src/parser_bison.y                            |  16 +++
 src/parser_json.c                             |  35 +++++
 src/rule.c                                    |  10 ++
 src/scanner.l                                 |   1 +
 .../testcases/rule_management/0011reset_0     | 127 ++++++++++++++++++
 .../rule_management/dumps/0011reset_0.nft     |  23 ++++
 18 files changed, 334 insertions(+), 14 deletions(-)
 create mode 100755 tests/shell/testcases/rule_management/0011reset_0
 create mode 100644 tests/shell/testcases/rule_management/dumps/0011reset_0.nft

diff --git a/doc/libnftables-json.adoc b/doc/libnftables-json.adoc
index d985149a0af35..f4aea36eb5711 100644
--- a/doc/libnftables-json.adoc
+++ b/doc/libnftables-json.adoc
@@ -175,7 +175,7 @@ kind, optionally filtered by *family* and for some, also *table*.
 ____
 *{ "reset":* 'RESET_OBJECT' *}*
 
-'RESET_OBJECT' := 'COUNTER' | 'COUNTERS' | 'QUOTA' | 'QUOTAS'
+'RESET_OBJECT' := 'COUNTER' | 'COUNTERS' | 'QUOTA' | 'QUOTAS' | 'RULE' | 'RULES'
 ____
 
 Reset state in suitable objects, i.e. zero their internal counter.
diff --git a/doc/nft.txt b/doc/nft.txt
index eb8df1d95e53a..18c18468c31b0 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -481,7 +481,10 @@ RULES
 [verse]
 {*add* | *insert*} *rule* ['family'] 'table' 'chain' [*handle* 'handle' | *index* 'index'] 'statement' ... [*comment* 'comment']
 *replace rule* ['family'] 'table' 'chain' *handle* 'handle' 'statement' ... [*comment* 'comment']
-*delete rule* ['family'] 'table' 'chain' *handle* 'handle'
+{*delete* | *reset*} *rule* ['family'] 'table' 'chain' *handle* 'handle'
+*reset rules* ['family']
+*reset rules* *table* ['family'] 'table'
+*reset rules* *chain* ['family'] 'table' ['chain']
 
 Rules are added to chains in the given table. If the family is not specified, the
 ip family is used. Rules are constructed from two kinds of components according
@@ -509,6 +512,7 @@ case the rule is inserted after the specified rule.
 beginning of the chain or before the specified rule.
 *replace*:: Similar to *add*, but the rule replaces the specified rule.
 *delete*:: Delete the specified rule.
+*reset*:: Reset rule-contained state, i.e. counter and quota statement values.
 
 .*add a rule to ip table output chain*
 -------------
diff --git a/include/cache.h b/include/cache.h
index 575381ef971bc..5bf78fe025501 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -3,6 +3,8 @@
 
 #include <string.h>
 
+struct handle;
+
 enum cache_level_bits {
 	NFT_CACHE_TABLE_BIT	= (1 << 0),
 	NFT_CACHE_CHAIN_BIT	= (1 << 1),
@@ -55,6 +57,7 @@ struct nft_cache_filter {
 		const char	*chain;
 		const char	*set;
 		const char	*ft;
+		uint64_t	rule_handle;
 	} list;
 
 	struct {
@@ -138,4 +141,8 @@ struct nft_cache {
 void nft_chain_cache_update(struct netlink_ctx *ctx, struct table *table,
 			    const char *chain);
 
+int rule_cache_dump(struct netlink_ctx *ctx, const struct handle *h,
+		    const struct nft_cache_filter *filter,
+		    bool dump, bool reset);
+
 #endif /* _NFT_CACHE_H_ */
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index e4b739d57480a..3d045030e3ad3 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -124,6 +124,7 @@ enum nf_tables_msg_types {
 	NFT_MSG_NEWFLOWTABLE,
 	NFT_MSG_GETFLOWTABLE,
 	NFT_MSG_DELFLOWTABLE,
+	NFT_MSG_GETRULE_RESET,
 	NFT_MSG_MAX,
 };
 
diff --git a/include/mnl.h b/include/mnl.h
index 8e0a7e3fccab9..c067669125395 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -34,7 +34,9 @@ int mnl_nft_rule_del(struct netlink_ctx *ctx, struct cmd *cmd);
 int mnl_nft_rule_replace(struct netlink_ctx *ctx, struct cmd *cmd);
 
 struct nftnl_rule_list *mnl_nft_rule_dump(struct netlink_ctx *ctx, int family,
-					  const char *table, const char *chain);
+					  const char *table, const char *chain,
+					  uint64_t rule_handle,
+					  bool dump, bool reset);
 
 int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
 		      unsigned int flags);
diff --git a/include/netlink.h b/include/netlink.h
index 5a7f6a1e28ef3..0d97f71ccff37 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -183,6 +183,9 @@ extern int netlink_list_flowtables(struct netlink_ctx *ctx,
 extern struct flowtable *netlink_delinearize_flowtable(struct netlink_ctx *ctx,
 						       struct nftnl_flowtable *nlo);
 
+extern int netlink_reset_rules(struct netlink_ctx *ctx, const struct cmd *cmd,
+			       bool dump);
+
 extern void netlink_dump_chain(const struct nftnl_chain *nlc,
 			       struct netlink_ctx *ctx);
 extern void netlink_dump_rule(const struct nftnl_rule *nlr,
diff --git a/include/rule.h b/include/rule.h
index d829f484a9afa..22c611f6068f3 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -620,6 +620,7 @@ enum cmd_obj {
 	CMD_OBJ_SETELEMS,
 	CMD_OBJ_SETS,
 	CMD_OBJ_RULE,
+	CMD_OBJ_RULES,
 	CMD_OBJ_CHAIN,
 	CMD_OBJ_CHAINS,
 	CMD_OBJ_TABLE,
diff --git a/src/cache.c b/src/cache.c
index 85de970f76448..d0010617cb0f0 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -263,6 +263,29 @@ static unsigned int evaluate_cache_list(struct nft_ctx *nft, struct cmd *cmd,
 	return flags;
 }
 
+static unsigned int evaluate_cache_reset(struct cmd *cmd, unsigned int flags,
+					 struct nft_cache_filter *filter)
+{
+	switch (cmd->obj) {
+	case CMD_OBJ_RULES:
+		if (filter) {
+			if (cmd->handle.table.name) {
+				filter->list.family = cmd->handle.family;
+				filter->list.table = cmd->handle.table.name;
+			}
+			if (cmd->handle.chain.name)
+				filter->list.chain = cmd->handle.chain.name;
+		}
+		flags |= NFT_CACHE_CHAIN;
+		break;
+	default:
+		flags |= NFT_CACHE_TABLE;
+		break;
+	}
+
+	return flags;
+}
+
 static int nft_handle_validate(const struct cmd *cmd, struct list_head *msgs)
 {
 	const struct handle *h = &cmd->handle;
@@ -277,6 +300,7 @@ static int nft_handle_validate(const struct cmd *cmd, struct list_head *msgs)
 		}
 		break;
 	case CMD_OBJ_RULE:
+	case CMD_OBJ_RULES:
 	case CMD_OBJ_CHAIN:
 	case CMD_OBJ_CHAINS:
 		if (h->table.name &&
@@ -403,7 +427,7 @@ int nft_cache_evaluate(struct nft_ctx *nft, struct list_head *cmds,
 			flags = evaluate_cache_get(cmd, flags);
 			break;
 		case CMD_RESET:
-			flags |= NFT_CACHE_TABLE;
+			flags |= evaluate_cache_reset(cmd, flags, filter);
 			break;
 		case CMD_LIST:
 			flags |= evaluate_cache_list(nft, cmd, flags, filter);
@@ -591,8 +615,8 @@ static int list_rule_cb(struct nftnl_rule *nlr, void *data)
 	table  = nftnl_rule_get_str(nlr, NFTNL_RULE_TABLE);
 	chain  = nftnl_rule_get_str(nlr, NFTNL_RULE_CHAIN);
 
-	if (h->family != family ||
-	    strcmp(table, h->table.name) != 0 ||
+	if ((h->family != NFPROTO_UNSPEC && h->family != family) ||
+	    (h->table.name && strcmp(table, h->table.name) != 0) ||
 	    (h->chain.name && strcmp(chain, h->chain.name) != 0))
 		return 0;
 
@@ -604,19 +628,23 @@ static int list_rule_cb(struct nftnl_rule *nlr, void *data)
 	return 0;
 }
 
-static int rule_cache_dump(struct netlink_ctx *ctx, const struct handle *h,
-			   const struct nft_cache_filter *filter)
+int rule_cache_dump(struct netlink_ctx *ctx, const struct handle *h,
+		    const struct nft_cache_filter *filter,
+		    bool dump, bool reset)
 {
 	struct nftnl_rule_list *rule_cache;
 	const char *table = NULL;
 	const char *chain = NULL;
+	uint64_t rule_handle = 0;
 
 	if (filter) {
 		table = filter->list.table;
 		chain = filter->list.chain;
+		rule_handle = filter->list.rule_handle;
 	}
 
-	rule_cache = mnl_nft_rule_dump(ctx, h->family, table, chain);
+	rule_cache = mnl_nft_rule_dump(ctx, h->family,
+				       table, chain, rule_handle, dump, reset);
 	if (rule_cache == NULL) {
 		if (errno == EINTR)
 			return -1;
@@ -948,7 +976,7 @@ static int rule_init_cache(struct netlink_ctx *ctx, struct table *table,
 	struct chain *chain;
 	int ret;
 
-	ret = rule_cache_dump(ctx, &table->handle, filter);
+	ret = rule_cache_dump(ctx, &table->handle, filter, true, false);
 
 	list_for_each_entry_safe(rule, nrule, &ctx->list, list) {
 		chain = chain_cache_find(table, rule->handle.chain.name);
diff --git a/src/evaluate.c b/src/evaluate.c
index 21de18409c873..61ebcbfc81cf7 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -5286,6 +5286,8 @@ static int cmd_evaluate_reset(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_QUOTA:
 	case CMD_OBJ_COUNTERS:
 	case CMD_OBJ_QUOTAS:
+	case CMD_OBJ_RULES:
+	case CMD_OBJ_RULE:
 		if (cmd->handle.table.name == NULL)
 			return 0;
 		if (!table_cache_find(&ctx->nft->cache.table_cache,
diff --git a/src/json.c b/src/json.c
index f57f2f77f48ec..f15461d33894c 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1911,6 +1911,7 @@ int do_command_list_json(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_SET:
 		root = do_list_set_json(ctx, cmd, table);
 		break;
+	case CMD_OBJ_RULES:
 	case CMD_OBJ_RULESET:
 		root = do_list_ruleset_json(ctx, cmd);
 		break;
diff --git a/src/mnl.c b/src/mnl.c
index 62b0b59c2da8a..0f749af066af2 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -654,13 +654,21 @@ static int rule_cb(const struct nlmsghdr *nlh, void *data)
 }
 
 struct nftnl_rule_list *mnl_nft_rule_dump(struct netlink_ctx *ctx, int family,
-					  const char *table, const char *chain)
+					  const char *table, const char *chain,
+					  uint64_t rule_handle,
+					  bool dump, bool reset)
 {
+	uint16_t nl_flags = dump ? NLM_F_DUMP : NLM_F_ACK;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nftnl_rule_list *nlr_list;
 	struct nftnl_rule *nlr = NULL;
 	struct nlmsghdr *nlh;
-	int ret;
+	int msg_type, ret;
+
+	if (reset)
+		msg_type = NFT_MSG_GETRULE_RESET;
+	else
+		msg_type = NFT_MSG_GETRULE;
 
 	if (table) {
 		nlr = nftnl_rule_alloc();
@@ -670,14 +678,16 @@ struct nftnl_rule_list *mnl_nft_rule_dump(struct netlink_ctx *ctx, int family,
 		nftnl_rule_set_str(nlr, NFTNL_RULE_TABLE, table);
 		if (chain)
 			nftnl_rule_set_str(nlr, NFTNL_RULE_CHAIN, chain);
+		if (rule_handle)
+			nftnl_rule_set_u64(nlr, NFTNL_RULE_HANDLE, rule_handle);
 	}
 
 	nlr_list = nftnl_rule_list_alloc();
 	if (nlr_list == NULL)
 		memory_allocation_error();
 
-	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETRULE, family,
-				    NLM_F_DUMP, ctx->seqnum);
+	nlh = nftnl_nlmsg_build_hdr(buf, msg_type, family,
+				    nl_flags, ctx->seqnum);
 	if (nlr) {
 		nftnl_rule_nlmsg_build_payload(nlh, nlr);
 		nftnl_rule_free(nlr);
diff --git a/src/netlink.c b/src/netlink.c
index 51de9c9c8edb2..1e0f43d8e5200 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1767,6 +1767,55 @@ int netlink_reset_objs(struct netlink_ctx *ctx, const struct cmd *cmd,
 	return err;
 }
 
+int netlink_reset_rules(struct netlink_ctx *ctx, const struct cmd *cmd,
+		        bool dump)
+{
+	const struct handle *h = &cmd->handle;
+	struct nft_cache_filter f = {
+		.list.table		= h->table.name,
+		.list.chain		= h->chain.name,
+		.list.rule_handle	= h->handle.id,
+	};
+	struct rule *rule, *next, *crule, *cnext;
+	struct table *table;
+	struct chain *chain;
+	int ret;
+
+	ret = rule_cache_dump(ctx, h, &f, dump, true);
+
+	list_for_each_entry_safe(rule, next, &ctx->list, list) {
+		table = table_cache_find(&ctx->nft->cache.table_cache,
+					 rule->handle.table.name,
+					 rule->handle.family);
+		if (!table)
+			continue;
+
+		chain = chain_cache_find(table, rule->handle.chain.name);
+		if (!chain)
+			continue;
+
+		list_del(&rule->list);
+		list_for_each_entry_safe(crule, cnext, &chain->rules, list) {
+			if (crule->handle.handle.id != rule->handle.handle.id)
+				continue;
+
+			list_replace(&crule->list, &rule->list);
+			rule_free(crule);
+			rule = NULL;
+			break;
+		}
+		if (rule) {
+			list_add_tail(&rule->list, &chain->rules);
+		}
+	}
+	list_for_each_entry_safe(rule, next, &ctx->list, list) {
+		list_del(&rule->list);
+		rule_free(rule);
+	}
+
+	return ret;
+}
+
 struct flowtable *
 netlink_delinearize_flowtable(struct netlink_ctx *ctx,
 			      struct nftnl_flowtable *nlo)
diff --git a/src/parser_bison.y b/src/parser_bison.y
index ccf07a30fbfc5..62a4809b9ee7e 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1597,6 +1597,22 @@ reset_cmd		:	COUNTERS	ruleset_spec
 			{
 				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_QUOTA, &$2, &@$, NULL);
 			}
+			|	RULES		ruleset_spec
+			{
+				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_RULES, &$2, &@$, NULL);
+			}
+			|	RULES		TABLE	table_spec
+			{
+				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_RULES, &$3, &@$, NULL);
+			}
+			|	RULES		CHAIN	chain_spec
+			{
+				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_RULES, &$3, &@$, NULL);
+			}
+			|	RULE		ruleid_spec
+			{
+				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_RULE, &$2, &@$, NULL);
+			}
 			;
 
 flush_cmd		:	TABLE		table_spec
diff --git a/src/parser_json.c b/src/parser_json.c
index ae68331424351..dfab3f9cbc7d3 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -3763,6 +3763,39 @@ static struct cmd *json_parse_cmd_list(struct json_ctx *ctx,
 	return NULL;
 }
 
+static struct cmd *json_parse_cmd_reset_rule(struct json_ctx *ctx,
+					     json_t *root, enum cmd_ops op,
+					     enum cmd_obj obj)
+{
+	struct handle h = {
+		.family = NFPROTO_UNSPEC,
+	};
+	const char *family = NULL, *table = NULL, *chain = NULL;
+
+
+	if (obj == CMD_OBJ_RULE &&
+	    json_unpack_err(ctx, root, "{s:s, s:s, s:s, s:I}",
+			    "family", &family, "table", &table,
+			    "chain", &chain, "handle", &h.handle.id))
+		return NULL;
+	else if (obj == CMD_OBJ_RULES) {
+		json_unpack(root, "{s:s}", "family", &family);
+		json_unpack(root, "{s:s}", "table", &table);
+		json_unpack(root, "{s:s}", "chain", &chain);
+	}
+
+	if (family && parse_family(family, &h.family)) {
+		json_error(ctx, "Unknown family '%s'.", family);
+		return NULL;
+	}
+	if (table) {
+		h.table.name = xstrdup(table);
+		if (chain)
+			h.chain.name = xstrdup(chain);
+	}
+	return cmd_alloc(op, obj, &h, int_loc, NULL);
+}
+
 static struct cmd *json_parse_cmd_reset(struct json_ctx *ctx,
 				        json_t *root, enum cmd_ops op)
 {
@@ -3776,6 +3809,8 @@ static struct cmd *json_parse_cmd_reset(struct json_ctx *ctx,
 		{ "counters", CMD_OBJ_COUNTERS, json_parse_cmd_list_multiple },
 		{ "quota", CMD_OBJ_QUOTA, json_parse_cmd_add_object },
 		{ "quotas", CMD_OBJ_QUOTAS, json_parse_cmd_list_multiple },
+		{ "rule", CMD_OBJ_RULE, json_parse_cmd_reset_rule },
+		{ "rules", CMD_OBJ_RULES, json_parse_cmd_reset_rule },
 	};
 	unsigned int i;
 	json_t *tmp;
diff --git a/src/rule.c b/src/rule.c
index 903c01f53825a..371c803a57c60 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -2504,6 +2504,8 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_SET:
 		return do_list_set(ctx, cmd, table);
 	case CMD_OBJ_RULESET:
+	case CMD_OBJ_RULES:
+	case CMD_OBJ_RULE:
 		return do_list_ruleset(ctx, cmd);
 	case CMD_OBJ_METERS:
 		return do_list_sets(ctx, cmd);
@@ -2611,6 +2613,14 @@ static int do_command_reset(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_QUOTA:
 		type = NFT_OBJECT_QUOTA;
 		break;
+	case CMD_OBJ_RULES:
+		ret = netlink_reset_rules(ctx, cmd, true);
+		if (ret < 0)
+			return ret;
+
+		return do_command_list(ctx, cmd);
+	case CMD_OBJ_RULE:
+		return netlink_reset_rules(ctx, cmd, false);
 	default:
 		BUG("invalid command object type %u\n", cmd->obj);
 	}
diff --git a/src/scanner.l b/src/scanner.l
index 9c85ee3769bc9..aa0a0a9f94fdf 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -402,6 +402,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 <SCANSTATE_CMD_LIST,SCANSTATE_CMD_RESET>{
 	"counters"		{ return COUNTERS; }
 	"quotas"		{ return QUOTAS; }
+	"rules"			{ return RULES; }
 }
 
 "log"			{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_LOG); return LOG; }
diff --git a/tests/shell/testcases/rule_management/0011reset_0 b/tests/shell/testcases/rule_management/0011reset_0
new file mode 100755
index 0000000000000..7e9072b00ce87
--- /dev/null
+++ b/tests/shell/testcases/rule_management/0011reset_0
@@ -0,0 +1,127 @@
+#!/bin/sh
+
+set -e
+
+echo "loading ruleset"
+$NFT -f - <<EOF
+table ip t {
+	chain c {
+		counter packets 1 bytes 11 accept
+		counter packets 2 bytes 12 drop
+	}
+
+	chain c2 {
+		counter packets 3 bytes 13 accept
+		counter packets 4 bytes 14 drop
+	}
+}
+table inet t {
+	chain c {
+		counter packets 5 bytes 15 accept
+		counter packets 6 bytes 16 drop
+	}
+}
+table ip t2 {
+	chain c2 {
+		counter packets 7 bytes 17 accept
+		counter packets 8 bytes 18 drop
+	}
+}
+EOF
+
+echo "resetting specific rule"
+handle=$($NFT -a list chain t c | sed -n 's/.*accept # handle \([0-9]*\)$/\1/p')
+$NFT reset rule t c handle $handle
+EXPECT='table ip t {
+	chain c {
+		counter packets 0 bytes 0 accept
+		counter packets 2 bytes 12 drop
+	}
+
+	chain c2 {
+		counter packets 3 bytes 13 accept
+		counter packets 4 bytes 14 drop
+	}
+}
+table inet t {
+	chain c {
+		counter packets 5 bytes 15 accept
+		counter packets 6 bytes 16 drop
+	}
+}
+table ip t2 {
+	chain c2 {
+		counter packets 7 bytes 17 accept
+		counter packets 8 bytes 18 drop
+	}
+}'
+$DIFF -u <(echo "$EXPECT") <($NFT list ruleset)
+
+echo "resetting specific chain"
+EXPECT='table ip t {
+	chain c2 {
+		counter packets 3 bytes 13 accept
+		counter packets 4 bytes 14 drop
+	}
+}'
+$DIFF -u <(echo "$EXPECT") <($NFT reset rules chain t c2)
+
+echo "resetting specific table"
+EXPECT='table ip t {
+	chain c {
+		counter packets 0 bytes 0 accept
+		counter packets 2 bytes 12 drop
+	}
+
+	chain c2 {
+		counter packets 0 bytes 0 accept
+		counter packets 0 bytes 0 drop
+	}
+}'
+$DIFF -u <(echo "$EXPECT") <($NFT reset rules table t)
+
+echo "resetting specific family"
+EXPECT='table ip t {
+	chain c {
+		counter packets 0 bytes 0 accept
+		counter packets 0 bytes 0 drop
+	}
+
+	chain c2 {
+		counter packets 0 bytes 0 accept
+		counter packets 0 bytes 0 drop
+	}
+}
+table ip t2 {
+	chain c2 {
+		counter packets 7 bytes 17 accept
+		counter packets 8 bytes 18 drop
+	}
+}'
+$DIFF -u <(echo "$EXPECT") <($NFT reset rules ip)
+
+echo "resetting whole ruleset"
+EXPECT='table ip t {
+	chain c {
+		counter packets 0 bytes 0 accept
+		counter packets 0 bytes 0 drop
+	}
+
+	chain c2 {
+		counter packets 0 bytes 0 accept
+		counter packets 0 bytes 0 drop
+	}
+}
+table inet t {
+	chain c {
+		counter packets 5 bytes 15 accept
+		counter packets 6 bytes 16 drop
+	}
+}
+table ip t2 {
+	chain c2 {
+		counter packets 0 bytes 0 accept
+		counter packets 0 bytes 0 drop
+	}
+}'
+$DIFF -u <(echo "$EXPECT") <($NFT reset rules)
diff --git a/tests/shell/testcases/rule_management/dumps/0011reset_0.nft b/tests/shell/testcases/rule_management/dumps/0011reset_0.nft
new file mode 100644
index 0000000000000..c9bbde2456ba6
--- /dev/null
+++ b/tests/shell/testcases/rule_management/dumps/0011reset_0.nft
@@ -0,0 +1,23 @@
+table ip t {
+	chain c {
+		counter packets 0 bytes 0 accept
+		counter packets 0 bytes 0 drop
+	}
+
+	chain c2 {
+		counter packets 0 bytes 0 accept
+		counter packets 0 bytes 0 drop
+	}
+}
+table inet t {
+	chain c {
+		counter packets 0 bytes 0 accept
+		counter packets 0 bytes 0 drop
+	}
+}
+table ip t2 {
+	chain c2 {
+		counter packets 0 bytes 0 accept
+		counter packets 0 bytes 0 drop
+	}
+}
-- 
2.38.0

