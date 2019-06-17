Return-Path: <SRS0=CDuC=UQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57750C31E5B
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 17:39:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B42B2084D
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 17:39:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbfFQRjp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jun 2019 13:39:45 -0400
Received: from mail.us.es ([193.147.175.20]:35818 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725995AbfFQRjp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 13:39:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4BC6BC329A
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jun 2019 19:39:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3A3F4DA70B
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jun 2019 19:39:41 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2FAE8DA708; Mon, 17 Jun 2019 19:39:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D090DDA70D;
        Mon, 17 Jun 2019 19:39:38 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 17 Jun 2019 19:39:38 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A80144265A32;
        Mon, 17 Jun 2019 19:39:38 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc, fw@strlen.de
Subject: [PATCH nft 5/5,v3] src: add cache level flags
Date:   Mon, 17 Jun 2019 19:39:36 +0200
Message-Id: <20190617173936.14067-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The score approach based on command type is confusing.

This patch introduces cache level flags, each flag specifies what kind
of object type is needed. These flags are set on/off depending on the
list of commands coming in this batch.

cache_is_complete() now checks if the cache contains the objects that
are needed through these new flags.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: adjust rule_evaluate() to use NFT_CACHE_RULE, per Phil Sutter.

 include/Makefile.am |   1 +
 include/cache.h     |  35 +++++++++++++++++
 include/nftables.h  |   2 +-
 include/rule.h      |   3 +-
 src/cache.c         |  86 ++++++++++++++++++++++--------------------
 src/evaluate.c      |   3 +-
 src/libnftables.c   |   6 +--
 src/rule.c          | 106 +++++++++++++++++++++++-----------------------------
 8 files changed, 135 insertions(+), 107 deletions(-)
 create mode 100644 include/cache.h

diff --git a/include/Makefile.am b/include/Makefile.am
index b1f4fcf29015..2d77a768acb0 100644
--- a/include/Makefile.am
+++ b/include/Makefile.am
@@ -2,6 +2,7 @@ SUBDIRS =		linux		\
 			nftables
 
 noinst_HEADERS = 	cli.h		\
+			cache.h		\
 			datatype.h	\
 			expression.h	\
 			fib.h		\
diff --git a/include/cache.h b/include/cache.h
new file mode 100644
index 000000000000..d3502a8a6039
--- /dev/null
+++ b/include/cache.h
@@ -0,0 +1,35 @@
+#ifndef _NFT_CACHE_H_
+#define _NFT_CACHE_H_
+
+enum cache_level_bits {
+	NFT_CACHE_TABLE_BIT	= (1 << 0),
+	NFT_CACHE_CHAIN_BIT	= (1 << 1),
+	NFT_CACHE_SET_BIT	= (1 << 2),
+	NFT_CACHE_FLOWTABLE_BIT	= (1 << 3),
+	NFT_CACHE_OBJECT_BIT	= (1 << 4),
+	NFT_CACHE_SETELEM_BIT	= (1 << 5),
+	NFT_CACHE_RULE_BIT	= (1 << 6),
+	__NFT_CACHE_MAX_BIT	= (1 << 7),
+};
+
+enum cache_level_flags {
+	NFT_CACHE_EMPTY		= 0,
+	NFT_CACHE_TABLE		= NFT_CACHE_TABLE_BIT,
+	NFT_CACHE_CHAIN		= NFT_CACHE_TABLE_BIT |
+				  NFT_CACHE_CHAIN_BIT,
+	NFT_CACHE_SET		= NFT_CACHE_TABLE_BIT |
+				  NFT_CACHE_SET_BIT,
+	NFT_CACHE_FLOWTABLE	= NFT_CACHE_TABLE_BIT |
+				  NFT_CACHE_FLOWTABLE_BIT,
+	NFT_CACHE_OBJECT	= NFT_CACHE_TABLE_BIT |
+				  NFT_CACHE_OBJECT_BIT,
+	NFT_CACHE_SETELEM	= NFT_CACHE_TABLE_BIT |
+				  NFT_CACHE_SET_BIT |
+				  NFT_CACHE_SETELEM_BIT,
+	NFT_CACHE_RULE		= NFT_CACHE_TABLE_BIT |
+				  NFT_CACHE_CHAIN_BIT |
+				  NFT_CACHE_RULE_BIT,
+	NFT_CACHE_FULL		= __NFT_CACHE_MAX_BIT - 1,
+};
+
+#endif /* _NFT_CACHE_H_ */
diff --git a/include/nftables.h b/include/nftables.h
index b7c78572da77..ed446e2d16cf 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -81,7 +81,7 @@ struct nft_cache {
 	uint32_t		genid;
 	struct list_head	list;
 	uint32_t		seqnum;
-	uint32_t		cmd;
+	uint32_t		flags;
 };
 
 struct mnl_socket;
diff --git a/include/rule.h b/include/rule.h
index 299485ffeeaa..aefb24d95163 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -462,7 +462,6 @@ enum cmd_ops {
 	CMD_EXPORT,
 	CMD_MONITOR,
 	CMD_DESCRIBE,
-	__CMD_FLUSH_RULESET,
 };
 
 /**
@@ -636,7 +635,7 @@ extern struct error_record *rule_postprocess(struct rule *rule);
 struct netlink_ctx;
 extern int do_command(struct netlink_ctx *ctx, struct cmd *cmd);
 
-extern int cache_evaluate(struct nft_ctx *nft, struct list_head *cmds);
+extern unsigned int cache_evaluate(struct nft_ctx *nft, struct list_head *cmds);
 extern int cache_update(struct nft_ctx *ctx, enum cmd_ops cmd,
 			struct list_head *msgs);
 extern void cache_flush(struct nft_ctx *ctx, struct list_head *msgs);
diff --git a/src/cache.c b/src/cache.c
index d7153f6f6b8f..d371c5488d1b 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -11,112 +11,116 @@
 #include <rule.h>
 #include <erec.h>
 #include <utils.h>
+#include <cache.h>
 
-static unsigned int evaluate_cache_add(struct cmd *cmd)
+static unsigned int evaluate_cache_add(struct cmd *cmd, unsigned int flags)
 {
-	unsigned int completeness = CMD_INVALID;
-
 	switch (cmd->obj) {
 	case CMD_OBJ_SETELEM:
-	case CMD_OBJ_SET:
-	case CMD_OBJ_CHAIN:
-	case CMD_OBJ_FLOWTABLE:
-		completeness = cmd->op;
+		flags |= NFT_CACHE_SETELEM;
 		break;
 	case CMD_OBJ_RULE:
-		if (cmd->handle.index.id)
-			completeness = CMD_LIST;
+		if (cmd->handle.index.id ||
+		    cmd->handle.position.id)
+			flags |= NFT_CACHE_RULE;
 		break;
 	default:
 		break;
 	}
 
-	return completeness;
+	return flags;
 }
 
-static unsigned int evaluate_cache_del(struct cmd *cmd)
+static unsigned int evaluate_cache_del(struct cmd *cmd, unsigned int flags)
 {
-	unsigned int completeness = CMD_INVALID;
-
 	switch (cmd->obj) {
 	case CMD_OBJ_SETELEM:
-		completeness = cmd->op;
+		flags |= NFT_CACHE_SETELEM;
 		break;
 	default:
 		break;
 	}
 
-	return completeness;
+	return flags;
 }
 
-static unsigned int evaluate_cache_flush(struct cmd *cmd)
+static unsigned int evaluate_cache_flush(struct cmd *cmd, unsigned int flags)
 {
-	unsigned int completeness = CMD_INVALID;
-
 	switch (cmd->obj) {
-	case CMD_OBJ_RULESET:
-		completeness = __CMD_FLUSH_RULESET;
-		break;
 	case CMD_OBJ_SET:
 	case CMD_OBJ_MAP:
 	case CMD_OBJ_METER:
-		completeness = cmd->op;
+		flags |= NFT_CACHE_SET;
 		break;
+	case CMD_OBJ_RULESET:
 	default:
+		flags = NFT_CACHE_EMPTY;
 		break;
 	}
 
-	return completeness;
+	return flags;
 }
 
-static unsigned int evaluate_cache_rename(struct cmd *cmd)
+static unsigned int evaluate_cache_rename(struct cmd *cmd, unsigned int flags)
 {
-	unsigned int completeness = CMD_INVALID;
-
 	switch (cmd->obj) {
 	case CMD_OBJ_CHAIN:
-		completeness = cmd->op;
+		flags |= NFT_CACHE_CHAIN;
 		break;
 	default:
 		break;
 	}
 
-	return completeness;
+	return flags;
 }
 
-int cache_evaluate(struct nft_ctx *nft, struct list_head *cmds)
+unsigned int cache_evaluate(struct nft_ctx *nft, struct list_head *cmds)
 {
-	unsigned int echo_completeness = CMD_INVALID;
-	unsigned int completeness = CMD_INVALID;
+	unsigned int flags = NFT_CACHE_EMPTY;
 	struct cmd *cmd;
 
 	list_for_each_entry(cmd, cmds, list) {
 		switch (cmd->op) {
 		case CMD_ADD:
 		case CMD_INSERT:
-		case CMD_REPLACE:
-			if (nft_output_echo(&nft->output))
-				echo_completeness = cmd->op;
-
+			if (nft_output_echo(&nft->output)) {
+				flags = NFT_CACHE_FULL;
+				break;
+			}
+
+			flags |= NFT_CACHE_TABLE |
+				 NFT_CACHE_CHAIN |
+				 NFT_CACHE_SET |
+				 NFT_CACHE_FLOWTABLE |
+				 NFT_CACHE_OBJECT;
 			/* Fall through */
 		case CMD_CREATE:
-			completeness = evaluate_cache_add(cmd);
+			flags = evaluate_cache_add(cmd, flags);
+			break;
+		case CMD_REPLACE:
+			flags = NFT_CACHE_FULL;
 			break;
 		case CMD_DELETE:
-			completeness = evaluate_cache_del(cmd);
+			flags |= NFT_CACHE_TABLE |
+				 NFT_CACHE_CHAIN |
+				 NFT_CACHE_SET |
+				 NFT_CACHE_FLOWTABLE |
+				 NFT_CACHE_OBJECT;
+
+			flags = evaluate_cache_del(cmd, flags);
 			break;
 		case CMD_GET:
 		case CMD_LIST:
 		case CMD_RESET:
 		case CMD_EXPORT:
 		case CMD_MONITOR:
-			completeness = cmd->op;
+			flags |= NFT_CACHE_FULL;
 			break;
 		case CMD_FLUSH:
-			completeness = evaluate_cache_flush(cmd);
+			flags = evaluate_cache_flush(cmd, flags);
 			break;
 		case CMD_RENAME:
-			completeness = evaluate_cache_rename(cmd);
+			flags = evaluate_cache_rename(cmd, flags);
 			break;
 		case CMD_DESCRIBE:
 		case CMD_IMPORT:
@@ -126,5 +130,5 @@ int cache_evaluate(struct nft_ctx *nft, struct list_head *cmds)
 		}
 	}
 
-	return max(completeness, echo_completeness);
+	return flags;
 }
diff --git a/src/evaluate.c b/src/evaluate.c
index 73a4be339ce1..511f9f14bedd 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -29,6 +29,7 @@
 #include <netlink.h>
 #include <time.h>
 #include <rule.h>
+#include <cache.h>
 #include <erec.h>
 #include <gmputil.h>
 #include <utils.h>
@@ -3294,7 +3295,7 @@ static int rule_evaluate(struct eval_ctx *ctx, struct rule *rule,
 	}
 
 	/* add rules to cache only if it is complete enough to contain them */
-	if (!cache_is_complete(&ctx->nft->cache, CMD_LIST))
+	if (!cache_is_complete(&ctx->nft->cache, NFT_CACHE_RULE))
 		return 0;
 
 	return rule_cache_update(ctx, op);
diff --git a/src/libnftables.c b/src/libnftables.c
index abd133bee127..dccb8ab4da42 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -381,11 +381,11 @@ static int nft_parse_bison_filename(struct nft_ctx *nft, const char *filename,
 static int nft_evaluate(struct nft_ctx *nft, struct list_head *msgs,
 			struct list_head *cmds)
 {
-	unsigned int completeness;
+	unsigned int flags;
 	struct cmd *cmd;
 
-	completeness = cache_evaluate(nft, cmds);
-	if (cache_update(nft, completeness, msgs) < 0)
+	flags = cache_evaluate(nft, cmds);
+	if (cache_update(nft, flags, msgs) < 0)
 		return -1;
 
 	list_for_each_entry(cmd, cmds, list) {
diff --git a/src/rule.c b/src/rule.c
index ed199889702f..f60374abcfbc 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -24,6 +24,7 @@
 #include <mnl.h>
 #include <misspell.h>
 #include <json.h>
+#include <cache.h>
 
 #include <libnftnl/common.h>
 #include <libnftnl/ruleset.h>
@@ -147,97 +148,85 @@ static int cache_init_tables(struct netlink_ctx *ctx, struct handle *h,
 	return 0;
 }
 
-static int cache_init_objects(struct netlink_ctx *ctx, enum cmd_ops cmd)
+static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags)
 {
+	struct rule *rule, *nrule;
 	struct table *table;
 	struct chain *chain;
-	struct rule *rule, *nrule;
 	struct set *set;
 	int ret;
 
 	list_for_each_entry(table, &ctx->nft->cache.list, list) {
-		ret = netlink_list_sets(ctx, &table->handle);
-		list_splice_tail_init(&ctx->list, &table->sets);
-
-		if (ret < 0)
-			return -1;
-
-		list_for_each_entry(set, &table->sets, list) {
-			ret = netlink_list_setelems(ctx, &set->handle, set);
+		if (flags & NFT_CACHE_SET_BIT) {
+			ret = netlink_list_sets(ctx, &table->handle);
+			list_splice_tail_init(&ctx->list, &table->sets);
 			if (ret < 0)
 				return -1;
 		}
-
-		ret = netlink_list_chains(ctx, &table->handle);
-		if (ret < 0)
-			return -1;
-		list_splice_tail_init(&ctx->list, &table->chains);
-
-		ret = netlink_list_flowtables(ctx, &table->handle);
-		if (ret < 0)
-			return -1;
-		list_splice_tail_init(&ctx->list, &table->flowtables);
-
-		if (cmd != CMD_RESET) {
+		if (flags & NFT_CACHE_SETELEM_BIT) {
+			list_for_each_entry(set, &table->sets, list) {
+				ret = netlink_list_setelems(ctx, &set->handle,
+							    set);
+				if (ret < 0)
+					return -1;
+			}
+		}
+		if (flags & NFT_CACHE_CHAIN_BIT) {
+			ret = netlink_list_chains(ctx, &table->handle);
+			if (ret < 0)
+				return -1;
+			list_splice_tail_init(&ctx->list, &table->chains);
+		}
+		if (flags & NFT_CACHE_FLOWTABLE_BIT) {
+			ret = netlink_list_flowtables(ctx, &table->handle);
+			if (ret < 0)
+				return -1;
+			list_splice_tail_init(&ctx->list, &table->flowtables);
+		}
+		if (flags & NFT_CACHE_OBJECT_BIT) {
 			ret = netlink_list_objs(ctx, &table->handle);
 			if (ret < 0)
 				return -1;
 			list_splice_tail_init(&ctx->list, &table->objs);
 		}
 
-		/* Skip caching other objects to speed up things: We only need
-		 * a full cache when listing the existing ruleset.
-		 */
-		if (cmd != CMD_LIST)
-			continue;
-
-		ret = netlink_list_rules(ctx, &table->handle);
-		list_for_each_entry_safe(rule, nrule, &ctx->list, list) {
-			chain = chain_lookup(table, &rule->handle);
-			list_move_tail(&rule->list, &chain->rules);
+		if (flags & NFT_CACHE_RULE_BIT) {
+			ret = netlink_list_rules(ctx, &table->handle);
+			list_for_each_entry_safe(rule, nrule, &ctx->list, list) {
+				chain = chain_lookup(table, &rule->handle);
+				list_move_tail(&rule->list, &chain->rules);
+			}
+			if (ret < 0)
+				return -1;
 		}
-
-		if (ret < 0)
-			return -1;
 	}
 	return 0;
 }
 
-static int cache_init(struct netlink_ctx *ctx, enum cmd_ops cmd)
+static int cache_init(struct netlink_ctx *ctx, unsigned int flags)
 {
 	struct handle handle = {
 		.family = NFPROTO_UNSPEC,
 	};
 	int ret;
 
-	if (cmd == __CMD_FLUSH_RULESET)
+	if (flags == NFT_CACHE_EMPTY)
 		return 0;
 
+	/* assume NFT_CACHE_TABLE is always set. */
 	ret = cache_init_tables(ctx, &handle, &ctx->nft->cache);
 	if (ret < 0)
 		return ret;
-	ret = cache_init_objects(ctx, cmd);
+	ret = cache_init_objects(ctx, flags);
 	if (ret < 0)
 		return ret;
 
 	return 0;
 }
 
-/* Return a "score" of how complete local cache will be if
- * cache_init_objects() ran for given cmd. Higher value
- * means more complete. */
-static int cache_completeness(enum cmd_ops cmd)
+bool cache_is_complete(struct nft_cache *cache, unsigned int flags)
 {
-	if (cmd == CMD_LIST)
-		return 3;
-	if (cmd != CMD_RESET)
-		return 2;
-	return 1;
-}
-
-bool cache_is_complete(struct nft_cache *cache, enum cmd_ops cmd)
-{
-	return cache_completeness(cache->cmd) >= cache_completeness(cmd);
+	return (cache->flags & flags) == flags;
 }
 
 static bool cache_is_updated(struct nft_cache *cache, uint16_t genid)
@@ -245,7 +234,7 @@ static bool cache_is_updated(struct nft_cache *cache, uint16_t genid)
 	return genid && genid == cache->genid;
 }
 
-int cache_update(struct nft_ctx *nft, enum cmd_ops cmd, struct list_head *msgs)
+int cache_update(struct nft_ctx *nft, unsigned int flags, struct list_head *msgs)
 {
 	struct netlink_ctx ctx = {
 		.list		= LIST_HEAD_INIT(ctx.list),
@@ -259,14 +248,14 @@ int cache_update(struct nft_ctx *nft, enum cmd_ops cmd, struct list_head *msgs)
 replay:
 	ctx.seqnum = cache->seqnum++;
 	genid = mnl_genid_get(&ctx);
-	if (cache_is_complete(cache, cmd) &&
+	if (cache_is_complete(cache, flags) &&
 	    cache_is_updated(cache, genid))
 		return 0;
 
 	if (cache->genid)
 		cache_release(cache);
 
-	ret = cache_init(&ctx, cmd);
+	ret = cache_init(&ctx, flags);
 	if (ret < 0) {
 		cache_release(cache);
 		if (errno == EINTR) {
@@ -283,7 +272,7 @@ replay:
 	}
 
 	cache->genid = genid;
-	cache->cmd = cmd;
+	cache->flags = flags;
 	return 0;
 }
 
@@ -308,15 +297,14 @@ void cache_flush(struct nft_ctx *nft, struct list_head *msgs)
 
 	__cache_flush(&cache->list);
 	cache->genid = mnl_genid_get(&ctx);
-	cache->cmd = CMD_LIST;
+	cache->flags = NFT_CACHE_FULL;
 }
 
 void cache_release(struct nft_cache *cache)
 {
 	__cache_flush(&cache->list);
 	cache->genid = 0;
-	cache->cmd = CMD_INVALID;
-
+	cache->flags = NFT_CACHE_EMPTY;
 }
 
 /* internal ID to uniquely identify a set in the batch */
-- 
2.11.0

