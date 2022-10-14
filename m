Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FCEAC4332F
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Oct 2022 21:47:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiJNVrh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 Oct 2022 17:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbiJNVrJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Oct 2022 17:47:09 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB43E1DED4E
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Oct 2022 14:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5JfcU7dPd9z404HCLwsAEpsHaChNRLXPkvLizMGyp7I=; b=lpoyvVW1Qk9JXr39TKDkhdaO0B
        oSK90+i9UnilWrxA1c/oaYI2MrBfFoR7aYdyhkG7pvqNjs6ywDPqNZXmz/DtGJE0dIdaiPmVD0ze9
        GWmAxCu7cSSE2VjtcLlAoYkTo2EvGi8UIa8zIWr+9OyivnByWRtF7q601FihBMjV6NJCzjj1ECVSJ
        Nrp0x6DtSqLMvDEcG5eyQ1U+XY5NrGIPLHZNNEXHLyrro80z8GRi2qx7FoJeEPqsVNpAkyifbO+Fa
        7JvyIem4uBDZF620xisbEH7OxLt4b9OqS1pOSRqeSZ85OHynYSHQwF6XgYwyJRGE1PXz1s/NOF7g1
        8nFALubg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1ojSVi-0000aR-Fn; Fri, 14 Oct 2022 23:46:30 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] Implement 'reset rule' and 'reset rules' commands
Date:   Fri, 14 Oct 2022 23:46:21 +0200
Message-Id: <20221014214621.22838-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
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
 doc/libnftables-json.adoc           |  2 +-
 doc/nft.txt                         |  6 +++-
 include/cache.h                     |  7 +++++
 include/linux/netfilter/nf_tables.h |  1 +
 include/mnl.h                       |  4 ++-
 include/netlink.h                   |  3 ++
 include/rule.h                      |  1 +
 src/cache.c                         | 40 +++++++++++++++++++----
 src/evaluate.c                      |  2 ++
 src/json.c                          |  1 +
 src/mnl.c                           | 18 ++++++++---
 src/netlink.c                       | 49 +++++++++++++++++++++++++++++
 src/parser_bison.y                  | 16 ++++++++++
 src/parser_json.c                   | 36 +++++++++++++++++++++
 src/rule.c                          | 10 ++++++
 src/scanner.l                       |  1 +
 16 files changed, 184 insertions(+), 13 deletions(-)

diff --git a/doc/libnftables-json.adoc b/doc/libnftables-json.adoc
index bb59945fc510d..57c8c362b4cee 100644
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
index 02cf13a57c2e7..299558adc685d 100644
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
index 575381ef971bc..ea522963cc842 100644
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
+		uint64_t	rule_id;
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
index 466fd3f4447c2..713ce327e381e 100644
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
index 8e0a7e3fccab9..849b6155b3ca9 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -34,7 +34,9 @@ int mnl_nft_rule_del(struct netlink_ctx *ctx, struct cmd *cmd);
 int mnl_nft_rule_replace(struct netlink_ctx *ctx, struct cmd *cmd);
 
 struct nftnl_rule_list *mnl_nft_rule_dump(struct netlink_ctx *ctx, int family,
-					  const char *table, const char *chain);
+					  const char *table, const char *chain,
+					  uint64_t rule_id,
+					  bool dump, bool reset);
 
 int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
 		      unsigned int flags);
diff --git a/include/netlink.h b/include/netlink.h
index 63d07edf419ea..db7639b38c02b 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -176,6 +176,9 @@ extern int netlink_list_flowtables(struct netlink_ctx *ctx,
 extern struct flowtable *netlink_delinearize_flowtable(struct netlink_ctx *ctx,
 						       struct nftnl_flowtable *nlo);
 
+extern int netlink_reset_rules(struct netlink_ctx *ctx, const struct cmd *cmd,
+			       bool dump);
+
 extern void netlink_dump_chain(const struct nftnl_chain *nlc,
 			       struct netlink_ctx *ctx);
 extern void netlink_dump_rule(const struct nftnl_rule *nlr,
diff --git a/include/rule.h b/include/rule.h
index 00a1bac5a7737..f8dcadae23fce 100644
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
index 85de970f76448..a878e4cc8ee2d 100644
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
+		flags |= NFT_CACHE_RULE;
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
@@ -592,7 +616,7 @@ static int list_rule_cb(struct nftnl_rule *nlr, void *data)
 	chain  = nftnl_rule_get_str(nlr, NFTNL_RULE_CHAIN);
 
 	if (h->family != family ||
-	    strcmp(table, h->table.name) != 0 ||
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
+	uint64_t rule_id = 0;
 
 	if (filter) {
 		table = filter->list.table;
 		chain = filter->list.chain;
+		rule_id = filter->list.rule_id;
 	}
 
-	rule_cache = mnl_nft_rule_dump(ctx, h->family, table, chain);
+	rule_cache = mnl_nft_rule_dump(ctx, h->family,
+				       table, chain, rule_id, dump, reset);
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
index a52867b33be01..c4c446f08d889 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -5125,6 +5125,8 @@ static int cmd_evaluate_reset(struct eval_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_QUOTA:
 	case CMD_OBJ_COUNTERS:
 	case CMD_OBJ_QUOTAS:
+	case CMD_OBJ_RULES:
+	case CMD_OBJ_RULE:
 		if (cmd->handle.table.name == NULL)
 			return 0;
 		if (!table_cache_find(&ctx->nft->cache.table_cache,
diff --git a/src/json.c b/src/json.c
index 6662f8087736a..a20363037003f 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1896,6 +1896,7 @@ int do_command_list_json(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_SET:
 		root = do_list_set_json(ctx, cmd, table);
 		break;
+	case CMD_OBJ_RULES:
 	case CMD_OBJ_RULESET:
 		root = do_list_ruleset_json(ctx, cmd);
 		break;
diff --git a/src/mnl.c b/src/mnl.c
index e87b033870b0f..e9a42370dd5fc 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -654,13 +654,21 @@ static int rule_cb(const struct nlmsghdr *nlh, void *data)
 }
 
 struct nftnl_rule_list *mnl_nft_rule_dump(struct netlink_ctx *ctx, int family,
-					  const char *table, const char *chain)
+					  const char *table, const char *chain,
+					  uint64_t rule_id,
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
+		if (rule_id)
+			nftnl_rule_set_u64(nlr, NFTNL_RULE_HANDLE, rule_id);
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
index 799cf9b8ebefb..9ae78ca12afea 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1677,6 +1677,55 @@ int netlink_reset_objs(struct netlink_ctx *ctx, const struct cmd *cmd,
 	return err;
 }
 
+int netlink_reset_rules(struct netlink_ctx *ctx, const struct cmd *cmd,
+		        bool dump)
+{
+	const struct handle *h = &cmd->handle;
+	struct nft_cache_filter f = {
+		.list.table = h->table.name,
+		.list.chain = h->chain.name,
+		.list.rule_id = h->handle.id,
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
index 0266819a779b6..630d864cc5104 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1564,6 +1564,22 @@ reset_cmd		:	COUNTERS	ruleset_spec
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
index 76c268f857202..29c8e43274a3a 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -3673,6 +3673,7 @@ static struct cmd *json_parse_cmd_list_multiple(struct json_ctx *ctx,
 	};
 	const char *tmp;
 
+
 	if (!json_unpack(root, "{s:s}", "family", &tmp)) {
 		if (parse_family(tmp, &h.family)) {
 			json_error(ctx, "Unknown family '%s'.", tmp);
@@ -3750,6 +3751,39 @@ static struct cmd *json_parse_cmd_list(struct json_ctx *ctx,
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
@@ -3763,6 +3797,8 @@ static struct cmd *json_parse_cmd_reset(struct json_ctx *ctx,
 		{ "counters", CMD_OBJ_COUNTERS, json_parse_cmd_list_multiple },
 		{ "quota", CMD_OBJ_QUOTA, json_parse_cmd_add_object },
 		{ "quotas", CMD_OBJ_QUOTAS, json_parse_cmd_list_multiple },
+		{ "rule", CMD_OBJ_RULE, json_parse_cmd_reset_rule },
+		{ "rules", CMD_OBJ_RULES, json_parse_cmd_reset_rule },
 	};
 	unsigned int i;
 	json_t *tmp;
diff --git a/src/rule.c b/src/rule.c
index e9f9b232aa244..fb322ee333c5f 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -2498,6 +2498,8 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
 	case CMD_OBJ_SET:
 		return do_list_set(ctx, cmd, table);
 	case CMD_OBJ_RULESET:
+	case CMD_OBJ_RULES:
+	case CMD_OBJ_RULE:
 		return do_list_ruleset(ctx, cmd);
 	case CMD_OBJ_METERS:
 		return do_list_sets(ctx, cmd);
@@ -2605,6 +2607,14 @@ static int do_command_reset(struct netlink_ctx *ctx, struct cmd *cmd)
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
index 1371cd044b65a..b4d63564d1070 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -400,6 +400,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 <SCANSTATE_CMD_LIST,SCANSTATE_CMD_RESET>{
 	"counters"		{ return COUNTERS; }
 	"quotas"		{ return QUOTAS; }
+	"rules"			{ return RULES; }
 }
 
 "log"			{ scanner_push_start_cond(yyscanner, SCANSTATE_STMT_LOG); return LOG; }
-- 
2.34.1

