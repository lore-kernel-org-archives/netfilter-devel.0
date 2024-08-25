Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8F1176046
	for <netfilter-devel@vger.kernel.org>; Sun, 25 Aug 2024 22:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724626043; cv=none; b=RAPh2x6+pXtLhGqFIuQFdesiVT7VBR00PtByMKSMGHXpsk90WfbcUuFxKzvXBqklH7EPUYvkTH8foG8cvSxQMNKa9af6GF3hVB/eqYd5YAbhmqJaVOd4QLUX/myigG7Gma4chsUsOB7ZQ5t3uQbpu+PpZGHoCwghLsyINq4KaPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724626043; c=relaxed/simple;
	bh=9aVysyLY7CPsN94082IATo4aHtPrP526vQIBzMLtaxg=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JZI47LU9KkPRbVvBe8eGbL8JyWg6Oh+J60C8JftwdH5qCGUeGLCFFgnUAzEt+gTzyopK8CTG1M8awyEfPm9syUrq1LGpmyHCDdFTS8FxXzI06wwbqx7L9gt5y6sUtSdZalEJeh/xUNmdcqVKDS8bDi7j7ktb7AgwLr9oYjcnG8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 3/5] cache: consolidate reset command
Date: Mon, 26 Aug 2024 00:47:05 +0200
Message-Id: <20240825224707.3687-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240825224707.3687-1-pablo@netfilter.org>
References: <20240825224707.3687-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reset command does not utilize the cache infrastructure.

This implicitly fixes a crash with anonymous sets because elements are
not fetched. I initially tried to fix it by toggling the missing cache
flags, but then ASAN reports memleaks.

To address these issues relies on Phil's list filtering infrastructure
which updates is expanded to accomodate filtering requirements of the
reset commands, such as 'reset table ip' where only the family is sent
to the kernel.

After this update, tests/shell reports a few inconsistencies between
reset and list commands:

- reset rules chain t c2

  display sets, but it should only list the given chain.

- reset rules table t
  reset rules ip

  do not list elements in the set. In both cases, these are fully
  listing a given table and family, elements should be included.

The consolidation also ensures list and reset will not differ.

A few more notes:

- CMD_OBJ_TABLE is used for:

	rules family table

  from the parser, due to the lack of a better enum, same applies to
  CMD_OBJ_CHAIN.

- CMD_OBJ_ELEMENTS still does not use the cache, but same occurs in
  the CMD_GET command case which needs to be consolidated.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1763
Fixes: 83e0f4402fb7 ("Implement 'reset {set,map,element}' commands")
Fixes: 1694df2de79f ("Implement 'reset rule' and 'reset rules' commands")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/cache.h                               | 10 ++-
 include/netlink.h                             |  5 --
 src/cache.c                                   | 65 ++++++++++++----
 src/evaluate.c                                |  2 +
 src/mnl.c                                     |  7 +-
 src/netlink.c                                 | 78 -------------------
 src/parser_bison.y                            |  8 +-
 src/rule.c                                    | 48 +-----------
 .../testcases/rule_management/0011reset_0     | 10 +--
 9 files changed, 69 insertions(+), 164 deletions(-)

diff --git a/include/cache.h b/include/cache.h
index c72bedf542dc..e6bde6c6bee3 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -64,6 +64,12 @@ struct nft_cache_filter {
 	struct {
 		struct list_head head;
 	} obj[NFT_CACHE_HSIZE];
+
+	struct {
+		bool		obj;
+		bool		rule;
+		bool		elem;
+	} reset;
 };
 
 struct nft_cache;
@@ -149,8 +155,4 @@ struct netlink_ctx;
 void nft_chain_cache_update(struct netlink_ctx *ctx, struct table *table,
 			    const char *chain);
 
-int rule_cache_dump(struct netlink_ctx *ctx, const struct handle *h,
-		    const struct nft_cache_filter *filter,
-		    bool dump, bool reset);
-
 #endif /* _NFT_CACHE_H_ */
diff --git a/include/netlink.h b/include/netlink.h
index 27a62462bf7d..cf7ba3693885 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -176,8 +176,6 @@ extern int netlink_delinearize_setelem(struct nftnl_set_elem *nlse,
 				       struct nft_cache *cache);
 
 extern int netlink_list_objs(struct netlink_ctx *ctx, const struct handle *h);
-extern int netlink_reset_objs(struct netlink_ctx *ctx, const struct cmd *cmd,
-			      uint32_t type, bool dump);
 extern struct obj *netlink_delinearize_obj(struct netlink_ctx *ctx,
 					   struct nftnl_obj *nlo);
 
@@ -186,9 +184,6 @@ extern int netlink_list_flowtables(struct netlink_ctx *ctx,
 extern struct flowtable *netlink_delinearize_flowtable(struct netlink_ctx *ctx,
 						       struct nftnl_flowtable *nlo);
 
-extern int netlink_reset_rules(struct netlink_ctx *ctx, const struct cmd *cmd,
-			       bool dump);
-
 extern void netlink_dump_chain(const struct nftnl_chain *nlc,
 			       struct netlink_ctx *ctx);
 extern void netlink_dump_rule(const struct nftnl_rule *nlr,
diff --git a/src/cache.c b/src/cache.c
index 3b664ee77d04..f408fe45d9f4 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -315,6 +315,8 @@ static unsigned int evaluate_cache_reset(struct cmd *cmd, unsigned int flags,
 					 struct nft_cache_filter *filter)
 {
 	switch (cmd->obj) {
+	case CMD_OBJ_TABLE:
+	case CMD_OBJ_CHAIN:
 	case CMD_OBJ_RULES:
 	case CMD_OBJ_RULE:
 		if (filter) {
@@ -324,17 +326,36 @@ static unsigned int evaluate_cache_reset(struct cmd *cmd, unsigned int flags,
 			}
 			if (cmd->handle.chain.name)
 				filter->list.chain = cmd->handle.chain.name;
+			if (cmd->handle.family)
+				filter->list.family = cmd->handle.family;
+			if (cmd->handle.handle.id)
+				filter->list.rule_handle = cmd->handle.handle.id;
 		}
-		flags |= NFT_CACHE_SET | NFT_CACHE_FLOWTABLE |
-			 NFT_CACHE_OBJECT | NFT_CACHE_CHAIN;
+		filter->reset.rule = true;
+		flags |= NFT_CACHE_FULL;
+		break;
+	case CMD_OBJ_COUNTER:
+	case CMD_OBJ_COUNTERS:
+		obj_filter_setup(cmd, &flags, filter, NFT_OBJECT_COUNTER);
+		filter->reset.obj = true;
+		break;
+	case CMD_OBJ_QUOTA:
+	case CMD_OBJ_QUOTAS:
+		obj_filter_setup(cmd, &flags, filter, NFT_OBJECT_QUOTA);
+		filter->reset.obj = true;
 		break;
-	case CMD_OBJ_ELEMENTS:
 	case CMD_OBJ_SET:
 	case CMD_OBJ_MAP:
-		flags |= NFT_CACHE_SET;
+		if (filter && cmd->handle.table.name && cmd->handle.set.name) {
+			filter->list.family = cmd->handle.family;
+			filter->list.table = cmd->handle.table.name;
+			filter->list.set = cmd->handle.set.name;
+		}
+		flags |= NFT_CACHE_SETELEM;
+		filter->reset.elem = true;
 		break;
 	default:
-		flags |= NFT_CACHE_TABLE;
+		flags |= NFT_CACHE_FULL;
 		break;
 	}
 	flags |= NFT_CACHE_REFRESH;
@@ -683,23 +704,32 @@ static int list_rule_cb(struct nftnl_rule *nlr, void *data)
 	return 0;
 }
 
-int rule_cache_dump(struct netlink_ctx *ctx, const struct handle *h,
-		    const struct nft_cache_filter *filter,
-		    bool dump, bool reset)
+static int rule_cache_dump(struct netlink_ctx *ctx, const struct handle *h,
+			   const struct nft_cache_filter *filter)
 {
 	struct nftnl_rule_list *rule_cache;
 	const char *table = h->table.name;
 	const char *chain = NULL;
 	uint64_t rule_handle = 0;
+	int family = h->family;
+	bool dump = true;
 
 	if (filter) {
-		table = filter->list.table;
-		chain = filter->list.chain;
-		rule_handle = filter->list.rule_handle;
+		if (filter->list.table)
+			table = filter->list.table;
+		if (filter->list.chain)
+			chain = filter->list.chain;
+		if (filter->list.rule_handle) {
+			rule_handle = filter->list.rule_handle;
+			dump = false;
+		}
+		if (filter->list.family)
+			family = filter->list.family;
 	}
 
-	rule_cache = mnl_nft_rule_dump(ctx, h->family,
-				       table, chain, rule_handle, dump, reset);
+	rule_cache = mnl_nft_rule_dump(ctx, family,
+				       table, chain, rule_handle, dump,
+				       filter->reset.rule);
 	if (rule_cache == NULL) {
 		if (errno == EINTR)
 			return -1;
@@ -883,7 +913,8 @@ static struct nftnl_obj_list *obj_cache_dump(struct netlink_ctx *ctx,
 		if (filter->list.obj_type)
 			type = filter->list.obj_type;
 	}
-	obj_list = mnl_nft_obj_dump(ctx, family, table, obj, type, dump, false);
+	obj_list = mnl_nft_obj_dump(ctx, family, table, obj, type, dump,
+				    filter->reset.obj);
 	if (!obj_list) {
                 if (errno == EINTR)
 			return NULL;
@@ -1057,7 +1088,7 @@ static int rule_init_cache(struct netlink_ctx *ctx, struct table *table,
 	struct chain *chain;
 	int ret;
 
-	ret = rule_cache_dump(ctx, &table->handle, filter, true, false);
+	ret = rule_cache_dump(ctx, &table->handle, filter);
 
 	list_for_each_entry_safe(rule, nrule, &ctx->list, list) {
 		chain = chain_cache_find(table, rule->handle.chain.name);
@@ -1153,7 +1184,7 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags,
 					continue;
 
 				ret = netlink_list_setelems(ctx, &set->handle,
-							    set, false);
+							    set, filter->reset.elem);
 				if (ret < 0)
 					goto cache_fails;
 			}
@@ -1166,7 +1197,7 @@ static int cache_init_objects(struct netlink_ctx *ctx, unsigned int flags,
 					continue;
 
 				ret = netlink_list_setelems(ctx, &set->handle,
-							    set, false);
+							    set, filter->reset.elem);
 				if (ret < 0)
 					goto cache_fails;
 			}
diff --git a/src/evaluate.c b/src/evaluate.c
index 0a31c73e4276..593a0140e92a 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -5848,6 +5848,8 @@ static int cmd_evaluate_reset(struct eval_ctx *ctx, struct cmd *cmd)
 		return 0;
 	case CMD_OBJ_ELEMENTS:
 		return setelem_evaluate(ctx, cmd);
+	case CMD_OBJ_TABLE:
+	case CMD_OBJ_CHAIN:
 	case CMD_OBJ_SET:
 	case CMD_OBJ_MAP:
 		return cmd_evaluate_list(ctx, cmd);
diff --git a/src/mnl.c b/src/mnl.c
index 12e145204ef5..db53a60b43cb 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1163,8 +1163,11 @@ struct nftnl_table_list *mnl_nft_table_dump(struct netlink_ctx *ctx,
 		if (!nlt)
 			memory_allocation_error();
 
-		nftnl_table_set_u32(nlt, NFTNL_TABLE_FAMILY, family);
-		nftnl_table_set_str(nlt, NFTNL_TABLE_NAME, table);
+		if (family != NFPROTO_UNSPEC)
+			nftnl_table_set_u32(nlt, NFTNL_TABLE_FAMILY, family);
+		if (table)
+			nftnl_table_set_str(nlt, NFTNL_TABLE_NAME, table);
+
 		flags = NLM_F_ACK;
 	}
 
diff --git a/src/netlink.c b/src/netlink.c
index efb0b69939dc..dea95ffa0704 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1769,84 +1769,6 @@ void netlink_dump_flowtable(struct nftnl_flowtable *flo,
 	fprintf(fp, "\n");
 }
 
-static int list_obj_cb(struct nftnl_obj *nls, void *arg)
-{
-	struct netlink_ctx *ctx = arg;
-	struct obj *obj;
-
-	obj = netlink_delinearize_obj(ctx, nls);
-	if (obj == NULL)
-		return -1;
-	list_add_tail(&obj->list, &ctx->list);
-	return 0;
-}
-
-int netlink_reset_objs(struct netlink_ctx *ctx, const struct cmd *cmd,
-		       uint32_t type, bool dump)
-{
-	const struct handle *h = &cmd->handle;
-	struct nftnl_obj_list *obj_cache;
-	int err;
-
-	obj_cache = mnl_nft_obj_dump(ctx, h->family,
-				     h->table.name, h->obj.name, type, dump, true);
-	if (obj_cache == NULL)
-		return -1;
-
-	err = nftnl_obj_list_foreach(obj_cache, list_obj_cb, ctx);
-	nftnl_obj_list_free(obj_cache);
-	return err;
-}
-
-int netlink_reset_rules(struct netlink_ctx *ctx, const struct cmd *cmd,
-		        bool dump)
-{
-	const struct handle *h = &cmd->handle;
-	struct nft_cache_filter f = {
-		.list.table		= h->table.name,
-		.list.chain		= h->chain.name,
-		.list.rule_handle	= h->handle.id,
-	};
-	struct rule *rule, *next, *crule, *cnext;
-	struct table *table;
-	struct chain *chain;
-	int ret;
-
-	ret = rule_cache_dump(ctx, h, &f, dump, true);
-
-	list_for_each_entry_safe(rule, next, &ctx->list, list) {
-		table = table_cache_find(&ctx->nft->cache.table_cache,
-					 rule->handle.table.name,
-					 rule->handle.family);
-		if (!table)
-			continue;
-
-		chain = chain_cache_find(table, rule->handle.chain.name);
-		if (!chain)
-			continue;
-
-		list_del(&rule->list);
-		list_for_each_entry_safe(crule, cnext, &chain->rules, list) {
-			if (crule->handle.handle.id != rule->handle.handle.id)
-				continue;
-
-			list_replace(&crule->list, &rule->list);
-			rule_free(crule);
-			rule = NULL;
-			break;
-		}
-		if (rule) {
-			list_add_tail(&rule->list, &chain->rules);
-		}
-	}
-	list_for_each_entry_safe(rule, next, &ctx->list, list) {
-		list_del(&rule->list);
-		rule_free(rule);
-	}
-
-	return ret;
-}
-
 struct flowtable *
 netlink_delinearize_flowtable(struct netlink_ctx *ctx,
 			      struct nftnl_flowtable *nlo)
diff --git a/src/parser_bison.y b/src/parser_bison.y
index f3368dd3e922..8fbb98bdcd69 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1757,21 +1757,21 @@ reset_cmd		:	COUNTERS	ruleset_spec
 			}
 			|	RULES		table_spec
 			{
-				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_RULES, &$2, &@$, NULL);
+				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_TABLE, &$2, &@$, NULL);
 			}
 			|	RULES		TABLE	table_spec
 			{
 				/* alias of previous rule. */
-				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_RULES, &$3, &@$, NULL);
+				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_TABLE, &$3, &@$, NULL);
 			}
 			|	RULES		chain_spec
 			{
-				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_RULES, &$2, &@$, NULL);
+				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_CHAIN, &$2, &@$, NULL);
 			}
 			|	RULES		CHAIN	chain_spec
 			{
 				/* alias of previous rule. */
-				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_RULES, &$3, &@$, NULL);
+				$$ = cmd_alloc(CMD_RESET, CMD_OBJ_CHAIN, &$3, &@$, NULL);
 			}
 			|	RULE		ruleid_spec
 			{
diff --git a/src/rule.c b/src/rule.c
index 0f92ef532ece..9bc160ec0d88 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -2462,58 +2462,12 @@ static int do_command_get(struct netlink_ctx *ctx, struct cmd *cmd)
 
 static int do_command_reset(struct netlink_ctx *ctx, struct cmd *cmd)
 {
-	struct obj *obj, *next;
-	struct table *table;
-	bool dump = false;
-	uint32_t type;
-	int ret;
-
 	switch (cmd->obj) {
-	case CMD_OBJ_COUNTERS:
-		dump = true;
-		/* fall through */
-	case CMD_OBJ_COUNTER:
-		type = NFT_OBJECT_COUNTER;
-		break;
-	case CMD_OBJ_QUOTAS:
-		dump = true;
-		/* fall through */
-	case CMD_OBJ_QUOTA:
-		type = NFT_OBJECT_QUOTA;
-		break;
-	case CMD_OBJ_RULES:
-		ret = netlink_reset_rules(ctx, cmd, true);
-		if (ret < 0)
-			return ret;
-
-		return do_command_list(ctx, cmd);
-	case CMD_OBJ_RULE:
-		return netlink_reset_rules(ctx, cmd, false);
 	case CMD_OBJ_ELEMENTS:
 		return do_get_setelems(ctx, cmd, true);
-	case CMD_OBJ_SET:
-	case CMD_OBJ_MAP:
-		ret = netlink_list_setelems(ctx, &cmd->handle, cmd->set, true);
-		if (ret < 0)
-			return ret;
-
-		return do_command_list(ctx, cmd);
 	default:
-		BUG("invalid command object type %u\n", cmd->obj);
-	}
-
-	ret = netlink_reset_objs(ctx, cmd, type, dump);
-	list_for_each_entry_safe(obj, next, &ctx->list, list) {
-		table = table_cache_find(&ctx->nft->cache.table_cache,
-					 obj->handle.table.name,
-					 obj->handle.family);
-		if (!obj_cache_find(table, obj->handle.obj.name, obj->type)) {
-			list_del(&obj->list);
-			obj_cache_add(obj, table);
-		}
+		break;
 	}
-	if (ret < 0)
-		return ret;
 
 	return do_command_list(ctx, cmd);
 }
diff --git a/tests/shell/testcases/rule_management/0011reset_0 b/tests/shell/testcases/rule_management/0011reset_0
index 33eadd9eb562..3fede56fb7d8 100755
--- a/tests/shell/testcases/rule_management/0011reset_0
+++ b/tests/shell/testcases/rule_management/0011reset_0
@@ -74,13 +74,6 @@ $DIFF -u <(echo "$EXPECT") <($NFT list ruleset)
 
 echo "resetting specific chain"
 EXPECT='table ip t {
-	set s {
-		type ipv4_addr
-		size 65535
-		flags dynamic
-		counter
-	}
-
 	chain c2 {
 		counter packets 3 bytes 13 accept
 		counter packets 4 bytes 14 drop
@@ -95,6 +88,7 @@ EXPECT='table ip t {
 		size 65535
 		flags dynamic
 		counter
+		elements = { 1.1.1.1 counter packets 1 bytes 11 }
 	}
 
 	chain c {
@@ -116,6 +110,7 @@ EXPECT='table ip t {
 		size 65535
 		flags dynamic
 		counter
+		elements = { 1.1.1.1 counter packets 1 bytes 11 }
 	}
 
 	chain c {
@@ -143,6 +138,7 @@ EXPECT='table ip t {
 		size 65535
 		flags dynamic
 		counter
+		elements = { 1.1.1.1 counter packets 1 bytes 11 }
 	}
 
 	chain c {
-- 
2.30.2

