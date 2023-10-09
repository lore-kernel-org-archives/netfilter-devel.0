Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B8C1E95A8E
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Oct 2023 11:36:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234521AbjJILge (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Oct 2023 07:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234518AbjJILge (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Oct 2023 07:36:34 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBD9194
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Oct 2023 04:36:30 -0700 (PDT)
Received: from [78.30.34.192] (port=51136 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qpoYj-00DZ3o-7L; Mon, 09 Oct 2023 13:36:28 +0200
Date:   Mon, 9 Oct 2023 13:36:23 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Arturo Borrero Gonzalez <arturo@debian.org>
Cc:     Jeremy Sowden <jeremy@azazel.net>, netfilter-devel@vger.kernel.org,
        fw@strlen.de, phil@nwl.cc
Subject: [RFC] nftables 0.9.8 -stable backports
Message-ID: <ZSPltyxV10hYvsr+@calendula>
References: <ZSPZiekbEmjDfIF2@calendula>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="P/tE4XFKULwxH9Uv"
Content-Disposition: inline
In-Reply-To: <ZSPZiekbEmjDfIF2@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--P/tE4XFKULwxH9Uv
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Arturo, Jeremy,

This is a small batch offering fixes for nftables 0.9.8. It only
includes the fixes for the implicit chain regression in recent
kernels.

This is a few dependency patches that are missing in 0.9.8 are
required:

        3542e49cf539 ("evaluate: init cmd pointer for new on-stack context")
        a3ac2527724d ("src: split chain list in table")
        4e718641397c ("cache: rename chain_htable to cache_chain_ht")

a3ac2527724d is fixing an issue with the cache that is required by the
fixes. Then, the backport fixes for the implicit chain regression with
Linux -stable:

        3975430b12d9 ("src: expand table command before evaluation")
        27c753e4a8d4 ("rule: expand standalone chain that contains rules")
        784597a4ed63 ("rule: add helper function to expand chain rules into commands")

I tested with tests/shell at the time of the nftables 0.9.8 release
(*I did not use git HEAD tests/shell as I did for 1.0.6*).

I have kept back the backport of this patch intentionally:

        56c90a2dd2eb ("evaluate: expand sets and maps before evaluation")

this depends on the new src/interval.c code, in 0.9.8 overlap and
automerge come a later stage and cache is not updated incrementally,
I tried the tests coming in this patch and it works fine.

I did run a few more tests with rulesets that I have been collecting
from people that occasionally send them to me for my personal ruleset
repo.

I: results: [OK] 266 [FAILED] 0 [TOTAL] 266

This has been tested with latest Linux kernel 5.10 -stable.

I can still run a few more tests, I will get back to you if I find any
issue.

Let me know, thanks.

--P/tE4XFKULwxH9Uv
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0001-cache-rename-chain_htable-to-cache_chain_ht.patch"

From 0a39091a75b6255422832126df4cbf73c86845cd Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu, 1 Apr 2021 22:18:29 +0200
Subject: [PATCH nft 0.9.8 1/7] cache: rename chain_htable to cache_chain_ht

upstream 3542e49cf539ecfcef6ef7c2d4befb7896ade2cd commit.

Rename the hashtable chain that is used for fast cache lookups.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h | 4 ++--
 src/cache.c    | 6 +++---
 src/rule.c     | 6 +++---
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index 330a09aa77fa..43872db8947a 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -154,7 +154,7 @@ struct table {
 	struct handle		handle;
 	struct location		location;
 	struct scope		scope;
-	struct list_head	*chain_htable;
+	struct list_head	*cache_chain_ht;
 	struct list_head	chains;
 	struct list_head	sets;
 	struct list_head	objs;
@@ -220,7 +220,7 @@ struct hook_spec {
  */
 struct chain {
 	struct list_head	list;
-	struct list_head	hlist;
+	struct list_head	cache_hlist;
 	struct handle		handle;
 	struct location		location;
 	unsigned int		refcnt;
diff --git a/src/cache.c b/src/cache.c
index ed2609008e22..7101b74160be 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -194,7 +194,7 @@ static int chain_cache_cb(struct nftnl_chain *nlc, void *arg)
 	if (chain->flags & CHAIN_F_BINDING) {
 		list_add_tail(&chain->list, &ctx->table->chain_bindings);
 	} else {
-		list_add_tail(&chain->hlist, &ctx->table->chain_htable[hash]);
+		list_add_tail(&chain->cache_hlist, &ctx->table->cache_chain_ht[hash]);
 		list_add_tail(&chain->list, &ctx->table->chains);
 	}
 
@@ -238,7 +238,7 @@ void chain_cache_add(struct chain *chain, struct table *table)
 	uint32_t hash;
 
 	hash = djb_hash(chain->handle.chain.name) % NFT_CACHE_HSIZE;
-	list_add_tail(&chain->hlist, &table->chain_htable[hash]);
+	list_add_tail(&chain->cache_hlist, &table->cache_chain_ht[hash]);
 	list_add_tail(&chain->list, &table->chains);
 }
 
@@ -249,7 +249,7 @@ struct chain *chain_cache_find(const struct table *table,
 	uint32_t hash;
 
 	hash = djb_hash(handle->chain.name) % NFT_CACHE_HSIZE;
-	list_for_each_entry(chain, &table->chain_htable[hash], hlist) {
+	list_for_each_entry(chain, &table->cache_chain_ht[hash], cache_hlist) {
 		if (!strcmp(chain->handle.chain.name, handle->chain.name))
 			return chain;
 	}
diff --git a/src/rule.c b/src/rule.c
index e4bb6bae276a..3b445851f657 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1328,10 +1328,10 @@ struct table *table_alloc(void)
 	init_list_head(&table->scope.symbols);
 	table->refcnt = 1;
 
-	table->chain_htable =
+	table->cache_chain_ht =
 		xmalloc(sizeof(struct list_head) * NFT_CACHE_HSIZE);
 	for (i = 0; i < NFT_CACHE_HSIZE; i++)
-		init_list_head(&table->chain_htable[i]);
+		init_list_head(&table->cache_chain_ht[i]);
 
 	return table;
 }
@@ -1359,7 +1359,7 @@ void table_free(struct table *table)
 		obj_free(obj);
 	handle_free(&table->handle);
 	scope_release(&table->scope);
-	xfree(table->chain_htable);
+	xfree(table->cache_chain_ht);
 	xfree(table);
 }
 
-- 
2.30.2


--P/tE4XFKULwxH9Uv
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0002-src-split-chain-list-in-table.patch"

From f37e4261130b021edf068e4d5c6ca062ce4e2ac1 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu, 1 Apr 2021 22:19:30 +0200
Subject: [PATCH nft 0.9.8 2/7] src: split chain list in table

upstream a3ac2527724dd27628e12caaa55f731b109e4586 commit.

This patch splits table->lists in two:

- Chains that reside in the cache are stored in the new
  tables->cache_chain and tables->cache_chain_ht. The hashtable chain
  cache allows for fast chain lookups.

- Chains that defined via command line / ruleset file reside in
  tables->chains.

Note that chains in the cache (already in the kernel) are not placed in
the table->chains.

By keeping separated lists, chains defined via command line / ruleset
file can be added to cache.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h |  2 ++
 src/cache.c    |  6 +++---
 src/json.c     |  6 +++---
 src/rule.c     | 18 +++++++++++-------
 4 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index 43872db8947a..dde32367f48f 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -155,6 +155,7 @@ struct table {
 	struct location		location;
 	struct scope		scope;
 	struct list_head	*cache_chain_ht;
+	struct list_head	cache_chain;
 	struct list_head	chains;
 	struct list_head	sets;
 	struct list_head	objs;
@@ -221,6 +222,7 @@ struct hook_spec {
 struct chain {
 	struct list_head	list;
 	struct list_head	cache_hlist;
+	struct list_head	cache_list;
 	struct handle		handle;
 	struct location		location;
 	unsigned int		refcnt;
diff --git a/src/cache.c b/src/cache.c
index 7101b74160be..32e6eea4ac5c 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -192,10 +192,10 @@ static int chain_cache_cb(struct nftnl_chain *nlc, void *arg)
 	chain = netlink_delinearize_chain(ctx->nlctx, nlc);
 
 	if (chain->flags & CHAIN_F_BINDING) {
-		list_add_tail(&chain->list, &ctx->table->chain_bindings);
+		list_add_tail(&chain->cache_list, &ctx->table->chain_bindings);
 	} else {
 		list_add_tail(&chain->cache_hlist, &ctx->table->cache_chain_ht[hash]);
-		list_add_tail(&chain->list, &ctx->table->chains);
+		list_add_tail(&chain->cache_list, &ctx->table->cache_chain);
 	}
 
 	nftnl_chain_list_del(nlc);
@@ -239,7 +239,7 @@ void chain_cache_add(struct chain *chain, struct table *table)
 
 	hash = djb_hash(chain->handle.chain.name) % NFT_CACHE_HSIZE;
 	list_add_tail(&chain->cache_hlist, &table->cache_chain_ht[hash]);
-	list_add_tail(&chain->list, &table->chains);
+	list_add_tail(&chain->cache_list, &table->cache_chain);
 }
 
 struct chain *chain_cache_find(const struct table *table,
diff --git a/src/json.c b/src/json.c
index 585d35326ac0..737e73b08b5a 100644
--- a/src/json.c
+++ b/src/json.c
@@ -1594,7 +1594,7 @@ static json_t *table_print_json_full(struct netlink_ctx *ctx,
 		tmp = flowtable_print_json(flowtable);
 		json_array_append_new(root, tmp);
 	}
-	list_for_each_entry(chain, &table->chains, list) {
+	list_for_each_entry(chain, &table->cache_chain, cache_list) {
 		tmp = chain_print_json(chain);
 		json_array_append_new(root, tmp);
 
@@ -1656,7 +1656,7 @@ static json_t *do_list_chain_json(struct netlink_ctx *ctx,
 	struct chain *chain;
 	struct rule *rule;
 
-	list_for_each_entry(chain, &table->chains, list) {
+	list_for_each_entry(chain, &table->cache_chain, cache_list) {
 		if (chain->handle.family != cmd->handle.family ||
 		    strcmp(cmd->handle.chain.name, chain->handle.chain.name))
 			continue;
@@ -1684,7 +1684,7 @@ static json_t *do_list_chains_json(struct netlink_ctx *ctx, struct cmd *cmd)
 		    cmd->handle.family != table->handle.family)
 			continue;
 
-		list_for_each_entry(chain, &table->chains, list) {
+		list_for_each_entry(chain, &table->cache_chain, cache_list) {
 			json_t *tmp = chain_print_json(chain);
 
 			json_array_append_new(root, tmp);
diff --git a/src/rule.c b/src/rule.c
index 3b445851f657..f76c27c9d091 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -953,7 +953,7 @@ struct chain *chain_lookup(const struct table *table, const struct handle *h)
 {
 	struct chain *chain;
 
-	list_for_each_entry(chain, &table->chains, list) {
+	list_for_each_entry(chain, &table->cache_chain, cache_list) {
 		if (!strcmp(chain->handle.chain.name, h->chain.name))
 			return chain;
 	}
@@ -965,7 +965,7 @@ struct chain *chain_binding_lookup(const struct table *table,
 {
 	struct chain *chain;
 
-	list_for_each_entry(chain, &table->chain_bindings, list) {
+	list_for_each_entry(chain, &table->chain_bindings, cache_list) {
 		if (!strcmp(chain->handle.chain.name, chain_name))
 			return chain;
 	}
@@ -983,7 +983,7 @@ struct chain *chain_lookup_fuzzy(const struct handle *h,
 	string_misspell_init(&st);
 
 	list_for_each_entry(table, &cache->list, list) {
-		list_for_each_entry(chain, &table->chains, list) {
+		list_for_each_entry(chain, &table->cache_chain, cache_list) {
 			if (!strcmp(chain->handle.chain.name, h->chain.name)) {
 				*t = table;
 				return chain;
@@ -1321,6 +1321,7 @@ struct table *table_alloc(void)
 
 	table = xzalloc(sizeof(*table));
 	init_list_head(&table->chains);
+	init_list_head(&table->cache_chain);
 	init_list_head(&table->sets);
 	init_list_head(&table->objs);
 	init_list_head(&table->flowtables);
@@ -1349,7 +1350,10 @@ void table_free(struct table *table)
 		xfree(table->comment);
 	list_for_each_entry_safe(chain, next, &table->chains, list)
 		chain_free(chain);
-	list_for_each_entry_safe(chain, next, &table->chain_bindings, list)
+	list_for_each_entry_safe(chain, next, &table->chain_bindings, cache_list)
+		chain_free(chain);
+	/* this is implicitly releasing chains in the hashtable cache */
+	list_for_each_entry_safe(chain, next, &table->cache_chain, cache_list)
 		chain_free(chain);
 	list_for_each_entry_safe(set, nset, &table->sets, list)
 		set_free(set);
@@ -1465,7 +1469,7 @@ static void table_print(const struct table *table, struct output_ctx *octx)
 		flowtable_print(flowtable, octx);
 		delim = "\n";
 	}
-	list_for_each_entry(chain, &table->chains, list) {
+	list_for_each_entry(chain, &table->cache_chain, cache_list) {
 		nft_print(octx, "%s", delim);
 		chain_print(chain, octx);
 		delim = "\n";
@@ -2555,7 +2559,7 @@ static int do_list_chain(struct netlink_ctx *ctx, struct cmd *cmd,
 
 	table_print_declaration(table, &ctx->nft->output);
 
-	list_for_each_entry(chain, &table->chains, list) {
+	list_for_each_entry(chain, &table->cache_chain, cache_list) {
 		if (chain->handle.family != cmd->handle.family ||
 		    strcmp(cmd->handle.chain.name, chain->handle.chain.name) != 0)
 			continue;
@@ -2580,7 +2584,7 @@ static int do_list_chains(struct netlink_ctx *ctx, struct cmd *cmd)
 
 		table_print_declaration(table, &ctx->nft->output);
 
-		list_for_each_entry(chain, &table->chains, list) {
+		list_for_each_entry(chain, &table->cache_chain, cache_list) {
 			chain_print_declaration(chain, &ctx->nft->output);
 			nft_print(&ctx->nft->output, "\t}\n");
 		}
-- 
2.30.2


--P/tE4XFKULwxH9Uv
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0003-evaluate-init-cmd-pointer-for-new-on-stack-context.patch"

From 5af65a30a12396281c751e635509ab1d9363f4bc Mon Sep 17 00:00:00 2001
From: Florian Westphal <fw@strlen.de>
Date: Fri, 4 Mar 2022 11:30:55 +0100
Subject: [PATCH nft 0.9.8 3/7] evaluate: init cmd pointer for new on-stack
 context

upstream 4e718641397c876315a87db441afc53139863122 commit

else, this will segfault when trying to print the
"table 'x' doesn't exist" error message.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                   | 1 +
 tests/shell/testcases/chains/0041chain_binding_0 | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index c830dcdbd965..f546667131e1 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3211,6 +3211,7 @@ static int stmt_evaluate_chain(struct eval_ctx *ctx, struct stmt *stmt)
 			struct eval_ctx rule_ctx = {
 				.nft	= ctx->nft,
 				.msgs	= ctx->msgs,
+				.cmd	= ctx->cmd,
 			};
 			struct handle h2 = {};
 
diff --git a/tests/shell/testcases/chains/0041chain_binding_0 b/tests/shell/testcases/chains/0041chain_binding_0
index 59bdbe9f0ba9..4b541bb55c30 100755
--- a/tests/shell/testcases/chains/0041chain_binding_0
+++ b/tests/shell/testcases/chains/0041chain_binding_0
@@ -1,5 +1,11 @@
 #!/bin/bash
 
+# no table x, caused segfault in earlier nft releases
+$NFT insert rule inet x y handle 107 'goto { log prefix "MOO! "; }'
+if [ $? -ne 1 ]; then
+	exit 1
+fi
+
 set -e
 
 EXPECTED="table inet x {
-- 
2.30.2


--P/tE4XFKULwxH9Uv
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0004-rule-add-helper-function-to-expand-chain-rules-into-.patch"

From 0f559011ee7e805df883be635b88396639fbb87e Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 12 Sep 2023 23:22:46 +0200
Subject: [PATCH nft 0.9.8 4/7] rule: add helper function to expand chain rules
 into commands

upstream 784597a4ed63b9decb10d74fdb49a1b021e22728 commit.

This patch adds a helper function to expand chain rules into commands.
This comes in preparation for the follow up patch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c | 39 ++++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index f76c27c9d091..3fbf4271accd 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1503,6 +1503,25 @@ void cmd_add_loc(struct cmd *cmd, uint16_t offset, const struct location *loc)
 	cmd->num_attrs++;
 }
 
+static void nft_cmd_expand_chain(struct chain *chain, struct list_head *new_cmds)
+{
+	struct rule *rule;
+	struct handle h;
+	struct cmd *new;
+
+	list_for_each_entry(rule, &chain->rules, list) {
+		memset(&h, 0, sizeof(h));
+		handle_merge(&h, &rule->handle);
+		if (chain->flags & CHAIN_F_BINDING) {
+			rule->handle.chain_id = chain->handle.chain_id;
+			rule->handle.chain.location = chain->location;
+		}
+		new = cmd_alloc(CMD_ADD, CMD_OBJ_RULE, &h,
+				&rule->location, rule_get(rule));
+		list_add_tail(&new->list, new_cmds);
+	}
+}
+
 void nft_cmd_expand(struct cmd *cmd)
 {
 	struct list_head new_cmds;
@@ -1510,7 +1529,6 @@ void nft_cmd_expand(struct cmd *cmd)
 	struct flowtable *ft;
 	struct table *table;
 	struct chain *chain;
-	struct rule *rule;
 	struct obj *obj;
 	struct cmd *new;
 	struct handle h;
@@ -1555,22 +1573,9 @@ void nft_cmd_expand(struct cmd *cmd)
 					&ft->location, flowtable_get(ft));
 			list_add_tail(&new->list, &new_cmds);
 		}
-		list_for_each_entry(chain, &table->chains, list) {
-			list_for_each_entry(rule, &chain->rules, list) {
-				memset(&h, 0, sizeof(h));
-				handle_merge(&h, &rule->handle);
-				if (chain->flags & CHAIN_F_BINDING) {
-					rule->handle.chain_id =
-						chain->handle.chain_id;
-					rule->handle.chain.location =
-						chain->location;
-				}
-				new = cmd_alloc(CMD_ADD, CMD_OBJ_RULE, &h,
-						&rule->location,
-						rule_get(rule));
-				list_add_tail(&new->list, &new_cmds);
-			}
-		}
+		list_for_each_entry(chain, &table->chains, list)
+			nft_cmd_expand_chain(chain, &new_cmds);
+
 		list_splice(&new_cmds, &cmd->list);
 		break;
 	case CMD_OBJ_SET:
-- 
2.30.2


--P/tE4XFKULwxH9Uv
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0005-rule-expand-standalone-chain-that-contains-rules.patch"

From f03bc399d75ef724fcbed184f74fc306ca8ef324 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 6 Feb 2023 15:28:41 +0100
Subject: [PATCH nft 0.9.8 5/7] rule: expand standalone chain that contains
 rules

upstream 27c753e4a8d4744f479345e3f5e34cafef751602 commit.

Otherwise rules that this chain contains are ignored when expressed
using the following syntax:

chain inet filter input2 {
       type filter hook input priority filter; policy accept;
       ip saddr 1.2.3.4 tcp dport { 22, 443, 123 } drop
}

When expanding the chain, remove the rule so the new CMD_OBJ_CHAIN
case does not expand it again.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1655
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c                                    | 15 +++++++++---
 .../testcases/include/0020include_chain_0     | 23 +++++++++++++++++++
 .../include/dumps/0020include_chain_0.nft     |  6 +++++
 3 files changed, 41 insertions(+), 3 deletions(-)
 create mode 100755 tests/shell/testcases/include/0020include_chain_0
 create mode 100644 tests/shell/testcases/include/dumps/0020include_chain_0.nft

diff --git a/src/rule.c b/src/rule.c
index 3fbf4271accd..9139418e1bf8 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1505,11 +1505,12 @@ void cmd_add_loc(struct cmd *cmd, uint16_t offset, const struct location *loc)
 
 static void nft_cmd_expand_chain(struct chain *chain, struct list_head *new_cmds)
 {
-	struct rule *rule;
+	struct rule *rule, *next;
 	struct handle h;
 	struct cmd *new;
 
-	list_for_each_entry(rule, &chain->rules, list) {
+	list_for_each_entry_safe(rule, next, &chain->rules, list) {
+		list_del(&rule->list);
 		memset(&h, 0, sizeof(h));
 		handle_merge(&h, &rule->handle);
 		if (chain->flags & CHAIN_F_BINDING) {
@@ -1517,7 +1518,7 @@ static void nft_cmd_expand_chain(struct chain *chain, struct list_head *new_cmds
 			rule->handle.chain.location = chain->location;
 		}
 		new = cmd_alloc(CMD_ADD, CMD_OBJ_RULE, &h,
-				&rule->location, rule_get(rule));
+				&rule->location, rule);
 		list_add_tail(&new->list, new_cmds);
 	}
 }
@@ -1578,6 +1579,14 @@ void nft_cmd_expand(struct cmd *cmd)
 
 		list_splice(&new_cmds, &cmd->list);
 		break;
+	case CMD_OBJ_CHAIN:
+		chain = cmd->chain;
+		if (!chain || list_empty(&chain->rules))
+			break;
+
+		nft_cmd_expand_chain(chain, &new_cmds);
+		list_splice(&new_cmds, &cmd->list);
+		break;
 	case CMD_OBJ_SET:
 	case CMD_OBJ_MAP:
 		set = cmd->set;
diff --git a/tests/shell/testcases/include/0020include_chain_0 b/tests/shell/testcases/include/0020include_chain_0
new file mode 100755
index 000000000000..2ff83c92fda8
--- /dev/null
+++ b/tests/shell/testcases/include/0020include_chain_0
@@ -0,0 +1,23 @@
+#!/bin/bash
+
+set -e
+
+tmpfile1=$(mktemp -p .)
+if [ ! -w $tmpfile1 ] ; then
+	echo "Failed to create tmp file" >&2
+	exit 0
+fi
+
+trap "rm -rf $tmpfile1" EXIT # cleanup if aborted
+
+RULESET="table inet filter { }
+include \"$tmpfile1\""
+
+RULESET2="chain inet filter input2 {
+	type filter hook input priority filter; policy accept;
+	ip saddr 1.2.3.4 tcp dport { 22, 443, 123 } drop
+}"
+
+echo "$RULESET2" > $tmpfile1
+
+$NFT -f - <<< $RULESET
diff --git a/tests/shell/testcases/include/dumps/0020include_chain_0.nft b/tests/shell/testcases/include/dumps/0020include_chain_0.nft
new file mode 100644
index 000000000000..3ad6db14d2f5
--- /dev/null
+++ b/tests/shell/testcases/include/dumps/0020include_chain_0.nft
@@ -0,0 +1,6 @@
+table inet filter {
+	chain input2 {
+		type filter hook input priority filter; policy accept;
+		ip saddr 1.2.3.4 tcp dport { 22, 123, 443 } drop
+	}
+}
-- 
2.30.2


--P/tE4XFKULwxH9Uv
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0006-src-expand-table-command-before-evaluation.patch"

From 050e0b7a85016b733e1a59285df501d1c05eec0b Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 12 Sep 2023 23:25:27 +0200
Subject: [PATCH nft 0.9.8 6/7] src: expand table command before evaluation

upstream 3975430b12d97c92cdf03753342f2269153d5624 commit.

The nested syntax notation results in one single table command which
includes all other objects. This differs from the flat notation where
there is usually one command per object.

This patch adds a previous step to the evaluation phase to expand the
objects that are contained in the table into independent commands, so
both notations have similar representations.

Remove the code to evaluate the nested representation in the evaluation
phase since commands are independently evaluated after the expansion.

The commands are expanded after the set element collapse step, in case
that there is a long list of singleton element commands to be added to
the set, to shorten the command list iteration.

This approach also avoids interference with the object cache that is
populated in the evaluation, which might refer to objects coming in the
existing command list that is being processed.

There is still a post_expand phase to detach the elements from the set
which could be consolidated by updating the evaluation step to handle
the CMD_OBJ_SETELEMS command type.

This patch fixes 27c753e4a8d4 ("rule: expand standalone chain that
contains rules") which broke rule addition/insertion by index because
the expansion code after the evaluation messes up the cache.

Fixes: 27c753e4a8d4 ("rule: expand standalone chain that contains rules")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h    |  1 +
 src/evaluate.c    | 39 ---------------------------------------
 src/libnftables.c |  9 ++++++++-
 src/rule.c        | 21 +++++++++++++++++++--
 4 files changed, 28 insertions(+), 42 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index dde32367f48f..f880cfd32bd8 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -717,6 +717,7 @@ extern struct cmd *cmd_alloc(enum cmd_ops op, enum cmd_obj obj,
 			     const struct handle *h, const struct location *loc,
 			     void *data);
 extern void nft_cmd_expand(struct cmd *cmd);
+extern void nft_cmd_post_expand(struct cmd *cmd);
 extern struct cmd *cmd_alloc_obj_ct(enum cmd_ops op, int type,
 				    const struct handle *h,
 				    const struct location *loc, struct obj *obj);
diff --git a/src/evaluate.c b/src/evaluate.c
index f546667131e1..232ae39020cc 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4068,7 +4068,6 @@ static uint32_t str2hooknum(uint32_t family, const char *hook)
 static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
 {
 	struct table *table;
-	struct rule *rule;
 
 	table = table_lookup_global(ctx);
 	if (table == NULL)
@@ -4122,11 +4121,6 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
 		}
 	}
 
-	list_for_each_entry(rule, &chain->rules, list) {
-		handle_merge(&rule->handle, &chain->handle);
-		if (rule_evaluate(ctx, rule, CMD_INVALID) < 0)
-			return -1;
-	}
 	return 0;
 }
 
@@ -4183,11 +4177,6 @@ static int obj_evaluate(struct eval_ctx *ctx, struct obj *obj)
 
 static int table_evaluate(struct eval_ctx *ctx, struct table *table)
 {
-	struct flowtable *ft;
-	struct chain *chain;
-	struct set *set;
-	struct obj *obj;
-
 	if (table_lookup(&ctx->cmd->handle, &ctx->nft->cache) == NULL) {
 		if (table == NULL) {
 			table = table_alloc();
@@ -4198,34 +4187,6 @@ static int table_evaluate(struct eval_ctx *ctx, struct table *table)
 		}
 	}
 
-	if (ctx->cmd->table == NULL)
-		return 0;
-
-	ctx->table = table;
-	list_for_each_entry(set, &table->sets, list) {
-		expr_set_context(&ctx->ectx, NULL, 0);
-		handle_merge(&set->handle, &table->handle);
-		if (set_evaluate(ctx, set) < 0)
-			return -1;
-	}
-	list_for_each_entry(chain, &table->chains, list) {
-		handle_merge(&chain->handle, &table->handle);
-		ctx->cmd->handle.chain.location = chain->location;
-		if (chain_evaluate(ctx, chain) < 0)
-			return -1;
-	}
-	list_for_each_entry(ft, &table->flowtables, list) {
-		handle_merge(&ft->handle, &table->handle);
-		if (flowtable_evaluate(ctx, ft) < 0)
-			return -1;
-	}
-	list_for_each_entry(obj, &table->objs, list) {
-		handle_merge(&obj->handle, &table->handle);
-		if (obj_evaluate(ctx, obj) < 0)
-			return -1;
-	}
-
-	ctx->table = NULL;
 	return 0;
 }
 
diff --git a/src/libnftables.c b/src/libnftables.c
index 044365914747..b1f57802b90e 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -420,6 +420,13 @@ static int nft_evaluate(struct nft_ctx *nft, struct list_head *msgs,
 	if (cache_update(nft, flags, msgs) < 0)
 		return -1;
 
+	list_for_each_entry(cmd, cmds, list) {
+		if (cmd->op != CMD_ADD)
+			continue;
+
+		nft_cmd_expand(cmd);
+	}
+
 	list_for_each_entry(cmd, cmds, list) {
 		struct eval_ctx ectx = {
 			.nft	= nft,
@@ -437,7 +444,7 @@ static int nft_evaluate(struct nft_ctx *nft, struct list_head *msgs,
 		if (cmd->op != CMD_ADD)
 			continue;
 
-		nft_cmd_expand(cmd);
+		nft_cmd_post_expand(cmd);
 	}
 
 	return 0;
diff --git a/src/rule.c b/src/rule.c
index 9139418e1bf8..9c74b89c1fb1 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1511,8 +1511,9 @@ static void nft_cmd_expand_chain(struct chain *chain, struct list_head *new_cmds
 
 	list_for_each_entry_safe(rule, next, &chain->rules, list) {
 		list_del(&rule->list);
+		handle_merge(&rule->handle, &chain->handle);
 		memset(&h, 0, sizeof(h));
-		handle_merge(&h, &rule->handle);
+		handle_merge(&h, &chain->handle);
 		if (chain->flags & CHAIN_F_BINDING) {
 			rule->handle.chain_id = chain->handle.chain_id;
 			rule->handle.chain.location = chain->location;
@@ -1526,10 +1527,10 @@ static void nft_cmd_expand_chain(struct chain *chain, struct list_head *new_cmds
 void nft_cmd_expand(struct cmd *cmd)
 {
 	struct list_head new_cmds;
-	struct set *set, *newset;
 	struct flowtable *ft;
 	struct table *table;
 	struct chain *chain;
+	struct set *set;
 	struct obj *obj;
 	struct cmd *new;
 	struct handle h;
@@ -1543,6 +1544,7 @@ void nft_cmd_expand(struct cmd *cmd)
 			return;
 
 		list_for_each_entry(chain, &table->chains, list) {
+			handle_merge(&chain->handle, &table->handle);
 			memset(&h, 0, sizeof(h));
 			handle_merge(&h, &chain->handle);
 			h.chain_id = chain->handle.chain_id;
@@ -1587,6 +1589,21 @@ void nft_cmd_expand(struct cmd *cmd)
 		nft_cmd_expand_chain(chain, &new_cmds);
 		list_splice(&new_cmds, &cmd->list);
 		break;
+	default:
+		break;
+	}
+}
+
+void nft_cmd_post_expand(struct cmd *cmd)
+{
+	struct list_head new_cmds;
+	struct set *set, *newset;
+	struct cmd *new;
+	struct handle h;
+
+	init_list_head(&new_cmds);
+
+	switch (cmd->obj) {
 	case CMD_OBJ_SET:
 	case CMD_OBJ_MAP:
 		set = cmd->set;
-- 
2.30.2


--P/tE4XFKULwxH9Uv
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0007-tests-shell-Stabilize-sets-0043concatenated_ranges_0.patch"

From 69d1ab7c50a6a1dd369b50a5edad769b98779e12 Mon Sep 17 00:00:00 2001
From: Phil Sutter <phil@nwl.cc>
Date: Wed, 23 Aug 2023 18:18:49 +0200
Subject: [PATCH nft 0.9.8 7/7] tests: shell: Stabilize
 sets/0043concatenated_ranges_0 test

upstream c791765cb0d62ba261f0b495e07315437b3ae914 commit.

On a slow system, one of the 'delete element' commands would
occasionally fail. Assuming it can only happen if the 2s timeout passes
"too quickly", work around it by adding elements with a 2m timeout
instead and when wanting to test the element expiry just drop and add
the element again with a short timeout.

Fixes: 6231d3fa4af1e ("tests: shell: Fix for unstable sets/0043concatenated_ranges_0")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/shell/testcases/sets/0043concatenated_ranges_0 | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tests/shell/testcases/sets/0043concatenated_ranges_0 b/tests/shell/testcases/sets/0043concatenated_ranges_0
index 11767373bcd2..8d3dacf6e38a 100755
--- a/tests/shell/testcases/sets/0043concatenated_ranges_0
+++ b/tests/shell/testcases/sets/0043concatenated_ranges_0
@@ -147,7 +147,7 @@ for ta in ${TYPES}; do
 			eval add_b=\$ADD_${tb}
 			eval add_c=\$ADD_${tc}
 			${NFT} add element inet filter test \
-				"{ ${add_a} . ${add_b} . ${add_c} timeout 1s${mapv}}"
+				"{ ${add_a} . ${add_b} . ${add_c} timeout 2m${mapv}}"
 			[ $(${NFT} list ${setmap} inet filter test |	\
 			   grep -c "${add_a} . ${add_b} . ${add_c}") -eq 1 ]
 
@@ -180,6 +180,10 @@ for ta in ${TYPES}; do
 				continue
 			fi
 
+			${NFT} delete element inet filter test \
+				"{ ${add_a} . ${add_b} . ${add_c} ${mapv}}"
+			${NFT} add element inet filter test \
+				"{ ${add_a} . ${add_b} . ${add_c} timeout 1s${mapv}}"
 			sleep 1
 			[ $(${NFT} list ${setmap} inet filter test |		\
 			   grep -c "${add_a} . ${add_b} . ${add_c} ${mapv}") -eq 0 ]
-- 
2.30.2


--P/tE4XFKULwxH9Uv--
